//
//  BrightnessSettingView.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import SwiftUI

struct BrightnessSettingView: View {
    @State private var selectedColor: Color = .red
    @State private var selectedColorName: String = "Red"
    
    private let colors: [(color: Color, name: String)] = [
        (.red, "Red"), (.orange, "Orange"), (.yellow, "Yellow"),
        (.green, "Green"), (.blue, "Blue"), (.purple, "Purple"),
        (.pink, "Pink"), (.gray, "Gray"), (.teal, "Teal")
    ]
    
    var body: some View {
        Form {
            Section {
                HStack(alignment: .top) {
                    Text("Bar color")
                        .font(.system(size: 14))
                        .foregroundStyle(.primary)
                    Spacer()
                    VStack(alignment: .leading, content: {
                        HStack {
                            ForEach(colors, id: \.name) { colorItem in
                                ColorButton(color: colorItem.color, isSelected: colorItem.color == selectedColor) {
                                    selectedColor = colorItem.color
                                    selectedColorName = colorItem.name
                                }
                            }
                        }
                        Text(selectedColorName)
                            .font(.system(size: 12))
                            .padding(.top, 5)
                            .foregroundColor(.gray)
                    })
                }
                .padding(.leading, 0)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    BrightnessSettingView()
}
