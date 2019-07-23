//
//  TextEditorModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation
import UIKit

enum Aligment: Int, CaseIterable {
    case left, center, right
    
    var image: UIImage {
        switch self {
        case .left:
            return #imageLiteral(resourceName: "leftAlignment")
        case .right:
            return #imageLiteral(resourceName: "rightAlignment")
        case .center:
            return #imageLiteral(resourceName: "centerAlignment")
        }
    }
    
    var textAlignment: NSTextAlignment {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        case .center:
            return .center
        }
    }
}

enum FontEnum: CaseIterable {
    case cheque, solena, journalism, chalkboardSE, didot, futura, baskerville
    
    var name: String {
        switch self {
        case .cheque:
            return "CHEQUE"
        case .solena:
            return "Solena"
        case .journalism:
            return "Journalism"
        case .chalkboardSE:
            return "Chalkboard SE"
        case .didot:
            return "Didot"
        case .futura:
            return "Futura"
        case .baskerville:
            return "Baskerville"
        }
    }
}

enum ColorEnum {
    
    static let allCases: [ColorEnum] = [.white, .r206g181b141, .r248g229b210, .r227g220b184, .r219g192b178, .r186g142b105, .r150g174b160, .r80g76b69, .black]
    
    case white, r206g181b141, r248g229b210, r227g220b184, r219g192b178, r186g142b105, r150g174b160, r80g76b69, black
    
    var color: UIColor {
        switch self {
        case .white:
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .r206g181b141:
            return #colorLiteral(red: 0.8078431373, green: 0.7098039216, blue: 0.5529411765, alpha: 1)
        case .r248g229b210:
            return #colorLiteral(red: 0.9725490196, green: 0.8980392157, blue: 0.8235294118, alpha: 1)
        case .r227g220b184:
            return #colorLiteral(red: 0.8901960784, green: 0.862745098, blue: 0.7215686275, alpha: 1)
        case .r219g192b178:
            return #colorLiteral(red: 0.8588235294, green: 0.7529411765, blue: 0.6980392157, alpha: 1)
        case .r186g142b105:
            return #colorLiteral(red: 0.7294117647, green: 0.5568627451, blue: 0.4117647059, alpha: 1)
        case .r150g174b160:
            return #colorLiteral(red: 0.5882352941, green: 0.6823529412, blue: 0.6274509804, alpha: 1)
        case .r80g76b69:
            return #colorLiteral(red: 0.3137254902, green: 0.2980392157, blue: 0.2705882353, alpha: 1)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
}

enum SliderEditionType {
    case kern, lineSpacing, fontSize, color
}

struct SliderModel {
    let minValue: CGFloat
    let maxValue: CGFloat
    let value: CGFloat?
}

/// Протокол для общения с вью частью
protocol TextEditorModuleDisplayable: class {
    func updateView()
    func updateSlider(with model: SliderModel?)
}

/// Интерфейс презентера
protocol TextEditorModulePresentable: class {
    var textSetups: TextSetupsEditable? { get set }
    var view: TextEditorModuleDisplayable? { get set }
    var fonts: [FontEnum] { get }
    var type: SliderEditionType { get }
    func makeBold() -> Bool
    func makeItalic() -> Bool
    func upperCase() -> Bool
    func changeAlignment() -> Aligment
    func setFont(at index: Int)
    func setColor(_ color: UIColor)
    func beginEdition(with type: SliderEditionType)
    func valueDidChanged(_ value: Float)
}

/// Презентер для экрана «TextEditorModule»
final class TextEditorModulePresenter: TextEditorModulePresentable {
    
    // MARK: - Nested types
    
    weak var view: TextEditorModuleDisplayable?
    
    var textSetups: TextSetupsEditable? {
        didSet {
            view?.updateView()
            beginEdition(with: type)
        }
    }
    
    let fonts: [FontEnum] = FontEnum.allCases
    
    private(set) var type: SliderEditionType = .fontSize
    
    /// Параметры экрана
    struct Parameters {
        
    }
    
    // MARK: - Construction
    
    init(params: Parameters) {
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - TextEditorModulePresentable
    
    func makeBold() -> Bool {
        textSetups?.makeBold()
        return textSetups?.isBold ?? false
    }
    
    func makeItalic() -> Bool {
        textSetups?.makeItalic()
        return textSetups?.isItalic ?? false
    }
    
    func upperCase() -> Bool {
        textSetups?.upperCase()
        return textSetups?.isUpperCase ?? false
    }
    
    func changeAlignment() -> Aligment {
        textSetups?.changeAlignment()
        return textSetups?.aligment ?? .left
    }
    
    func setFont(at index: Int) {
        textSetups?.update(with: fonts[index])
    }
    
    func setColor(_ color: UIColor) {
        textSetups?.color = color
    }
    
    func beginEdition(with type: SliderEditionType) {
        self.type = type
        var model: SliderModel?
        switch type {
        case .fontSize:
            model = SliderModel(minValue: 20, maxValue: 80, value: textSetups?.fontSize)
        case .kern:
            model = SliderModel(minValue: -8, maxValue: 30, value: textSetups?.kern)
        case .lineSpacing:
            model = SliderModel(minValue: -20, maxValue: 40, value: textSetups?.lineSpacing)
        case .color:
            model = nil
        }
        view?.updateSlider(with: model)
    }
    
    func valueDidChanged(_ value: Float) {
        switch type {
        case .fontSize:
            textSetups?.fontSize = CGFloat(value)
        case .kern:
            textSetups?.kern = CGFloat(value)
        case .lineSpacing:
            textSetups?.lineSpacing = CGFloat(value)
        case .color:
            break
        }
    }
    
}
