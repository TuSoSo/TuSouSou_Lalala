//
//  ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/2/27.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

let Scheme = "http://"
let AppName = "/stockmgr"
let apath  =  "/api/rest/1.0"
let JuyuwangIP = UserDefaults.value(forKey: "JuYuWang")
let BizMethod = "/sys/login"
let QianWaiWangIP = "www.yaopandian.com"
let urlString = "\(Scheme)\(QianWaiWangIP)\(AppName)\(apath)\(BizMethod)"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let params = ["loginName":"xlzz","password":"123456"]
//
//        print(urlString)
//        NetworkTools.shardTools.request(method: .Post, urlString: urlString, parameters: params as AnyObject?) { (responseObject, error) in
//
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            guard (responseObject as [String : AnyObject]?) != nil else{
//
//                return
//            }
//
//            print(responseObject!)
//
//        }
//
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

