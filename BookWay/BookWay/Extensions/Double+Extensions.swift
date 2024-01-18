//
//  Double+Extensions.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 18.01.2024.
//

import Foundation

extension Double {
    /// 3:25 | m:s
    var fromattedTime: String {
        let time = Int(self)
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60

        return String(format: "%02i:%02i", minute, second)
    }
}
