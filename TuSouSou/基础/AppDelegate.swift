//
//  AppDelegate.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/2/27.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder,WXApiDelegate,BMKGeneralDelegate,UIApplicationDelegate {
    
    var window: UIWindow?
    var _mapManager: BMKMapManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        WXApi.registerApp(WeiXin_AppID)
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            //            appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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
            window?.makeKeyAndVisible()
            //            let leftVC = XL_LeftMenuViewController()
            //            let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            //            window?.rootViewController = XL_DrawerViewController(mainVC: tabBarVC!, leftMenuVC: leftVC, leftWidth: 300)
            //            window?.makeKeyAndVisible()
            
        }
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    //
    //    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (resultDic) in
                if resultDic!["resultStatus"] as! String == "9000" {
                    let Box = XL_waringBox()
                    Box.warningBoxModeText(message: "支付成功", view: (self.window?.rootViewController?.view)! )
                }else{
                    let Box = XL_waringBox()
                    Box.warningBoxModeText(message: resultDic!["memo"] as! String, view: (self.window?.rootViewController?.view)! )
                }
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
    
    
    private func onResp(resp: BaseResp!) {
        var strTitle = "支付结果"
        var strMsg = "(resp.errCode)"
        if resp.isKind(of: PayResp.self) {
            
        }
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case 0 :
                print("支付成功")
//                NSNotificationCenter.defaultCenter().postNotificationName(WXPaySuccessNotification, object: nil)
            default:
                strMsg = "支付失败，请您重新支付!"
                print("retcode = (resp.errCode), retstr = (resp.errStr)")
            }
        }
        let alert = UIAlertView(title: nil, message: strMsg, delegate: nil, cancelButtonTitle: "好的")
        alert.show()
    }
}

