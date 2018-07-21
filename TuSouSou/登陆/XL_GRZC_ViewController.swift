//
//  XL_GRZC_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/4.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_GRZC_ViewController: UIViewController,UITextFieldDelegate {
    
    var state: Int?
    
    @IBOutlet weak var YZMButton: UIButton!
    @IBOutlet weak var yanZM: UITextField!
    @IBOutlet weak var yaoqingren: UITextField!
    @IBOutlet weak var remima: UITextField!
    @IBOutlet weak var mima: UITextField!
    @IBOutlet weak var zhanghao: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        print(state!)
        let textFArr:[UITextField] = [yanZM,remima,mima,zhanghao]
        delegate(textfields: textFArr)
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func delegate(textfields:[UITextField]) {
        for textF in textfields {
            textF.delegate = self
            if textF == mima || textF == remima {
                textF.keyboardType = .asciiCapable
            }else if textF == zhanghao || textF == yanZM {
                textF.keyboardType = .numberPad
            }
        }//279772
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        
        let len = text.count + string.count - range.length
        if textField == yanZM {
            return len <= 6
        }else if textField == zhanghao {
            return len <= 11
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
    @IBAction func zhuce(_ sender: Any) {
        if (zhanghao.text?.isPhoneNumber())! {
            if mima.text == remima.text{
                if (yanZM.text?.count)! > 0{
            let method = "/user/register"
            let dic = ["phone":zhanghao.text!,"passWord":mima.text!,"invitationCode":yaoqingren.text!,"authCode":yanZM.text!,"userType":state!] as [String : Any]
            XL_waringBox().warningBoxModeIndeterminate(message: "注册中...", view: self.view)
            XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
                print(res)
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                if (res as! [String: Any])["code"] as! String == "0000" {
                    XL_waringBox().warningBoxModeText(message: "注册成功", view: self.view)
                    let data = (res as! [String: Any])["data"] as! [String:Any]
                    
                    userDefaults.set(data["userId"], forKey: "userId")
                    //返回登录界面
                    if self.state == 1 {
                        //普通注册
                        for controller: UIViewController in (self.navigationController?.viewControllers)! {
                            if controller.isKind(of: XL_Denglu_ViewController.self) == true{
                                let a = controller as! XL_Denglu_ViewController
                                self.navigationController?.popToViewController(a, animated: true)
                                
                            }
                        }
                    }else if self.state == 2 {
                        //跳转到企业认证 //先跳到实名注册
                        let qiyeRZ: XL_ShimingRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shimingrz") as? XL_ShimingRZ_ViewController
                        qiyeRZ?.xxx = 1
                       qiyeRZ?.yyy = 2
                        self.navigationController?.pushViewController(qiyeRZ!, animated: true)
                    }
                    
                    //                    let dic = (res as! [String: Any])["data"] as! [String:Any]
                    
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
                     XL_waringBox().warningBoxModeText(message: "请填写验证码", view: self.view)
                }
            }else{
                 XL_waringBox().warningBoxModeText(message: "两次密码不相同", view: self.view)
            }
        }else {
            XL_waringBox().warningBoxModeText(message: "请填写正确的手机号", view: self.view)
        }
        
        
    }
    
    @IBAction func huoquYZM(_ sender: Any) {
        self.view.endEditing(true)
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
