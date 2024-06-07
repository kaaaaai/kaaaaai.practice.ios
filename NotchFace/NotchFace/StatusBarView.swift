//
//  StatusBarView.swift
//  NotchFace
//
//  Created by Kai Lv on 2024/6/4.
//

import Cocoa
import SwiftUI

class StatusBarController {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    var eventMonitor: Any?
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "🔍"
        }
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: 200, height: 100)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: CustomPopView())
        
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .gesture], handler: handleMouseMoved)
        
        // 设置全局手势事件监听器
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .gesture) { [weak self] event in
            self?.handleGesture(event: event)
        }
    }
    
    private func handleMouseMoved(event: NSEvent) {
       
        
        let screenFrame = NSScreen.main?.frame ?? .zero
        let mouseLocation = NSEvent.mouseLocation
        
        if mouseLocation.x > (screenFrame.midX - 50) && mouseLocation.x < (screenFrame.midX + 50) && mouseLocation.y > (screenFrame.height - 20) {
            showPopover(at: mouseLocation)
        } else {
            popover.performClose(nil)
        }
        
        if event.type == .gesture {
            NSLog("handleGesture:\(event)")
        }
    }
    
    @objc func togglePopover() {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            if let button = statusItem?.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
            }
        }
    }
    
    func handleGesture(event: NSEvent) {
        NSLog("handleGesture:\(event)")
        
        // 检查是否为三指点击
        if event.type == .gesture && event.subtype.rawValue == 0x9 { // 0x9 corresponds to some gesture
            togglePopover()
        }
        
        // 检查是否为三指下滑手势
        if event.type == .swipe && event.deltaY == -1 && event.phase == .began {
            togglePopover()
        }
    }
    
    private func showPopover(at point: NSPoint) {
        if let button = statusItem.button, !popover.isShown {
            let screenFrame = NSScreen.main?.frame ?? .zero
            let popoverOrigin = NSPoint(x: screenFrame.midX - 100, y: screenFrame.height - 22) // Adjust the y position
            
            let rect = NSRect(origin: popoverOrigin, size: .zero)
            
            popover.show(relativeTo: rect, of: button.window!.contentView!, preferredEdge: .maxY)
        }
    }
}

struct CustomTooltipView: View {
    var body: some View {
        VStack {
            Text("Custom Tooltip")
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 100)
    }
}
