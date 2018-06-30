//
//  XL_DPCK_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_DPCK_ViewController: UIViewController {

    @IBOutlet weak var farensheng: UIImageView!
    @IBOutlet weak var yingyezhizhao: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "企业资质管理"
        jiekou()
        
        // Do any additional setup after loading the view.
    }

    func jiekou() {
        let method = "/merchant/information"
        let userId = userDefaults.value(forKey: "userId")
       
        let dic:[String:Any] = ["userId":userId!]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
               
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func zhaop(dic:[String:String]) {
        var jiee = ""
        if nil != dic["licensePic"]{
            jiee = dic["licensePic"]!
        }
        let uul = URL(string: TupianUrl + jiee)
        yingyezhizhao.sd_setImage(with: uul, placeholderImage: UIImage(named: "广告页"), options: SDWebImageOptions.progressiveDownload, completed: nil)
        var jiee1 = ""
        if nil != dic["idCard"]{
            jiee1 = dic["idCard"]!
        }
        let uul1 = URL(string: TupianUrl + jiee1)
        farensheng.sd_setImage(with: uul1, placeholderImage: UIImage(named: "广告页"), options: SDWebImageOptions.progressiveDownload, completed: nil)
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
