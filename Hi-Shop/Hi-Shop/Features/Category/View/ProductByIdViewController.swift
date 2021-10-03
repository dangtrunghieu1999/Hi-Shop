//
//  ProductByCateogryViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit
import RxSwift

class ProductByIdViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate var products:       [Product]   = []
    fileprivate var cachedProducts: [Product]   = []
    fileprivate var productsResponse: [Product] = []
    fileprivate var isLoadMore                  = false
    fileprivate var canLoadMore                 = true
    fileprivate var currentPage                 = 0
    var idProductByCategrory: Int?
    var titeCategory: String?                   = ""
    
    // MARK: - UI ELements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 6
        layout.minimumInteritemSpacing = 0
        let collectionView             = UICollectionView(frame: .zero,
                                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBackground
        collectionView.frame           = view.bounds
        collectionView.dataSource      = self
        collectionView.delegate        = self
        collectionView.refreshControl  = refreshControl
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(
            LoadMoreCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        collectionView.registerReusableSupplementaryView(FilterCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollectionView()
        requestAPIProducts()
        setupNavigationBar()
    }
    
    // MARK: - UI Actions
    
    @objc private func pullToRefresh() {
        currentPage = 0
        canLoadMore = true
        requestAPIProducts()
    }
    
    override func setupNavigationBar() {
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = cartBarButtonItem
        self.searchBar.delegate = self
        searchBar.textColor = UIColor.bodyText
        searchBar.text = titeCategory
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performAction()
        return true
    }
    
    
    func performAction() {
        let vc = SearchTextViewController()
        guard let searchText = searchBar.text else {
            return
        }
        vc.searchText = searchText
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UI Action
    
    // MARK: - Layout
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom
                .equalToSuperview()
        }
    }

}

// MARK: - UICollectionViewDataSource
extension ProductByIdViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if isRequestingAPI {
            return 6
        } else if products.isEmpty {
            return 1
        } else {
            return self.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let product = products[safe: indexPath.row] {
            cell.configCell(product)
        }
        if !isRequestingAPI {
            cell.stopShimmering()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer: LoadMoreCollectionViewCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            footer.animiate(isLoadMore)
            return footer
        } else if kind == UICollectionView.elementKindSectionHeader {
            let header: FilterCollectionViewHeaderCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            header.delegate = self
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

extension ProductByIdViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (ScreenSize.SCREEN_WIDTH - 4) / 2, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoadMore {
            return CGSize(width: collectionView.frame.width, height: 70)
        } else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductByIdViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDelegate = scrollDelegateFunc {
            scrollDelegate(scrollView)
        }
        
        let collectionViewOffset = collectionView.contentSize.height - collectionView.frame.size.height - 50
        if scrollView.contentOffset.y >= collectionViewOffset
            && !isLoadMore
            && !isRequestingAPI
            && canLoadMore {
            
            currentPage += 1
            isLoadMore = true
            collectionView.reloadData()
            requestAPIProducts()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard !isRequestingAPI && !products.isEmpty else { return }
        guard let product = products[safe: indexPath.row] else { return }
        AppRouter.pushToProductDetail(product)
    }
}

extension ProductByIdViewController: FilterCollectionViewHeaderCellDelegate {
    func didTapFilterType(type: FilterType) {
        self.showLoading()
        if type.key == "all" {
            self.requestAPIProducts()
        } else {
            self.requestAPIFilterProduct(filterKey: type.key)
        }
    }
}

// MARK: - API

extension ProductByIdViewController {
    
    private func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.isLoadMore = false
        self.canLoadMore = true
        self.hideLoading()
        self.refreshControl.endRefreshing()
        self.collectionView.reloadData()
    }
    
    func requestAPIProducts() {
        
        let params: [String: Any] = ["categoryId": idProductByCategrory ?? 0,
                                     "pageNumber": currentPage,
                                     "pageSize": AppConfig.defaultProductPerPage]
        
        let endPoint = ProductEndPoint.getAllCategoryById(parameters: params)
        
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.hideLoading()
            let json       = apiResponse.data?["content"]
            self.productsResponse  = json?.arrayValue.map { Product(json: $0)} ?? []
            
            if self.isLoadMore {
                self.cachedProducts.append(contentsOf: self.productsResponse)
            } else {
                self.cachedProducts = self.productsResponse
            }
            
            if self.canLoadMore {
                self.canLoadMore = !self.productsResponse.isEmpty
            }
            
            self.isRequestingAPI = false
            
            if self.isLoadMore {
                self.isLoadMore = false
                var reloadIndexPaths: [IndexPath] = []
                let numberProducts = self.products.count
                
                for index in 0..<self.productsResponse.count {
                    reloadIndexPaths.append(
                        IndexPath(item: numberProducts + index,
                                  section: 0))
                }
                
                self.products = self.cachedProducts
                self.collectionView.insertItems(at: reloadIndexPaths)
            } else {
                self.products = self.cachedProducts
                self.collectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
            if self.products.count < 3 {
                self.collectionView.contentInset =
                    UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            }
            
        }, onFailure: { [weak self] (apiError) in
            guard let self = self else { return }
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.showToast()
            
        }) { [weak self] in
            guard let self = self else { return }
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.showToast()
        }
    }
    
    func requestAPIFilterProduct(filterKey: String) {
        self.currentPage = 0
        let params: [String: Any] = ["k": filterKey,
                                     "categoryId": idProductByCategrory ?? 0,
                                     "pageNumber": currentPage,
                                     "pageSize": AppConfig.defaultProductPerPage]
        
        let endPoint = ProductEndPoint.getProductFilter(parameters: params)
        
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.hideLoading()
            let json       = apiResponse.data?["content"]
            self.productsResponse  = json?.arrayValue.map { Product(json: $0)} ?? []
            
            if self.isLoadMore {
                self.cachedProducts.append(contentsOf: self.productsResponse)
            } else {
                self.cachedProducts = self.productsResponse
            }
            
            if self.canLoadMore {
                self.canLoadMore = !self.productsResponse.isEmpty
            }
            
            self.isRequestingAPI = false
            
            if self.isLoadMore {
                self.isLoadMore = false
                var reloadIndexPaths: [IndexPath] = []
                let numberProducts = self.products.count
                
                for index in 0..<self.productsResponse.count {
                    reloadIndexPaths.append(
                        IndexPath(item: numberProducts + index,
                                  section: 0))
                }
                
                self.products = self.cachedProducts
                self.collectionView.insertItems(at: reloadIndexPaths)
            } else {
                self.products = self.cachedProducts
                self.collectionView.reloadData()
            }
            
            self.refreshControl.endRefreshing()
            
            if self.products.count < 3 {
                self.collectionView.contentInset =
                    UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            }
            
        }, onFailure: { [weak self] (apiError) in
            guard let self = self else { return }
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.showToast()
            
        }) { [weak self] in
            guard let self = self else { return }
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.showToast()
        }
    }
}
