//
//  Extension_UIDevice.swift
//  QTimePicker
//
//  Created by ifeng on 2019/5/28.
//

import Foundation
import UIKit

extension UIDevice {
    /// 判断机型是 iPhoneX/iPhoneXR/iPhoneXS/iPhoneXSMax
    ///
    /// - Returns: true: X系列；false 其他
    class func isXSeries() -> Bool {
        if UIApplication.shared.statusBarFrame.size.height >= 44
            && (UIScreen.main.bounds.size.height == 812.0
                || UIScreen.main.bounds.size.height == 896.0) {
            return true
        } else {
            return false
        }
    }
}
