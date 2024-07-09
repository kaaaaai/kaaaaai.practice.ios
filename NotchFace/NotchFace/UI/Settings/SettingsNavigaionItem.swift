//
//  SettingsNavigaionItem.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import SwiftUI

struct SettingsNavigationItem: Hashable, Identifiable {
    let name: Name
    let icon: IconResource
    var id: Int { name.hashValue }
}

extension SettingsNavigationItem {
    enum Name: String {
        case general = "General"
        case audio = "Audio"
        case brightness = "Brightness"
        case kbBrightness = "Keyboard Brightness"
        case playing = "Now Playing"
        case about = "About"

        var localized: LocalizedStringKey {
            LocalizedStringKey(rawValue)
        }
    }
}

extension SettingsNavigationItem {
    enum IconResource: Hashable {
        case systemSymbol(_ name: String, backgroundColor: NSColor?)
        case assetCatalog(_ resource: ImageResource, backgroundColor: NSColor?)

        var view: some View {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .frame(width: 25, height: 25)
                .background(backgroundColor?.uiColor ?? Color.clear)
                .cornerRadius(7)
        }

        private var image: Image {
            switch self {
            case .systemSymbol(let name, _):
                Image(systemName: name)
            case .assetCatalog(let resource, _):
                Image(resource)
            }
        }
        
        private var backgroundColor: NSColor? {
            switch self {
            case .systemSymbol(_, let backgroundColor),
                    .assetCatalog(_, let backgroundColor):
                return backgroundColor
            }
        }
    }
}
