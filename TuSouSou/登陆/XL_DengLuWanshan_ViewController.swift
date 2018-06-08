//
//  XL_DengLuWanshan_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/7.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_DengLuWanshan_ViewController: UIViewController,UITextFieldDelegate {
    var isWQ:String?
    
    @IBOutlet weak var YYY: UIButton!
    @IBOutlet weak var yanzhengma: UITextField!
    @IBOutlet weak var phone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(isWQ!)
        yanzhengma.delegate = self
        phone.delegate = self
        phone.keyboardType = . numberPad
        yanzhengma.keyboardType = . numberPad
        // Do any additional setup after loading the view.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        
        let len = text.count + string.count - range.length
        if textField == yanzhengma {
            return len <= 6
        }else if textField == phone {
            return len <= 11
        }
       return true
    }
    @IBAction func huoquyanzhengma(_ sender: Any) {
        self.view.endEditing(true)
        FaSongYZM()
    }
    func FaSongYZM() {
        if phone.text!.isPhoneNumber() {
            let method = "/user/sendCode"
            let dic = ["phoneNum":phone.text!]
            XL_waringBox().warningBoxModeIndeterminate(message: "飕飕飕～发送验证码...", view: self.view)
            XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
                if (res as! [String: Any])["code"] as! String == "0000" {
                    XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                    XL_waringBox().warningBoxModeText(message: "验证码发送成功", view: self.view)
                    self.YZMdaoshu()
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
        YYY.countDown(count: 59)
    }
    @IBAction func dengluanniu(_ sender: Any) {
        self.view.endEditing(true)
        let openId:String = userDefaults.value(forKey: "openID") as! String
        
        dengfangfa(loginMethod: isWQ!, loginName: phone.text!, passWord: "", authCode: yanzhengma.text!, openID: openId, view: (self.navigationController?.view)!)
    }
    
    func dengfangfa(loginMethod: String,loginName:String,passWord:String,authCode:String, openID: String,view: UIView) {
        let method = "/user/logined"
        let dic = ["loginPlatform":"1","loginMethod":loginMethod,"loginName":loginName,"passWord":passWord,"authCode":authCode,"openID":openID]
        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "登录成功", view: (self.navigationController?.view)!)
                let dic = (res as! [String: Any])["data"] as! [String:Any]
                userDefaults.set(dic["userId"], forKey: "userId")
                userDefaults.set(dic["isPayPassWord"], forKey: "isPayPassWord")
                userDefaults.set(dic["userPhone"], forKey: "userPhone")
                userDefaults.set(dic["invitationCode"], forKey: "invitationCode")
                userDefaults.set(loginMethod, forKey: "loginMethod")
                userDefaults.set(passWord, forKey: "passWord")
                userDefaults.set(openID, forKey: "openID")
                userDefaults.set("1", forKey: "isDengLu")
                AppDelegate().method()
                self.navigationController?.popToRootViewController(animated: true)
            }else if (res as! [String: Any])["code"] as! String == "8000" {
                //跳转到完善个人信息
                XL_waringBox().warningBoxModeText(message: "请完善基础资料", view: (self.navigationController?.view)!)
                let wanshan: XL_DengLuWanshan_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dengluwansahn") as? XL_DengLuWanshan_ViewController
                wanshan?.isWQ = loginMethod
                self.navigationController?.pushViewController(wanshan!, animated: true)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: view)
            print(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
