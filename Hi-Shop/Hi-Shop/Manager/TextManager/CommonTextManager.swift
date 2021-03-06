//
//  TextManager.swift
//  ZoZoApp
//
//  Created by MACOS on 5/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

final class  TextManager {
    
    // MARK: - Common
    
    static let search                       = "Bạn tìm gì hôm nay?"
    static let cancel                       = "Huỷ"
    static let done                         = "Xong"
    static let save                         = "Lưu"
    static let preview                      = "Xem trước"
    static let photoPermission              = "Cho phép ứng dụng truy cập thư viện ảnh để chia sẻ hình ảnh đến bạn bè"
    static let cameraPermission             = "Cho phép ứng dụng truy cập Camera ảnh để chia sẻ khoảnh khắc đến bạn bè"
    static let add                          = "Thêm"
    static let agree                        = "Đồng ý"
    static let viewDetail                   = "Xem chi tiết"
    static let noPreview                    = "Không có bản xem trước nào"
    static let send                         = "Gửi"
    static let typeComment                  = "Nhập bình luận"
    static let delete                       = "Xoá"
    static let featureInDev                 = "Tính năng này chưa hoạt động"
    static let seemore                      = "Xem thêm"
    static let colapse                      = "Thu gọn"
    static let close                        = "Đóng"
    static let home                         = "Trang chủ"
    static let profile                      = "Cá nhân"
    static let notification                 = "Thông báo"
    static let emptyNotification            = "Thông báo trống"
    static let setting                      = "Cài đặt"
    static let addFriend                    = "Thêm bạn"
    static let news                         = "Tin tức"
    static let makeFriend                   = "Kết bạn"
    static let category                     = "Danh mục"
    static let person                       = "Cá nhân"
    static let notificationOrder            = "Thông báo đơn hàng"
    static let notificationAddFriend        = "Thông báo thêm bạn"
    static let notificationNews             = "Thông báo tin tức"
    static let completeOrder                = "Đặt hàng thành công"
    
    // MARK: - Alert
    
    static let IUnderstand                  = "Tôi đã hiểu"
    static let alertTitle                   = "Thông báo"
    static let loginFailMessage             = "Đăng nhập thất bại vui lòng kiểm tra tên đăng nhập hoặc mật khẩu"
    static let accNotActive                 = "Tài khoản chưa kích hoạt \n Bạn kiểm tra email và kích hoạt tài khoản để bắt đầu sử dụng"
    static let errorMessage                 = "Đã xảy ra lỗi vui lòng thử lại"
    static let gender                       = "Giới tính"
    static let female                       = "Nữ"
    static let male                         = "Nam"
    static let thank                        = "Cảm ơn "
    
    // MARK: - Users
    
    // SignIn
    static let connectFriend                = "Kết nối, nhắn tin với bạn bè"
    static let commentFriendShare           = "Bàn luận cùng bạn bè"
    static let followYourFavorite           = "Theo dõi những sở thích của bạn"
    static let buyAndSave                   = "Mua sắm được tích luỹ tiền"
    static let earnMoney                    = "Kiếm tiền"
    static let bussinessAndEarnMoney        = "Kinh doanh, kiếm tiền"
    static let signIn                       = "Đăng nhập hoặc Tạo tài khoản"
    static let pleaseSignInNeed             = "Vui lòng đăng nhập để sử dụng tính năng này"
    static let signInNow                    = "Đăng nhập ngay"
    static let signInUserNamePlaceHolder    = "Điện thoại"
    static let password                     = "Mật khẩu"
    static let confirmPassword              = "Nhập lại mật khẩu"
    static let forgotPassword               = "Quên mật khẩu"
    static let signUpAccount                = "Đăng ký tài khoản"
    static let tokenFailMessage             = "Phiên làm việc hết hạn. Bạn vui lòng đăng nhập lại!"
    
