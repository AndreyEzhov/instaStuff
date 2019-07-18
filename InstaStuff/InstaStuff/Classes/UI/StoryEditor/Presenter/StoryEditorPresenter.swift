//
//  StoryEditorPresenter.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation
import UIKit

protocol StoryEditorDisplayable: View {

}

protocol StoryEditorPresentable: Presenter {
    var story: StoryItem { get }
    var slideViewPresenter: SlideViewPresenter? { get set }
    func saveTemplate(with image: UIImage)
}

final class StoryEditorPresenter: StoryEditorPresentable {
    
    struct Dependencies {
        let templatesStorage: TemplatesStorage
        let imageHandler: ImageHandler
    }
    
    struct Parameters {
        let template: Template
    }
    
    // MARK: - Nested types
    
    typealias T = StoryEditorDisplayable
    
    // MARK: - Properties
    
    weak var view: View?
    
    let story: StoryItem
    
    private let templatesStorage: TemplatesStorage
    
    private let imageHandler: ImageHandler
    
    var slideViewPresenter: SlideViewPresenter?
    
    private let templateName: String
    
    // MARK: - Construction
    
    init(dependencies: Dependencies, parameters: Parameters) {
        imageHandler = dependencies.imageHandler
        templatesStorage = dependencies.templatesStorage
        story = StoryItem(template: parameters.template)
        templateName = parameters.template.createdByUser ? parameters.template.name : "\(Date())"
    }
    
    // MARK: - Private Functions
    
    func saveTemplate(with image: UIImage) {
        let template = Template(name: templateName,
                                backgroundColor: story.backgroundColor,
                                backgroundImageName: story.backgroundImageName,
                                storyEditableItem: story.items.map { $0.copy() },
                                createdByUser: true)
        templatesStorage.save(template)
        imageHandler.saveImage(image, name: templateName)
    }
    
    // MARK: - Functions
    
    // MARK: - StoryEditorPresentable

}
