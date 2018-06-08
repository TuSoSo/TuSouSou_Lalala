//
//  XL_GGXQViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/13.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//
//广告详情
import UIKit

class XL_GGXQViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var urlstring: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urlstring)
        let request = NSURLRequest(url: NSURL(string: urlstring!)! as URL)
        webView.loadRequest(request as URLRequest)
        
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
