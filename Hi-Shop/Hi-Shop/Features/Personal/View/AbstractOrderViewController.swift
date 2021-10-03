//
//  AbstractOrderViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 18/06/2021.
//

import UIKit

class AbstractOrderViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = dimension.mediumMargin
        layout.minimumInteritemSpacing = 0
        let collectionView             = UICollectionView(frame: .zero,
                                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBackground
        collectionView.frame           = view.bounds
        collectionView.dataSource      = self
        collectionView.delegate        = self
        collectionView.contentInset    = UIEdgeInsets(top: dimension.mediumMargin,
                                                      left: 0,
                                                      bottom: dimension.mediumMargin,
                                                      right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(OrderStatusCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(GrayCollectionViewFooterCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()

    private var orders: [Order] = []
    private(set) var status: OrderStatus = .all
    
    convenience init(status: OrderStatus) {
        self.init()
        self.status = status
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollectionView()
        emptyView.backgroundColor = .clear
        addEmptyView(message: TextManager.emptyOrder,
                     image: ImageManager.icon_logo2)
        setDefaultNavigationBar(leftBarImage: ImageManager.back)
    }
    
    func reloadData(_ orders: [Order]) {
        self.orders = orders
        if self.status == OrderStatus.all {
            self.emptyView.isHidden = !self.orders.isEmpty
        }
        collectionView.reloadData()
        collectionView.dataSource = self
    }
    
    override func touchUpInLeftBarButtonItem() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.snp.bottomMargin)
                    .offset(-dimension.largeMargin_32)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
                    .offset(-dimension.largeMargin_32)
            }
        }
    }
}

extension AbstractOrderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 100)
    }
}


extension AbstractOrderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OrderStatusCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(order: orders[indexPath.row], index: indexPath.row)
        cell.delegate = self
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
// MARK: - OrderStatusCollectionViewCellDelegate

extension AbstractOrderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let vc = OrderDetailViewController()
        AppRouter.pushToOrderDetailVC(id: orders[indexPath.row].orderId,
                                      viewController: vc)
    }
}

// MARK: - OrderStatusCollectionViewCellDelegate
extension AbstractOrderViewController: OrderStatusCollectionViewCellDelegate {
    func handleTapOrderDetail(index: Int) {
        let vc = OrderDetailViewController()
        AppRouter.pushToOrderDetailVC(id: orders[index].orderId,
                                      viewController: vc)
    }
    
    func handleTapBuy(index: Int) {
        let order = orders[index]
        let endPoint = ProductEndPoint.buyAgain(params: order.toDictionaryRegain())
        self.showLoading()
        APIService.request(endPoint: endPoint) {[weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            NotificationCenter.default.post(name: Notification.Name.reloadCartBadgeNumber, object: nil)
            AppRouter.pushToCart()
        } onFailure: { error in
            self.hideLoading()
            if error?.code == "409" {
                AlertManager.shared.showToast(message: "Sản phẩm đã hết hàng")
            }
        } onRequestFail: {
            self.hideLoading()
        }
    }
}
