//
//  KKSwiftLabTool.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/11.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

class KKSwiftLabTool: NSObject {
    @objc static let shareManage = KKSwiftLabTool()
}

enum Color {
   case red
   case yellow
   case blue
}

func testEnum() {
    let i: Int = 1
    print(MemoryLayout.size(ofValue: i))       // 8
  
    let color = Color.blue
    print(MemoryLayout.alignment(ofValue: color))  // 1
    print(MemoryLayout.size(ofValue: color))       // 1
    print(MemoryLayout.stride(ofValue: color))     // 1
}
