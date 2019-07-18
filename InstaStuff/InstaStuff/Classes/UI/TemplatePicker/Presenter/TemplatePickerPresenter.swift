//
//  TemplatePickerPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 14/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation
import RxSwift

/// Протокол для общения с вью частью
protocol TemplatePickerDisplayable: View {
    func updateCollectionView()
}

/// Интерфейс презентера
protocol TemplatePickerPresentable: Presenter {
    var usersTemplate: Bool { get }
    var selectedSet: Int { get }
    var imageHandler: ImageHandler { get }
    var templateSets: [SetWithTemplates] { get }
    var templates: [Template] { get }
    func selectSet(at index: Int)
}

/// Презентер для экрана «TemplatePicker»
final class TemplatePickerPresenter: TemplatePickerPresentable {
    
    // MARK: - Nested types
    
    typealias T = TemplatePickerDisplayable
    
    /// Параметры экрана
    struct Parameters {
        let usersTemplate: Bool
    }
    
    struct Dependencies {
        let templatesStorage: TemplatesStorage
        let imageHandler: ImageHandler
    }
    
    let templatesStorage: TemplatesStorage
    
    var templateSets: [SetWithTemplates] {
        return templatesStorage.templateSets
    }
    
    var templates: [Template] {
        return usersTemplate ? templatesStorage.usersTemplates : templateSets[selectedSet].templates
    }
    
    private(set) var selectedSet = 0
    
    // MARK: - Properties
    
    weak var view: View?
    
    let imageHandler: ImageHandler
    
    let usersTemplate: Bool
    
    private let bag = DisposeBag()
    
    // MARK: - Construction
    
    init(params: Parameters, dependencies: Dependencies) {
        templatesStorage = dependencies.templatesStorage
        imageHandler = dependencies.imageHandler
        usersTemplate = params.usersTemplate
        if usersTemplate {
            templatesStorage.usersTemplatesUpdateObserver.subscribe { [weak self] _ in
                self?.contentView()?.updateCollectionView()
                }.disposed(by: bag)
        }
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - TemplatePickerPresentable
    
    func selectSet(at index: Int) {
        self.selectedSet = index
    }
    
}
