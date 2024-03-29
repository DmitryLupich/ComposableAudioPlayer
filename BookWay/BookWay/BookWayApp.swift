//
//  BookWayApp.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 16.01.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct BookWayApp: App {
    var body: some Scene {
        WindowGroup {
            PlayerView(
                store: Store(
                    initialState: PlayerFeature.State(
                        book: .mock,
                        playbackSpeed: .normal,
                        isPlayerMode: true,
                        controlsState: PlayerControlsFeature.State()
                    ),
                    reducer: {
                        PlayerFeature()
                            .dependency(
                                \.playerClient,
                                 .live
                            )
                    }
                )
            )
        }
    }
}
