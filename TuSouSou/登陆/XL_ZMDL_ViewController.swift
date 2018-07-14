//
//  XL_ZMDL_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/4.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_ZMDL_ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var zhanghao: UITextField!
    
    @IBOutlet weak var mima: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        zhanghao.keyboardType = .numberPad
        if #available(iOS 10.0, *) {
            mima.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
        }
        zhanghao.delegate = self
        mima.delegate = self
        mima.isSecureTextEntry = true
        self.title = "账号密码登录"
        // Do any additional setup after loading the view.
    }

    @IBAction func denglu(_ sender: Any) {
        self.view.endEditing(true)
        if (zhanghao.text?.isPhoneNumber())! && (mima.text?.count)! > 0 {
            let method = "/user/logined"
            let dic = ["loginPlatform":"1","loginMethod":"2","loginName":zhanghao.text!,"passWord":mima.text!,"authCode":"","openID":""]
            XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
            XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
                print(res)
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                if (res as! [String: Any])["code"] as! String == "0000" {
                    XL_waringBox().warningBoxModeText(message: "登录成功", view: self.view)
                    let dic = (res as! [String: Any])["data"] as! [String:Any]
                    userDefaults.set(dic["userId"], forKey: "userId")
                    userDefaults.set(dic["isPayPassWord"], forKey: "isPayPassWord")
                    userDefaults.set(dic["userPhone"], forKey: "userPhone")
                    userDefaults.set(dic["invitationCode"], forKey: "invitationCode")
                    userDefaults.set("2", forKey: "loginMethod")
                    userDefaults.set(self.mima.text!, forKey: "passWord")
                    userDefaults.set("1", forKey: "isDengLu")
                    AppDelegate().method()
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    let msg = (res as! [String: Any])["msg"] as! String
                    XL_waringBox().warningBoxModeText(message: msg, view: self.view)
                }
            }) { (error) in
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
                print(error)
            }
        }else {
            XL_waringBox().warningBoxModeText(message: "请完善信息", view: self.view)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mima {
            if (textField.text?.count)! < 6 {
                textField.text = ""
                XL_waringBox().warningBoxModeText(message: "密码过短", view: self.view)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        
        let len = text.count + string.count - range.length
        if textField == mima {
            return len <= 15
        }else if textField == zhanghao {
            return len <= 11
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
