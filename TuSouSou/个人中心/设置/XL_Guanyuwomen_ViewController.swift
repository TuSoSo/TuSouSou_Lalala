//
//  XL_Guanyuwomen_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/4.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_Guanyuwomen_ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "关于我们"
        let newString = "http://www.tusousouxr.com/tssweb/aboutus"
        let uul = URL(string: String(format: "%@",newString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
        let request = NSURLRequest(url: uul!)
        self.webView.loadRequest(request as URLRequest)
        // Do any additional setup after loading the view.
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
