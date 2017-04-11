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

class AuthorizationManagerConfiguration {
    var title: String = ""
    var message: String = ""
    var presentingViewController: UIViewController?
}


class AuthorizationManager {
    static var configuration = AuthorizationManagerConfiguration()
    
    class func configure(configure: (AuthorizationManagerConfiguration)->()) -> AuthorizationManager.Type {
        configure(configuration)
        return self
    }
    
    /// 获取视频权限, 授权成功回调
    ///
    /// - Parameter finish: 成功回调
    class func authorizedVideo(finish: @escaping () -> ()) {
        defaultAuthorized(mediaType: .video, finish: finish)
    }
    
    /// 获取音频权限, 授权成功回调
    ///
    /// - Parameter finish: 成功回调
    class func authorizedAudio(finish: @escaping () -> ()) {
        defaultAuthorized(mediaType: .audio, finish: finish)
    }
    
    /// 获取视频和音频权限, 授权成功回调
    ///
    /// - Parameter finish: 成功回调
    class func authorizedVideoAndAudio(finish: @escaping () -> ()) {
        authorizedVideo {
            authorizedAudio(finish: finish)
        }
    }
    
    /// 获取通讯录权限, 授权成功回调
    ///
    /// - Parameter finish: 成功回调
    class func authorizedContacts(finish: @escaping () -> ()) {
        authorizedAddressBook(finish: finish)
    }
}


// MARK: - 通讯录授权私有方法
extension AuthorizationManager {
    fileprivate class func authorizedAddressBook(finish: @escaping () -> ()) {
        if #available(iOS 9.0, *) {
            let entityType = CNEntityType.contacts
            let status = CNContactStore.authorizationStatus(for: entityType)
            switch status {
            case .notDetermined:
                let store = CNContactStore()
                store.requestAccess(for: entityType, completionHandler: { (granted, error) in
                    if granted {
                        // 这个回调是子线程
                        DispatchQueue.main.async {
                            finish()
                        }
                    } else {
                        print("授权失败")
                        print(error ?? "授权失败的错误为空")
                    }
                })
            case .authorized:
                DispatchQueue.main.async {
                    finish()
                }
            case .restricted, .denied:
                setDefaultAlertController()
            }
        } else {
            let status = ABAddressBookGetAuthorizationStatus()
            switch status {
            case .notDetermined:
                let addressBook = ABAddressBookCreate().takeUnretainedValue()
                ABAddressBookRequestAccessWithCompletion(addressBook, { (granted, error) in
                    if granted {
                        DispatchQueue.main.async {
                            finish()
                        }
                    } else {
                        print("授权失败")
                        print(error ?? "授权失败的错误为空")
                    }
                })
            case .authorized:
                DispatchQueue.main.async {
                    finish()
                }
            case .restricted, .denied:
                setDefaultAlertController()
            }
        }
    }
}

// MARK: - 音视频授权私有方法
extension AuthorizationManager {
    fileprivate class func defaultAuthorized(mediaType: FDMediaType, finish: @escaping () -> ()) {
        authorizationStatus(forMediaType: mediaType) { (status) in
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(forMediaType: mediaType.rawValue, completionHandler: { (granted) in
                    if granted {
                        DispatchQueue.main.async {
                            finish()
                        }
                    } else {
                        print("授权失败  \(FDMediaType.video.rawValue)")
                    }
                })
            case .authorized:
                DispatchQueue.main.async {
                    finish()
                }
            case .denied, .restricted:
                setDefaultAlertController()
            }
        }
    }
    
    fileprivate class func setDefaultAlertController() {
        let alertController = UIAlertController(title: configuration.title, message: configuration.message, preferredStyle: UIAlertControllerStyle.alert)
        let action0 = UIAlertAction(title: "设置", style: UIAlertActionStyle.default, handler: { (action) in
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
                print("UIApplicationOpenSettingsURLString 有可能被废弃了")
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
