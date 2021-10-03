//
//  RaitingReviewViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 25/07/2021.
//

import UIKit
import HCSStarRatingView

protocol RaitingReviewViewControllerDelegate: AnyObject {
    func handleSuccessReview(index: Int)
}

class RaitingReviewViewController: BaseViewController {
    
    weak var delegate: RaitingReviewViewControllerDelegate?
    var index: Int = 0
    
    fileprivate lazy var coverViewImage: BaseView = {
        let view = BaseView()
        view.layer.cornerRadius = dimension.cornerRadiusSmall
        view.layer.borderWidth  = 1
        view.layer.borderColor  = UIColor.separator.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var provideByShopLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        label.textColor = UIColor.lightBodyText
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor  = UIColor.lightSeparator
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var statusRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.text = TextManager.normal
        label.textAlignment = .center
        return label
    }()
    
    private let ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.allowsHalfStars = false
        ratingView.emptyStarColor = UIColor.white
        ratingView.value = 3
        ratingView.tintColor = UIColor.ratingColor
        ratingView.isUserInteractionEnabled = true
        ratingView.addTarget(self, action: #selector(textValueChange),
                             for: .touchUpInside)
        return ratingView
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
    
    fileprivate lazy var alertRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primary
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.text = "Bạn cần chia sẽ ít nhất 25 kí tự."
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.send, for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.primary
        button.addTarget(self, action: #selector(sendRatingView),
                         for: .touchUpInside)
        return button
    }()
    
    private (set) var raiting = Raiting()
    
    convenience init(_ rait: Raiting) {
        self.init()
        self.raiting = rait
        self.productImageView.loadImage(by: rait.photo)
        self.productNameLabel.text   = rait.name
        self.provideByShopLabel.text = rait.shopName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.writeReview
        layoutCoverView()
        layoutProductImageView()
        layoutProductNameLabel()
        layoutProvideByShopLabel()
        layoutLineView()
        layoutStatusRatingLabel()
        layoutRatingView()
        layoutContentTextView()
        layoutAlertRatingLabel()
        layoutSendButton()
    }
    
    @objc private func sendRatingView() {
        let star = ratingView.value
        let id        = raiting.itemId 
        guard let productId = raiting.id else { return }
        guard let content = contentTextView.text else { return }
        let params: [String: Any] = ["itemId": id,
                                     "star": star,
                                     "productId": productId,
                                     "content": content]
        let endPoint = ProductEndPoint.createRaiting(params: params)
        self.showLoading()
        
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            self.navigationController?.popViewControllerWithHandler(completion: {
                self.delegate?.handleSuccessReview(index: self.index)
            })
        } onFailure: { error in
            self.hideLoading()
        } onRequestFail: {
            self.hideLoading()
        }

    }

    @objc private func textValueChange() {
        if ratingView.value == 3 {
            self.statusRatingLabel.text = TextManager.normal
        } else if ratingView.value == 4 {
            self.statusRatingLabel.text = TextManager.good
        } else if ratingView.value == 5 {
            self.statusRatingLabel.text = TextManager.extremely
        } else if ratingView.value == 2 {
            self.statusRatingLabel.text = TextManager.bad
        } else {
            self.statusRatingLabel.text = TextManager.displeasure
        }
    }
    
    private func layoutCoverView() {
        view.addSubview(coverViewImage)
        coverViewImage.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.normalMargin)
            }
            make.height.width
                .equalTo(80)
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutProductImageView() {
        coverViewImage.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.width.height
                .equalTo(60)
            make.centerY
                .equalToSuperview()
            make.centerX
                .equalToSuperview()
        }
    }
    
    private func layoutProductNameLabel() {
        view.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(coverViewImage.snp.right)
                .offset(dimension.normalMargin)
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top
                .equalTo(productImageView)
        }
    }
    
    private func layoutProvideByShopLabel() {
        view.addSubview(provideByShopLabel)
        provideByShopLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(productNameLabel)
            make.top.equalTo(productNameLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutLineView() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(dimension.mediumMargin)
            make.left.right.equalToSuperview()
            make.top.equalTo(coverViewImage.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutStatusRatingLabel() {
        view.addSubview(statusRatingLabel)
        statusRatingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    private func layoutRatingView() {
        view.addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.largeMargin_42)
            make.right.equalToSuperview()
                .offset(-dimension.largeMargin_42)
            make.top.equalTo(statusRatingLabel.snp.bottom)
                .offset(dimension.largeMargin)
            make.height.equalTo(dimension.largeMargin_42)
        }
    }
    
    private func layoutContentTextView() {
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(80)
            make.top.equalTo(ratingView.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    private func layoutAlertRatingLabel() {
        view.addSubview(alertRatingLabel)
        alertRatingLabel.snp.makeConstraints { make in
            make.left.equalTo(contentTextView)
            make.top.equalTo(contentTextView.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutSendButton() {
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
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

extension RaitingReviewViewController: UITextViewDelegate {
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

