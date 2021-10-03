//
//  OrderDetailInfoCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 22/07/2021.
//

import UIKit

class OrderDetailInfoCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icon_package
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.infoOrder
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        return label
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.registerReusableCell(OrderProductTableViewCell.self)
        return tableView
    }()
    
    private var products: [Product] = []
    
    override func initialize() {
        super.initialize()
        layoutIconImageView()
        layoutTitleLabel()
        layoutTableView()
    }
    
    func configCell(products: [Product]) {
        self.products = products
        self.tableView.reloadData()
    }
    
    private func layoutIconImageView() {
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right)
                .offset(dimension.normalMargin)
            make.top.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top
                .equalTo(iconImageView.snp.bottom)
            make.right
                .equalToSuperview()
                .offset(-dimension.largeMargin_32)
            make.left.equalToSuperview()
                .offset(dimension.largeMargin_32)
            make.bottom
                .equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource

extension OrderDetailInfoCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderProductTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        if let product = products[safe: indexPath.row] {
            cell.configData(product: product)
        }

        return cell
    }
}

extension OrderDetailInfoCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

