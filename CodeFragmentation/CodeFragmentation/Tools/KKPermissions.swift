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
public enum PermissionStatus: String,CustomStringConvertible {
    case authorized    = "Authorized"
    case denied        = "Denied"
    case disabled      = "Disabled"
    case notDetermined = "Not Determined"

    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(rawValue: string)
    }

    public var description: String {
        return rawValue
    }
}

extension KKPermissions {
    public typealias Callback = (PermissionStatus) -> Void
}


//MARK:获取权限状态
extension KKPermissions {
    ///麦克风权限
    public class func microphoneAuthorizationStatus() -> PermissionStatus {
        let audioSession = AVAudioSession.sharedInstance()
        let status = audioSession.recordPermission
        switch status {
        case .denied:
            return .denied
        case .granted:
            return .authorized
        case .undetermined:
            return .notDetermined
        default:
            return .disabled
        }
    }
    
    ///通讯录权限
    public class func contactAuthorizationStatus() -> PermissionStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .denied, .restricted:
            return .denied
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        default:
            return .disabled
        }
    }
    
    ///地理位置权限
    public class func locationAuthorizationStatus() -> PermissionStatus {
        let status = CLLocationManager.authorizationStatus()
            
        switch status {
        case .denied, .restricted:
            return .denied
        case .authorizedAlways,.authorizedWhenInUse:
            return .authorized
        case .notDetermined:
            return .notDetermined
        default:
            return .disabled
        }
    }
    
    ///蓝牙权限
    //TODO: 获取时会触发弹窗
    public class func bluetoothAuthorizationStatus() -> PermissionStatus {
//        let status = CBPeripheralManager.authorizationStatus()

        let status = CBPeripheralManager().state

        switch status {
        case .unsupported, .poweredOff:
            return .disabled
        case .unauthorized:
            return .denied
        case .poweredOn:
            return .authorized
        case .resetting, .unknown:
            return .notDetermined
        default:
            return .disabled
        }
    }
    
}

//MARK:权限请求方法
extension KKPermissions {
    ///蓝牙权限
    public class func requestBluetooth(_ callback: @escaping Callback){
        KKPermissions.provide.bluetoothManager = KKPermissions.provide.createBluetoothManager()
        KKPermissions.provide.bluetoothCallBack = callback
        KKPermissions.provide.bluetoothManager.startAdvertising(nil)
        KKPermissions.provide.bluetoothManager.stopAdvertising()
    }
    
    ///应用内定位权限
    public class func requestLocationWhenInUse(_ callback: @escaping Callback){
        KKPermissions.provide.LocationManager = KKPermissions.provide.createLocationManager()
        KKPermissions.provide.LocationManager.requestWhenInUseAuthorization()
        KKPermissions.provide.locationCallBack = callback
    }
    
    ///持续使用定位权限
    public class func requestLocationAlways(_ callback: @escaping Callback){
        KKPermissions.provide.LocationManager = KKPermissions.provide.createLocationManager()
        KKPermissions.provide.LocationManager.requestAlwaysAuthorization()
        KKPermissions.provide.locationCallBack = callback
    }
    
    ///麦克风权限
    public class func requestMicrophone(_ callback: @escaping Callback){
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
    public class func requestContacts(_ callback: @escaping Callback) {
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
    public class func requestPhoto(_ callback: @escaping Callback) {
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
        case .limited:
            callback(.authorized)
        @unknown default:
            callback(.denied)
        }
    }
    
    //MARK: 相机权限
    public class func requestCamera(_ callback: @escaping Callback) {
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
    public class func jumpToSystemPrivacySetting() {
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
    
    private func createBluetoothManager() -> CBPeripheralManager{
        let bluetoothManager = CBPeripheralManager(
            delegate: KKPermissions.provide,
            queue: nil,
            options: nil)
        return bluetoothManager
    }
    
    private func createLocationManager() -> CLLocationManager{
        let locManager = CLLocationManager()
        locManager.delegate = KKPermissions.provide
        return locManager
    }
    
    private var LocationManager:CLLocationManager!

    private static var locationState: PermissionStatus?
    
    private var locationCallBack: Callback?

    private var bluetoothManager: CBPeripheralManager!
    
    private var bluetoothCallBack: Callback?

    private static var bluetoothState: PermissionStatus?

    private static let provide:KKPermissions =  KKPermissions()
    
    private override init() {
        super.init()
    }
}

//MARK: 定位/蓝牙 代理处理
extension KKPermissions: CLLocationManagerDelegate,CBPeripheralManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard KKPermissions.provide.LocationManager != nil else {
            return
        }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            KKPermissions.locationState = .authorized
            break
        case .restricted, .denied:
            KKPermissions.locationState = .denied
            break
        case .notDetermined:
            KKPermissions.locationState = .notDetermined
            break
        @unknown default:
            KKPermissions.locationState = .notDetermined
            break
        }
        
        self.locationCallBack?(KKPermissions.locationState!)
        
        self.locationCallBack = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print(">>>>>权限状态测试  KKpermissions \(peripheral.state)")

        guard KKPermissions.provide.bluetoothManager != nil else {
            return
        }
        
        switch peripheral.state {
        case .unsupported, .poweredOff:
            KKPermissions.bluetoothState = .disabled
            break
        case .unauthorized:
            KKPermissions.bluetoothState = .denied
            break
        case .poweredOn:
            KKPermissions.bluetoothState = .authorized
            break
        case .resetting, .unknown:
            KKPermissions.bluetoothState = .notDetermined
            break
        @unknown default:
            KKPermissions.bluetoothState = .notDetermined
            break
        }
        
        self.bluetoothCallBack?(KKPermissions.bluetoothState!)
        
        //响应一次后不再持有
        self.bluetoothCallBack = nil
    }
}
