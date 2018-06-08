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
        if rukou == "0" {
            self.title = "重置登录密码"
        }else{
            self.title = "重置支付密码"
        }
        
        zhanghao.delegate = self
        mima.delegate = self
        remima.delegate = self
        yanzhengma.delegate = self
        
        // Do any additional setup after loading the view.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        
        let len = text.count + string.count - range.length
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
    @IBAction func huoquYZM(_ sender: Any) {
        FaSongYZM()
    }
    func FaSongYZM() {
        if zhanghao.text!.isPhoneNumber() {
            let method = "/user/sendCode"
            let dic = ["phoneNum":zhanghao.text!]
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
        YZMButton.countDown(count: 59)
    }
    
    @IBAction func queding(_ sender: Any) {
        //重置密码接口
        if (zhanghao.text?.isPhoneNumber())! && mima.text == remima.text && (yanzhengma.text?.count)! > 0 {
            
        }
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
