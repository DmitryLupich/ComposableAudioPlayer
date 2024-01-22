//
//  Dependencies.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 22.01.2024.
//

import Foundation
import ComposableArchitecture

private enum PlayerServiceKey: DependencyKey {
    static var liveValue: PlayerService = .live
}

extension DependencyValues {
  var playerClient: PlayerService {
    get { self[PlayerServiceKey.self] }
    set { self[PlayerServiceKey.self] = newValue }
  }
}
