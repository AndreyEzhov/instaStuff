//
//  StoryEditorPresenter.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

protocol StoryEditorDisplayable: View {

}

protocol StoryEditorPresentable: Presenter {
    var story: StoryItem { get }
    var templateSets: [TemplateSet] { get }
    func addSlide(with template: FrameTemplate)
}

final class StoryEditorPresenter: StoryEditorPresentable {
    
    struct Dependencies {
        let templatesStorage: TemplatesStorage
        let storyStorage: StoryStorage
    }
    
    struct Parameters {
        let story: StoryItem
    }
    
    // MARK: - Nested types
    
    typealias T = StoryEditorDisplayable
    
    // MARK: - Properties
    
    weak var view: View?
    
    private let templatesStorage: TemplatesStorage
    
    private let storyStorage: StoryStorage
    
    let story: StoryItem
    
    var templateSets: [TemplateSet] {
        return templatesStorage.templateSets
    }
    
    // MARK: - Construction
    
    init(dependencies: Dependencies, parameters: Parameters) {
        templatesStorage = dependencies.templatesStorage
        storyStorage = dependencies.storyStorage
        
        story = parameters.story
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - StoryEditorPresentable
    
    func addSlide(with template: FrameTemplate) {
        let newSlide = StorySlide(template: template)
        story.slides.append(newSlide)
    }

}
