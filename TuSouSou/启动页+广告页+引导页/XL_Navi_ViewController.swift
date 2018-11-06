//
//  XL_Navi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//
//导航页
import UIKit

class XL_Navi_ViewController: UINavigationController,UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("已经到了导航页")
    }
    /*
        重写 PushView
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        addBackButton(viewController: viewController)
        super.pushViewController(viewController, animated: animated)
    }

    //返回按钮、只留图标不要文字
    func addBackButton(viewController: UIViewController) {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
