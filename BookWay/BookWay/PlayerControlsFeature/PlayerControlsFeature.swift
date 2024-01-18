//
//  PlayerControlsFeature.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 18.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayerControlsFeature: Reducer {

    //MARK: - State

    struct State: Equatable {
        var isPrevDisabled: Bool = false
        var isNextDisabled: Bool = false
        var isPaused: Bool = false

        var buttons: [ButtonType] {
            [
                .prev, .rewindBackward,
                isPaused ? ButtonType.pause : .play,
                .rewindForward, .next
            ]
        }
    }

    //MARK: - Action

    enum Action: Equatable {
        case prev
        case next
        case togglePlay
        case rewind(Int)
    }

    //MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .prev:
                return .none
            case .next:
                return .none
            case .togglePlay:
                state.isPaused.toggle()
                return .none
            case .rewind:
                return .none
            }
        }
    }
}
