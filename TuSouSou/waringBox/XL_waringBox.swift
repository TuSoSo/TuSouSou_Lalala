//
//  XL_waringBox.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/4/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_waringBox: UIView {
   ///2s后消失的文字提示框
    func warningBoxModeText(message: String, view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.show(animated: true)
        hud.mode = .text
        hud.label.text = message
        hud.label.font = UIFont.systemFont(ofSize: 12)
        hud.offset.y = 160
        hud.isUserInteractionEnabled = false
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 2)
        
    }
    ///网络加载的转圈提示框
    func warningBoxModeIndeterminate(message: String, view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.show(animated: true)
        hud.mode = .indeterminate
        hud.label.text = message
        hud.label.font = UIFont.systemFont(ofSize: 12)
        hud.removeFromSuperViewOnHide = true
    }
    ///隐藏显示的提示框
    func warningBoxModeHide(isHide: Bool, view: UIView) {
        MBProgressHUD.hide(for: view, animated: isHide)
    }
    
    
    
}
