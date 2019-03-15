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
        let stuff = StuffItem(stuffName: "stuff_1")
        stuffs[stuff.stuffName] = stuff
    }
    
    private func setupFrames() {
        let photoSettings = Settings(center: CGPoint(x: 0.5, y: 200.0 / 517.0),
                                     sizeWidth: 340.0 / 397.0,
                                     angle: 0,
                                     ratio: 340.0 / 336.0)
        let frameArea = PhotoItem(frameName: "frame1_1",
                                  photoAreaLocation: photoSettings)
        frames[frameArea.frameName] = frameArea
    }
    
    private func setupTemplates() {
        let frameSettings = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                     sizeWidth: 0.7,
                                     angle: .pi / 6,
                                     ratio: 397.0 / 517.0)
        let frameAreaDescription = FrameAreaDescription(settings: frameSettings,
                                                        frameArea: .photoFrame(frames["frame1_1"]!))
        
        let textSettings = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                    sizeWidth: 0.7,
                                    angle: 0,
                                    ratio: 4.0)
        
        let textItem = TextItem(textSetups: TextSetups(textType: [.bold]),
                                defautText: "Hello")
        let textAreaDescription = FrameAreaDescription(settings: textSettings,
                                                       frameArea: .textFrame(textItem))
        
        let textSettings2 = Settings(center: CGPoint(x: 0.5, y: 0.9),
                                    sizeWidth: 0.7,
                                    angle: 0,
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
            frameAreaDescription,
            //textAreaDescription,
            textAreaDescription2,
            stuffAreaDescription,
            ]
        
        let templates = [
            FrameTemplate(id: "template1",
                          name: "Frame 1",
                          frameAreas: areas),
            
            FrameTemplate(id: "template1",
                          name: "Frame 2",
                          frameAreas: areas),
            
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
