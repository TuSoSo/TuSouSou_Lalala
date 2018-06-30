//
//  XL_QD_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/30.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_QD_ViewController: UIViewController,UIWebViewDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tian: UILabel!
    var isSign = "0" //是否已签到 1shi 2 fou
    var lotteryNmber = 0 // 剩余抽奖次数
    var isAuthentic = 0 //是否实名认证
    var xuyaosousoubi:Float = 0 //抽奖所用飕飕币
    var xianyouSousoubi:Float = 0
    
    var mfLotteryNmber = 0 // 免费次数
    
    var diyi = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "签到"
        jiekou()
    }
    func web() {
        let newString = "\(sanfangUrl)/lotterys/dialAward.jsp"
        let uul = URL(string: String(format: "%@",newString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
        self.webView.delegate = self
        self.webView.isUserInteractionEnabled = true
        self.webView.scrollView.isUserInteractionEnabled = true
        let top1 = UIGestureRecognizer(target: self, action: nil)
        top1.delegate = self
        self.webView.scrollView.addGestureRecognizer(top1)
        let request = NSURLRequest(url: uul!)
        self.webView.loadRequest(request as URLRequest)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        dianjiWebView()
        return true
    }
    // MARK: 绑定JS交互事件
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.lotteryNmber > 0 {
            let userId:String = userDefaults.value(forKey: "userId") as! String
            let s = userId + "," + "1"
            self.webView.stringByEvaluatingJavaScript(from: String(format: "javascript:javacalljswithargs('%@')", s))
            jiekou()
        }
    }
func dianjiWebView() {
        if self.mfLotteryNmber > 0 {
            youcishu()
        }else{
            if isAuthentic == 2 { // 是否实名认证 1是2否
                //跳实名认证
            }else{
                //弹出需要使用飕飕币
                if lotteryNmber > 0 {
                    
                    let alertController = UIAlertController(title: "温馨提示", message: "您确定使用\(xuyaosousoubi)飕飕币用来抽奖?",preferredStyle: .alert)
                
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let QuedingAction = UIAlertAction(title: "确定", style: .default) { (ss) in
                        //飕飕币接口 判断 飕飕币是否够
                        //如果够 调这个。  不够 提示飕飕币不够
                        self.sousoubi_jiekou()
                        
                        }
                    alertController.addAction(cancelAction)
                    alertController.addAction(QuedingAction)
                
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    XL_waringBox().warningBoxModeIndeterminate(message: "今天您已经没有次数了哟～", view: self.view)
                }
            }
        }
    }
    func youcishu() {
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let s = userId + "," + "1"
        self.webView.stringByEvaluatingJavaScript(from: String(format: "javascript:javacalljswithargs('%@')", s))
        jiekou()
    }
    func meicishu() {
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let s = userId + "," + "2"
        self.webView.stringByEvaluatingJavaScript(from: String(format: "javascript:javacalljswithargs('%@')", s))
        jiekou()
    }
    func jiekou() {
        let method = "/mall/signHome"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!]
        XL_waringBox().warningBoxModeIndeterminate(message: "查询中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.isSign = data["isSign"] as! String
                self.lotteryNmber = data["lotteryNmber"] as! Int
                self.isAuthentic = data["isAuthentic"] as! Int
                self.tian.text = String(format: "%d", data["continuousSign"] as! Int)
                self.mfLotteryNmber = data["mfLotteryNmber"] as! Int
                if self.isSign == "1" {
                    self.button.isEnabled = false
                }
                self.xuyaosousoubi = Float(data["ssAmount"] as! Int)
                if self.diyi == 1 {
                   self.diyi = 2
                    self.web()
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
    func sousoubi_jiekou() {
        let method = "/account/find"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let  data = (res as! [String: Any])["data"] as! [String:Any]
                self.xianyouSousoubi = Float(self.preciseDecimal(x: data["ssMoney"] as! String, p: 4))!
                if self.xuyaosousoubi < self.xianyouSousoubi {
                    self.meicishu()
                }else{
                    XL_waringBox().warningBoxModeText(message: "飕飕币不足，不能抽奖哟～", view: self.view)
                }
            }
        }) { (error) in
            print(error)
        }
    }
    func preciseDecimal(x : String, p : Int) -> String {
        //        为了安全要判空
        if (Double(x) != nil) {
            //         四舍五入
            let decimalNumberHandle : NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode(rawValue: 0)!, scale: Int16(p), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let decimaleNumber : NSDecimalNumber = NSDecimalNumber(value: Double(x)!)
            let resultNumber : NSDecimalNumber = decimaleNumber.rounding(accordingToBehavior: decimalNumberHandle)
            //          生成需要精确的小数点格式，
            //          比如精确到小数点第3位，格式为“0.000”；精确到小数点第4位，格式为“0.0000”；
            //          也就是说精确到第几位，小数点后面就有几个“0”
            var formatterString : String = "0."
            let count : Int = (p < 0 ? 0 : p)
            for _ in 0 ..< count {
                formatterString.append("0")
            }
            let formatter : NumberFormatter = NumberFormatter()
            //      设置生成好的格式，NSNumberFormatter 对象会按精确度自动四舍五入
            formatter.positiveFormat = formatterString
            //          然后把这个number 对象格式化成我们需要的格式，
            //          最后以string 类型返回结果。
            return formatter.string(from: resultNumber)!
        }
        return "0"
    }
    @IBAction func qiandao(_ sender: Any) {
        let method = "/mall/sign"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!]
        XL_waringBox().warningBoxModeIndeterminate(message: "签到中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                let ssMoney = data["ssMoney"] as! Double
               XL_waringBox().warningBoxModeText(message: "签到成功，获得\(ssMoney)飕飕币！", view: self.view)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
