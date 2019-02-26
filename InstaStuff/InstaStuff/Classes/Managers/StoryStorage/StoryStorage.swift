//
//  StoryStorage.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class StoryStorage {
    
    // MARK: - Properties
    
    var stories: [StoryItem] = []
    
    // MARK: - Construction
    
    init() {
        
    }
    
    func createNewStory() -> StoryItem {
        let story = StoryItem()
        stories.insert(story, at: 0)
        return story
    }
    
    func delete(at index: Int) {
        stories.remove(at: index)
    }
    
    
}
