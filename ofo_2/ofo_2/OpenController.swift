//
//  OpenController.swift
//  ofo_demo
//
//  Created by lym on 2017/7/6.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

import UIKit

class OpenController: UIViewController {
    
    var code = 0
    var passCode = 0
    
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var voiceBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.mainColor.cgColor
        textField.backgroundColor = UIColor.white
        
        // 设置阴影
        topView.layer.shadowOffset = CGSize(width: 0, height: 0)
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 3
        
        // 当发现设置后无效 一定要关闭clipsToBounds
        topView.clipsToBounds = false

        
    }
    
    
    @IBAction func clickFlashBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
    }

    @IBAction func clickVoiceBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func scanBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    
}
