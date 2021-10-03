//
//  WaitingReviewViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol WaitingReviewViewControllerDelegate: AnyObject {
    func handleReviewSuccess()
}
class WaitingReviewViewController: BaseViewController {
    
    // MARK: - UI Element
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background

        return refreshControl
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Dimension.shared.mediumMargin
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.tableBackground
        collectionView.delegate =  self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top:  Dimension.shared.mediumMargin,
                                                   left: 0,
                                                   bottom: Dimension.shared.mediumMargin,
                                                   right: 0)
        collectionView.registerReusableCell(ReviewCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(GrayCollectionViewFooterCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    // MARK: - ViewLife Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutCollectionView()
        emptyView.backgroundColor = UIColor.tableBackground
        addEmptyView(message: TextManager.emptyReview,
                     image: ImageManager.icon_logo2)
    }
    
    private var raitings: [Raiting] = []
    private(set) var status: RaitingType = .wait
    weak var delegate: WaitingReviewViewControllerDelegate?
    
    convenience init(status: RaitingType) {
        self.init()
        self.status = status
    }
    
    func reloadData(_ raitings: [Raiting]) {
        self.raitings = raitings
        self.emptyView.isHidden = !self.raitings.isEmpty
        collectionView.reloadData()
        collectionView.dataSource = self
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.snp.bottomMargin)
                    .offset(-dimension.largeMargin_32)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
                    .offset(-dimension.largeMargin_32)
            }
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WaitingReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH  - dimension.largeMargin_32, height: 172)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 100)
    }
}

// MARK: -
extension WaitingReviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let rait = raitings[safe: indexPath.row] {
            switch rait.isRating {
            case .done:
                let product = Product()
                product.id = rait.id
                AppRouter.pushToProductDetail(product)
            case .wait:
                let vc = RaitingReviewViewController(rait)
                vc.index = indexPath.row
                vc.delegate = self
                UINavigationController.topNavigationVC?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WaitingReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return raitings.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ReviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let raiting = self.raitings[safe: indexPath.row] {
            cell.configCell(raiting)
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let cell: GrayCollectionViewFooterCell =
                collectionView.dequeueReusableSupplementaryView(ofKind:
                UICollectionView.elementKindSectionFooter, for: indexPath)
            return cell
        } else {
            return UICollectionReusableView()
        }
    }
}

extension WaitingReviewViewController: RaitingReviewViewControllerDelegate {
    func handleSuccessReview(index: Int) {
        self.raitings.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        self.collectionView.reloadData()
        self.delegate?.handleReviewSuccess()
    }
}
