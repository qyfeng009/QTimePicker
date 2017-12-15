//
//  ViewController.swift
//  QTimePicker
//
//  Created by 009 on 2017/12/1.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.backgroundColor = .red
        self.view.addSubview(v)

//        print(v.size)
//        print(v.origin)
        v.size = CGSize(width: 44, height: 44)
        v.origin = CGPoint(x: 100, y: 100)

        v.roundedCorners(cornerRadius: 22, rectCorner: UIRectCorner([.bottomLeft, .topRight]))

//        let s = "123456"
//        print(s.sliceString(2...4))

//        v.backgroundColor = UIColor.hex(hex: "#ff4081")
//        v.backgroundColor = UIColor.hex(hex: "#00B3C4")
//        print(v.backgroundColor?.hex as Any)
        v.backgroundColor = UIColor.rgba(red: 255, green: 0, blue: 255, alpha: 1)
//        print(v.backgroundColor?.rgba as Any)
        v.backgroundColor = UIColor.randomColor()

        self.view.gradientColor(colors: [UIColor.red.cgColor, UIColor.yellow.cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0.3, y: 0.3), endPoint: CGPoint(x: 0.7, y: 0.7))

        let blurView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        blurView.roundedCorners(cornerRadius: 15)
        blurView.center = view.center
        view.addSubview(blurView)
        let asd = UIButton(type: UIButtonType.roundedRect)
        asd.setTitle("123", for: UIControlState.normal)
        asd.setTitleColor(.black, for: UIControlState.normal)
        asd.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        blurView.addSubview(asd)

        blurView.addBlurEffect(style: UIBlurEffectStyle.extraLight)

        print(Date().lastMonth)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


    @IBAction func showBtn(_ sender: Any) {
        let button = sender as? UIButton
        let picker = QCalendarPicker { (date: String) in
            print(date)
            button?.setTitle(date, for: UIControlState.normal)
        }
        //        picker.isAllowSelectTime = false
        picker.show()
    }
    @IBAction func showQDatePickerBtn(_ sender: Any) {
        let button = sender as? UIButton
        let picker = QDatePicker { (date: String) in
            print(date)
            button?.setTitle(date, for: UIControlState.normal)
        }
//        picker.datePickerStyle = .MDHM
//        picker.themeColor = .red
//        picker.pickerStyle = .singlePicker
//        picker.animationStyle = .styleOptional
//        picker.singlePickerDatas = ["小新", "小徹", "阿呆", "正男", "妮妮", "小白", "娜娜子®"]
        picker.show()
    }

}



