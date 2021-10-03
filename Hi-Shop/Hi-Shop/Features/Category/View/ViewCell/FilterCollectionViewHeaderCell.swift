//
//  FilterCollectionViewHeaderCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 21/07/2021.
//

import UIKit

enum FilterType: Int {
    case all     = 0
    case popular
    case news
    case cheapt
    case expensive
    
    static func numberOfItem() -> Int {
        return 5
    }
    
    var title: String {
        switch self {
        case .all:
            return "Tất cả"
        case .popular:
            return "Phổ biến"
        case .news:
            return "Hàng mới"
        case .cheapt:
            return "Giá thấp"
        case .expensive:
            return "Giá cao"
        }
    }
    
    var key: String {
        switch self {
        case .all:
            return "all"
        case .popular:
            return "selling"
        case .news:
            return "news"
        case .cheapt:
            return "cheap"
        case .expensive:
            return "expensive"
        }
    }
}

protocol FilterCollectionViewHeaderCellDelegate: AnyObject {
    func didTapFilterType(type: FilterType)
}

class FilterCollectionViewHeaderCell: BaseCollectionViewHeaderFooterCell {

    weak var delegate: FilterCollectionViewHeaderCellDelegate?
    var selectIndex: Int       = 0
    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerReusableCell(FilterTitleCollectionViewCell.self)
        return collectionView
    }()
    
    fileprivate lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.filter
        return imageView
    }()
    
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.white
        layoutFilterImageView()
        layoutCollectionView()
    }
    
    private func layoutFilterImageView() {
        addSubview(filterImageView)
        filterImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.width.height.equalTo(18)
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(filterImageView.snp.left)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterCollectionViewHeaderCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: 50)
    }
}

// MARK: - UICollectionViewDataSource
extension FilterCollectionViewHeaderCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return FilterType.numberOfItem()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = FilterType(rawValue: indexPath.row)
        let cell: FilterTitleCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configcCell(title: type?.title)
        cell.setHighlight(selectIndex == indexPath.row)
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension FilterCollectionViewHeaderCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let type = FilterType(rawValue: indexPath.row) else { return }
        selectIndex = indexPath.row
        self.collectionView.reloadData()
        self.delegate?.didTapFilterType(type: type)
    }
}

