//
//  Common.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 10.03.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

struct Settings {
    let center: CGPoint
    let sizeWidth: CGFloat
    let angle: CGFloat
    let ratio: CGFloat
}

struct FrameAreaDescription {
    enum FrameAreaType {
        case textFrame(TextItem), photoFrame(PhotoItem), stuffFrame(StuffItem)
    }
    let settings: Settings
    let frameArea: FrameAreaType
}

struct PhotoItem {
    
    typealias Id = String
    
    let frameName: PhotoItem.Id
    let photoAreaLocation: Settings
    var framePlaceImage: UIImage? {
        return UIImage(named: frameName + "_frameplace")
    }
}

struct TextItem {
    let textSetups: TextSetups
    let defautText: String
}

struct StuffItem {
    typealias Id = String
    
    let stuffName: PhotoItem.Id
    
    var stuffImage: UIImage? {
        return UIImage(named: stuffName)
    }
}
