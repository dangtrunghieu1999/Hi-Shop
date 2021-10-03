//
//  InfoDetailCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

class DescriptionsCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    static let defaultHeightToExpand: CGFloat = 280
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutTitleLabel()
    }
    
    // MARK: - Helper Method
    
    static func estimateHeight(_ product: Product) -> CGFloat {
        let textWidth = ScreenSize.SCREEN_WIDTH - 2 * dimension.normalMargin
        let textHeight = product
            .descriptions.height(withConstrainedWidth: textWidth,
                                font: UIFont.systemFont(ofSize: FontSize.h1.rawValue))
        if textHeight > 180 {
            return textHeight + 50
        } else {
            return textHeight + 16
        }
    }
    
    static func esitmateColapseHeight(_ product: Product) -> CGFloat {
        let textWidth = ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin
        let text = String(product.descriptions.prefix(500))
        return text.height(withConstrainedWidth: textWidth,
                           font: UIFont.systemFont(ofSize: FontSize.h1.rawValue)) + 50
    }
    
    func configData(_ product: Product) {
        let name = product.descriptions
        titleLabel.attributedText = Ultilities.lineSpacingLabel(title: name)
    }
    
    // MARK: - GET API
    
    // MARK: - Layouts
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
}
