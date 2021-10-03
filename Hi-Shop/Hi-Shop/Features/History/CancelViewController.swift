//
//  CancelViewController.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 13/09/2021.
//

import UIKit

protocol CancelViewControllerDelegate: AnyObject {
    func handleCancelSuccess()
}

class CancelViewController: BaseViewController {

    private (set) var orderDetail = OrderDetail()
    weak var delegate: CancelViewControllerDelegate?
    
    fileprivate lazy var infoCodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.orderCode.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var infoCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var orderTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.text = TextManager.orderTime.localized()
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var orderTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var statusTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.text = "Trạng thái:"
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.text = "Đặt hàng thành công"
        label.textAlignment = .left
        return label
    }()
    
    private let lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var reasonTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Lý do"
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 20)
        textView.text = TextManager.yourProblem.localized()
        textView.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textView.textColor = UIColor.placeholder
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = dimension.cornerRadiusSmall
        textView.layer.masksToBounds = true
        textView.delegate = self
        return textView
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.send, for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.primary
        button.addTarget(self, action: #selector(tapOnNextCancel),
                         for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Huỷ đơn hàng"
        layoutInfoCodeTitleLabel()
        layoutCodeTitleLabel()
        layoutOrderTimeTitleLabel()
        layoutOrderTimeLabel()
        layoutStatusTitleLabel()
        layoutStatusLabel()
        layoutLineView()
        layoutNoteTitleLabel()
        layoutContentTextView()
        layoutSendButton()
    }
    
    @objc private func tapOnNextCancel() {
        guard let reason = contentTextView.text else { return }
        let endPoint = OrderEndPoint.cancelOrderProcess(params: ["id": orderDetail.orderId,
                                                                 "reason": reason])
        
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.navigationController?.popViewControllerWithHandler(completion: {
                self.delegate?.handleCancelSuccess()
            })
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
    }
    
    func configData(order: OrderDetail) {
        self.orderDetail = order
        self.infoCodeLabel.text = order.orderCode
        self.orderTimeLabel.text = order.orderTime
    }
    
    private func layoutInfoCodeTitleLabel() {
        view.addSubview(infoCodeTitleLabel)
        infoCodeTitleLabel.snp.makeConstraints { make in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.normalMargin)
            }
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutCodeTitleLabel() {
        view.addSubview(infoCodeLabel)
        infoCodeLabel.snp.makeConstraints { make in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.normalMargin)
            }
            make.left.equalTo(infoCodeTitleLabel.snp.right)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutOrderTimeTitleLabel() {
        view.addSubview(orderTimeTitleLabel)
        orderTimeTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(infoCodeTitleLabel)
            make.top.equalTo(infoCodeTitleLabel.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutOrderTimeLabel() {
        view.addSubview(orderTimeLabel)
        orderTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(orderTimeTitleLabel)
            make.left.equalTo(orderTimeTitleLabel.snp.right)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutStatusTitleLabel() {
        view.addSubview(statusTitleLabel)
        statusTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(orderTimeTitleLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.left.equalTo(infoCodeTitleLabel)
        }
    }
    
    private func layoutStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(statusTitleLabel)
            make.left.equalTo(statusTitleLabel.snp.right)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutLineView() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.height.equalTo(dimension.mediumMargin)
            make.left.right.equalToSuperview()
        }
    }
    
    private func layoutNoteTitleLabel() {
        view.addSubview(reasonTitleLabel)
        reasonTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalTo(lineView.snp.bottom)
                .offset(dimension.normalMargin)
            
        }
    }
    
    private func layoutContentTextView() {
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(80)
            make.top.equalTo(reasonTitleLabel.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    private func layoutSendButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
                .inset(Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.largeHeightButton)
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                    .offset(-Dimension.shared.mediumMargin)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
                    .offset(-Dimension.shared.mediumMargin)
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension CancelViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == TextManager.yourProblem.localized() {
            textView.text = ""
        }
        textView.textColor = UIColor.titleText
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = TextManager.yourProblem.localized()
            textView.textColor = UIColor.placeholder
        }
    }
}


