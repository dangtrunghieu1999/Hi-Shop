//
//  ProductDetailsCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

protocol DetailsCollectionViewCellDelegate: AnyObject {
    func didTapSeemoreParamter()
}

class DetailsCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: DetailsCollectionViewCellDelegate?
    
    private var dataKey: [String]   = ["Danh mục","Cung cấp bởi",
                                       "Thương hiệu","Xuất xứ thương hiệu",
                                       "Xuất xứ", "Hướng dẫn",
                                       "Chất liệu","Model",
                                       "Hoá đơn VAT","Bảo hành"]
   
    private var dataValue: [String] = []
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(TitleTableViewCell.self)
        return tableView
    }()
    
    fileprivate lazy var seemoreButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.seemore, for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.primary, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addRightIcon(image: ImageManager.see_more ?? UIImage())
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        button.addTarget(self, action: #selector(tapSeeMore), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutTableView()
        layoutSeemoreButton()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - UI Action
    
    @objc private func tapSeeMore() {
        delegate?.didTapSeemoreParamter()
    }
    
    // MARK: - Helper Method
    
    func configCell(detail: String) {
        self.dataValue = detail.components(separatedBy: ";")
        self.tableView.reloadData()
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    
    private func layoutTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(200)
        }
    }
    
    private func layoutSeemoreButton() {
        addSubview(seemoreButton)
        seemoreButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}

// MARK: - UITableViewDelegate

extension DetailsCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDataSource

extension DetailsCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell: TitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configTitle(keyTitle: dataKey[indexPath.row],
                         valueTitle: dataValue[indexPath.row])
        if indexPath.row % 2 == 0{
            cell.keyCoverView.backgroundColor = UIColor.lightBackground
            cell.valueCoverView.backgroundColor = UIColor.lightBackground
        } else {
            cell.keyCoverView.backgroundColor = UIColor.white
            cell.valueCoverView.backgroundColor = UIColor.white
        }
        return cell
    }
}
