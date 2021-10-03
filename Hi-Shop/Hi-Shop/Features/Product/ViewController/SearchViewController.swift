//
//  SearchProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit

class SearchViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    private lazy var baseView: BaseView = {
        let baseView = BaseView()
        baseView.backgroundColor = UIColor.clear
        return baseView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode =  .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.icon_logo2
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.lightBodyText
        label.text = TextManager.emptySearch
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.numberOfLines = 0
        return label
    }()
    // MAKR: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        self.searchBar.fontPlaceholder(text: TextManager.searchTitle2,
                                       size: FontSize.h2.rawValue)
        layoutBaseView()
        layoutImageView()
        layoutTitleLabel()
        self.searchBar.delegate = self
    }
    
    private func layoutBaseView() {
        self.view.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
    }
    
    private func layoutImageView() {
        baseView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width
                .height
                .equalTo(Dimension.shared.largeMargin_120)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            
        }
    }
    
    private func layoutTitleLabel() {
        baseView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performAction()
        return true
    }
    
    
    func performAction() {
        let vc = SearchTextViewController()
        guard let searchText = searchBar.text else {
            return
        }
        vc.searchText = searchText
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
