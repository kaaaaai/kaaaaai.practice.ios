//
//  KKPermissions.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/9/3.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit
import Contacts
import AVFoundation
import Photos
import CoreBluetooth

//MARK: 权限状态枚举
public enum PermissionStatus: String {
    case authorized    = "Authorized"
    case denied        = "Denied"
    case disabled      = "Disabled"
    case notDetermined = "Not Determined"

    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(rawValue: string)
    }
}

extension PermissionStatus: CustomStringConvertible {
    /// The textual representation of self.
    public var description: String {
        return rawValue
    }
}

extension KKPermissions {
    public typealias Callback = (PermissionStatus) -> Void
}

//MARK:权限请求方法
extension KKPermissions{
    //MARK:蓝牙权限
    public static func requestBluetooth(_ callback: @escaping Callback){
        guard KKPermissions.provide.bluetoothManager.state == .poweredOn else{ return }
        KKPermissions.provide.bluetoothManager.startAdvertising(nil)
        KKPermissions.provide.bluetoothManager.stopAdvertising()
    }
    
    //MARK:应用内定位权限
    public static func requestLocationWhenInUse(_ callback: @escaping Callback){
        KKPermissions.provide.LocationManager.requestWhenInUseAuthorization()
        KKPermissions.provide.locationCallBack = callback
    }
    
    //MARK:持续使用定位权限
    public static func requestLocationAlways(_ callback: @escaping Callback){
        KKPermissions.provide.LocationManager.requestAlwaysAuthorization()
        KKPermissions.provide.locationCallBack = callback
    }
    
    //MARK:麦克风权限
    public static func requestMicrophone(_ callback: @escaping Callback){
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { (allowed) in
            if allowed {
                callback(.authorized)
            }else{
                callback(.denied)
            }
        }
    }
    
    //MARK:通讯录权限
    public static func requestContacts(_ callback: @escaping Callback) {
        //1.获取授权状态
        //CNContactStore 通讯录对象
        let status = CNContactStore.authorizationStatus(for: .contacts)

        var phoneStatus: PermissionStatus

        //2.判断如果是未决定状态,则请求授权
        if status == .notDetermined {

            //创建通讯录对象
            let store = CNContactStore()

            phoneStatus = .notDetermined
            //请求授权
            store.requestAccess(for: .contacts, completionHandler: {(isRight : Bool,error : Error?) in

                if isRight {
                    print("授权成功")
                    phoneStatus = .authorized
                } else {
                    phoneStatus = .denied
                    print("授权失败")
                }
                
                callback(phoneStatus)
            })
        }else if status != .authorized {
            phoneStatus = .denied
            callback(phoneStatus)
        }else{
            phoneStatus = .authorized
            callback(phoneStatus)
        }
    }
    
    //MARK: 相册权限
    static func requestPhoto(_ callback: @escaping Callback) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            callback(.authorized)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            callback(.denied)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                DispatchQueue.main.async {
                    if status == .authorized{
                        callback(.authorized)
                    }else{
                        callback(.denied)
                    }
                }
            })
        @unknown default:
            callback(.denied)
        }
    }
    
    //MARK: 相机权限
    static func requestCamera(_ callback: @escaping Callback) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch granted {
        case .authorized:
            callback(.authorized)
        case .denied,.restricted:
            callback(.denied)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        callback(.authorized)
                    }else{
                        callback(.denied)
                    }
                }
            })
        @unknown default:
            callback(.denied)
        }
    }
    
    //MARK: 跳转到APP系统设置权限界面
    public static func jumpToSystemPrivacySetting() {
        guard let appSetting = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appSetting)
        }
    }
}

class KKPermissions: NSObject {
    
    private lazy var LocationManager:CLLocationManager = {
        let locManager = CLLocationManager()
        locManager.delegate = KKPermissions.provide
        return locManager
    }()
    
    private var locationCallBack: Callback?

    private lazy var bluetoothManager = CBPeripheralManager(
        delegate: KKPermissions.provide,
        queue: nil,
        options: [CBPeripheralManagerOptionShowPowerAlertKey : false])
    
    private var bluetoothCallBack: Callback?

    private static let provide:KKPermissions =  KKPermissions()
    
    private override init() {
        super.init()
    }
}

//MARK: 定位/蓝牙 代理处理
extension KKPermissions: CLLocationManagerDelegate,CBPeripheralManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationCallBack?(.authorized)
            break
        case .restricted, .denied:
            self.locationCallBack?(.denied)
            break
        case .notDetermined:
            self.locationCallBack?(.notDetermined)
            break
        @unknown default:
            self.locationCallBack?(.notDetermined)
            break
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unsupported, .poweredOff:
            self.bluetoothCallBack?(.disabled)
            break
        case .unauthorized:
            self.bluetoothCallBack?(.denied)
            break
        case .poweredOn:
            self.bluetoothCallBack?(.authorized)
            break
        case .resetting, .unknown:
            self.bluetoothCallBack?(.notDetermined)
            break
        @unknown default:
            self.bluetoothCallBack?(.notDetermined)
            break
        }
    }
}