    // SignUp
    static let createNewAccount             = "Tạo tài khoản mới"
    static let freePolicy                   = "Miễn phí và sẽ luôn như vậy"
    static let firstName                    = "Họ"
    static let lastName                     = "Tên"
    static let dateOfBirth                  = "Ngày sinh"
    static let createAccount                = "Tạo tài khoản"
    static let existEmail                   = "Email đã đăng kí. Vui lòng quay Đăng nhập hoặc Quên mật khẩu"
    static let existPhoneNumber             = "Số điện thoại đã đăng kí. Vui lòng quay Đăng nhập hoặc Quên mật khẩu"
    static let signUpEmailSuccessMessage    = "Tạo tài khoản thành công. Kiểm tra Email và xác thực tài khoản để bắt đầu sử dụng ứng dụng"
    
    static let signUpPhoneSuccessMessage    = "Tạo tài khoản thành công. Bắt đầu kích hoạt mã xác nhận"
    
    static let pwNotEnoughLength            = "Mật khẩu phải dài hơn \(AppConfig.minPasswordLenght) kí tự"
    
    // ForgotPassword
    static let resetPWTitle                 = "Quên mật khẩu"
    static let weWillSendCodeToEmail        = "Vui lòng cung cấp số điện thoại đăng nhập để lấy lại mật khẩu"
    static let weWillSendCodeToPhone        = "Vui lòng cung cấp số điện thoại để xác thực"

    static let next                         = "Tiếp tục"
    static let continuePassword             = "Tiếp tục nhập với mật khẩu mới"
    
    static let sendCodeRecoverPWInSMS       = "Chúng tôi đã gửi cho bạn mã code qua tin nhắn, hãy check tin nhắn bạn nhé! \n\n Vui lòng nhập code để khôi phục lại mật khẩu của bạn"
    
    static let sendCodeActiveAccInSMS       = "Chúng tôi đã gửi cho bạn mã code qua tin nhắn, hãy check tin nhắn bạn nhé! \n\n Vui lòng nhập code để kích hoạt tài khoản của bạn"
    
    static let defaultSendCodeMessage       = "Chúng tôi đã gửi cho bạn mã code qua tin nhắn, hãy check tin nhắn bạn nhé!"
    
    static let yourCode                     = "Mã code"
    
    static let resetPWSuccessMessage        = "Xin chúc mừng bạn! Bạn đã lấy lại mật khẩu thành công! Bạn vui lòng đăng nhập để tiếp tục khám phá! Xin cảm ơn!"
    static let updatePWSuccessMessage       = "Cập nhập mật khẩu thành công tiếp tục mua sắm!"
    static let oneStepToResetPW             = "Còn bước nữa là bạn có thể lấy lại được mật khẩu của mình!\n Vui lòng nhập mật khẩu mới của bạn tại đây"
    
    static let confirmPW                    = "Nhập lại mật khẩu"
    static let passwordNotMatch             = "Mật khẩu phải giống nhau!"
    static let invalidEmail                 = "Email không hợp lệ. Bạn vui lòng kiểm tra lại!"
    static let invalidPhone                 = "Số điện thoại không hợp lệ. Bạn vui lòng kiểm tra lại!"
    static let invalidCode                  = "Code không hợp lệ. Bạn vui lòng kiểm tra lại!"
    static let youNotHaveAccount            = "BẠN KHÔNG CÓ TÀI KHOẢN?"
    static let resendCodeAgain              = "Bạn không nhận được mã code?"
    static let againCode                    = "Thử lại"
    static let gotoSignInPage               = "VỀ TRANG ĐĂNG NHẬP"
    static let signUp                       = "Đăng ký"
    static let verifyCode                   = "Xác thực tài khoản"
    static let activeAccSuccess             = "Kích hoạt tài khoản thành công"
    static let createNewPW                  = "Tạo mật khẩu mới"
    static let backToHome                   = "Quay về trang chủ"
    static let locationRecive               = "Khu vực nhận hàng"
    
    // MARK: - User Profile
    
