//
//  ButtonStyle.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 17.01.2024.
//

import SwiftUI

struct GrayButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(configuration.isPressed ? .gray.opacity(0.10) : .gray.opacity(0.25))
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
    }
}
