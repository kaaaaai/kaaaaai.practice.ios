//
//  CustomVolumeView.swift
//  NotchFace
//
//  Created by Kai Lv on 2024/6/4.
//

import SwiftUI

struct CustomVolumeView: View {
    @State private var volume: Float = 0.0
    @State private var showVolumeView = false

    var body: some View {
        VStack {
            if showVolumeView {
                VStack {
                    Spacer()
                    Text("Volume: \(Int(volume * 100))%")
                    ProgressBar(value: $volume)
                        .cornerRadius(10)
                        .frame(height: 20)
                        .padding()
                }
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding()
                .transition(.move(edge: .top))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.showVolumeView = false
                        }
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .volumeDidChange)) { notification in
            if let userInfo = notification.userInfo, let newVolume = userInfo["volume"] as? Float {
                self.volume = newVolume
                withAnimation {
                    self.showVolumeView = true
                }
            }
        }
    }
}

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.blue)
                    .animation(.linear)
            }
        }
    }
}
