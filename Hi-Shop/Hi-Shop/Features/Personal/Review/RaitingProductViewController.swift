//
//  RaitingProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class RaitingProductViewController: HeaderedCAPSPageMenuViewController {

    private lazy var viewControllerFrame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height)
    var parameters: [CAPSPageMenuOption] = [
        .centerMenuItems(true),
        .scrollMenuBackgroundColor(UIColor.white),
        .selectionIndicatorColor(UIColor.primary),
        .selectedMenuItemLabelColor(UIColor.bodyText),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium)),
        .menuHeight(42),
        
    ]

    var pageMenu : CAPSPageMenu?
    private (set) var ratings: [Raiting] = []
    fileprivate var subPageControllers: [WaitingReviewViewController] = []
    
    // MARK: - LifeCycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackButtonIfNeeded()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.ratingForProduct.localized()
        addGuestChildsVC()
    }
    
    fileprivate func addGuestChildsVC() {
        createSubViewOrderManager()
        
        pageMenu = CAPSPageMenu(viewControllers: subPageControllers,
                                frame: CGRect(x: 0.0, y: self.topbarHeight,
                                width: self.view.frame.width,
                                height: self.view.frame.height),
                                pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        requestAPIRaiting()
    }
    
    func requestAPIRaiting() {
        
        let endPoint = ProductEndPoint.getListRatting
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.ratings = apiResponse.toArray([Raiting.self])
            self.reloadAllChildOrderVC(with: self.ratings)
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
    }
    
    private func reloadAllChildOrderVC(with raits: [Raiting]) {
        for vc in subPageControllers {
            let currentRaiting = filterRaits(raits, by: vc.status)
            vc.reloadData(currentRaiting)
        }
    }
    
    func createSubViewOrderManager() {
        for status in Raiting.arraySubVC {
            let vc = WaitingReviewViewController(status: status)
            vc.delegate = self
            vc.view.frame = viewControllerFrame
            vc.title = status.title
            subPageControllers.append(vc)
        }
    }
    
    func filterRaits(_ raits: [Raiting], by status: RaitingType) -> [Raiting] {
        switch status {
        case .wait:
            return raits.filter { $0.isRating == status }
        case .done:
            return raits.filter { $0.isRating == status }
        }
    }
}

extension RaitingProductViewController: WaitingReviewViewControllerDelegate {
    func handleReviewSuccess() {
        self.requestAPIRaiting()
    }
}
