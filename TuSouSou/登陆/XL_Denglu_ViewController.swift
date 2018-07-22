//
//  XL_Denglu_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/29.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
import Alamofire
class XL_Denglu_ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var xuanzhongButton: UIButton!
    
    @IBOutlet weak var yonghuxieyi: UIButton!
    
    @IBOutlet weak var zhanghao: UITextField!
    @IBOutlet weak var YZMButton: UIButton!
    @IBOutlet weak var yanzhengma: UITextField!
    var xxjj = 0
    
    @IBAction func xuanzhong(_ sender: Any) {
        if xuanzhongButton.isSelected == false {
            xuanzhongButton.isSelected = true
        }else{
            xuanzhongButton.isSelected = false
        }
    }
    @IBAction func xieyi(_ sender: Any) {
        //跳页
        let xieyi: XL_XieYi_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "xieyi") as? XL_XieYi_ViewController
        self.navigationController?.pushViewController(xieyi!, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        xuanzhongButton.isSelected = false
        self.title = "登录"
        zhanghao.keyboardType = .numberPad
        yanzhengma.keyboardType = .numberPad
        zhanghao.delegate = self
        yanzhengma.delegate = self
        // 微信登录通知
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
        let name = Notification.Name(rawValue: "QQLoginSuccessNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(QQLoginSuccess(notification:)), name: name, object:  nil)
        if xxjj == 1 {
            fanhuidaoRoot()
        }
        youAnniu()
    }
    func fanhuidaoRoot() {
        let leftBarBtn = UIBarButtonItem(title: "X", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    @objc func backToPrevious(){
        self.navigationController!.popToRootViewController(animated: true)
    }
    func youAnniu() {
        let item = UIBarButtonItem(title:"账号密码登录",style: .plain,target:self,action:#selector(YouActio))
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio()  {
        if xuanzhongButton.isSelected == true {
            XL_waringBox().warningBoxModeText(message: "请同意用户协议", view: self.view)
        }else{
            let WDXX: XL_ZMDL_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "zmdl") as? XL_ZMDL_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        
        let len = text.count + string.count - range.length
        if textField == yanzhengma {
            return len <= 6
        }else if textField == zhanghao {
            return len <= 11
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func dengluanniu(_ sender: Any) {
        self.view.endEditing(true)
        if xuanzhongButton.isSelected == true {
            XL_waringBox().warningBoxModeText(message: "请同意用户协议", view: self.view)
        }else{
            if (zhanghao.text?.isPhoneNumber())! {
                if (yanzhengma.text?.count)! > 0 {
                //            dengdeng(loginMethod: "1", loginName: zhanghao.text!, passWord: "", authCode: yanzhengma.text!, openID: "",view: self.view)
                let method = "/user/logined"
                let dic = ["loginPlatform":"1","loginMethod":"1","loginName":zhanghao.text!,"passWord":"","authCode":yanzhengma.text!,"openID":""]
                XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: view)
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
                        userDefaults.set("1", forKey: "loginMethod")
                        userDefaults.set("1", forKey: "isDengLu")
                        userDefaults.set(dic["accessToken"], forKey: "accessToken")
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
                    
                }else{
                    XL_waringBox().warningBoxModeText(message: "请填写验证码", view: self.view)
                }
            }else {
                XL_waringBox().warningBoxModeText(message: "请填写正确的手机号", view: self.view)
            }
        }
    }
    func dengdeng(loginMethod: String,loginName:String,passWord:String,authCode:String, openID: String,view: UIView,WeChatName:String) {
        let method = "/user/logined"
        let dic = ["loginPlatform":"1","loginMethod":loginMethod,"loginName":loginName,"passWord":passWord,"authCode":authCode,"openID":openID,"WeChatName":WeChatName]
        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "登录成功", view: view)
                let dic = (res as! [String: Any])["data"] as! [String:Any]
                userDefaults.set(dic["userId"], forKey: "userId")
                userDefaults.set(dic["isPayPassWord"], forKey: "isPayPassWord")
                userDefaults.set(dic["userPhone"], forKey: "userPhone")
                userDefaults.set(dic["invitationCode"], forKey: "invitationCode")
                userDefaults.set(loginMethod, forKey: "loginMethod")
                userDefaults.set(passWord, forKey: "passWord")
                userDefaults.set(openID, forKey: "openID")
                userDefaults.set("1", forKey: "isDengLu")
                userDefaults.set(dic["accessToken"], forKey: "accessToken")
                AppDelegate().method()
                self.navigationController?.popToRootViewController(animated: true)
            }else if (res as! [String: Any])["code"] as! String == "8000" {
                //跳转到完善个人信息
                userDefaults.set(openID, forKey: "openID")
                XL_waringBox().warningBoxModeText(message: "请完善基础资料", view: (self.navigationController?.view)!)
                let wanshan: XL_DengLuWanshan_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dengluwanshan") as? XL_DengLuWanshan_ViewController
                wanshan?.isWQ = loginMethod
                self.navigationController?.pushViewController(wanshan!, animated: true)
                
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: view)
            print(error)
        }
    }
    @IBAction func huoquyanzhengma(_ sender: Any) {
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
    
    
    //    @IBAction func ZMdenglu(_ sender: Any) {
    //        let WDXX: XL_ZMDL_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "zmdl") as? XL_ZMDL_ViewController
    //        self.navigationController?.pushViewController(WDXX!, animated: true)
    //    }
    
    
    //    @IBAction func WJmima(_ sender: Any) {
    //        let WDXX: XL_WHMM_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "whmm") as? XL_WHMM_ViewController
    //        self.navigationController?.pushViewController(WDXX!, animated: true)
    //    }
    
    @IBAction func GRzc(_ sender: Any) {
        if xuanzhongButton.isSelected == true {
            XL_waringBox().warningBoxModeText(message: "请同意用户协议", view: self.view)
        }else{
            let WDXX: XL_GRZC_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grzc") as? XL_GRZC_ViewController
            WDXX?.state = 1
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }
        
    }
    
    @IBAction func QYzc(_ sender: Any) {
        if xuanzhongButton.isSelected == true {
            XL_waringBox().warningBoxModeText(message: "请同意用户协议", view: self.view)
        }else{
            let WDXX: XL_GRZC_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grzc") as? XL_GRZC_ViewController
            WDXX?.state = 2
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }
    }
    
    @IBAction func WeixinDenglu(_ sender: Any) {
        if xuanzhongButton.isSelected == true {
            XL_waringBox().warningBoxModeText(message: "请同意用户协议", view: self.view)
        }else{
            let urlStr = "weixin://"
            if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
                let red = SendAuthReq.init()
                red.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
                red.state = "\(arc4random()%100)"
                WXApi.send(red)
            }else{
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
                }
            }
        }
    }
    /**  QQ通知  */
    @objc func QQLoginSuccess(notification:Notification) {
        let openid = notification.userInfo!["openId"] as! String
        self.dengdeng(loginMethod: "3", loginName: "", passWord: "", authCode: "", openID: openid, view: self.view, WeChatName: "")
    }
    /**  微信通知  */
    @objc func WXLoginSuccess(notification:Notification) {
        
        let code = notification.object as! String
        let requestUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WeiXin_AppID)&secret=\(WX_APPSecret)&code=\(code)&grant_type=authorization_code"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                let openid: String = jsonResult["openid"] as! String
                
                let accessToken = jsonResult["access_token"] as! String
                self.wechatLoginByRequestForUserInfo(accessToken:accessToken,openid:openid)
                
                //                userDefaults.set(openid, forKey: "WXopenid")
                //                let params = ["access_token": accessToken! as! String, "openid": openid! as! String] as Dictionary<String, Any>
                
            }
        }
    }
    func wechatLoginByRequestForUserInfo(accessToken:String,openid:String) {
        // 获取用户信息
        
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openid)"
        
        //        DispatchQueue.global().async {
        
        let requestURL: URL = URL.init(string: requestUrl)!
        let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
        
        
        let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
        
        print(jsonResult)
        let nickname = jsonResult["nickname"] as! String
        userDefaults.set(nickname, forKey: "nickname")
        //登录
        self.dengdeng(loginMethod: "4", loginName: "", passWord: "", authCode: "", openID: openid, view: self.view, WeChatName: nickname)
        //                userDefaults.set(openid, forKey: "WXopenid")
        //                let params = ["access_token": accessToken! as! String, "openid": openid! as! String] as Dictionary<String, Any>
        
        
        //        }
    }
    
    @IBAction func qqDenglu(_ sender: Any) {
        if xuanzhongButton.isSelected == true {
            XL_waringBox().warningBoxModeText(message: "请同意用户协议", view: self.view)
        }else{
            let appDel = UIApplication.shared.delegate as! AppDelegate
            // 需要获取的用户信息
            let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
            appDel.tencentAuth.authorize(permissions)
        }
    }
}
extension String{
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    public func isPhoneNumber() -> Bool {
        if self.count == 0 {
            return false
        }
        let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: self) == true {
            return true
        }else
        {
            return false
        }
    }
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        
        let utf16view = self.utf16
        
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
            
        }
        
        return nil
        
    }
}
extension UIButton{
    public func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
        backgroundColor = UIColor.gray
        
        var remainingCount: Int = count {
            willSet {
                setTitle("重新发送(\(newValue))", for: .normal)
                
                if newValue <= 0 {
                    setTitle("发送验证码", for: .normal)
                }
            }
        }
        
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
}
