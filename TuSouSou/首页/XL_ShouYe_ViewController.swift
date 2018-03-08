//
//  XL_ShouYe_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_ShouYe_ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    @IBAction func zuoanniu(_ sender: UIBarButtonItem) {
        XL_DrawerViewController.shareDrawer?.openLeftMenu()
    }
  
    @IBAction func you(_ sender: Any) {
        
    }
    var window: UIWindow?
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    // popoverPresentControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
