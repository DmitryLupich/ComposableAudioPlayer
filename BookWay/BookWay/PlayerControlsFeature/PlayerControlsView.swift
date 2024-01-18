//
//  PlayerControlsView.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 16.01.2024.
//

import SwiftUI
import ComposableArchitecture

//MARK: - View
struct PlayerControlsView: View {
    let store: StoreOf<PlayerControlsFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(spacing: 32) {
                ForEach(viewStore.buttons) { buttonType in
                    Button {
                        let action = action(for: buttonType)
                        viewStore.send(action)
                    } label: {
                        Image(systemName: buttonType.imageName)
                            .resizable()
                            .frame(width: buttonType.size, height: buttonType.size)
                            .tint(.black)
                    }.disabled(
                        (buttonType == .prev && viewStore.isPrevDisabled)
                                             ||
                        (buttonType == .next && viewStore.isNextDisabled)
                    )
                }
            }
        }
    }
}

//MARK: - Private methods

private extension PlayerControlsView {
    func action(for button: ButtonType) -> PlayerControlsFeature.Action {
        switch button {
        case .prev:
            return .prev
        case .next:
            return .next
        case .play, .pause:
            return .togglePlay
        case .rewindBackward:
            return .rewind(-5)
        case .rewindForward:
            return .rewind(10)
        }
    }
}

//MARK: - Button Types

enum ButtonType: Identifiable {
    var id: Self { self }

    case prev
    case next

    case play
    case pause

    case rewindBackward
    case rewindForward

    var imageName: String {
        switch self {
        case .prev:
            return "backward.end.fill"
        case .next:
            return "forward.end.fill"
        case .play:
            return "play.fill"
        case .pause:
            return "pause.fill"
        case .rewindBackward:
            return "gobackward.5"
        case .rewindForward:
            return "goforward.10"
        }
    }

    var size: CGFloat {
        switch self {
        case .prev, .next:
            return 20
        case .play, .pause:
            return 36
        case .rewindBackward, .rewindForward:
            return 28
        }
    }
}
