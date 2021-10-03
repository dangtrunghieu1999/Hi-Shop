//
//  WebViewViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class WebViewViewController: BaseViewController {
    
    private let webView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = UIColor.white
        layoutWebView()
    }
    
    func configWebView(by url: URL) {
        webView.loadRequest(URLRequest(url: url))
    }
    
    private func layoutWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left
                .right
                .bottom
                .equalToSuperview()
        }
    }

}
