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

        v.size = CGSize(width: 44, height: 44)
        v.origin = CGPoint(x: 100, y: 100)

        v.roundedCorners(cornerRadius: 22, rectCorner: UIRectCorner([.bottomLeft, .topRight]))


        v.backgroundColor = UIColor.rgba(red: 255, green: 0, blue: 255, alpha: 1)
        v.backgroundColor = UIColor.randomColor()

        self.view.gradientColor(colors: [UIColor.hex(hex: 0xBDFCC9).cgColor, UIColor.hex(hex: 0x32CD31).cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0.3, y: 0.3), endPoint: CGPoint(x: 0.7, y: 0.7))

        let blurView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        blurView.roundedCorners(cornerRadius: 15)
        blurView.center = view.center
        view.addSubview(blurView)
        
        let asd = UIButton(type: UIButton.ButtonType.roundedRect)
        asd.setTitle("123", for: UIControl.State.normal)
        asd.setTitleColor(UIColor.hex(hex: 0xDA6FD6), for: UIControl.State.normal)
        asd.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        asd.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        blurView.addSubview(asd)
        
        blurView.addBlurEffect(style: UIBlurEffect.Style.extraLight)

        
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
            button?.setTitle(date, for: UIControl.State.normal)
        }
        //        picker.isAllowSelectTime = false
        picker.show()
    }
    @IBAction func showQDatePickerBtn(_ sender: Any) {
        let button = sender as? UIButton
        let picker = QDatePicker { (date: String) in
            print(date)
            button?.setTitle(date, for: UIControl.State.normal)
        }
//        picker.datePickerStyle = .MDHM
//        picker.themeColor = .red
//        picker.pickerStyle = .singlePicker
//        picker.animationStyle = .styleOptional
//        picker.singlePickerDatas = ["小新", "小徹", "阿呆", "正男", "妮妮", "小白", "娜娜子®"]
        picker.show()
    }

}
