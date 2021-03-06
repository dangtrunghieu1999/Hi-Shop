//
//  PersonalHeaderCollectionReusableView.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit

protocol PersonalHeaderCollectionViewDelegate: AnyObject {
    func tapOnSignIn()
}

class PersonalCollectionHeaderCell: BaseCollectionViewHeaderFooterCell {
    
    // MARK: - Variables
    weak var delegate: PersonalHeaderCollectionViewDelegate?
    
    // MARK: - UI Elements
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.avatarDefault
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius  = 25
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.separator.cgColor
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.welcome
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.welcomeSignInUp
        label.textColor = UIColor.primary
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue,
                                       weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.setImage(ImageManager.more, for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        backgroundColor = .white
        layoutAvatarImageView()
        layoutTitleLabel()
        layoutSubTitleLabel()
        layoutNextButton()
        tapGestureHeaderCell()
    }
    
    private func tapGestureHeaderCell() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnSignIn))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    @objc func tapOnSignIn() {
        delegate?.tapOnSignIn()
    }
        
    // MARK: - Helper Method
    
    func configData(_ hidden: Bool, title: String?, url: String?) {
        guard let url = url else { return }
        self.avatarImageView.loadImage(by: url,
                                       defaultImage: ImageManager.avatarDefault)
        self.subTitleLabel.text  = title
        self.nextButton.isHidden = hidden
    }
    
    

    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
            make.width.height
                .equalTo(50)
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(avatarImageView.snp.right)
                .offset(dimension.normalMargin)
            make.top
                .equalTo(avatarImageView.snp.top)
                .offset(dimension.smallMargin)
            make.right
                .equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
    
    private func layoutSubTitleLabel() {
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom
                .equalTo(avatarImageView.snp.bottom)
                .offset(-dimension.smallMargin)
        }
    }
    
    private func layoutNextButton() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.centerY
                .equalToSuperview()
            make.width
                .height
                .equalTo(24)
        }
    }
}
