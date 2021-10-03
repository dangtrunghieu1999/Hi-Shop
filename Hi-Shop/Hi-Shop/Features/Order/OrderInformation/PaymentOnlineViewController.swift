//
//  PaymentOnlineViewController.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 09/08/2021.
//

import UIKit
import MomoiOSSwiftSdk

protocol PaymentOnlineViewControllerDelegate: AnyObject {
    func paymentSuccessMomo()
}
class PaymentOnlineViewController: BaseViewController {
    
    var payment_merchantCode = "CGV01"
    var payment_merchantName = "Hi-Shop"
    var payment_amount       = 0.0
    var payment_fee_display  = 0
    var payment_userId       = ""
    
    weak var delegate: PaymentOnlineViewControllerDelegate?
    
    fileprivate lazy var moneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = TextManager.momoTitle
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var moneyPaymentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue,
                                       weight: .bold)
        label.text = payment_amount.currencyFormat
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.nextPayment, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.addTarget(self, action: #selector(gettoken), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.NoficationCenterTokenReceived),
                                               name: NSNotification.Name.reciveTokenMomo, object: nil)
        layoutMoneyTitleLabel()
        layoutMoneyPaymentLabel()
        layoutNextButton()
        setupPaymentInfo()
    }
    
    func setupPaymentInfo() {
        let paymentinfo = NSMutableDictionary()
        paymentinfo["merchantcode"] = "CGV01"
        paymentinfo["merchantname"] = "Hi-Shop"
        paymentinfo["merchantnamelabel"] = "Service"
        
        paymentinfo["amount"] = payment_amount
        paymentinfo["fee"] = payment_fee_display
        paymentinfo["description"] = "Thanh toán đơn hàng"
        paymentinfo["username"] = payment_userId
        paymentinfo["appScheme"] = "MOMOESG820210610"
        MoMoPayment.createPaymentInformation(info: paymentinfo)
    }
    
    @objc func gettoken() {
        MoMoPayment.requestToken()
    }
    
    @objc func NoficationCenterTokenReceived(notif: NSNotification) {
        let response:NSMutableDictionary = notif.object! as! NSMutableDictionary
        self.nextButton.backgroundColor = UIColor.disable
        let _statusStr = "\(response["status"] as! String)"
        
        if (_statusStr == "0") {
            
            print("::MoMoPay Log: SUCESS TOKEN. CONTINUE TO CALL API PAYMENT")
            print(">>phone \(response["phonenumber"] as! String)   :: data \(response["data"] as! String)")
            
            let merchant_username       = "username_or_email_or_fullname"
            
            let orderInfo = NSMutableDictionary();
            orderInfo.setValue(response["phonenumber"] as! String,            forKey: "phonenumber");
            orderInfo.setValue(response["data"] as! String,            forKey: "data");
            
            
            orderInfo.setValue(Int(payment_amount),            forKey: "amount");
            orderInfo.setValue(Int(0),            forKey: "fee");
            orderInfo.setValue(payment_merchantCode,            forKey: "merchantcode");
            orderInfo.setValue(merchant_username,            forKey: "username");
            
            submitOrderToServer(parram: orderInfo)
        }
    }
    
    func submitOrderToServer(parram: NSMutableDictionary) {
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.dismiss(animated: true) {
                self.delegate?.paymentSuccessMomo()
            }
        }
    }
    
    private func layoutMoneyTitleLabel() {
        self.view.addSubview(moneyTitleLabel)
        moneyTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(dimension.largeMargin_56)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
                .offset(-dimension.largeMargin)
        }
    }
    
    private func layoutMoneyPaymentLabel() {
        self.view.addSubview(moneyPaymentLabel)
        moneyPaymentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(moneyTitleLabel)
            make.top.equalTo(moneyTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutNextButton() {
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
                .offset(dimension.largeMargin)
            make.right.equalToSuperview()
                .offset(-dimension.largeMargin)
            make.height.equalTo(dimension.defaultHeightButton)
            make.bottom.equalToSuperview()
                .offset(-dimension.largeMargin_56)
        }
    }
}