    static let userProfile                  = "Thông tin cá nhân"
    static let welcome                      = "Chào mừng bạn đến với HiShop"
    static let welcomeSignInUp              = "Đăng nhập/Đăng ký"
    
    static let welcomeSignIn                = "Xin chào,"
    static let continueSignIn               = "Tiếp tục"
    static let titlePassword                = "Mật khẩu"
    static let inputPassword                = "Nhập mật khẩu"
    static let beginPassword                = "Lấy lại mật khẩu"
    static let updateNewPassword            = "Cập nhập mật khẩu mới"
    static let pleaseInputPW                = "Vui lòng nhập mật khẩu HiShop của số điện thoại "
    static let signInAccount                = "Đăng nhập"
    static let continueRules                = "Bằng việc tiếp tục, bạn đã chấp nhận điều khoản sử dụng"
    static let optionSignIn                 = "Hoặc tiếp tục bằng"
    static let seeShop                      = "Xem shop"
    static let followShop                   = "Theo dõi Shop"
    static let detailProduct                = "Thông tin chi tiết"
    static let refundMoney                  = "RẺ HƠN HOÀN TIỀN"
    static let changeAction                 = "Thay đổi"
    static let addressRecive                = "Địa chỉ nhận hàng"
    static let addressOrder                 = "Địa chỉ người nhận"
    static let infoOrder                    = "Thông tin kiện hàng"
    static let paymentOrder                 = "Hình thức thanh toán"
    static let transportOrder               = "Hình thức giao hàng"
    static let updateRecive                 = "Cập nhập địa chỉ"
    static let update                       = "Cập nhập"
    static let processOrder                 = "Tiến hành đặt hàng"
    static let shipAddress                  = "Giao đến địa chỉ này"
    static let selectShipAddress            = "Chọn địa chỉ giao hàng"
    static let changePassword               = "Đổi mật khẩu"
    static let notSpecify                   = "Khác"
    static let searchTitle2                 = "Sản phẩm và thương hiệu mọi thứ bạn cần"
    static let myCategory                   = "Danh mục cho bạn"
    
    static let infoPayment                  = "Thông tin thanh toán"
    static let bought                       = "Đã mua"
    static let loved                        = "Yêu thích"
    static let waitReview                   = "Chờ đánh giá"
    static let haveReview                   = "Đã đánh giá"
    static let myOrdered                    = "Đơn hàng của tôi"
    
}

extension TextManager {
    static let allOrder                     = "Tất cả đơn"
    static let waitOrder                    = "Chờ thanh toán"
    static let processing                   = "Đang xử lý"
    static let transported                  = "Đang vận chuyển"
    static let recivedSuccess               = "Đã giao"
    static let cancelOrder                  = "Đã huỷ"
    static let infoGuarantee                = "Thông tin bảo hành"
    static let getPhotoLibrary              = "Chọn ảnh từ thư viện"
    static let camera                       = "Máy ảnh"
    static let changePhoto                  = "Thay đổi ảnh"
    static let logOut                       = "Đăng xuất"
    static let myStall                      = "Gian hàng của bạn"
    static let orderSetting                 = "Đơn hàng"
    static let statusLogOut                 = "Bạn có chắc chắn muốn đăng xuất?"
    static let paymentForm                  = "Hình thức thanh toán"
    static let orderAgain                   = "Mua lại"
    static let statusDelete                 = "Bạn có chắc chắn xoá địa chỉ?"
    static let emptyReview                  = "Chưa có đánh giá nào"
    static let emptyOrder                   = "Bạn chưa có đơn hàng nào"
}

// MAR: - Rating

extension TextManager {
    static let displeasure                  = "Rất không hài lòng"
    static let bad                          = "Không hài lòng"
    static let normal                       = "Bình thường"
    static let good                         = "Hài lòng"
    static let extremely                    = "Cực kì hài lòng"
    static let writeReview                  = "Viết đánh giá"
    static let yourProblem                  = "Vấn đề bạn gặp là gì"
    static let hi_shop                      = "Hi-Shop"
}
