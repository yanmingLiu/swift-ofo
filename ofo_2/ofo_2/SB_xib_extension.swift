//
//  SB_xib_extension.swift
//  ofo_demo
//
//  Created by lym on 2017/7/9.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

/// sb xib上直接设置layer

extension UIView {
    
   @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderColor1: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
}

@IBDesignable class DesignableLabel : UILabel {
    
}








