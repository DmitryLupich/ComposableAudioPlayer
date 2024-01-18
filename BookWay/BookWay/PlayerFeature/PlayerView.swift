//
//  PlayerView.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 16.01.2024.
//

import SwiftUI
import ComposableArchitecture

//MARK: - Player View

struct PlayerView: View {
    typealias PlayerViewStore = ViewStore<PlayerFeature.State, PlayerFeature.Action>
    
    let store: StoreOf<PlayerFeature>
    
    var body: some View {
        VStack(spacing: .zero) {
            ZStack {
                Constants.backgroundColor.ignoresSafeArea(.all)
                WithViewStore(store, observe: { $0 }) { viewStore in
                    ZStack {
                        if viewStore.isPlayerMode {
                            playModeView(viewStore)
                        } else {
                            textModeView(viewStore)
                        }
                        
                        VStack {
                            Spacer()
                            ModeSwitch { isPlayerMode in
                                viewStore.send(.toggleMode)
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Private Views

private extension PlayerView {
    func playModeView(_ viewStore: PlayerViewStore) -> some View {
        VStack(spacing: .zero) {
            Image(viewStore.book.cover)
                .resizable()
                .frame(width: 200, height: 300)
                .scaledToFill()
                .padding(.vertical, 32)
            
            Text(viewStore.keyPointTitle)
                .foregroundStyle(.gray)
                .padding(.bottom, 8)
            
            Text(viewStore.chapterDescription)
                .lineLimit(2)
                .padding(.bottom, 8)
                .padding(.horizontal, 32)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                Text(viewStore.currentTime)
                    .frame(width: 48)
                    .foregroundStyle(.brown)
                    .lineLimit(1)
                Slider(
                    value: viewStore.binding(
                        get: \.progress,
                        send: PlayerFeature.Action.scrollToProgress
                    )
                )
                .frame(width: 250)
                Text(viewStore.state.duration.fromattedTime)
                    .frame(width: 48)
                    .foregroundStyle(.brown)
                    .lineLimit(1)
            }
            .foregroundColor(.blue)
            .padding(.bottom, 8)
            
            Button {
                viewStore.send(.toogleSpeed)
            } label: {
                Text(viewStore.playbackSpeed.title)
                    .bold()
            }
            .buttonStyle(GrayButton())
            .padding(.bottom, 32)
            
            Spacer()
            
            PlayerControlsView(
                store: store.scope(
                    state: \.controlsState,
                    action: PlayerFeature.Action.controlsAction
                )
            )
            .padding(.bottom, 128)
        }
        .onAppear { viewStore.send(.onAppear) }
    }
    
    func textModeView(_ viewStore: PlayerViewStore) -> some View {
        Text(viewStore.chapterDescription)
    }
}

//MARK: - Constants

private extension PlayerView {
    enum Constants {
        static let backgroundColor = Color(
            uiColor: UIColor(
                red: 254/255,
                green: 248/255,
                blue: 244/255,
                alpha: 1
            )
        )
    }
}
