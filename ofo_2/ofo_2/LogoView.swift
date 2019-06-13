//
//  LogoView.swift
//  ofo_2
//
//  Created by lym on 2017/12/27.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

import UIKit

class LogoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupSubViews(frame: CGRect )  {
        
        let imageView = UIImageView(frame: bounds)
        imageView.image = #imageLiteral(resourceName: "whiteImage")
        addSubview(imageView)
        
        let msgBtn = UIButton()
        msgBtn.setImage(#imageLiteral(resourceName: "bluebar_unfold"), for: .normal)
        addSubview(msgBtn)
        
        msgBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.rightMargin.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Login_Logo"))
        addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { (make) in
            make.leftMargin.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
