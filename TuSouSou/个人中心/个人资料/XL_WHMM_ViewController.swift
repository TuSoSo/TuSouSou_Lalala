//
//  XL_WHMM_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/4.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WHMM_ViewController: UIViewController,UITextFieldDelegate {

    var rukou:String = ""
    
    @IBOutlet weak var zhanghao: UITextField!
    
    @IBOutlet weak var mima: UITextField!
    
    @IBOutlet weak var remima: UITextField!
    
    @IBOutlet weak var YZMButton: UIButton!
    @IBOutlet weak var yanzhengma: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zhanghao.text = userDefaults.value(forKey: "phone") as? String
        zhanghao.delegate = self
//        zhanghao.keyboardType = .numberPad
        mima.delegate = self
        mima.keyboardType = .asciiCapable
        mima.autocorrectionType = .no //联想
        mima.autocapitalizationType = .none //首字母不大写
        remima.delegate = self
        remima.keyboardType = .asciiCapable
        remima.autocorrectionType = .no //联想
        remima.autocapitalizationType = .none //首字母不大写
        yanzhengma.delegate = self
        yanzhengma.keyboardType = .numberPad
        if rukou == "0" {
            self.title = "重置登录密码"
        }else{
            self.title = "重置支付密码"
            mima.placeholder = "请输入支付密码(6位数字)"
            mima.keyboardType = .numberPad
            remima.placeholder = "再次输入支付密码(6位数字)"
            remima.keyboardType = .numberPad
        }
        // Do any additional setup after loading the view.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        
        let len = text.count + string.count - range.length
        if rukou == "1" {
            if textField == mima || textField == remima{
                //判断是否是数字
                let length = string.lengthOfBytes(using: String.Encoding.utf8)
                
                for loopIndex in 0..<length {
                    
                    let char = (string as NSString).character(at: loopIndex)
                    
                    if char < 48 {return false }
                    
                    if char > 57 {return false }
                    
                }
                return len <= 6
            }
        }
        if textField == yanzhengma {
            return len <= 6
        }else if textField == zhanghao {
            return len <= 11
        }else if textField == remima{
            return len <= 15
        }else if textField == mima {
            return len <= 15
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mima {
            if (textField.text?.count)! < 6 {
                textField.text = ""
                XL_waringBox().warningBoxModeText(message: "密码过短", view: self.view)
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == zhanghao {
            return false
        }
        return true
    }
    @IBAction func huoquYZM(_ sender: Any) {
        FaSongYZM()
    }
    func FaSongYZM() {
        if zhanghao.text!.isPhoneNumber() {
            let method = "/user/sendCode"
            let dic = ["phoneNum":zhanghao.text!,"userType":"1"]
            XL_waringBox().warningBoxModeIndeterminate(message: "飕飕飕～发送验证码...", view: self.view)
            XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
                if (res as! [String: Any])["code"] as! String == "0000" {
                    XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                    XL_waringBox().warningBoxModeText(message: "验证码发送成功", view: self.view)
                    self.YZMdaoshu()
                }else{
                    let msg = (res as! [String: Any])["msg"] as! String
                    XL_waringBox().warningBoxModeText(message: msg, view: self.view)
                }
            }) { (error) in
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                XL_waringBox().warningBoxModeText(message: "验证码发送失败，请重试", view: self.view)
                print(error)
            }
        }else {
            XL_waringBox().warningBoxModeText(message: "请输入正确的手机号", view: self.view)
        }
    }
    func YZMdaoshu() {
        YZMButton.countDown(count: 59)
    }
    
    @IBAction func queding(_ sender: Any) {
        //重置密码接口
        var isTrue = true
        var passwordType = ""
        
        if rukou == "1" {
            passwordType = "2"
            if mima.text?.count != 6{
               
                isTrue = false
            }
        }else{
            passwordType = "1"
        }
        if (zhanghao.text?.isPhoneNumber())!{
            if isTrue {
                if mima.text == remima.text {
                    if (yanzhengma.text?.count)! > 0 {
            let method = "/user/setPassword"
            let userId = userDefaults.value(forKey: "userId") as! String
                        let dic:[String:Any] = ["userId":userId,"newPassword":mima.text!,"passwordType":passwordType,"authCode":yanzhengma.text!]
            XL_waringBox().warningBoxModeIndeterminate(message: "密码验证中...", view: self.view)
            let accessToken = userDefaults.value(forKey: "accessToken") as! String
                        
            XL_QuanJu().TokenWangluo(methodName: method, methodType: .post, userId: userId, accessToken: accessToken, rucan: dic, success:{ (res) in
                print(res)
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                if (res as! [String: Any])["code"] as! String == "0000" {
                    if self.rukou == "1"{
                        XL_waringBox().warningBoxModeText(message: "支付密码设置成功", view: (self.navigationController?.view)!)
                        userDefaults.set(1, forKey: "isPayPassWord")
                    }else{
                        XL_waringBox().warningBoxModeText(message: "登陆密码设置成功", view: (self.navigationController?.view)!)
                    }
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let msg = (res as! [String: Any])["msg"] as! String
                    XL_waringBox().warningBoxModeText(message: msg, view: self.view)
                }
            }) { (error) in
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
                print(error)
                        }
                    }else{
                        XL_waringBox().warningBoxModeIndeterminate(message: "请填写验证码", view: self.view)
                    }
                }else{
                    XL_waringBox().warningBoxModeIndeterminate(message: "两次密码不相同", view: self.view)
                }
            }else{
                XL_waringBox().warningBoxModeIndeterminate(message: "支付密码为 6位", view: self.view)
            }
        }else{
                XL_waringBox().warningBoxModeIndeterminate(message: "请填写正确的手机号", view: self.view)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
