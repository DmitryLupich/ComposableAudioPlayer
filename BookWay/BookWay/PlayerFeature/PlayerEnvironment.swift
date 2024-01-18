//
//  PlayerEnvironment.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 18.01.2024.
//

import Combine
import Foundation
import AVFoundation

//MARK: - Environment

extension PlayerFeature {
    struct Environment {
        var rewind: (Double) -> Void
        var scrollTo: (Double) -> Void
        var setItem: (String) -> Void
        var play: () -> Void
        var pause: () -> Void
        var toggleSpeed: () -> Void
        var progress: () -> AnyPublisher<Double, Never>
        var time: () -> AnyPublisher<Double, Never>
    }
}

//MARK: - Live
extension PlayerFeature.Environment {
    static let live: (PlayerService) -> Self = { player in
            .init(
                rewind: player.rewind(_:),
                scrollTo: player.scrollTo(_:),
                setItem: player.setItem(_:),
                play: player.play,
                pause: player.pause,
                toggleSpeed: player.toggleSpeed,
                progress: player.currentProgressPublisher.eraseToAnyPublisher,
                time: player.currentTimePublisher.eraseToAnyPublisher
            )
    }
}

//TODO: - Add Mock environment for test purposes

//extension PlayerFeature.Environment {
//    static let mock: (PlayerService) -> Self
//}
