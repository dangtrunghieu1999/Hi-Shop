//
//  ProductedBuyViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit

class ProductedBuyViewController: BaseViewController {
    
    // MARK: - Variables
    
    var products: [Product]  = []

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 150
        tableView.registerReusableCell(EmptyTableViewCell.self)
        tableView.registerReusableCell(ProductItemTableViewCell.self)
        return tableView
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = TextManager.bought
        requestGetBouthProducts()
        
        navigationItem.rightBarButtonItem = cartBarButtonItem
        layoutTableView()
    }
    
    // MARK: - GET API

    
    func requestGetBouthProducts() {
        let endPoint = ProductEndPoint.getListProductBought

        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }

            self.products = apiResponse.toArray([Product.self])
            self.tableView.reloadData()
        } onFailure: { error in
        } onRequestFail: {
        }
        
    }
    
    // MARK: - Layout
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate
extension ProductedBuyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.products.isEmpty {
            return 400
        } else {
            return 180
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        let product = Product()
        product.id  = products[indexPath.row].id
        vc.configData(product)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProductedBuyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if self.products.isEmpty {
            return 1
        } else {
            return self.products.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.products.isEmpty {
            let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.emptyView.image = ImageManager.icon_logo2
            cell.emptyView.message = TextManager.emptyProducts
            cell.emptyView.backgroundColor = .clear
            return cell
        } else {
            let cell: ProductItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configCell(products[indexPath.row], isBought: true)
            return cell
        }
    }
}
