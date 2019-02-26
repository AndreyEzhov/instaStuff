//
//  StoryItem.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class StoryItem {
    
    typealias StoryId = String
    
    // MARK: - Properties
    
    private let storyId: StoryId
    
    var slides: [StorySlide] = []
    
    // MARK: - Constrcution
    
    init() {
        storyId = UUID().uuidString
    }
    
}

extension StoryItem: Equatable {
    static func == (lhs: StoryItem, rhs: StoryItem) -> Bool {
        return lhs.storyId == rhs.storyId
    }
}
