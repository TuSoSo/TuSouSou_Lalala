//
//  XL_WDXXXQ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/1.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDXXXQ_ViewController: UIViewController {
    var xxId:String?
    
    var mssId:String?
    var DDArr:[String:Any] = [:]
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var neirongLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知详情"
        // Do any additional setup after loading the view.
        xiaoxixiangqingjiekou()
        if xxId == "0" {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tiaoddxq))
            neirongLabel.addGestureRecognizer(tap)
            neirongLabel.isUserInteractionEnabled = true
        }
    }
    @objc func tiaoddxq() {
        let neirong = DDArr["context"] as! String
        if !neirong.contains("【订单】:您的订单编号") && !neirong.contains("【订单】:您有新的") {
            
        }else{
            let wwddxq: XL_WDDDXQ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdddxq") as? XL_WDDDXQ_ViewController
            wwddxq?.shangLX = DDArr["orderType"]! as? String
            wwddxq?.dingdanId = DDArr["orderId"] as? String
            wwddxq?.leixing = DDArr["orderState"] as? String
            self.navigationController?.pushViewController(wwddxq!, animated: true)
        }
    }
    func xiaoxixiangqingjiekou() {
        let method = "/user/messageDetail"
//        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["mssId":mssId!]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                //                XL_waringBox().warningBoxModeText(message: "评价成功", view: self.view)
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.DDArr = data
                self.fuzhi(dic:data)
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
    func fuzhi(dic:[String:Any]) {
        titleLabel.text = dic["title"] as? String
        let neirong = dic["context"] as! String
        if xxId == "0" {
            if neirong.contains("[") {
                var new = "xxx"
                if neirong.contains("【订单】:您的订单编号") {
                    new = neirong[13..<47]
                }else if neirong.contains("【订单】:您有新的"){
                    new = neirong[18..<52]
                }
                let attributedString =  NSMutableAttributedString(string: neirong)
                let range = attributedString.string.range(of: new)
                if nil != range {
                    let nsrange = attributedString.string.nsRange(from: range!)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: nsrange!)
                    neirongLabel.attributedText = attributedString
                }
               
            }
        }else{
            neirongLabel.text = neirong
        }
        
        timeLabel.text = dic["pushTime"] as? String
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
