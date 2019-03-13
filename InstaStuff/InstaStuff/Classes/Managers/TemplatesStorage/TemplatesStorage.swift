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
        
        let textItem = TextItem(defautText: "Hello")
        let textAreaDescription = FrameAreaDescription(settings: textSettings,
                                                       frameArea: .textFrame(textItem))
        
        let stuffSettings = Settings(center: CGPoint(x: 0.42, y: 0.22),
                                     sizeWidth: 0.3,
                                     angle: -.pi / 6,
                                     ratio: 86.0 / 43)
        let stuffAreaDescription = FrameAreaDescription(settings: stuffSettings,
                                                        frameArea: .stuffFrame(stuffs["stuff_1"]!))
        
        templateSets = [
            TemplateSet(id: 1,
                        name: "Set 1",
                        templates: [
                            FrameTemplate(id: "template1",
                                          name: "Frame 1",
                                          frameAreas: [
                                            frameAreaDescription,
                                            //textAreaDescription,
                                            stuffAreaDescription,
                                            ]),
                            ]
            )
        ]
    }
    
}
