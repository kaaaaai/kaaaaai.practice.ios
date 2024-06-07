//
//  CustomPopView.swift
//  NotchFace
//
//  Created by Kai Lv on 2024/6/4.
//

import SwiftUI

struct CustomPopView: View {
    var body: some View {
           VStack {
               Text("Custom Popover")
                   .font(.headline)
                   .padding()
               Button("Close") {
                   NSApplication.shared.keyWindow?.close()
               }
               .padding()
           }
           .frame(width: 200, height: 100)
       }
}

#Preview {
    CustomPopView()
}
