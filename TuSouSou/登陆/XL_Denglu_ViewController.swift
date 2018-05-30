//
//  XL_Denglu_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/29.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_Denglu_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 微信登录通知
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
        
        userDefaults.set("1212111", forKey: "userId")
        AppDelegate().method()
        
        
    }

    @IBAction func WeixinDenglu(_ sender: Any) {
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
                userDefaults.set(openid, forKey: "WXopenid")
//                let access_token: String = jsonResult["access_token"] as! String
//                self.getUserInfo(openid: openid, access_token: access_token)
            }
        }
    }
   
    @IBAction func qqDenglu(_ sender: Any) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        // 需要获取的用户信息
        let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        appDel.tencentAuth.authorize(permissions)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
