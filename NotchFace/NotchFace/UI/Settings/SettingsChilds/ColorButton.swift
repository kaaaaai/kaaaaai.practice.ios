//
//  ColorButton.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/7/9.
//  Copyright © 2024 NotchFace. All rights reserved.
//

import SwiftUI

struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 15, height: 15)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.black.opacity(0.5) : Color.clear, lineWidth: 0.5)
                    )
                Circle()
                    .fill(isSelected ? Color.white: Color.clear)
                    .frame(width: 5, height: 5)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
