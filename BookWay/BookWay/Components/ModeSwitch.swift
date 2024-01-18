//
//  ModeSwitch.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 17.01.2024.
//

import SwiftUI

/// Good candidate for moving logic to separate Reducer
struct ModeSwitch: View {
    @State private var isPlayerMode = true {
        didSet {
            if oldValue != isPlayerMode {
                toggleAction(isPlayerMode)
            }
        }
    }
    
    private var toggleAction: (Bool) -> Void

    init(_ toggleAction: @escaping (Bool) -> Void) {
        self.toggleAction = toggleAction
    }

    var body: some View {
        ZStack {
            Capsule()
                .foregroundStyle(.white)

            if isPlayerMode {
                HStack {
                    blueCircle
                    Spacer()
                }
            } else {
                HStack {
                    Spacer()
                    blueCircle
                }
            }

            HStack(spacing: 4) {
                headphonesButton
                textButton
            }
        }.frame(width: 100, height: 56)
    }
}

//MARK: - Private Views

private extension ModeSwitch {
    var blueCircle: some View {
        Circle()
            .foregroundStyle(.blue)
            .frame(width: 48, height: 48)
    }

    var textButton: some View {
        Button {
            withAnimation {
                isPlayerMode = false
            }
        } label: {
            Image(systemName: "text.alignleft")
                .foregroundStyle(!isPlayerMode ? .white : .brown)
                .frame(width: 48, height: 48)
        }
    }

    var headphonesButton: some View {
        Button {
            withAnimation {
                isPlayerMode = true
            }
        } label: {
            Image(systemName: "headphones")
                .foregroundStyle(isPlayerMode ? .white : .brown)
                .frame(width: 48, height: 48)
        }
    }
}
