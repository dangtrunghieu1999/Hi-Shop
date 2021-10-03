//
//  FilterTitleCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 21/07/2021.
//

import UIKit

class FilterTitleCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.lightBodyText
        return label
    }()
    
    fileprivate lazy var dotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBodyText
        view.layer.cornerRadius = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    override func initialize() {
        super.initialize()
        layoutTitleLabel()
        layoutDotView()
    }
    
    func configcCell(title: String?) {
        self.titleLabel.text = title
    }
    
    func setHighlight(_ isHighlight: Bool) {
        self.titleLabel.textColor = isHighlight ? .primary : .lightBodyText
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutDotView() {
        addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.height.equalTo(2)
            make.centerY.equalToSuperview()
        }
    }
    
}
