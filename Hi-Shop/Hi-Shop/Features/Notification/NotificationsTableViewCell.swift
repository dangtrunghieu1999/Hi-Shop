//
//  NotificationsTableViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

class NotificationsTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Elements
    
    
    fileprivate lazy var coverImage: BaseView = {
        let view = BaseView()
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.lightBodyText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var timeDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.lightBodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutCoverView()
        layoutAvatarImageView()
        layoutTitleLabel()
        layoutSubTitleLabel()
        layoutTimeDateLabel()
        layoutLineView()
    }
    
    func configCell(_ notification: Notifications) {
        self.avatarImageView.loadImage(by: notification.avatar)
        self.titleLabel.text = notification.title
        self.subTitleLabel.text = notification.subTitle
        self.timeDateLabel.text = notification.time
    }
    
    
    // MARK: - Setup layouts
    
    private func layoutCoverView() {
        addSubview(coverImage)
        coverImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(80)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.bottom.equalToSuperview()
                .offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutAvatarImageView() {
        coverImage.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImage.snp.right)
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .offset(-dimension.mediumMargin)
            make.top.equalTo(coverImage)
        }
    }
    
    private func layoutSubTitleLabel() {
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutTimeDateLabel() {
        addSubview(timeDateLabel)
        timeDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(subTitleLabel.snp.bottom)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(lineView)
            make.height.equalTo(2)
            make.right.equalToSuperview()
            make.left.equalTo(titleLabel)
        }
    }
}
