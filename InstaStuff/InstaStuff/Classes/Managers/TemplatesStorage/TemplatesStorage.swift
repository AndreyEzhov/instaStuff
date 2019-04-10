//
//  TemplatesStorage.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class TemplatesStorage {
    
    // MARK: - Properties
    
    private(set) var frames: [PhotoItem.Id: PhotoItem] = [:]
    
    private(set) var stuffs: [StuffItem.Id: StuffItem] = [:]
    
    private(set) var templateSets: [TemplateSet] = []
    
    // MARK: - Consruction
    
    init() {
        setupFrames()
        setupStuffs()
        setupTemplates()
    }
    
    // MARK: - Private Functions
    
    private func setupStuffs() {
        [
            StuffItem(stuffName: "stuff_1")
            ].forEach {
                stuffs[$0.stuffName] = $0
        }
    }
    
    private func setupFrames() {
        let photoSettings = Settings(center: CGPoint(x: 0.5, y: 20.0 / 52.0),
                                     sizeWidth: 340.0 / 396.0,
                                     angle: 0,
                                     ratio: 340.0 / 336.0)
        let frameArea = PhotoItem(frameName: "frame1_1",
                                  photoAreaLocation: photoSettings)
        frames[frameArea.frameName] = frameArea
        
        let photoSettingsEmpty7to8 = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                              sizeWidth: 1,
                                              angle: 0,
                                              ratio: 7.0/8.0)
        let frameAreaEmpty7to8 = PhotoItem(frameName: "empty7to8",
                                           photoAreaLocation: photoSettingsEmpty7to8)
        frames[frameAreaEmpty7to8.frameName] = frameAreaEmpty7to8
        
        let photoSettingsEmpty8to10 = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                               sizeWidth: 1,
                                               angle: 0,
                                               ratio: 0.8)
        let frameAreaEmpty8to10 = PhotoItem(frameName: "empty8to10",
                                            photoAreaLocation: photoSettingsEmpty8to10)
        frames[frameAreaEmpty8to10.frameName] = frameAreaEmpty8to10
        
        let photoSettingsEmpty1to1 = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                              sizeWidth: 1,
                                              angle: 0,
                                              ratio: 1)
        let frameAreaEmpty1to1 = PhotoItem(frameName: "empty1to1",
                                           photoAreaLocation: photoSettingsEmpty1to1)
        frames[frameAreaEmpty1to1.frameName] = frameAreaEmpty1to1
        
        let photoSettingsEmpty9to16 = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                               sizeWidth: 1,
                                               angle: 0,
                                               ratio: 9.0/16.0)
        let frameAreaEmpty9to16 = PhotoItem(frameName: "empty9to16",
                                            photoAreaLocation: photoSettingsEmpty9to16)
        frames[frameAreaEmpty9to16.frameName] = frameAreaEmpty9to16
    }
    
    private func setupTemplates() {
        let frameSettings = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                     sizeWidth: 0.7,
                                     angle: .pi / 6,
                                     ratio: 397.0 / 517.0)
        let frameAreaDescription = FrameAreaDescription(settings: frameSettings,
                                                        frameArea: .photoFrame(frames["frame1_1"]!, nil))
        
        let frameSettings2 = Settings(center: CGPoint(x: 0.3, y: 0.3),
                                      sizeWidth: 0.7,
                                      angle: .pi / 8,
                                      ratio: 397.0 / 517.0)
        let frameAreaDescription2 = FrameAreaDescription(settings: frameSettings2,
                                                         frameArea: .photoFrame(frames["frame1_1"]!, nil))
        
        let textSettings = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                    sizeWidth: 0.7,
                                    angle: 0,
                                    ratio: 4.0)
        
        let textItem = TextItem(textSetups: TextSetups(textType: [.bold, .italic], aligment: .left, fontSize: 60, lineSpacing: 1, fontType: .chalkboardSE, kern: 1, color: .black),
                                defautText: "a aa aaa aaaa aaaaa aaaaa aaaaaa aaaaaaa aaaaaaa")
        let textAreaDescription = FrameAreaDescription(settings: textSettings,
                                                       frameArea: .textFrame(textItem))
        
        let textSettings2 = Settings(center: CGPoint(x: 0.5, y: 0.9),
                                     sizeWidth: 0.7,
                                     angle: -.pi / 10,
                                     ratio: 4.0)
        
        let textAreaDescription2 = FrameAreaDescription(settings: textSettings2,
                                                        frameArea: .textFrame(textItem))
        
        let stuffSettings = Settings(center: CGPoint(x: 0.42, y: 0.22),
                                     sizeWidth: 0.3,
                                     angle: -.pi / 6,
                                     ratio: 86.0 / 43)
        let stuffAreaDescription = FrameAreaDescription(settings: stuffSettings,
                                                        frameArea: .stuffFrame(stuffs["stuff_1"]!))
        
        let areas = [
            stuffAreaDescription,
            frameAreaDescription,
            frameAreaDescription2,
            textAreaDescription2
        ]
        
        let frame2Photo1Settings = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                            sizeWidth: 1,
                                            angle: 0,
                                            ratio: 9.0 / 16.0)
        
        let frame2Photo1 = FrameAreaDescription(settings: frame2Photo1Settings,
                                                frameArea: .photoFrame(frames["empty9to16"]!, PhotoItemCustomSettings(closeButtonPosition: .rightTop, plusLocation: CGPoint(x: 11.0/108.0, y: 36.0/192.0))))
        
        let frame2Photo2Settings = Settings(center: CGPoint(x: 63.0/108.0, y: 66.0/192.0),
                                            sizeWidth: 80.0/108.0,
                                            angle: 0,
                                            ratio: 0.8)
        
        let frame2Photo2 = FrameAreaDescription(settings: frame2Photo2Settings,
                                                frameArea: .photoFrame(frames["empty8to10"]!, nil))
        
        let frame2Photo3Settings = Settings(center: CGPoint(x: 40.0/108.0, y: 134.0/192.0),
                                            sizeWidth: 70.0/108.0,
                                            angle: 0,
                                            ratio: 7.0/8.0)
        
        let frame2Photo3 = FrameAreaDescription(settings: frame2Photo3Settings,
                                                frameArea: .photoFrame(frames["empty7to8"]!, PhotoItemCustomSettings(closeButtonPosition: .leftTop, plusLocation: CGPoint(x: 0.5, y: 0.5))))
        
        let frame2Photo4Settings = Settings(center: CGPoint(x: 75.0/108.0, y: 108.0/192.0),
                                            sizeWidth: 43.0/108.0,
                                            angle: 0,
                                            ratio: 1)
        
        let frame2Photo4 = FrameAreaDescription(settings: frame2Photo4Settings,
                                                frameArea: .photoFrame(frames["empty1to1"]!, nil))
        
        let viewItem = ViewItem(color: .white)
        
        let frame2ViewPhoto2Settings = Settings(center: CGPoint(x: 63.0/108.0, y: 66.0/192.0),
                                                sizeWidth: 84.0/108.0,
                                                angle: 0,
                                                ratio: 84.0/104.0)
        
        let frame2ViewPhoto2 = FrameAreaDescription(settings: frame2ViewPhoto2Settings,
                                                    frameArea: .viewFrame(viewItem))
        
        let frame2ViewPhoto3Settings = Settings(center: CGPoint(x: 40.0/108.0, y: 134.0/192.0),
                                                sizeWidth: 74.0/108.0,
                                                angle: 0,
                                                ratio: 74.0/84.0)
        
        let frame2ViewPhoto3 = FrameAreaDescription(settings: frame2ViewPhoto3Settings,
                                                    frameArea: .viewFrame(viewItem))
        
        let frame2ViewPhoto4Settings = Settings(center: CGPoint(x: 75.0/108.0, y: 108.0/192.0),
                                                sizeWidth: 47.0/108.0,
                                                angle: 0,
                                                ratio: 1)
        
        let frame2ViewPhoto4 = FrameAreaDescription(settings: frame2ViewPhoto4Settings,
                                                    frameArea: .viewFrame(viewItem))
        
        let areas2 = [
            frame2Photo1,
            frame2ViewPhoto2,
            frame2Photo2,
            frame2ViewPhoto3,
            frame2Photo3,
            frame2ViewPhoto4,
            frame2Photo4
        ]
        
        let templates = [
            FrameTemplate(id: "template1",
                          name: "Frame 1",
                          frameAreas: areas),
            
            FrameTemplate(id: "template2",
                          name: "Frame 2",
                          frameAreas: areas2),
            
            FrameTemplate(id: "template1",
                          name: "Frame 3",
                          frameAreas: areas),
            
            FrameTemplate(id: "template1",
                          name: "Frame 4",
                          frameAreas: areas),
            
            FrameTemplate(id: "template1",
                          name: "Frame 5",
                          frameAreas: areas),
            
            FrameTemplate(id: "template1",
                          name: "Frame 6",
                          frameAreas: areas),
        ]
        
        templateSets = [
            TemplateSet(id: 1,
                        themeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                        name: "Casual",
                        templates: templates),
            TemplateSet(id: 2,
                        themeColor: #colorLiteral(red: 0.8901960784, green: 0.862745098, blue: 0.7215686275, alpha: 1),
                        name: "Lifestyle",
                        templates: templates),
            TemplateSet(id: 3,
                        themeColor: #colorLiteral(red: 0.8588235294, green: 0.7529411765, blue: 0.6980392157, alpha: 1),
                        name: "Love",
                        templates: templates),
            TemplateSet(id: 4,
                        themeColor: #colorLiteral(red: 0.8078431373, green: 0.7098039216, blue: 0.5529411765, alpha: 1),
                        name: "Fashion",
                        templates: templates),
            TemplateSet(id: 5,
                        themeColor: #colorLiteral(red: 0.5882352941, green: 0.6823529412, blue: 0.6274509804, alpha: 1),
                        name: "Ocean",
                        templates: templates),
            TemplateSet(id: 6,
                        themeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                        name: "Tommy",
                        templates: templates),
            
            TemplateSet(id: 1,
                        themeColor: #colorLiteral(red: 0.8901960784, green: 0.862745098, blue: 0.7215686275, alpha: 1),
                        name: "Casual",
                        templates: templates),
            TemplateSet(id: 2,
                        themeColor: #colorLiteral(red: 0.8588235294, green: 0.7529411765, blue: 0.6980392157, alpha: 1),
                        name: "Lifestyle",
                        templates: templates),
            TemplateSet(id: 3,
                        themeColor: #colorLiteral(red: 0.8078431373, green: 0.7098039216, blue: 0.5529411765, alpha: 1),
                        name: "Love",
                        templates: templates),
            TemplateSet(id: 4,
                        themeColor: #colorLiteral(red: 0.5882352941, green: 0.6823529412, blue: 0.6274509804, alpha: 1),
                        name: "Fashion",
                        templates: templates),
            TemplateSet(id: 5,
                        themeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                        name: "Ocean",
                        templates: templates),
            TemplateSet(id: 6,
                        themeColor: #colorLiteral(red: 0.8078431373, green: 0.7098039216, blue: 0.5529411765, alpha: 1),
                        name: "Tommy",
                        templates: templates)
        ]
    }
    
}
