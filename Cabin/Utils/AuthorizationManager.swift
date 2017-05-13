//
//  AuthorizationManager.swift
//  Cabin
//
//  Created by QianTuFD on 2017/4/10.
//  Copyright © 2017年 fandy. All rights reserved.
//  授权管理者

import UIKit
import AVFoundation
import Contacts
import AddressBook
import Photos

/*
 @available(iOS 4.0, *)
 public let AVMediaTypeVideo: String
 @available(iOS 4.0, *)
 public let AVMediaTypeAudio: String
 @available(iOS 4.0, *)
 public let AVMediaTypeText: String
 @available(iOS 4.0, *)
 public let AVMediaTypeClosedCaption: String
 @available(iOS 4.0, *)
 public let AVMediaTypeSubtitle: String
 @available(iOS 4.0, *)
 public let AVMediaTypeTimecode: String
 @available(iOS 6.0, *)
 public let AVMediaTypeMetadata: String
 @available(iOS 4.0, *)
 public let AVMediaTypeMuxed: String
 */


enum FDMediaType {
    case video  // AVMediaTypeVideo
    case audio  // AVMediaTypeAudio
    case text  // AVMediaTypeText
    case closedCaption  // AVMediaTypeClosedCaption
    case subtitle  // AVMediaTypeSubtitle
    case timecode  // AVMediaTypeTimecode
    case metadata  // AVMediaTypeMetadata
    case muxed  // AVMediaTypeMuxed
    
    var rawValue: String {
        get {
            switch self {
            case .video:
                return AVMediaTypeVideo
            case .audio:
                return AVMediaTypeAudio
            case .text:
                return AVMediaTypeText
            case .closedCaption:
                return AVMediaTypeClosedCaption
            case .subtitle:
                return AVMediaTypeSubtitle
            case .timecode:
                return AVMediaTypeTimecode
            case .metadata:
                return AVMediaTypeMetadata
            case .muxed:
                return AVMediaTypeMuxed
            }
        }
    }
}



/// 授权管理者数据配置
class AuthorizationManagerConfiguration {
    var title: String = ""
    var message: String = ""
    weak var presentingViewController: UIViewController?
}


class AuthorizationManager {
    static var configuration = AuthorizationManagerConfiguration()
    
    class func config(config: (AuthorizationManagerConfiguration)->()) -> AuthorizationManager.Type {
        config(configuration)
        return self
    }
    
    /// 获取相机权限, 授权成功回调
    ///
    /// - Parameter finish: 成功回调
    class func authorizedVideo(completion: @escaping AuthorizationCompletion) {
        defaultAuthorized(mediaType: .video, completion: completion)
    }
    
    /// 获取音频权限, 授权成功回调
    ///
    /// - Parameter finish: 成功回调
    class func authorizedAudio(completion: @escaping AuthorizationCompletion) {
        defaultAuthorized(mediaType: .audio, completion: completion)
    }
    
    /// 获取通讯录权限, 授权成功回调
    ///
    /// - Parameter finish: 成功回调
    class func authorizedContacts(completion: @escaping AuthorizationCompletion) {
        authorizedAddressBook(completion: completion)
    }
    
    class func authorizedPhotoLibrary(completion: @escaping AuthorizationCompletion) {
        authorizedPhoto(completion: completion)
    }
}


// MARK: - 相册授权私有方法
extension AuthorizationManager {
    fileprivate class func authorizedPhoto(completion: @escaping AuthorizationCompletion) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    if status == PHAuthorizationStatus.authorized {
                        completion(AuthorizationResult.success("notDetermined"))
                    } else {
                        let error = AuthorizationError.photo("...")
                        completion(AuthorizationResult.failure(error))
                    }
                }
            })
        case .authorized:
            DispatchQueue.main.async {
                completion(AuthorizationResult.success("authorized"))
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                setDefaultAlertController()
            }
        }
    }
}

// MARK: - 通讯录授权私有方法
extension AuthorizationManager {
    fileprivate class func authorizedAddressBook(completion: @escaping AuthorizationCompletion) {
        if #available(iOS 9.0, *) {
            let entityType = CNEntityType.contacts
            let status = CNContactStore.authorizationStatus(for: entityType)
            switch status {
            case .notDetermined:
                let store = CNContactStore()
                store.requestAccess(for: entityType, completionHandler: { (granted, error) in
                    // 这个回调是子线程
                    DispatchQueue.main.async {
                        if granted {
                            completion(AuthorizationResult.success("notDetermined"))
                        } else {
                            let message = error.debugDescription
                            let error = AuthorizationError.contacts(message)
                            completion(AuthorizationResult.failure(error))
                        }
                    }
                })
            case .authorized:
                DispatchQueue.main.async {
                    completion(AuthorizationResult.success("authorized"))
                }
            case .restricted, .denied:
                DispatchQueue.main.async {
                    setDefaultAlertController()
                }
            }
        } else {
            let status = ABAddressBookGetAuthorizationStatus()
            switch status {
            case .notDetermined:
                let addressBook = ABAddressBookCreate().takeUnretainedValue()
                ABAddressBookRequestAccessWithCompletion(addressBook, { (granted, error) in
                    DispatchQueue.main.async {
                        if granted {
                            DispatchQueue.main.async {
                                completion(AuthorizationResult.success("notDetermined"))
                            }
                        } else {
                            let message = error.debugDescription
                            let error = AuthorizationError.contacts(message)
                            completion(AuthorizationResult.failure(error))
                        }
                    }
                })
            case .authorized:
                DispatchQueue.main.async {
                    completion(AuthorizationResult.success("authorized"))
                }
            case .restricted, .denied:
                DispatchQueue.main.async {
                    setDefaultAlertController()
                }
            }
        }
    }
}


