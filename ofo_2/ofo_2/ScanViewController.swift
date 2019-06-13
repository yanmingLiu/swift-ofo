//
//  ScanViewController.swift
//  ofo_demo
//
//  Created by lym on 2017/7/9.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

import UIKit
import swiftScan
import FTIndicator

class ScanViewController: LBXScanViewController {

    @IBOutlet var panelView: UIView!
    @IBOutlet weak var flashBtn: UIButton!
    var isFlash = false
    
    @IBAction func viewbringSubviewtoFrontpanelView(_ sender: UIButton) {
        isFlash = !isFlash
        sender.isSelected = !sender.isSelected
        
       scanObj?.changeTorch();
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.white

        var style  = LBXScanViewStyle()
        style.anmiationStyle = .NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_full_net.png")
        scanStyle = style
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: panelView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        if let result = arrayResult.first {
            let msg  = result.strScanned
            
            FTIndicator.setIndicatorStyle(.dark)
            FTIndicator.showSuccess(withMessage: msg)
            
        }
    }

}
