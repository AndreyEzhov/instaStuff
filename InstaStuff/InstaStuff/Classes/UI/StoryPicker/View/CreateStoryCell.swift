//
//  CreateStoryCell.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class CreateStoryCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    // MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        imageView.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 60, height: 60))
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath(rect: rect)
        let dashes: [CGFloat] = [1, 5]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        path.lineWidth = 1.0
        path.lineCapStyle = .round
        UIColor.white.setFill()
        path.fill()
        Consts.Colors.r112g112b112.setStroke()
        path.stroke()
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        contentView.addSubview(imageView)
        setNeedsUpdateConstraints()
    }
    
}
