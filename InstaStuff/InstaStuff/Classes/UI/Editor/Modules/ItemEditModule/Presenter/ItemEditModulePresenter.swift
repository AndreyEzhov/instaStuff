//
//  ItemEditModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation
import UIKit

/// Протокол для общения с вью частью
protocol ItemEditModuleDisplayable: View {

}

/// Интерфейс презентера
protocol ItemEditModulePresentable: Presenter {
    var dataSource: [PreviewProtocol] { get }
    var slideView: ConstructorSlideView? { get set }
    var numberOfRows: Int { get }
    func select(at index: Int)
}

/// Презентер для экрана «ItemEditModule»
final class ItemEditModulePresenter: ItemEditModulePresentable {
    
    // MARK: - Nested types
    
    typealias T = ItemEditModuleDisplayable
    
    private let templatesStorage: TemplatesStorage
    
    weak var slideView: ConstructorSlideView?
    
    let numberOfRows: Int
    
    var dataSource: [PreviewProtocol] {
        return templatesStorage.stuffItems
    }
    
    /// Параметры экрана
    struct Parameters {
        let numberOfRows: Int
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    init(params: Parameters, templatesStorage: TemplatesStorage) {
        self.templatesStorage = templatesStorage
        numberOfRows = params.numberOfRows
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - ItemEditModulePresentable

    func select(at index: Int) {
        let item = templatesStorage.stuffItems[index]
        let settings = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.2, angle: 0, ratio: item.stuffImage.size.width / item.stuffImage.size.height)
        slideView?.add(StuffPlace(StoryEditableStuffItem(item, settings: settings)))
    }
    
}
