//
//  StoryPickerPresenter.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

protocol StoryPickerDisplayable: View {
    
}

protocol StoryPickerPresentable: Presenter {
    var stories: [StoryItem] { get }
    func createNewStory() -> StoryItem
    func deleteStory(at index: Int)
}

final class StoryPickerPresenter: StoryPickerPresentable {
    
    struct Dependencies {
        let storyStorage: StoryStorage
    }
    
    // MARK: - Nested types
    
    typealias T = StoryPickerDisplayable
    
    // MARK: - Properties
    
    weak var view: View?
    
    private let storyStorage: StoryStorage
    
    var stories: [StoryItem] {
        return storyStorage.stories
    }
    
    // MARK: - Construction
    
    init(dependencies: Dependencies) {
        storyStorage = dependencies.storyStorage
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - StoryPickerPresentable
    
    func createNewStory() -> StoryItem {
        return storyStorage.createNewStory()
    }
    
    func deleteStory(at index: Int) {
        storyStorage.delete(at: index)
    }
    
}
