//
//  MenuItemViewB.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 15/09/2021.
//

import UIKit

class MenuItemViewB: UIView {
    // MARK: - Menu item view

    var titleLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var menuItemSeparator : UIView?
    
    func setUpMenuItemView(_ menuItemWidth: CGFloat, menuScrollViewHeight: CGFloat, indicatorHeight: CGFloat, separatorPercentageHeight: CGFloat, separatorWidth: CGFloat, separatorRoundEdges: Bool, menuItemSeparatorColor: UIColor) {
        
        menuItemSeparator = UIView(frame: CGRect(x: menuItemWidth - (separatorWidth / 2), y: floor(menuScrollViewHeight * ((1.0 - separatorPercentageHeight) / 2.0)), width: separatorWidth, height: floor(menuScrollViewHeight * separatorPercentageHeight)))
        menuItemSeparator!.backgroundColor = menuItemSeparatorColor
        
        if separatorRoundEdges {
            menuItemSeparator!.layer.cornerRadius = menuItemSeparator!.frame.width / 2
        }
        
        menuItemSeparator!.isHidden = true
        self.addSubview(menuItemSeparator!)
        
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.top.equalToSuperview()
                .offset(dimension.mediumMargin)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView)
            make.left.right.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom)
                .offset(dimension.smallMargin)
        }
    }
    
    func setTitleText(_ text: NSString) {
            titleLabel.text = text as String
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
    }
    
    func configure(for pageMenu: CAPSPageMenuB, controller: UIViewController, index: CGFloat) {
        if pageMenu.configuration.useMenuLikeSegmentedControl {
            //**************************拡張*************************************
            if pageMenu.menuItemMargin > 0 {
                let marginSum = pageMenu.menuItemMargin * CGFloat(pageMenu.controllerArray.count + 1)
                let menuItemWidth = (pageMenu.view.frame.width - marginSum) / CGFloat(pageMenu.controllerArray.count)
                self.setUpMenuItemView(menuItemWidth, menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor)
            } else {
                self.setUpMenuItemView(CGFloat(pageMenu.view.frame.width) / CGFloat(pageMenu.controllerArray.count), menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor)
            }
            //**************************拡張ここまで*************************************
        } else {
            self.setUpMenuItemView(pageMenu.configuration.menuItemWidth, menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor)
        }
        
        // Configure menu item label font if font is set by user
        self.titleLabel.font = pageMenu.configuration.menuItemFont
        
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.textColor = pageMenu.configuration.unselectedMenuItemLabelColor
        
        //**************************拡張*************************************
        self.titleLabel.adjustsFontSizeToFitWidth = pageMenu.configuration.titleTextSizeBasedOnMenuItemWidth
        //**************************拡張ここまで*************************************
        let iconImage = [ImageManager.managerOrder, ImageManager.reciveOrder, ImageManager.transport, ImageManager.successOrder, ImageManager.cancelOrder]

        // Set title depending on if controller has a title set
        if controller.title != nil {
            self.titleLabel.text = controller.title!
            self.iconImageView.image = iconImage[(Int(index))]?.withRenderingMode(.alwaysOriginal)
        } else {
            self.titleLabel.text = "Menu \(Int(index) + 1)"
        }
        
        // Add separator between menu items when using as segmented control
        if pageMenu.configuration.useMenuLikeSegmentedControl {
            if Int(index) < pageMenu.controllerArray.count - 1 {
                self.menuItemSeparator!.isHidden = false
            }
        }
    }
}