// MARK: - 音视频授权私有方法
fileprivate extension AuthorizationManager {
    class func defaultAuthorized(mediaType: FDMediaType, completion: @escaping AuthorizationCompletion) {
        authorizationStatus(forMediaType: mediaType) { (status) in
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(forMediaType: mediaType.rawValue, completionHandler: { (granted) in
                    DispatchQueue.main.async {
                        if granted {
                            completion(AuthorizationResult.success("notDetermined"))
                        } else {
                            var error = AuthorizationError.video("..")
                            if mediaType == FDMediaType.audio {
                                error = AuthorizationError.audio("..")
                            }
                            completion(AuthorizationResult.failure(error))
                        }
                    }
                })
            case .authorized:
                DispatchQueue.main.async {
                    completion(AuthorizationResult.success("authorized"))
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    setDefaultAlertController()
                }
            }
        }
    }
    
    
    
    fileprivate class func authorizationStatus(forMediaType mediaType: FDMediaType, finish: (AVAuthorizationStatus) -> ()) {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType.rawValue)
        switch authStatus {
        case .authorized:
            finish(.authorized)
        case .denied:
            finish(.denied)
        case .notDetermined:
            finish(.notDetermined)
        case .restricted:
            finish(.restricted)
        }
    }
}


// MARK: - 弹框
extension AuthorizationManager {
    /// 可以覆盖这个方法来实现拒绝情况, 如果拒绝没有要执行的,则覆盖写个空的
    class func setDefaultAlertController() {
        let alertController = UIAlertController(title: configuration.title, message: configuration.message, preferredStyle: UIAlertControllerStyle.alert)
        let action0 = UIAlertAction(title: "设置", style: UIAlertActionStyle.default, handler: { (action) in
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
                assertionFailure("UIApplicationOpenSettingsURLString 有可能被废弃了")
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: false], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        })
        let action1 = UIAlertAction(title: "好", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(action0)
        alertController.addAction(action1)
        
        assert(configuration.presentingViewController != nil, "请先调用 configure 进行配置再使用这个方法")
        configuration.presentingViewController?.present(alertController, animated: true, completion: {
            configuration.title = ""
            configuration.message = ""
            configuration.presentingViewController = nil
        })
    }
}


// MARK: - 授权结果处理
typealias AuthorizationCompletion = (_ result: AuthorizationResult<AuthorizationError>) -> Void

enum AuthorizationResult<Error: AuthorizationErrorProtocol>: CustomStringConvertible, CustomDebugStringConvertible {
    case success(String)
    case failure(Error)
    
    init(error: Error) {
        self = .failure(error)
    }
    
    func analysis<Result>(ifSuccess: (String) -> Result, ifFailure: (Error) -> Result) -> Result {
        switch self {
        case let .success(str):
            return ifSuccess(str)
        case let .failure(value):
            return ifFailure(value)
        }
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        return analysis(
            ifSuccess: { "Success \($0) " },
            ifFailure: { "Failure (\($0.description))" })
    }
    
    // MARK: CustomDebugStringConvertible
    public var debugDescription: String {
        return description
    }
}



protocol AuthorizationErrorProtocol: Swift.Error, CustomStringConvertible, CustomDebugStringConvertible {
    
}

enum AuthorizationError: AuthorizationErrorProtocol {
    case video(String)
    case audio(String)
    case contacts(String)
    case photo(String)
    
    func analysis<Error>(ifVideo: (String) -> Error, ifAudio: (String) -> Error, ifContacts: (String) -> Error, ifPhoto: (String) -> Error) -> Error {
        switch self {
        case let .video(str):
            return ifVideo(str)
        case let .audio(str):
            return ifAudio(str)
        case let .contacts(str):
            return ifContacts(str)
        case let .photo(str):
            return ifPhoto(str)
        }
        
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        return analysis(ifVideo: { "Video Denied \($0)"},
                        ifAudio: {"Audio Denied \($0)"},
                        ifContacts: {"Contacts Denied \($0)"},
                        ifPhoto:{"Photo Denied \($0)"}
        )
    }
    
    // MARK: CustomDebugStringConvertible
    public var debugDescription: String {
        return description
    }
}


