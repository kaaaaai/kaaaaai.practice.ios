//
//  KKVolumeDownIcon.swift
//  CodeFragmentation
//
//  Created by Kaaaaai on 2021/8/6.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

class KKVolumeDownIcon: UIControl {
    override func draw(_ rect: CGRect) {
        VolumeDown.drawCanvas1(frame: rect,resizing: .aspectFill)
    }
}
