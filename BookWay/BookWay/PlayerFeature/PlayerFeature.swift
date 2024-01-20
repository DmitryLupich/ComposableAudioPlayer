//
//  PlayerFeature.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 16.01.2024.
//

import Foundation
import AVFoundation
import ComposableArchitecture

@Reducer
struct PlayerFeature {

    let environment: Environment

    init(playerSerice: PlayerService) {
        environment = .live(playerSerice)
    }

    //MARK: - State

    struct State: Equatable {
        var book: BookModel
        var progress: Double = .zero
        var playbackSpeed: PlaybackSpeed
        var isPlayerMode: Bool
        var currentChapter: Node<Chapter>?
        var controlsState: PlayerControlsFeature.State
        private let numberOfChapters: Int
        var currentTime: String = "0:00"

        init(
            book: BookModel,
            progress: Double = .zero,
            playbackSpeed: PlaybackSpeed,
            isPlayerMode: Bool,
            controlsState: PlayerControlsFeature.State
        ) {
            self.book = book
            self.progress = progress
            self.playbackSpeed = playbackSpeed
            self.isPlayerMode = isPlayerMode
            self.currentChapter = Node<Chapter>.create(from: book.chapters)
            self.controlsState = controlsState
            self.numberOfChapters = book.chapters.count
        }

        var duration: Double { currentChapter?.value.duration ?? .zero }

        var keyPointTitle: String {
            "Key Point \(currentChapterIndex + 1) of \(numberOfChapters)".uppercased()
        }

        var chapterDescription: String {
            currentChapter.map(\.value.description) ?? ""
        }

        private var currentChapterIndex: Int {
            currentChapter.flatMap { book.chapters.firstIndex(of: $0.value) } ?? .zero
        }
    }

    //MARK: - Action

    enum Action: Equatable {
        case onAppear
        case onProgressChange(Double)
        case onTimeChange(Double)
        case scrollToProgress(Double)
        case updateButtonsState
        case toogleSpeed
        case toggleMode
        case controlsAction(PlayerControlsFeature.Action)
        case onDisappear
    }

    //MARK: - Reducer

    var body: some ReducerOf<Self> {
        Scope(
            state: \.controlsState,
            action: /Action.controlsAction,
            child: { PlayerControlsFeature() }
        )
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.currentChapter
                    .map { environment.setItem($0.value.audioFile) }

                let updateButtonsEffect = Effect.run { send in
                    await send(Action.updateButtonsState)
                }

                return Effect.publisher {
                    environment
                        .progress()
                        .map(Action.onProgressChange)
                }.merge(
                    with: Effect.publisher {
                        environment
                            .time()
                            .map(Action.onTimeChange)
                    }.merge(with: updateButtonsEffect)
                ).cancellable(id: Cancellable())

            case let .onProgressChange(progress):
                state.progress = progress
                return .none

            case let .onTimeChange(time):
                state.currentTime = time.fromattedTime
                return .none

            case let .scrollToProgress(progress):
                environment.scrollTo(progress)
                return .none

            case .updateButtonsState:
                state.controlsState.isPrevDisabled = state.currentChapter?.prev == nil
                state.controlsState.isNextDisabled = state.currentChapter?.next == nil
                return .none

            case .toogleSpeed:
                state.playbackSpeed.toggle()
                environment.toggleSpeed()
                return .none

            case .toggleMode:
                state.isPlayerMode.toggle()
                return .none

            case let .controlsAction(controlAction):
                switch controlAction {
                case .prev:
                    if let prev = state.currentChapter?.prev {
                        state.currentChapter = prev
                        state.currentChapter
                            .map { environment.setItem($0.value.audioFile) }
                        return Effect.run { send in
                            await send(.updateButtonsState)
                        }
                    }
                    return .none

                case .next:
                    if let next = state.currentChapter?.next {
                        state.currentChapter = next
                        state.currentChapter
                            .map { environment.setItem($0.value.audioFile) }
                        return Effect.run { send in
                            await send(.updateButtonsState)
                        }
                    }
                    return .none

                case .togglePlay:
                    state.controlsState.isPaused ? environment.play() : environment.pause()
                    return .none

                case let .rewind(seconds):
                    environment.rewind(Double(seconds))
                    return .none
                }
            case .onDisappear:
                return .cancel(id: Cancellable())
            }
        }
    }
}

//MARK: - Cancellable

private extension PlayerFeature {
    struct Cancellable: Hashable {}
}
