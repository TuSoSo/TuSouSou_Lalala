//
//  XL_XieYi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/7/14.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_XieYi_ViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        xieyijiekou()
        // Do any additional setup after loading the view.
    }

    func xieyijiekou() {
        let method = "/about/agreement"
        let dic = ["ss":"ss",]
        XL_waringBox().warningBoxModeIndeterminate(message: "协议编写中...", view: view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
//                XL_waringBox().warningBoxModeText(message: "登录成功", view: self.view)
                let data = (res as! [String: Any])["data"] as! [String:Any]
                self.textView.text = data["context"] as! String
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
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
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
