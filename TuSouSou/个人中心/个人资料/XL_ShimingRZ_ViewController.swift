//
//  XL_ShimingRZ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/1.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
//zzp1z5
class XL_ShimingRZ_ViewController: UIViewController {
    var xxx = 0
    var yyy = 0
    
    var jiemian = 1
    var shengyu = 0
    //次数
    var remainder = ""
    
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var shenhecishu: UILabel!
    @IBOutlet weak var tongguojiemian: UIView!
    @IBOutlet weak var shirenrenzhengjiemian: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //调一个接口。存剩余次数
        if xxx == 1 && jiemian == 1 {
            fanhuidaoRoot()
        }
        cishujiekou()
        jiazai()
    }
    override func viewWillAppear(_ animated: Bool) {
        zhuangtai()
    }
    func fanhuidaoRoot() {
        let leftBarBtn = UIBarButtonItem(title: "X", style: .plain, target: self,action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    @objc func backToPrevious(){
        for controller: UIViewController in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: XL_Denglu_ViewController.self) == true{
                let a = controller as! XL_Denglu_ViewController
                self.navigationController?.popToViewController(a, animated: true)
                
            }
        }
    }
    func jiazai() {
        if jiemian == 1 {
            self.title = "实名认证"
            tongguojiemian.isHidden = true
            shirenrenzhengjiemian.isHidden = false
        }else{
            if yyy > 0 {
                let anniu = UIButton(frame: CGRect(x: 40, y: Height - 180, width: Width - 80, height: 48))
                anniu.setTitle("下一步", for: .normal)
                anniu.setTitleColor(UIColor.white, for: .normal)
                anniu.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
                anniu.setBackgroundImage(UIImage(named: "button_normal_light"), for: .highlighted)
                anniu.addTarget(self, action: #selector(xiayibu), for: .touchUpInside)
                self.view.addSubview(anniu)
            }
            self.title = "实名认证结果"
            tongguojiemian.isHidden = false
            shirenrenzhengjiemian.isHidden = true
            self.shenfenzheng()
        }
        //调一个接口。存剩余次数
    }
    @objc func xiayibu() {
        let qiyeRZ: XL_QiyeRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qiyerz") as? XL_QiyeRZ_ViewController
        qiyeRZ?.yyy = yyy
        self.navigationController?.pushViewController(qiyeRZ!, animated: true)
    }
    @IBAction func renzhneg(_ sender: Any) {
        //如果次数大于0
        if self.remainder != "0" {
            tokenJiekou()
        }else{
            let aaa = UIAlertController(title: "温馨提示：", message: "此账号已没有认证次数！", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            aaa.addAction(cancelAction)
            self.present(aaa, animated: true, completion: nil)
        }
    }
    func tokenJiekou() {
        let method = "/AliYun/RPBasic"
        //        XL_waringBox().warningBoxModeIndeterminate(message: "保存中...", view: self.view)
        let dic:[String:Any] = ["ss":""]
        
        XL_QuanJu().SanFangWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                let verifyToken = data["token"] as! String
                userDefaults.set(data["ticketId"] as! String, forKey: "ticketId")
                RPSDK.start(verifyToken, rpCompleted: { (auditState: AUDIT) in
                    if auditState == AUDIT.PASS { //认证通过
                        //调接口 传
                        self.shimingrenzhengjiekou(authenticationResults: "1")
                    }
                    else if auditState == AUDIT.FAIL { //认证不通过
                        self.shimingrenzhengjiekou(authenticationResults: "2")
                    }
                    else if auditState == AUDIT.IN_AUDIT { //认证中，通常不会出现，只有在认证审核系统内部出现超时，未在限定时间内返回认证结果时出现。此时提示用户系统处理中，稍后查看认证结果即可。
                    }
                    else if auditState == AUDIT.NOT { //未认证，用户取消
                    }
                    else if auditState == AUDIT.EXCEPTION  { //系统异常
                    }
                }, withVC: self.navigationController)
                
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            print(error)
        }
    }
    func shimingrenzhengjiekou(authenticationResults:String) {
        let method = "/user/realNameAuthentication"
//        XL_waringBox().warningBoxModeIndeterminate(message: "保存中...", view: self.view)
        let userId = userDefaults.value(forKey: "userId")
        let ticketId = userDefaults.value(forKey: "ticketId")
        
        let dic:[String:Any] = ["userId":userId!,"authenticationResults":authenticationResults,"ticketId":ticketId!]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.jiemian = 2
                //调身份证信息接口
                self.remainder = data["remainder"] as! String
                self.jiazai()
            }else if (res as! [String: Any])["code"] as! String == "1003"{
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.remainder = data["remainder"] as! String
                let msg = (res as! [String: Any])["msg"] as! String
                let aaa = UIAlertController(title: "警告！", message: "\(msg)\n此账号剩余认证次数仅剩\(self.remainder)次，请慎用。", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                aaa.addAction(cancelAction)
                self.present(aaa, animated: true, completion: nil)
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            print(error)
        }
    }
    func shenfenzheng() {
        let method = "/user/authenticationInformation"
        //        XL_waringBox().warningBoxModeIndeterminate(message: "保存中...", view: self.view)
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                //                let verifyToken = data["token"] as! String
                self.jiemian = 2
                let name = data["name"] as? String
                let endIndex1 = name?.index((name?.endIndex)!, offsetBy:-((name?.count)! - 1))
                let namehou = name?.suffix(from: endIndex1!)
                self.name.text = "*" + "\(namehou!)"
                
                let IDNumber = data["IdentificationNumber"] as? String
                let indexID = IDNumber?.index((IDNumber?.startIndex)!, offsetBy: 6)
                let endIndex = IDNumber?.index((IDNumber?.endIndex)!, offsetBy:-4)
                let qianID = IDNumber?.prefix(upTo: indexID!)
                let houID = IDNumber?.suffix(from: endIndex!)
                
                self.ID.text = "\(qianID!)" + "********" + "\(houID!)"
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            print(error)
        }
    }
    func cishujiekou() {
        let method = "/user/selAufrequency"
        //        XL_waringBox().warningBoxModeIndeterminate(message: "保存中...", view: self.view)
        let userId = userDefaults.value(forKey: "userId")
        
        let dic:[String:Any] = ["userId":userId!]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.remainder = data["remainder"] as! String
                if self.remainder == "0" {
                    //弹出
                    let aaa = UIAlertController(title: "温馨提示：", message: "此账号已没有认证次数！", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    aaa.addAction(cancelAction)
                    self.present(aaa, animated: true, completion: nil)
                }
            }else{
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.remainder = data["remainder"] as! String
                if self.remainder == "0" {
                    //弹出
                    let aaa = UIAlertController(title: "温馨提示：", message: "此账号已没有认证次数！", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    aaa.addAction(cancelAction)
                    self.present(aaa, animated: true, completion: nil)
                }
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            print(error)
        }
    }
    func zhuangtai() {
        let method = "/user/approve"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                //实人
                if nil != dic["isAuthentic"]{
                    userDefaults.set(dic["isAuthentic"], forKey: "isRealAuthentication")
                }
                //企业
                if nil != dic["firmAuthentic"]{
                    userDefaults.set(dic["firmAuthentic"], forKey: "isFirmAdit")
                }
                //配送员
                if nil != dic["attestation"] {
                    userDefaults.set(dic["attestation"], forKey: "attestation")
                }
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
}
