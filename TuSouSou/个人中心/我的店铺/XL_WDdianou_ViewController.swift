//
//  XL_WDdianou_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDdianou_ViewController: UIViewController {
    var xxx = "2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的店铺"
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        jiekou()
    }
    func jiekou() {
        let method = "/user/selShopExistence"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.xxx = dic["selShopExistence"] as! String
                //                self.tablesplx.reloadData()
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    @IBAction func dingdanshezhi(_ sender: Any) {
        if xxx == "1" {
            let WDXX: XL_DDGL_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ddgl") as? XL_DDGL_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else{
            XL_waringBox().warningBoxModeText(message: "您还没有开店哟～请先进入店铺设置～", view: self.view)
        }
    }
    @IBAction func shangpinshezhi(_ sender: Any) {
        if xxx=="1" {
            let WDXX: XL_SPGL_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spgl") as? XL_SPGL_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else {
            XL_waringBox().warningBoxModeText(message: "您还没有开店哟～请先进入店铺设置～", view: self.view)
        }
    }
    @IBAction func dianpushizhe(_ sender: Any) {
        
        let WDXX: XL_DPSZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpsz") as? XL_DPSZ_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
        
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
