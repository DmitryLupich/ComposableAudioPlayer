//
//  BookWayTests.swift
//  BookWayTests
//
//  Created by Dmitriy Lupych on 16.01.2024.
//

import XCTest
import ComposableArchitecture
@testable import BookWay

@MainActor
final class BookWayTests: XCTestCase {
    func testToggleSpeed() async {
        // Given
        let store = TestStore(initialState: PlayerFeature.State(
            book: .mock,
            playbackSpeed: .normal,
            isPlayerMode: true,
            controlsState: .init()
        )
        ) {
            PlayerFeature(playerSerice: .init())
        }

        // Then

        await store.send(.toogleSpeed) {
            $0.playbackSpeed = .fast
        }

        await store.send(.toogleSpeed) {
            $0.playbackSpeed = .normal
        }
    }

    func testToggleMode() async {
        // Given
        let store = TestStore(initialState: PlayerFeature.State(
            book: .mock,
            playbackSpeed: .normal,
            isPlayerMode: true,
            controlsState: .init()
        )
        ) {
            PlayerFeature(playerSerice: .init())
        }

        // Then

        await store.send(.toggleMode) {
            $0.isPlayerMode = false
        }

        await store.send(.toggleMode) {
            $0.isPlayerMode = true
        }
    }

    func testPlayPause() async {
        // Given
        let store = TestStore(initialState: PlayerFeature.State(
            book: .mock,
            playbackSpeed: .normal,
            isPlayerMode: true,
            controlsState: .init()
        )
        ) {
            PlayerFeature(playerSerice: .init())
        }

        // Then

        await store.send(.controlsAction(.togglePlay)) {
            $0.controlsState.isPaused = true
        }

        await store.send(.controlsAction(.togglePlay)) {
            $0.controlsState.isPaused = false
        }
    }

    //TODO: - Add more tests
}
