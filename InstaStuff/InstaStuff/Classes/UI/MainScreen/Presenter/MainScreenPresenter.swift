//
//  StoryPickerPresenter.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

protocol MainScreenDisplayable: View {
    
}

protocol MainScreenPresentable: Presenter {
}

final class MainScreenPresenter: MainScreenPresentable {
    
    struct Dependencies {
        //let templatesStorage: TemplatesStorage
    }
    
    // MARK: - Nested types
    
    typealias T = MainScreenDisplayable
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    init(dependencies: Dependencies) {
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - StoryPickerPresentable

}
