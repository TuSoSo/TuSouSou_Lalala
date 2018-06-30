//
//  AppDelegate.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/2/27.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder,WXApiDelegate,BMKGeneralDelegate,UIApplicationDelegate,TencentSessionDelegate,JPUSHRegisterDelegate {
    
    var window: UIWindow?
    var _mapManager: BMKMapManager?
    var tencentAuth: TencentOAuth!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        tencentAuth = TencentOAuth(appId: qqAppID, andDelegate: self)
        WXApi.registerApp(WeiXin_AppID)
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            //            appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        //极光推送
        // 通知注册实体类
        let entity = JPUSHRegisterEntity();
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue);
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self);
        // 注册极光推送
        //apsForProduction : false 为开发环境 ，true 为生产环境
        JPUSHService.setup(withOption: launchOptions, appKey: JPush_AppKey, channel:"App Store" , apsForProduction: false);
        
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if resCode == 0 {
                self.method()
            }
        }
        
        //百度地图
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("44xyBYXqaNGwSh8ci2L0EDiQX1XQbn3A", generalDelegate: self)
        if ret == false {
            NSLog("地图初始化失败！")
        }
        
        // 引导页是否显示
        //        取得当前版本号
        let infoDic = Bundle.main.infoDictionary
        let currentAppVersion = infoDic! ["CFBundleShortVersionString"] as! String
        //        取得之前版本号
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        //        如果appVersion 为nil 则为第一次启动；若appVersion 不等于 currenAppVersion 则为更新了
        if appVersion == nil || appVersion != currentAppVersion {
            //            保存现在版本号
            userDefaults.set(currentAppVersion, forKey: "appVersion")
            let guideVc : XL_GuideViewController! = storyboard.instantiateViewController(withIdentifier: "GuideViewController") as! XL_GuideViewController
            
            self.window?.rootViewController = guideVc
            window?.makeKeyAndVisible()
        }else{
            let advertiseVC: XL_GuanggaoViewController! = storyboard.instantiateViewController(withIdentifier: "guanggao") as! XL_GuanggaoViewController
            
            window?.rootViewController = advertiseVC
        }
        
        
        return true
    }
    
    //MARK:微信三方登录
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.scheme == WeiXin_AppID {
            WXApi.handleOpen(url as URL?, delegate: self)
        }
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme == WeiXin_AppID {
            WXApi.handleOpen(url as URL?, delegate: self)
        }
        return true
    }
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("openURL:\(String(describing: url.absoluteString))")
        if url.scheme == WeiXin_AppID {
            return WXApi.handleOpen(url as URL?, delegate: self)
        }
        return true
    }
    func onReq(_ req: BaseReq!) {
        //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
        print(req.type)
    }
    
    /**  微信回调  */
    func onResp(_ resp: BaseResp!) {
        
        if resp.isKind(of: SendMessageToWXResp.self) {//确保是对我们分享操作的回调
            if resp.errCode == WXSuccess.rawValue{//分享成功
                NSLog("分享成功")
            }else{//分享失败
                NSLog("分享失败，错误码：%d, 错误描述：%@", resp.errCode, resp.errStr)
            }
        }
        else if resp.isKind(of: PayResp.self) {
            var strMsg = "(resp.errCode)"
            switch resp.errCode {
            case 0 :
                print("支付成功")
                if nil != userDefaults.value(forKey: "xixi") && (userDefaults.value(forKey: "xixi") as! Int) == 2 {
                    chongzhijiekou(lalala: userDefaults.value(forKey: "hahaha") as! String)
                }else{
                  self.zhifuhuidiao()
                }
                strMsg = "支付成功"
            //                NSNotificationCenter.defaultCenter().postNotificationName(WXPaySuccessNotification, object: nil)
            default:
                strMsg = "支付失败，请您重新支付!"
                userDefaults.set(0, forKey: "xixi")
                print("retcode = (resp.errCode), retstr = (resp.errStr)")
            }
            let alert = UIAlertView(title: nil, message: strMsg, delegate: nil, cancelButtonTitle: "好的")
            alert.show()
        }else if resp.errCode == 0 && resp.type == 0 {//授权成功
            let response = resp as! SendAuthResp
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
        }
        
    }
   
    //MARK:支付宝支付
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //微信回调
        if url.scheme == WeiXin_AppID {
            WXApi.handleOpen(url as URL?, delegate: self)
        }
        //qq回调
        let urlKey: String = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        if urlKey == "com.tencent.mqq" {
            // QQ 的回调
            return  TencentOAuth.handleOpen(url)
        }
        //支付宝回调
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (resultDic) in
                var strMsg = ""
                if resultDic!["resultStatus"] as! String == "9000" {
                    if nil != userDefaults.value(forKey: "xixi") && (userDefaults.value(forKey: "xixi") as! Int) == 2 {
                        self.chongzhijiekou(lalala: userDefaults.value(forKey: "hahaha") as! String)
                    }else{
                        self.zhifuhuidiao()
                    }
                    strMsg = "支付成功"
                }else{
                    strMsg = "支付失败，请您重新支付!"
                    userDefaults.set(0, forKey: "xixi")
                }
                let alert = UIAlertView(title: nil, message: strMsg, delegate: nil, cancelButtonTitle: "好的")
                alert.show()
            }
            AlipaySDK.defaultService().processAuthResult(url) { (resultDic) in
                print(resultDic as Any)
            }
            AlipaySDK.defaultService().processAuth_V2Result(url) { (resultDic) in
                print(resultDic as Any)
            }
        }
        if url.host == "platformapi" {
            
        }
        return true
    }
    
    
    func tencentDidLogin() {
        // 登录成功后要调用一下这个方法, 才能获取到个人信息
        self.tencentAuth.getUserInfo()
    }
    
    func tencentDidNotNetWork() {
        // 网络异常
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        // 获取个人信息
        if response.retCode == 0 {
            
            if (response.jsonResponse) != nil {
                
                if let uid = self.tencentAuth.getUserOpenID() {
                    // 获取uid
                    NotificationCenter.default.post(name: NSNotification.Name("QQLoginSuccessNotification"), object: self, userInfo: ["openId":uid])
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "QQLoginSuccessNotification"), object: ["openId":uid])
                    print(uid)
                }
            }
        } else {
            // 获取授权信息异常
        }
    }
    func chongzhijiekou(lalala:String) {
        let method = "/distribution/recharge"
        let userId = userDefaults.value(forKey: "userId")
        let dicc:[String:Any] = ["userId":userId!,"money":lalala]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            userDefaults.set("", forKey: "hahaha")
        }) { (error) in
            print(error)
        }
    }
    func zhifuhuidiao() {
        let method = "/order/payAfterHandler"
        var dingdanhao = ""
        if (userDefaults.value(forKey: "dingdanhao") as!  String).count != 0 {
            dingdanhao = userDefaults.value(forKey: "dingdanhao") as! String
        }
        
        let dicc:[String:Any] = ["orderCode":dingdanhao]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            userDefaults.set("", forKey: "dingdanhao")
        }) { (error) in
            
            print(error)
        }
    }
    // MARK: -JPUSHRegisterDelegate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func method()  {
        var alias: String = ""
        if nil != userDefaults.value(forKey: "userId") {
            alias = userDefaults.value(forKey: "userId") as! String
        }
        
        JPUSHService.setAlias(alias, completion: { (iResCode, alias, aa) in
            print("\(iResCode)\n别名:  \(alias)\n\(aa)")
        }, seq: 1)
        
    }
    // iOS 10.x 需要
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo;
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
            //小红点通知显示
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo;
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler();
        // 应用打开的时候收到推送消息
        UIApplication.shared.applicationIconBadgeNumber = 0;
        
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName_ReceivePush), object: NotificationObject_Sueecess, userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo);
        //小红点通知显示
        
        
        completionHandler(UIBackgroundFetchResult.newData);
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.cancelAllLocalNotifications()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
}

