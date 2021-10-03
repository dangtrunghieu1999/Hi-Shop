//
//  OrderDetailViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 12/07/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

enum OrderDetailType: Int {
    case code       = 0
    case section1
    case address
    case section2
    case info
    case section3
    case transport
    case section4
    case payment
    case section5
    case bill
    
    static func numberOfItems() -> Int {
        return 11
    }
}

class OrderDetailViewController: BaseViewController {

    // MARK: - UI Elements
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator,
                          andWidth: 1)
        
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.cancel, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary.cgColor
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnCancel),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.separator
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerReusableCell(OrderCodeCollectionViewCell.self)
        collectionView.registerReusableCell(BillerCollectionViewCell.self)
        collectionView.registerReusableCell(OrderAddressCollectionViewCell.self)
        collectionView.registerReusableCell(FooterCollectionViewCell.self)
        collectionView.registerReusableCell(OrderDetailInfoCollectionViewCell.self)
        collectionView.registerReusableCell(OrderPaymentCollectionViewCell.self)
        collectionView.registerReusableCell(OrderTransportCollectionViewCell.self)
        return collectionView
    }()
    
    private var orderDetail = OrderDetail()
    private var itemsId: [Int] = []
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.order
        layoutBottomView()
        layoutCancelButton()
        layoutCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideLoading()
    }
    
    @objc private func tapOnCancel() {
        if self.orderDetail.status == 1 {
            let vc = CancelViewController()
            vc.configData(order: orderDetail)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
           requestAddProduct()
        }
    }
    
    func setEnableButton() {
        if self.orderDetail.status == 4 || self.orderDetail.status == 3 {
            self.cancelButton.isEnabled = true
            self.cancelButton.setTitle(TextManager.orderAgain, for: .normal)
        }
        else {
            self.cancelButton.isEnabled = true
            self.cancelButton.setTitle(TextManager.cancel, for: .normal)
        }
    }
    
    // MARK: - Layout
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            if #available(iOS 11, *) {
                $0.bottom
                    .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
            $0.left.right.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
    
    private func layoutCancelButton() {
        bottomView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height
                .equalTo(dimension.defaultHeightButton)
            make.bottom
                .equalToSuperview()
                .offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OrderDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let type  = OrderDetailType(rawValue: indexPath.row)
        switch type {
        case .code:
            return CGSize(width: width,
                          height: 90)
        case .info:
            return CGSize(width: width,
                          height: orderDetail.estimateHeight + 50.0)
        case .address:
            return CGSize(width: width, height: 110)
        case .transport, .payment:
            return CGSize(width: width, height: 74)
        case .section1, .section2, .section3, .section4, .section5:
            return CGSize(width: width, height: 8)
        case .bill:
            return CGSize(width: width, height: 200)
        default:
            return CGSize(width: width, height: 0)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OrderDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return OrderDetailType.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = OrderDetailType(rawValue: indexPath.row)
        switch type {
        case .code:
            let cell: OrderCodeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(code: orderDetail.orderCode, orderTime: orderDetail.orderTime, deliveryTime: orderDetail.deliveryTime, statusCode: orderDetail.status)

            return cell
        case .info:
            let cell: OrderDetailInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(products: orderDetail.products)
            return cell
        case .address:
            let cell: OrderAddressCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(with: orderDetail.userInfo,
                            addressRecive: orderDetail.address)
            return cell
        case .transport:
            let cell: OrderTransportCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.trasnportTitleLabel.text = orderDetail.transporter
            return cell
        case .payment:
            let cell: OrderPaymentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if orderDetail.isPaymentOnline == 1 {
                cell.paymentTitleLabel.text = orderDetail.paymentMethod + " - Đơn hàng đã thanh toán"
            } else {
                cell.paymentTitleLabel.text = orderDetail.paymentMethod
            }
            return cell
        case .section1, .section2, .section3, .section4, .section5:
            let cell: FooterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .bill:
            let cell: BillerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(tempMoney: orderDetail.tempMoney,
                            feeShip: orderDetail.feeShip,
                            totalMoney: orderDetail.totalMoney)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

 // MARK: - API

extension OrderDetailViewController {
    
    func requestAPIOrderDetail(orderId: Int) {
        let endPoint = OrderEndPoint.getOrderDetail(params: ["id": orderId])
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            self.orderDetail = apiResponse.toObject(OrderDetail.self) ?? OrderDetail()
            self.itemsId = self.orderDetail.products.map{ $0.itemId }
            self.collectionView.reloadData()
            self.setEnableButton()
        } onFailure: { erorr in
            self.hideLoading()
        } onRequestFail: {
            self.hideLoading()
        }
    }
    
    func requestAddProduct() {
        
        let endPoint = ProductEndPoint.buyAgain(params: orderDetail.toDictionaryCheck())
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

extension OrderDetailViewController: CancelViewControllerDelegate {
    func handleCancelSuccess() {
        AlertManager.shared.showToast(message: "Đã huỷ thành công")
        self.orderDetail.status = 4
        self.cancelButton.isEnabled = true
        self.cancelButton.setTitle(TextManager.orderAgain, for: .normal)
        self.collectionView.reloadItems(at: [IndexPath(row: 0, section: OrderDetailType.code.rawValue)])
    }
}
