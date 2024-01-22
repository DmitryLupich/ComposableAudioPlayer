//
//  PlayerService.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 17.01.2024.
//

import Combine
import AVFoundation

//TODO: - Cover with protocol

class PlayerService {
    private let player: AVPlayer
    private var playerPeriodicObserver: Any?
    private var currentSpeedRate: PlaybackSpeed = .normal

    let currentTimePublisher = PassthroughSubject<Double, Never>()
    let currentProgressPublisher = PassthroughSubject<Double, Never>()

    init(player: AVPlayer = .init()) {
        self.player = player
        self.setupPeriodicObservation(for: player)
    }

    func rewind(_ duration: Double) {
        guard let fullDuration = player.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = playerCurrentTime + duration

        if newTime < (CMTimeGetSeconds(fullDuration) - duration) {
            let timeToRewind: CMTime = CMTime(
                value: Int64(newTime * 1000 as Float64),
                timescale: 1000
            )
            player.seek(
                to: timeToRewind,
                toleranceBefore: .zero,
                toleranceAfter: .zero
            )
        }
    }

    func scrollTo(_ progress: Double) {
        let desiredTime = duration*progress
        goTo(desiredTime)
    }

    func setItem(_ fileName: String) {
        let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        let item = AVPlayerItem(url: fileUrl)
        player.replaceCurrentItem(with: item)
    }

    func play() {
        player.play()
        player.rate = currentSpeedRate.value
    }

    func pause() {
        player.pause()
    }

    func toggleSpeed() {
        currentSpeedRate.toggle()
        if isPlaying {
            player.rate = currentSpeedRate.value
        }
    }
}

//MARK: - Private Methods

private extension PlayerService {
    func progress(_ currentTime: Double) -> Double {
        return duration == .zero ? .zero : Double(currentTime/duration)
    }

    var duration: Double {
        player.currentItem?.duration.seconds ?? .zero
    }

    var isPlaying: Bool {
        player.timeControlStatus == .playing
    }

    func goTo(_ timeInterval: Double) {
        let timeToRewind: CMTime = CMTime(
            value: Int64(timeInterval * 1000 as Float64),
            timescale: 1000
        )

        player.seek(
            to: timeToRewind,
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }

    func setupPeriodicObservation(for player: AVPlayer) {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        playerPeriodicObserver = player.addPeriodicTimeObserver(
            forInterval: time,
            queue: .main
        ) { [weak self] (time) in
            guard let self = self else  { return }
            let progress = self.progress(time.seconds)
            self.currentProgressPublisher.send(progress)
            self.currentTimePublisher.send(time.seconds)
        }
    }
}

//MARK: - Live

extension PlayerService {
    static let live: PlayerService = .init()
}

//MARK: - Mock
//TODO: - Add Mock
//extension PlayerService {
//    static let mock: PlayerService = .init()
//}
