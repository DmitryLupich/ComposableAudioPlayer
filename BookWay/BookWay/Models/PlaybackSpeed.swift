//
//  PlaybackSpeed.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 17.01.2024.
//

import Foundation

enum PlaybackSpeed: Equatable {
    case normal
    case fast

    var title: String {
        switch self {
        case .normal:
            return "Speed x1"
        case .fast:
            return "Speed x2"
        }
    }

    var value: Float {
        switch self {
        case .normal:
            return 1.0
        case .fast:
            return 2.0
        }
    }

    mutating func toggle() {
        self = self == .normal ? .fast : .normal
    }
}
