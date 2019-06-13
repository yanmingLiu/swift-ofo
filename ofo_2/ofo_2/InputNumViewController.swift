//
//  InputNumViewController.swift
//  ofo_demo
//
//  Created by lym on 2017/7/15.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

import UIKit
import SwiftyTimer
import SwiftySound    

class InputNumViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    var remindSeconds = 21
    
    var isTorchOn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 倒计时
        Timer.every(1) { (timer:Timer) in
            
            self.remindSeconds -= 1
            
            self.timerLabel.text = self.remindSeconds.description
            
            if self.remindSeconds == 0 {
                timer.invalidate()
            }
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: 打开闪光灯
    @IBAction func torchBtn(_ sender: UIButton) {
        
        turnTorch()
        
        isTorchOn = !isTorchOn;
    }
    
    // MARK: 声音播放
    @IBAction func palyVoice(_ sender: Any) {
        Sound.play(file: "您的解锁码为_D.m4a")
        
    }
}
