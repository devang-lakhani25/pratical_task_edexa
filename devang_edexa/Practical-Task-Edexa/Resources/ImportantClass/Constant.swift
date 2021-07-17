//
//  Constant.swift
//  Practical-Task-Edexa
//
//  Created by Devang Lakhani  on 7/17/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

/*---------------------------------------------------
Screen Size
---------------------------------------------------*/
let _screenSize     = UIScreen.main.bounds.size
let _screenFrame    = UIScreen.main.bounds

/*---------------------------------------------------
 Constants
 ---------------------------------------------------*/
let _defaultCenter  = NotificationCenter.default
let _userDefault    = UserDefaults.standard
let _application    = UIApplication.shared
let _appDelegator   = _application.delegate! as! AppDelegate
let _bundleID = Bundle.main.bundleIdentifier
let _deviceId = UIDevice.current.identifierForVendor!.uuidString
let _deviceName = UIDevice.current.systemName
let _deviceInternalMemory = Double(Double((ProcessInfo.processInfo.physicalMemory)) / (1024.0 * 1024.0 * 1024.0))
let _deviceInternetSpeed = ""
let _deviceBattery = UIDevice.current.batteryState
let _deviceVersion = UIDevice.current.systemVersion
let _deviceModel = UIDevice.current.model
let _bottomAreaSpacing         : CGFloat = _appDelegator.window!.rootViewController!.bottomLayoutGuide.length

/*---------------------------------------------------
 Device Extention
 ---------------------------------------------------*/
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}


var _statusBarHeight: CGFloat = {
    if #available(iOS 11.0, *) {
        if UIDevice.current.hasNotch {
            return _appDelegator.window!.safeAreaInsets.top
        } else {
            return 20
        }
    } else {
        return 20
    }
}()


var _bottomBarHeight: CGFloat = {
    if #available(iOS 11.0, *) {
        if UIDevice.current.hasNotch {
            return _appDelegator.window!.safeAreaInsets.bottom
        } else {
            return 0
        }
    } else {
        return 0
    }
}()

let _navigationHeight          : CGFloat = _statusBarHeight + 44
let _vcTransitionTime                    = 0.3
let _imageFadeTransitionTime   : Double  = 0.3

/*---------------------------------------------------
 Custom print
 ---------------------------------------------------*/
func kprint(items: Any...) {
    #if DEBUG
        for item in items {
            print(item)
        }
    #endif
}

/*---------------------------------------------------
 Ratio
 ---------------------------------------------------*/
let _heightRatio : CGFloat = {
    let ratio = _screenSize.height/812
    return ratio
}()

let _widthRatio : CGFloat = {
    let ratio = _screenSize.width/375
    return ratio
}()


extension CGFloat {

    var widthRatio: CGFloat{
        return self * _widthRatio
    }

    var heightRatio: CGFloat{
        return self * _heightRatio
    }
}

extension Int {
    
    var widthRatio: CGFloat{
        return CGFloat(self) * _widthRatio
    }
    
    var heightRatio: CGFloat{
        return CGFloat(self) * _heightRatio
    }
}

extension Float {
    
    var widthRatio: CGFloat{
        return CGFloat(self) * _widthRatio
    }
    
    var heightRatio: CGFloat{
        return CGFloat(self) * _heightRatio
    }
}

extension Double {
    
    var widthRatio: CGFloat{
        return CGFloat(self) * _widthRatio
    }
    
    var heightRatio: CGFloat{
        return CGFloat(self) * _heightRatio
    }
}

