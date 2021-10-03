//
//  SameProductCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

class SimilarCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    fileprivate lazy var products: [Product] = []
    
    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Dimension.shared.normalMargin
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: dimension.normalMargin,
                                                   bottom: 0,
                                                   right: dimension.normalMargin)
        return collectionView
    }()
    
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutSameProductCollectionView()
    }
    
    // MARK: - Helper Method
    
    func configDataCell(_ products: [Product]) {
        self.products = products
        self.collectionView.reloadData()
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutSameProductCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
                .offset(-dimension.mediumMargin)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SimilarCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3 * dimension.normalMargin) / 3
        return CGSize(width: width, height: 220)
    }
}

// MARK: - UICollectionViewDataSource

extension SimilarCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let row = indexPath.row
        cell.backgroundColor = UIColor.white
        cell.colorCoverView = UIColor.white
        cell.fontSize = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        cell.configCell(products[safe: row] ?? Product())
        cell.stopShimmering()
        return cell
    }
}

extension SimilarCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let product = products[safe: indexPath.row] else { return }
        AppRouter.pushToProductDetail(product)
    }
}
