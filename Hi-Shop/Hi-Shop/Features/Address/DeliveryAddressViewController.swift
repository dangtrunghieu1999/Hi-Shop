//
//  DeliveryAddressViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol DeliveryAddressViewControllerDelegate: AnyObject {
    func didTapAddressSelect(delivery: Delivery)
}

class DeliveryAddressViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        label.textAlignment = .left
        label.text = TextManager.selectShipAddress
        return label
    }()
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var shipAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.shipAddress, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapSelectAddressSuccess),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var shipAdressTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tableBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.isExclusiveTouch = true
        tableView.refreshControl = refreshControl
        tableView.registerReusableCell(SelectShipAddressTableViewCell.self)
        tableView.registerReusableHeaderFooter(ShipAddressTableViewFooter.self)
        return tableView
    }()
    
    
    // MARK: - Variables
    
    weak var delegate: DeliveryAddressViewControllerDelegate?
    
    private var deliveries: [Delivery] = []
    private var selectIndex = 0
    var isHiddenNeeded = false
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.addressRecive
        layoutTitleLabel()
        layoutBottomView()
        layoutShipAddressButton()
        layoutShipAddressTableView()
        requestAPIAddressRecive()
        self.bottomView.isHidden = self.isHiddenNeeded
    }
    
    // MARK: - Helper Method
    
    @objc private func tapSelectAddressSuccess() {
        let delivery = deliveries[selectIndex]
        self.navigationController?.popViewControllerWithHandler(completion: {
            self.delegate?.didTapAddressSelect(delivery: delivery)
        })
        
    }
    
    @objc private func pullToRefresh() {
        requestAPIAddressRecive()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - GET API
    
    func requestAPIAddressRecive() {
        let endPoint = UserEndPoint.getAllAdress
        self.showLoading()
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            self.deliveries = apiResponse.toArray([Delivery.self])
            self.shipAdressTableView.reloadData()
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
    }
    
    func requestAPIDeleteAddress(_ id: Int, row: Int) {
        let params   = ["id": id]
        let endPoint = UserEndPoint.deleteAddress(params: params)
        
        APIService.request(endPoint: endPoint) { apiResponse in
            AlertManager.shared.showToast(message: "Xoá địa chỉ thành công")
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
    }
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top
                    .equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.normalMargin)
            } else {
                make.top
                    .equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.normalMargin)
            }
            make.right
                .equalToSuperview()
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutShipAddressTableView() {
        view.addSubview(shipAdressTableView)
        shipAdressTableView.snp.makeConstraints { (make) in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(dimension.largeMargin)
            make.left
                .right
                .equalToSuperview()
            make.bottom
                .equalTo(bottomView.snp.top)
                .offset(-dimension.normalMargin)
        }
    }
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom
                    .equalTo(view.snp.bottomMargin)
            } else {
                make.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(68)
        }
    }
    
    private func layoutShipAddressButton() {
        bottomView.addSubview(shipAddressButton)
        shipAddressButton.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height
                .equalTo(dimension.defaultHeightButton)
            make.bottom
                .equalToSuperview()
                .offset(-dimension.mediumMargin)
        }
    }
}

// MARK: - UITableViewDelegate

extension DeliveryAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let delivery = self.deliveries[indexPath.row]
        if delivery.defaults {
            return 120
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 58
    }
}

// MARK: - UITableViewDataSource

extension DeliveryAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return deliveries.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectShipAddressTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configData(deliveries[indexPath.row], row: indexPath.row, isHidden: self.isHiddenNeeded)
        cell.isSelected = (indexPath.row == selectIndex)
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let footer: ShipAddressTableViewFooter = tableView.dequeueReusableHeaderFooterView()
        footer.delegateShip = self
        return footer
    }
}

// MARK: - SelectShipAddressTableViewCellDelegate

extension DeliveryAddressViewController: ShipAddressTableViewFooterDelegate {
    func didTapView() {
        let vc = DeliveryInfomationViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - DeliveryInfomationViewControllerDelegate

extension DeliveryAddressViewController: DeliveryInfomationViewControllerDelegate {
    func createSuccessAddress(_ delivey: Delivery) {
        AlertManager.shared.showToast(message: "Tạo địa chỉ mới thành công.")
        self.deliveries.append(delivey)
        self.shipAdressTableView.reloadData()
        self.pullToRefresh()
    }
}

// MARK: - SelectShipAddressTableViewCellDelegate

extension DeliveryAddressViewController: SelectShipAddressTableViewCellDelegate {
    func didTapSelectUpdate(delivery: Delivery) {
        let vc = UpdateAddressViewController()
        vc.configData(delivery)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapDeleteAddress(idAddress: Int?, with row: Int) {
        guard let id = idAddress else { return }
        AlertManager.shared.showConfirm("Bạn có chắc muốn xoá địa chỉ này!")
        { (action) in
            self.deliveries.remove(at: row)
            self.shipAdressTableView.deleteRows(at: [IndexPath(row: row, section: 0)],
                                                with: .automatic)
            self.requestAPIDeleteAddress(id, row: row)
           
        }
    }
}

// MARK: - UpdateAddressViewControllerDelegate

extension DeliveryAddressViewController: UpdateAddressViewControllerDelegate {
    func updateSuccessAddress() {
        self.shipAdressTableView.reloadData()
        self.pullToRefresh()
    }
}
