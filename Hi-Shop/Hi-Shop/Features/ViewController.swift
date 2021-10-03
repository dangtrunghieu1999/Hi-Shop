//
//  ViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 27/05/2021.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.second, for: .normal)
        button.setTitle(TextManager.signUp, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                                    weight: .semibold)
        button.addTarget(self, action: #selector(tapOnSignUp), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layoutSignUpButton()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @objc func tapOnSignUp() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    private func layoutSignUpButton() {
        self.view.addSubview(self.signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
}

