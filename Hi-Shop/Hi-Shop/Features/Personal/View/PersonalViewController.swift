//
//  PersonalViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class PersonalViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    fileprivate lazy var personalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.separator
        collectionView.dataSource      = self
        collectionView.delegate        = self
        collectionView.refreshControl  = refreshControl
        collectionView.registerReusableCell(PersonCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(PersonalCollectionHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutPersonalCollectionView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleLoginSuccess),
                                               name: Notification.Name.reloadLoginSuccess,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc private func pullToRefresh() {
        self.showLoading()
        self.refreshControl.endRefreshing()
        self.personalCollectionView.reloadData()
        self.hideLoading()
    }
    
    // MARK: - Helper Method
    
    override func setupNavigationBar() {
        navigationItem.title = TextManager.person
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    @objc func reloadCollectionView() {
        self.personalCollectionView.reloadData()
    }
    
    @objc func handleLoginSuccess() {
        self.pullToRefresh()
    }
    
    // MARK: - Layout
    
    private func layoutPersonalCollectionView() {
        view.addSubview(personalCollectionView)
        personalCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalTo(view.snp.bottomMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
}

// MARK: - PersonalViewModelDelegate

extension PersonalViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return PersonalType.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PersonCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(personal: Personal.cellObject[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: PersonalCollectionHeaderCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            if UserManager.isLoggedIn() {
                let fullName = UserManager.user?.fullName
                let pictureUrl = UserManager.user?.pictureURL
                header.configData(true, title: fullName, url: pictureUrl)
            } else {
                header.configData(false,
                                  title: TextManager.welcomeSignInUp,
                                  url: AppConfig.imageAvata)
            }
            header.delegate = self
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PersonalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type = PersonalType(rawValue: indexPath.row)
        switch type {
        case .section1, .section2:
            return CGSize(width: width, height: 10)
        default:
            return CGSize(width: width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 80.0)
    }
}

// MARK: - UICollectionViewDelegate

extension PersonalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let type = PersonalType(rawValue: indexPath.row) else { return }
        switch type {
        case .mananger, .recive, .transport, .success, .canccel:
            let vc = ManagerOrderViewController()
            vc.numberIndex = indexPath.row - 1
            self.handleWhenLoginPushView(vc)
        case .address:
            let vc = DeliveryAddressViewController()
            vc.isHiddenNeeded = true
            self.handleWhenLoginPushView(vc)
        case .bought:
            let vc = ProductedBuyViewController()
            self.handleWhenLoginPushView(vc)
        case .liked:
            let vc = ProductLikeViewController()
            self.handleWhenLoginPushView(vc)
        case .rating:
            let vc = RaitingProductViewController()
            self.handleWhenLoginPushView(vc)
        case .phone:
            let phone = "0985153812"
            if let phoneCallURL = URL(string: "tel://\(phone)") {

                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
              }
        default:
            break
        }
    }
    
    func handleWhenLoginPushView(_ vc: UIViewController) {
        if UserManager.isLoggedIn() {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = SignInViewController()
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
}

// MARK :- PersonalHeaderCollectionViewDelegate

extension PersonalViewController: PersonalHeaderCollectionViewDelegate {
    func tapOnSignIn() {
        let vc = ProfileViewController()
        vc.delegate = self
        self.handleWhenLoginPushView(vc)
    }
}

// MARK :- SignInViewControllerDelegate

extension PersonalViewController: SignInViewControllerDelegate {
    func loginSuccessBackToCurrentVC() {
        self.pullToRefresh()
    }
}

// MARK :- ProfileViewControllerDelegate

extension PersonalViewController: ProfileViewControllerDelegate {
    func handleUpdateInfo() {
        self.pullToRefresh()
    }
    
    func logOutSuccessful() {
        self.pullToRefresh()
    }
}
