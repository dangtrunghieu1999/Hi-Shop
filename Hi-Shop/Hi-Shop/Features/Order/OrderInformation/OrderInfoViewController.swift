//
//  OrderInformationViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

enum OrderSection: Int {
    case address      = 0
    case section1     = 1
    case transport    = 2
    case orderInfo    = 3
    case section2     = 4
    case payment      = 5
    case section3     = 6
    
    static func numberOfSections() -> Int {
        return 7
    }
}

class OrderInfoViewController: BaseViewController {
    
    // MARK: - UI Elements
    
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
        return collectionView
    }()
    
    private let bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var intoMoneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = TextManager.titleTotalMoney
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var totalMoneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.textColor = UIColor.primary
        label.text = viewModel.cartShopInfo?.totalMoney.currencyFormat
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.buyNow, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnConfirmOrder),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK -  Variables
    private var totalDistance: Double       = 0.0
    private var viewModel                   = OrderViewModel()
    fileprivate var selectedPayment: PaymentMethodType?
    fileprivate var selectedTransporter: TransportersType?
    private var itemId: [Int]               = []
    convenience init(_ viewModel: OrderViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.order
        layoutBottomView()
        layoutBuyButton()
        layoutSumMoneyTitleLabel()
        layoutTotalMoneyTitleLabel()
        layoutCollectionView()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideLoading()
    }
    
    private func registerCell() {
        self.collectionView.registerReusableCell(AddressCollectionViewCell.self)
        self.collectionView.registerReusableCell(FooterCollectionViewCell.self)
        self.collectionView.registerReusableCell(TransportCollectionViewCell.self)
        self.collectionView.registerReusableCell(OrderCollectionViewCell.self)
        self.collectionView.registerReusableCell(PaymentCollectionViewCell.self)
    }
    
    @objc private func tapOnConfirmOrder() {
        if selectedTransporter != nil && selectedPayment != nil {
            let params: [String: Any] = ["itemId": self.viewModel.itemsId]
            let endPoint = OrderEndPoint.checkItemOrder(params: params)
            self.showLoading()
            APIService.request(endPoint: endPoint) { [weak self] apiResponse in
                guard let self = self else { return }
                self.hideLoading()
                guard let data = apiResponse.data else {
                    return
                }
                self.itemId = data["itemId"].arrayValue.map{ $0.intValue }
                if self.itemId.count > 0 {
                    AlertManager.shared.show(message: "Sản phẩm đã hết, bạn vui lòng chọn sản phẩm khác")
                } else {
                    let vc = OrderConfirmViewController(self.viewModel)
                    vc.shippingDistance(distance: self.totalDistance)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } onFailure: { error in
                self.hideLoading()
            } onRequestFail: {
                self.hideLoading()
            }
        } else {
            AlertManager.shared.show(message: "Thông tin còn thiếu")
        }
    }
    
    func requestAPIAdressShops(shopId: String) {
        
        let params   = ["id": shopId]
        let endPoint = ShopEndPoint.getAddressShopById(params: params)
        
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            guard let delivery = apiResponse.toObject(Delivery.self) else {
                return
            }
            self.getDistance(origin: self.viewModel.delivery?.addressDetail ?? "",
                             destination: delivery.addressDetail ?? "")
            
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
        
    }
    
    func getDistance(origin: String, destination: String) {
        let key : String = "AIzaSyBNEduw0Q0e5ThDaP4L7UDlcdDmofnSaVc"
        let postParameters:[String: Any] = [ "origin": origin, "destination":destination, "key": key]
        let url : String = "https://maps.googleapis.com/maps/api/directions/json"
        Alamofire.request(url, method: .get,
                          parameters: postParameters,
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON {  response in
                            
                            if let receivedResults = response.result.value
                            {
                                let result = JSON(receivedResults)
                                let distance = GoogleModel(json: result["routes"][0]["legs"][0]["distance"])
                                self.totalDistance += distance.kilometer
                            }
                          }
    }
    
    // MARK: - Layout
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom
                    .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    private func layoutBuyButton() {
        bottomView.addSubview(buyButton)
        buyButton.snp.makeConstraints { (make) in
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height
                .equalTo(dimension.largeHeightButton)
            make.width
                .equalTo(150)
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutSumMoneyTitleLabel() {
        bottomView.addSubview(intoMoneyTitleLabel)
        intoMoneyTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutTotalMoneyTitleLabel() {
        bottomView.addSubview(totalMoneyTitleLabel)
        totalMoneyTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(intoMoneyTitleLabel)
            make.top
                .equalTo(intoMoneyTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
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
extension OrderInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type  = OrderSection(rawValue: indexPath.section)
        switch type {
        case .section1, .section2, .section3:
            return CGSize(width: width, height: 8)
        case .address:
            return CGSize(width: width, height: 120)
        case .transport:
            return CGSize(width: width, height: 230)
        case .orderInfo:
            return CGSize(width: width,
                          height: viewModel.estimateHeight + 120)
        case .payment:
            return CGSize(width: width, height: 200)
        default:
            return CGSize(width: width, height: 0)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OrderInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return OrderSection.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = OrderSection(rawValue: indexPath.section)
        switch type {
        case .section1,
             .section2,
             .section3:
            let cell: FooterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .address:
            let cell: AddressCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            let delivery = viewModel.delivery
            cell.configCell(with: delivery?.infoUser,
                            addressRecive: delivery?.addressDetail)
            return cell
        case .transport:
            let cell: TransportCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .orderInfo:
            let cell: OrderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.products = viewModel.products
            return cell
        case .payment:
            let cell: PaymentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - AddressCollectionViewCellDelegate
extension OrderInfoViewController: AddressCollectionViewCellDelegate {
    func didSelectAddress() {
        let vc = DeliveryAddressViewController()
        vc.isHiddenNeeded = false
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - DeliveryAddressViewControllerDelegate
extension OrderInfoViewController: DeliveryAddressViewControllerDelegate {
    func didTapAddressSelect(delivery: Delivery) {
        self.viewModel.setDeliveryOrder(delivery: delivery)
        let indexSet = IndexSet(integer: OrderSection.address.rawValue)
        self.collectionView.reloadSections(indexSet)
    }
}
// MARK: - TransportCollectionViewCellDelegate
extension OrderInfoViewController: TransportCollectionViewCellDelegate {
    func didTapTransported(at type: TransportersType) {
        self.viewModel.setTransporterType(type: type)
        self.selectedTransporter = type
    }
}
// MARK: - PaymentCollectionViewCellDelegate
extension OrderInfoViewController: PaymentCollectionViewCellDelegate {
    func didTapPaymentMethod(at type: PaymentMethodType) {
        self.viewModel.setPaymentMethod(type: type)
        self.selectedPayment = type
    }
}
