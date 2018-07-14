//
//  XL_PSYweizhi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/7/14.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_PSYweizhi_ViewController: UIViewController,UIWebViewDelegate {

    var longitudeJi = ""
    var latitudeJi = ""
    var longitudeShou = ""
    var latitudeShou = ""
    var longitudePost = ""
    var latitudePost = ""
    
    @IBOutlet weak var wenview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        web()
        // Do any additional setup after loading the view.
    }
    func web() {
        let newString = "\(TupianUrl)/tssweb/static/tusousou/orderMap2.jsp"
        let uul = URL(string: String(format: "%@",newString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
        wenview.delegate = self
        wenview.isUserInteractionEnabled = true
        let request = NSURLRequest(url: uul!)
        wenview.loadRequest(request as URLRequest)
    }
    // MARK: 绑定JS交互事件
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let s = longitudeJi + "," + latitudeJi + "," + longitudeShou + "," + latitudeShou + "," + longitudePost + "," + latitudePost + "," + "寄(取)件位置" + "," + "收件位置" + "," + "配送员位置";
        wenview.stringByEvaluatingJavaScript(from: String(format: "javascript:addSpot('%@')", s))
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
