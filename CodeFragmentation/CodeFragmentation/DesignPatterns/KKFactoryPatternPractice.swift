//
//  KKFactoryPatternPractice.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/23.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

class KKFactoryPatternPractice: NSObject {

}

//模拟存在的语音类
protocol OSManager {
    func createOSManager()
}

class iFly: OSManager {
    func createOSManager(){
        NSLog("iFly 被创建了")
    }
}

class Baidu: OSManager {
    func createOSManager()  {
        NSLog("Baidu 被创建了")
    }
}

class Tianmao: OSManager {
    func createOSManager() {
        NSLog("Tianmao 被创建了")
    }
}

//简单工厂模式
class voiceManager {
    func createVoiceManageWithType(type:NSString) -> OSManager {
        switch type {
        case "iFly":
            let iflyOS = iFly.init()
            iflyOS.createOSManager()
            return iflyOS
        case "Tianmao":
            let tianmaoOS = Tianmao.init()
            tianmaoOS.createOSManager()
            return tianmaoOS
        default:
            let baiduOS = Baidu.init()
            baiduOS.createOSManager()
            return baiduOS
        }
    }
}
