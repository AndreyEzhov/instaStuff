//
//  Common.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 10.03.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

struct Settings {
    var center: CGPoint
    var sizeWidth: CGFloat
    var angle: CGFloat
}

struct FrameAreaDescription {
    enum FrameAreaType {
        case textFrame(TextItem), photoFrame(PhotoItem, PhotoItemCustomSettings?), stuffFrame(StuffItem), viewFrame(ViewItem)
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
    var preview: UIImage? {
        return UIImage(named: frameName + "_preview")
    }
}

struct PhotoItemCustomSettings {
    enum CloseButtonPosition: Int16 {
        case rightTop = 0, leftTop = 1, leftBottom = 2, rightBottom = 3
    }
    let closeButtonPosition: CloseButtonPosition?
    let plusLocation: CGPoint?
}

struct TextItem {
    let textSetups: TextSetups
    let defautText: String
}

struct StuffItem: PreviewProtocol {
    
    typealias Id = Int
    
    let stuffId: StuffItem.Id
    
    let imageName: String
    
    var stuffImage: UIImage? {
        return UIImage(named: imageName)
    }
    
    var preview: UIImage? {
        return stuffImage
    }
}

struct ViewItem {
    let color: UIColor
}
