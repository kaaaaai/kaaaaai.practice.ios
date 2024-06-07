//
//  VolumeMonitor.swift
//  NotchFace
//
//  Created by Kai Lv on 2024/6/4.
//

import Cocoa
import CoreAudio

class VolumeMonitor {
    static let shared = VolumeMonitor()
    
    private var defaultOutputDeviceID: AudioDeviceID = kAudioObjectUnknown

    private init() {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        
        AudioObjectAddPropertyListener(AudioObjectID(kAudioObjectSystemObject), &address, defaultOutputDeviceChanged, nil)
        updateDefaultOutputDevice()
    }
    
    private func updateDefaultOutputDevice() {
        var deviceID = AudioDeviceID(0)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var size = UInt32(MemoryLayout<AudioDeviceID>.size)
        
        let status = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size, &deviceID)
        
        if status == noErr {
            defaultOutputDeviceID = deviceID
            addVolumeListener()
        }
    }
    
    private func addVolumeListener() {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        AudioObjectAddPropertyListener(defaultOutputDeviceID, &address, volumeDidChange, nil)
        notifyCurrentVolume()
    }
    
    private func notifyCurrentVolume() {
        var volume: Float = 0.0
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        var size = UInt32(MemoryLayout<Float>.size)
        
        let status = AudioObjectGetPropertyData(defaultOutputDeviceID, &address, 0, nil, &size, &volume)
        
        if status == noErr {
            NotificationCenter.default.post(name: .volumeDidChange, object: nil, userInfo: ["volume": volume])
        }
    }
    
    private let defaultOutputDeviceChanged: AudioObjectPropertyListenerProc = { _, _, _,_  in
        VolumeMonitor.shared.updateDefaultOutputDevice()
        return 0
    }
    
    private let volumeDidChange: AudioObjectPropertyListenerProc = { _, _, _,_  in
        VolumeMonitor.shared.notifyCurrentVolume()
        return 0
    }
}

extension Notification.Name {
    static let volumeDidChange = Notification.Name("volumeDidChange")
}
