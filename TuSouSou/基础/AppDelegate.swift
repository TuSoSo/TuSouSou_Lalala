//
//  AppDelegate.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/2/27.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        取得当前版本号
        let infoDic = Bundle.main.infoDictionary
        let currentAppVersion = infoDic! ["CFBundleShortVersionString"] as! String
//        取得之前版本号
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        print("当前版本号：\(currentAppVersion)\n原来版本号：\(String(describing: appVersion))")
        
//        如果appVersion 为nil 则为第一次启动；若appVersion 不等于 currenAppVersion 则为更新了
        if appVersion == nil || appVersion != currentAppVersion {
//            保存现在版本号
            userDefaults.set(currentAppVersion, forKey: "appVersion")
            let guideVc : XL_GuideViewController! = storyboard.instantiateViewController(withIdentifier: "GuideViewController") as! XL_GuideViewController
            
            self.window?.rootViewController = guideVc
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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


}

