//
//  ContentView.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/4.
//

import SwiftUI
import AppKit


struct ContentView: View {
    @State private var isModalPresented = false
    
    @State private var hoverLocation: CGPoint = .zero
    @State private var isHovering = false
    @State private var date:Date?
    @State private var selection = 0
    @State private var quantity = 0
    
    var body: some View {
        buildBody
    }
    
    var buildBody: some View {
        return VStack {
            Text("x: \(hoverLocation.x), y: \(hoverLocation.y)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Color.black)
                .background(Color.white)
                .onAppear {
                    NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { event in
                        let mouseLocation = NSEvent.mouseLocation
                        let screenSize = NSScreen.main?.frame.size ?? .zero
                        let screenCenter = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
                        let distanceToCenter = distanceBetweenPoints(screenCenter, mouseLocation)
                        if distanceToCenter < 20 {
                            isModalPresented = true
                        } else {
                            isModalPresented = false
                        }
                        hoverLocation = mouseLocation
                    }
                }
                .onContinuousHover { phase in
                    switch phase {
                    case .active(let location):
                        hoverLocation = location
                        isHovering = true
                    case .ended:
                        isHovering = false
                    }
                }
                .popover(isPresented: $isModalPresented) {
                    ModalView() // Your popover content view
                }
            CustomVolumeView()
                .frame(width: 300, height: 100)
                .padding()
        }
    }
}

struct ModalView: View {
    var body: some View {
        Text("Modal Popup")
            .font(.title)
            .padding()
    }
}

func distanceBetweenPoints(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let deltaX = b.x - a.x
    let deltaY = b.y - a.y
    return sqrt(deltaX * deltaX + deltaY * deltaY)
}

#Preview {
    ContentView()
}
