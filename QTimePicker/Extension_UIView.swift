//
//  Extension_UIView.swift
//  QTimePicker
//
//  Created by 009 on 2017/12/12.
//

import Foundation
import UIKit

extension UIView {

    // MARK: - UIView 坐标属性
    /// x 轴坐标
    var x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }

    /// y 轴坐标
    var y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }

    /// 中心点 x 轴坐标
    var centerX: CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }

    /// 中心点 y 轴坐标
    var centerY: CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get {
            return self.center.y
        }
    }

    /// view 宽度
    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }

    /// view 高度
    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }

    /// view Size 尺寸
    var size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }

    /// view 坐标
    var origin: CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }

    /// view 底部 y 轴坐标
    var bottomY: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get {
            return self.height + self.y
        }
    }

    /// view 右边 X 轴坐标
    var rightX: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get {
            return self.width + self.x
        }
    }

    // MARK: - UIView 圆角
    /// 切圆角
    ///
    /// - Parameter cornerRadius: 圆角半径
    func roundedCorners(cornerRadius: CGFloat) {
        roundedCorners(cornerRadius: cornerRadius, borderWidth: 0, borderColor: nil)
    }

    /// 圆角边框设置
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - borderWidth: 边款宽度
    ///   - borderColor: 边款颜色
    func roundedCorners(cornerRadius: CGFloat?, borderWidth: CGFloat?, borderColor: UIColor?) {
        self.layer.cornerRadius = cornerRadius!
        self.layer.borderWidth = borderWidth!
        self.layer.borderColor = borderColor?.cgColor
        self.layer.masksToBounds = true
    }

    /// 设置指定角的圆角
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - rectCorner: 指定切圆角的角
    func roundedCorners(cornerRadius: CGFloat?, rectCorner: UIRectCorner?) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner!, cornerRadii: CGSize(width: cornerRadius!, height: cornerRadius!))
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path.cgPath
        self.layer.mask = layer
    }

    // MARK: - UIView 渐变色
    /// 渐变色
    ///
    /// - Parameters:
    ///   - colors: 渐变的颜色
    ///   - locations: 每个颜色所在的位置(0为开始位...1为结束位)
    ///   - startPoint: 开始坐标[0...1]
    ///   - endPoint: 结束坐标[0...1]
    func gradientColor(colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        /*
         表示竖向渐变
         gradientLayer.startPoint = CGPoint(x: 0, y: 0)
         gradientLayer.endPoint = CGPoint(x: 0, y: 1)
         */
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - UIView 模糊效果
    /// view 添加模糊效果
    ///
    /// - Parameter style: UIBlurEffectStyle
    func addBlurEffect(style: UIBlurEffect.Style) {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = self.bounds
        self.backgroundColor = .clear
        self.addSubview(effectView)
        self.sendSubviewToBack(effectView)
    }
}
