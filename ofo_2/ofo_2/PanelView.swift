//
//  PanelView.swift
//  ofo_2
//
//  Created by lym on 2017/12/25.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

import UIKit
import SnapKit
//import RxCocoa
//import RxSwift


let buttonWH = 60
let sPointY = 80


class PanelView: UIView {
    
    let scanButton = UIButton()
    let userButton = UIButton()
    let tipsButton = UIButton()
    let closeButton = UIButton()
    let arrowButton = UIButton()
    
    var isOpen = true
//    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupSubViews()
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let size = rect.size
        
        // 画圆弧
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint(x: 0, y: sPointY))
        maskPath.addLine(to: CGPoint(x: 0, y: size.height))
        maskPath.addLine(to: CGPoint(x: size.width, y: size.height))
        maskPath.addLine(to: CGPoint(x: size.width, y: 80))
        maskPath.addQuadCurve(to: CGPoint(x: 0, y: sPointY), controlPoint: CGPoint(x: size.width / 2, y: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.shadowOpacity = 0.5
        maskLayer.shadowColor = UIColor.black.cgColor
        layer.mask = maskLayer
    }
    
    private func setupSubViews()  {
        
        backgroundColor = UIColor.white
        
        scanButton.setBackgroundImage(#imageLiteral(resourceName: "start_button_bg_scan"), for: .normal)
        addSubview(scanButton)
        
        scanButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(30)
        }
        
        userButton.setImage(#imageLiteral(resourceName: "user_center_icon"), for: .normal)
        addSubview(userButton)
        
        userButton.snp.makeConstraints { (make) in
            make.bottomMargin.equalToSuperview()
            make.leftMargin.equalToSuperview()
            make.size.equalTo(CGSize(width: buttonWH, height: buttonWH))
        }
        
        tipsButton.setImage(#imageLiteral(resourceName: "gift_icon"), for: .normal)
        addSubview(tipsButton)
        
        tipsButton.snp.makeConstraints { (make) in
            make.bottomMargin.equalToSuperview()
            make.rightMargin.equalToSuperview()
            make.size.equalTo(CGSize(width: buttonWH, height: buttonWH))
        }
        
        /// 按钮
        arrowButton.setImage(#imageLiteral(resourceName: "arrowdown"), for: .normal)
        addSubview(arrowButton)
        arrowButton.addTarget(self,action: .arrowAction,for:.touchUpInside)
//        arrowButton.rx.tap.subscribe(onNext: { (sender) in
//            self.movePanelView()
//        }).disposed(by: disposeBag)
//
        arrowButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.size.equalTo(CGSize(width: buttonWH, height: buttonWH))
        }

        /// 手势
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: .dragAction)
        addGestureRecognizer(pan)
        
        
    }
    
    @objc func arrowAction () {
        movePanelView()
    }

    @objc func dragAction (pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .ended: 
            let translate = pan.translation(in: self)
            
            if translate.y != 0 {
                movePanelView()
            }
            break
        default: break
        }
    }
    
    func movePanelView() -> Void {
        let transformH = frame.height / 1.5
        
        if isOpen {
            arrowButton.setImage(#imageLiteral(resourceName: "arrowup"), for: .normal)
            self.scanButton.snp.updateConstraints({ (make) in
                make.centerY.equalToSuperview().offset(50)
            })
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.transform = CGAffineTransform(translationX: 0, y: transformH)
            })
            
        } else {
            arrowButton.setImage(#imageLiteral(resourceName: "arrowdown"), for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.transform = .identity
                self.scanButton.snp.updateConstraints({ (make) in
                    make.centerY.equalToSuperview().offset(30)
                })
            })
        }
        
        isOpen = !isOpen
        
        /// 发送额外数据
        let info = ["minY": frame.minY]
        NotificationCenter.default.post(name: Notification.Name.init("panelViewOpenOrClose"), object: nil, userInfo: info)
        
    }
    
}

// MARK: - extension
/*
 通过extension Selector可以写的更加优雅。
 private extension Selector {
 static let btnTapped = #selector(DemoView.btnTapped)
 }
 */
private extension Selector {
    static let dragAction = #selector(PanelView.dragAction(pan:))
    static let arrowAction = #selector(PanelView.arrowAction)
}

/*
 Selector是runtime延迟动态绑定，
 #selector语法糖里面只是为了compiler（编译器）帮助检查prototype正确性
 所以即使写成 class.action，也只是告诉compiler这个原型参考函数，
 而并非Selector在runtime时真正选取的函数。
 
 因为函数选取是在Obj-C名字空间里做，所以需要用@objc修饰需要暴露给Obj-C的函数。
 
 addTarget的第一个参数是Obj-C消息机制的receiver(接受者)对象，
 把selector选取的函数发送给对象，其实就是“对象的方法调用”。
 
 self也是运行时选取，所以才会出现神奇的现象，即调用了DemoViewController而不是DemoView的btnTapped函数。
 
 也因此，如果把上面错误写法中的btn.addTarget(self改为btn.addTarget(class.action，
 即强行要求调用DemoView对象（instance of the class）的函数，运行时点击按钮就会得到错误，
 unrecognized selector +[DemoView btnTapped:]。
 
 BTW，可以看到，因为swift的lazy initialization特性，所以实现singleton异常简单。

 */
