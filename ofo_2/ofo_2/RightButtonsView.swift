//
//  RightButtonsView.swift
//  ofo_2
//
//  Created by lym on 2017/12/27.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

import UIKit

class RightButtonsView: UIView {
    
    var loctionBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSubviews() -> Void {
        
        let btnWH = 44
        let margin: CGFloat = 15
        
        let serviceBtnFrame = CGRect(x: 0, y: 0, width: btnWH, height: btnWH)
        let serviceBtn = creatButton(frame: serviceBtnFrame, image: #imageLiteral(resourceName: "rightBottomImage"))
        addSubview(serviceBtn)
        
        let loctionBtnFrame = CGRect(x: 0, y: Int(serviceBtn.frame.maxY + margin), width: btnWH, height: btnWH)
        loctionBtn = creatButton(frame: loctionBtnFrame, image: #imageLiteral(resourceName: "leftBottomImage"))
        addSubview(loctionBtn)
        
        
        NotificationCenter.default.addObserver(self, selector: .panelViewMove, name: NSNotification.Name(rawValue: "panelViewOpenOrClose"), object: nil)
        
    }
    
    private func creatButton(frame: CGRect, image: UIImage) -> UIButton {
        let serviceBtn = UIButton(frame: frame)
        serviceBtn.setImage(image, for: .normal)
        serviceBtn.layer.shadowOpacity = 0.4
        serviceBtn.layer.shadowRadius = 3
        serviceBtn.layer.shadowColor = UIColor.lightGray.cgColor
        serviceBtn.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        return serviceBtn
    }
    
    
    @objc func panelViewMove (notofication: Notification) {

        let minY = notofication.userInfo!["minY"] as! CGFloat
        print(minY)
      
        let margin: CGFloat = 80
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.frame.origin.y = minY - margin
        })
    }
    
    /// 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


private extension Selector {
    static let panelViewMove = #selector(RightButtonsView.panelViewMove(notofication:))
}
