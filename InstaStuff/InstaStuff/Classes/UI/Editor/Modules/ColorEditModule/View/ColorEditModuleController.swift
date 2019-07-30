//
//  ColorEditModuleController.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol ColorPickerListener: PippeteDelegate {
    func colorDidChanged(_ value: UIColor)
}

protocol PippeteDelegate: class {
    var currentColor: UIColor? { get }
    func placePipette(completion: @escaping (UIColor?) -> ())
}

/// Контроллер для экрана «ColorEditModule»
final class ColorEditModuleController: BaseViewController<ColorEditModulePresentable>, ColorEditModuleDisplayable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    private var colors: [ColorEnum] = ColorEnum.allCases
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.registerClass(for: ColorCell.self)
        return collectionView
    }()
    
    private lazy var pipetteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "color_picker"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(activatePipette), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pipetteButton.layer.cornerRadius = pipetteButton.bounds.width / 2.0
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        pipetteButton.snp.remakeConstraints { maker in
            maker.left.equalToSuperview().inset(20)
            maker.height.equalTo(pipetteButton.snp.width)
            maker.top.equalTo(10)
            maker.centerY.equalToSuperview()
        }
        collectionView.snp.remakeConstraints { maker in
            maker.right.top.bottom.equalToSuperview()
            maker.left.equalTo(pipetteButton.snp.right)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(pipetteButton)
        updateColor(presenter.delegate?.currentColor)
    }
    
    // MARK: - ColorEditModuleDisplayable
    
    // MARK: - Private Functions
    
    private func updateColor(_ color: UIColor?) {
        guard let color = color else { return }
        presenter.delegate?.colorDidChanged(color)
        updateUIColor(color)
    }
    
    // MARK: - Functions
    
    func updateUIColor(_ color: UIColor?) {
        guard let color = color else { return }
        pipetteButton.backgroundColor = color
        pipetteButton.tintColor = color.isLight ? .black : .white
    }
    
    // MARK: - Actions
    
    @objc private func activatePipette() {
        presenter.delegate?.placePipette { color in
            guard let color = color else { return }
            self.updateColor(color)
        }
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(indexPath: indexPath, with: { (cell: ColorCell) in
            cell.setup(with: colors[indexPath.row])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newColor = colors[indexPath.row].color
        updateColor(newColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = round(collectionView.bounds.height * 0.6)
        return CGSize(width: size, height: size)
    }
    
}


extension UIColor {
    
    var isLight: Bool {
        guard let rgbValues = rgb() else { return true }
        return rgbValues.red > 180 && rgbValues.blue > 180 && rgbValues.green > 180
    }
    
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    func inverce() -> UIColor {
        guard let rgb = rgb() else { return .white }
        func round(value: Int) -> CGFloat {
            let value = value < 120 ? (value + 120) : (value - 120)
            return CGFloat(value) / 255.0
        }
        let red = round(value: rgb.red)
        let green = round(value: rgb.green)
        let blue = round(value: rgb.blue)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
