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
    var isEditable: Bool { get }
    var slideViewPresenter: SlideViewPresenter? { get set }
}

final class StoryEditorPresenter: StoryEditorPresentable {
    
    struct Dependencies {
    }
    
    struct Parameters {
        let template: Template
        let isEditable: Bool
    }
    
    // MARK: - Nested types
    
    typealias T = StoryEditorDisplayable
    
    // MARK: - Properties
    
    weak var view: View?
    
    let story: StoryItem
    
    var slideViewPresenter: SlideViewPresenter?
    
    let isEditable: Bool
    
    // MARK: - Construction
    
    init(dependencies: Dependencies, parameters: Parameters) {
        story = StoryItem(template: parameters.template)
        isEditable = parameters.isEditable
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - StoryEditorPresentable

}
