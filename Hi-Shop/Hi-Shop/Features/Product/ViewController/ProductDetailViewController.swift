//
//  ProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/12/21.
//

import UIKit
import IGListKit
import SwiftyJSON
import Alamofire

protocol ProductDetailViewControllerDelegate: AnyObject {
    func refreshAPIProductsLike()
}

class ProductDetailViewController: BaseViewController {
    
    // MARK: - Variables
    weak var delegate: ProductDetailViewControllerDelegate?
    
    fileprivate var isExpandDescriptionCell = false
    fileprivate (set) lazy var product = Product()
    private (set) var isCheckPopView: Bool = false
    fileprivate var productInfoCellHeight:  CGFloat?
    fileprivate var desciptionCellHeight:   CGFloat?
    
    fileprivate lazy var productRecommend: [Product] = []
    fileprivate lazy var productsShop:     [Product] = []
    fileprivate lazy var productsResponse: [Product] = []
    fileprivate var currentPage                      = -1
    fileprivate var cachedProducts:        [Product] = []
    fileprivate lazy var comments:         [Comment] = []
    fileprivate var isLoadMore                       = false
    fileprivate var canLoadMore                      = true
    
    // MARK: - UI Elements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.selectToBuy, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnBuyButton),
                         for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerReusableCell()
        layoutBottomView()
        layoutBuyButton()
        layoutCollectionView()
        setLeftNavigationBar(ImageManager.back)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideLoading()
    }
    
    internal override func setupNavigationBar() {
        navigationItem.rightBarButtonItem = cartBarButtonItem
        navigationItem.title = TextManager.productDetail.localized()
    }
    
    override func touchUpInLeftBarButtonItem() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func pullToRefresh() {
        canLoadMore = true
        currentPage = 1
        requestAPIProducts()
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnBuyButton() {
        
        if UserManager.isLoggedIn() {
            if product.avaiable > 0 {
                product.quantity = 1
                CartManager.shared.addProductToCart(product) {
                    NotificationCenter.default.post(name: Notification.Name.reloadCartBadgeNumber, object: nil)
                    AlertManager.shared.showToast(message: TextManager.addToCartSuccess.localized())
                } error: {
                    AlertManager.shared.showToast()
                }
            } else {
                AlertManager.shared.show(message: "Sản phẩm đã bán hết vui lòng chọn sản phẩm khác")
            }
        } else {
            let vc = SignInViewController()
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper Method
    
    func configData(_ product: Product, isCheck: Bool = false) {
        self.isCheckPopView = isCheck
        self.product = product
        collectionView.reloadData()
        var params: [String: Any] = [:]
        guard let productId = product.id else { return }

        if UserManager.isLoggedIn() {
            guard let userId = UserManager.userId else { return }
            params = ["productId": productId, "userId": userId]
            getProductById(params: params)
        } else {
            params = ["productId": productId]
            getProductById(params: params)
        }
    }

    func scrollCommentProduct() {
        let indexPath = IndexPath(row: 0, section: ProductDetailType.comment.rawValue)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
            }, completion: { [weak self] _ in
                self?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
                self?.collectionView(self?.collectionView ?? UICollectionView(), didSelectItemAt: indexPath)
                }
            )
        }
        self.collectionView.reloadData()
    }
    
    private func registerReusableCell() {
        collectionView.registerReusableCell(InfoCollectionViewCell.self)
        collectionView.registerReusableCell(SimilarCollectionViewCell.self)
        collectionView.registerReusableCell(StallCollectionViewCell.self)
        collectionView.registerReusableCell(AdvanedCollectionViewCell.self)
        collectionView.registerReusableCell(DetailsCollectionViewCell.self)
        collectionView.registerReusableCell(CommentCollectionViewCell.self)
        collectionView.registerReusableCell(ChildCommentCollectionViewCell.self)
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.registerReusableCell(DescriptionsCollectionViewCell.self)
        collectionView.registerReusableCell(BaseCollectionViewCell.self)
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(TitleCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView
        .registerReusableSupplementaryView(LoadMoreCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
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
            make.height.equalTo(70)
            make.left.right.equalToSuperview()
        }
    }
    
    private func layoutBuyButton() {
        bottomView.addSubview(buyButton)
        buyButton.snp.makeConstraints { (make) in
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
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let sectionType = ProductDetailType(rawValue: indexPath.section)
        else { return .zero }
        
        switch sectionType {
        case .infomation:
            if let productInfoCellHeight = productInfoCellHeight {
                return CGSize(width: collectionView.frame.width,
                              height: productInfoCellHeight)
            } else {
                productInfoCellHeight = InfoCollectionViewCell.estimateHeight(product)
                return CGSize(width: collectionView.frame.width,
                              height: productInfoCellHeight ?? 0)
            }
        case .smiliarProduct:
            return CGSize(width: collectionView.frame.width, height: 230)
        case .stallShop:
            return CGSize(width: collectionView.frame.width, height: 90)
        case .advanedShop:
            return CGSize(width: collectionView.frame.width, height: 140)
        case .infoDetail:
            return CGSize(width: collectionView.frame.width, height: 250)
        case .description:
            desciptionCellHeight = DescriptionsCollectionViewCell.estimateHeight(product)
            return CGSize(width: collectionView.frame.width,
                          height: desciptionCellHeight ?? 0)
        case .comment:
            if product.comments.isEmpty {
                return CGSize(width: collectionView.frame.width, height: 140)
            } else {
                guard let comment = product.commentInProductDetail[safe: indexPath.row]
                else { return .zero }
                return CGSize(width: collectionView.frame.width,
                              height: CommentCollectionViewCell.estimateHeight(comment))
            }
            
        case .recommend:
            return CGSize(width: (ScreenSize.SCREEN_WIDTH - 4) / 2, height: 320)
        default:
            return CGSize(width: collectionView.frame.width, height: 8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let sectionType = ProductDetailType(rawValue: section) else {
            return .zero
        }
        return sectionType.sizeForHeader()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isLoadMore && section == ProductDetailType.recommend.rawValue {
            return CGSize(width: collectionView.frame.width, height: 70)
        } else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProductDetailType.numberSection()
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = ProductDetailType(rawValue: section) else { return 0 }
        switch sectionType {
        case .comment:
            if (product.comments.isEmpty) {
                return 1
            } else {
                return product.numberCommentInProductDetail
            }
        case .recommend:
            if isRequestingAPI {
                return 6
            } else {
                return productRecommend.count
            }
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch sectionType {
        case .infomation:
            let cell: InfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataInfomation(product: product)
            if !isRequestingAPI {
                self.hideLoading()
            }
            cell.delegate = self
            return cell
        case .smiliarProduct:
            let cell: SimilarCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataCell(productsShop)
            return cell
        case .stallShop:
            let cell: StallCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataShop(product)
            return cell
        case .advanedShop:
            let cell: AdvanedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .infoDetail:
            let cell: DetailsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(detail: product.detail)
            cell.delegate = self
            return cell
        case .description:
            let cell: DescriptionsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configData(product)
            return cell
        case .comment:
            if product.comments.isEmpty {
                let emptyCell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                emptyCell.imageSize = CGSize(width: 40, height: 40)
                emptyCell.messageFont = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
                emptyCell.image = ImageManager.comment
                emptyCell.message = TextManager.emptyComment.localized()
                return emptyCell
            } else {
                let comment = product.commentInProductDetail[indexPath.row]
                
                if comment.isParrentComment {
                    let cell: CommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.configData(comment: comment)
                    cell.delegate = self
                    return cell
                } else {
                    let cell: ChildCommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.configData(comment: comment)
                    cell.delegate = self
                    return cell
                }
            }
        case .recommend:
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let product = productRecommend[safe: indexPath.row] {
                cell.configCell(product)
            }
            if !isRequestingAPI {
                cell.stopShimmering()
            }
            cell.contentView.addBottomBorder(with: UIColor.lightBackground,
                                             andWidth: dimension.smallMargin)
            return cell
        default:
            let cell: BaseCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = UIColor.separator
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header: TitleCollectionViewHeaderCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            header.title = sectionType.title
            if sectionType == .recommend {
                header.textColor = UIColor.primary
            } else {
                header.textColor = UIColor.bodyText
            }
            return header
        } else if kind == UICollectionView.elementKindSectionFooter
                    && indexPath.section == ProductDetailType.recommend.rawValue {
            let footer: LoadMoreCollectionViewCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            footer.animiate(isLoadMore)
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else { return }
        
        switch sectionType {
        case .comment:
            let commentVC = ProductCommentViewController()
            commentVC.delegate = self
            commentVC.isCheck = self.isCheckPopView
            commentVC.configData(productId: product.id)
            commentVC.configData(comments: product.comments)
            navigationController?.pushViewController(commentVC, animated: true)
            break
        case .stallShop:
            AppRouter.pushToShopHome(product.shopId ?? "")
            break
        case .recommend:
            guard !isRequestingAPI && !productRecommend.isEmpty else { return }
            guard let product = productRecommend[safe: indexPath.row] else { return }
            AppRouter.pushToProductDetail(product)
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDelegate = scrollDelegateFunc {
            scrollDelegate(scrollView)
        }
        
        let collectionViewOffset = collectionView.contentSize.height -
            collectionView.frame.size.height - 50
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
}

// MARK: - DetailsCollectionViewCellDelegate
extension ProductDetailViewController: DetailsCollectionViewCellDelegate {
    func didTapSeemoreParamter() {
        AppRouter.presentViewParameterProduct(viewController: self,
                                              detail: product.detail)
    }
}

// MARK: - ProductCommentViewControllerDelegate
extension ProductDetailViewController: ProductCommentViewControllerDelegate {
    func updateNewComments(_ comments: [Comment]) {
        product.comments = comments
        collectionView.reloadData()
    }
}

// MARK: - ProductDetailCommentCollectionViewCellDelegate
extension ProductDetailViewController: DetailCommentCollectionViewCellDelegate {
    
    func didSelectReplyComment(_ comment: Comment) {
        let commentVC = ProductCommentViewController()
        commentVC.delegate = self
        commentVC.configData(comments: product.comments)
        commentVC.configData(productId: product.id, replyComment: comment)
        navigationController?.pushViewController(commentVC, animated: true)
    }
}

//MARK: - SignInViewControllerDelegate
extension ProductDetailViewController: SignInViewControllerDelegate {
    func loginSuccessBackToCurrentVC() {
        product.quantity = 1
        CartManager.shared.addProductToCart(product) {
            NotificationCenter.default.post(name: Notification.Name.reloadCartBadgeNumber, object: nil)
            AlertManager.shared.showToast(message: TextManager.addToCartSuccess.localized())
            NotificationCenter.default.post(name: Notification.Name.reloadLoginSuccess, object: nil)
        } error: {
            AlertManager.shared.showToast()
        }
    }
}

// MARK: - API

extension ProductDetailViewController {
    
    private func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.isLoadMore = false
        self.canLoadMore = true
        self.refreshControl.endRefreshing()
        self.collectionView.reloadData()
    }

    func getProductById(params: [String: Any]) {
        let endPoint = ProductEndPoint.getProductById(parameters: params)
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            if let product = apiResponse.toObject(Product.self) {
                self.product = product
                self.requestProductSameAPI()
            }
        }, onFailure: { (apiError) in
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
            self.hideLoading()
        }) {
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }
    }
    
    func requestProductSameAPI() {
        guard let shopId = product.shopId else { return }
        let param = ["shopId": shopId]
        let endPoint = ShopEndPoint.getAllProduct(params: param)
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let data = apiResponse.data?["content"]
            self.productsShop = data?.arrayValue.map{ Product(json: $0)} ?? []
            self.reloadDataWhenFinishLoadAPI()
        }, onFailure: { (apiError) in
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }) {
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }
    }

    func requestAPIProducts() {
        
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        guard let id = self.product.category.uuid else { return }

        let params = ["categoryId": id,
                      "pageNumber": currentPage,
                      "pageSize": AppConfig.defaultProductPerPage]
        let endPoint = ProductEndPoint.getSuggestProduct(parameters: params)
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
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
                let numberProducts = self.productRecommend.count
                
                for index in 0..<self.productsResponse.count {
                    reloadIndexPaths.append(
                        IndexPath(item: numberProducts + index,
                                  section: ProductDetailType.recommend.rawValue))
                }
                
                self.productRecommend = self.cachedProducts
                self.collectionView.insertItems(at: reloadIndexPaths)
            } else {
                self.productRecommend = self.cachedProducts
                self.collectionView.reloadData()
            }
            
            if self.productRecommend.count < 3 {
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

extension ProductDetailViewController: InfoCollectionViewCellDelegate {
    func refreshLikeProducts() {
        delegate?.refreshAPIProductsLike()
    }
}
