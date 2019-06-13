//
//  Extension.swift
//  ofo_demo
//
//  Created by lym on 2017/7/9.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

extension UIColor {
    static var mainColor: UIColor {
        return UIColor(red: 247/255, green: 215/255, blue: 80/255, alpha: 1)
    }
}


import AVFoundation


// MARK: 手电筒功能
func turnTorch()  {
    guard let device = AVCaptureDevice.default(for: .video) else {
        return;
    }
        
    if device.hasTorch && device.isTorchAvailable {
        try?device.lockForConfiguration()
        if device.torchMode == .off {
            device.torchMode = .on
        } else {
            device.torchMode = .off
        }
        device.unlockForConfiguration()
    }
}
