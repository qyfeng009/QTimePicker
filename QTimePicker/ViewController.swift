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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


    @IBAction func showBtn(_ sender: Any) {
        let button = sender as! UIButton
        let picker = QTimePicker { (date: String) in
            print(date)
            button.setTitle(date, for: UIControlState.normal)
        }
        picker.isAllowSelectTime = false
        picker.show()

    }
}

