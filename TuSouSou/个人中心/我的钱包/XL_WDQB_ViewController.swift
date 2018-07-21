//
//  XL_WDQB_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDQB_ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var shangView: UIView!
    var keyBoardisHidden = true
    var shuruDic : [String:String] = [:]
    //提现最小飕飕币
    var minimumAmount:Double = 0.0
    
    
    //shangView 中的东西
    var YuE = "0.00"
    var SouSouBi = "0.0000"
    var XiaoShou = "0.00"
    var isPass = 0
    //zhongjianView
    var Mon = UIButton()
    var zhou = UIButton()
    var jinrisousoubi = UILabel()
    var ZY = 0
    // 转花钱
    var tichengzhuanhua = UILabel()
    var tidaozhuanhua = UILabel()
    var zhuanhua:String = "0"
    
    var ZhiWei = 0
    //隐藏
    var yinying = UIView()
    var ZhuanrangView = UIView()
    var chongzhiView = UIView()
    var zhiImageView = UIImageView()
    var weiImageView = UIImageView()
    var ZHIWEI = 0 //1 zhifu 2 weixin
    var chongzhihjiangli = ""
    var shouxufei = ""
    var tixianyue = UIView()
    var tichengxianjinView = UIView()
    var tixianView = UIView()
    
    //折线图
    var aaChartView = AAChartView()
    var hengArr:[String] = []
    var shuArr:[NSDecimalNumber] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zhexiantu()
        self.title = "我的钱包"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisShow(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        let name = Notification.Name(rawValue: "支付成功")
        NotificationCenter.default.addObserver(self, selector: #selector(chenggongle(notification:)), name: name, object:  nil)
        zhongjianUI()
        youAnniu()
        qiye()
    }
    @objc func chenggongle(notification:NSNotification) {
        //jiemianshuaxin
        self.youhui()
    }
    @objc func keyboardWillShow(notification:NSNotification) {
        keyBoardisHidden = false
        //得到键盘frame
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            if UIDevice.current.isX() {
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve), animations: {
                                
                                self.view.frame = CGRect(x: 0, y: -100, width: self.view.frame.width, height: self.view.frame.height)
                                
                }, completion: nil)
            }else {
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve), animations: {
                                
                                self.view.frame = CGRect(x: 0, y:-80, width: self.view.frame.width, height: self.view.frame.height)
                                
                }, completion: nil)
            }
        }
        
    }
    @objc func keyboardDidHide(notification:NSNotification) {
        keyBoardisHidden = true
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        //得到键盘frame
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            if UIDevice.current.isX() {
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve), animations: {
                                
                                self.view.frame = CGRect(x: 0, y: 88, width: self.view.frame.width, height: self.view.frame.height)
                                
                }, completion: nil)
            }else {
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve), animations: {
                                
                                self.view.frame = CGRect(x: 0, y:64, width: self.view.frame.width, height: self.view.frame.height)
                                
                }, completion: nil)
            }
        }
    }
    func shangViewUI() {
        
        for VV:UIView in shangView.subviews {
            if VV.tag == 1001 || VV.tag == 1002 || VV.tag == 1003 {
                VV.removeFromSuperview()
            }
        }
        var YuEView = UIView(frame: CGRect(x: 0, y: 0, width: Width/4, height: 180))
        var SouSoubiView = UIView(frame: CGRect(x: Width/4, y: 0, width: Width/2, height: 180))
        var XiaoShouView = UIView(frame: CGRect(x: Width*3/4, y: 0, width: Width/4, height: 180))
        YuEView.tag = 1001
        SouSoubiView.tag = 1002
        XiaoShouView.tag = 1003
        if isPass != 4 {//如果不是企业
            YuEView = UIView(frame: CGRect(x: 0, y: 0, width: Width/3, height: 180))
            SouSoubiView = UIView(frame: CGRect(x: Width/3, y: 0, width: Width*2/3, height: 180))
            XiaoShouView = UIView(frame: CGRect(x: Width*4/4, y: 0, width: 0, height: 180))
            YuEView.tag = 1001
            SouSoubiView.tag = 1002
            XiaoShouView.tag = 1003
        }
        YuEView.backgroundColor = UIColor.clear
        qian(title: "\(YuE)", Iview: YuEView)
        let yue = UILabel(frame: CGRect(x: 0, y: YuEView.frame.size.height - 44, width: YuEView.frame.size.width, height: 44))
        yue.font = UIFont.systemFont(ofSize: 16)
        yue.text = "当前余额"
        yue.textColor = UIColor.white
        yue.textAlignment = .center
        YuEView.addSubview(yue)
        shangView.addSubview(YuEView)
        
        SouSoubiView.backgroundColor = UIColor.clear
        qian(title: "\(SouSouBi)", Iview: SouSoubiView)
        let sousoubi = UILabel(frame: CGRect(x: 0, y: SouSoubiView.frame.size.height - 44, width: SouSoubiView.frame.size.width, height: 44))
        sousoubi.font = UIFont.systemFont(ofSize: 16)
        sousoubi.textAlignment = .center
        sousoubi.text = "飕飕币数量"
        sousoubi.textColor = UIColor.white
        SouSoubiView.addSubview(sousoubi)
        shangView.addSubview(SouSoubiView)
        
        XiaoShouView.backgroundColor = UIColor.clear
        qian(title: "\(XiaoShou)", Iview: XiaoShouView)
        let xiaoshou = UILabel(frame: CGRect(x: 0, y: XiaoShouView.frame.size.height - 44, width: XiaoShouView.frame.size.width, height: 44))
        xiaoshou.font = UIFont.systemFont(ofSize: 16)
        xiaoshou.text = "销售金额"
        xiaoshou.textColor = UIColor.white
        xiaoshou.textAlignment = .center
        XiaoShouView.addSubview(xiaoshou)
        shangView.addSubview(XiaoShouView)
        
        //        let yuechongzhi = UIButton(frame: CGRect(x: 0, y: Height/3 - 66, width: YuEView.frame.maxX, height: 44))
        let yuechongzhiView = UIView(frame: CGRect(x: 0, y: 184, width: YuEView.frame.maxX, height: 44))
        shangView.addSubview(yuechongzhiView)
        let yuechongzhi = UIButton(frame: CGRect(x: 20, y: 4, width: yuechongzhiView.frame.size.width - 40, height: 32))
        //        yuechongzhi.center = CGPoint(x: yuechongzhiView.frame.size.width/2, y: yuechongzhiView.frame.size.height/2)
        yuechongzhi.layer.borderColor = UIColor.white.cgColor//设置边框颜色
        yuechongzhi.layer.borderWidth = 1.0;//设置边框宽度
        yuechongzhi.setTitle("充值", for: .normal)
        yuechongzhi.setTitleColor(UIColor.white, for: .normal)
        yuechongzhi.backgroundColor = UIColor.clear
        yuechongzhi.addTarget(self, action: #selector(Yuechongzhi), for: .touchUpInside)
        yuechongzhiView.addSubview(yuechongzhi)
        
        //        let sousoubizhuanrang = UIButton(frame: CGRect(x: YuEView.frame.maxX, y: Height/3 - 66, width: YuEView.frame.maxX, height: 44))
        let sousoubizhuanrangView = UIView(frame:CGRect(x: YuEView.frame.maxX, y: 184, width: YuEView.frame.maxX, height: 44))
        shangView.addSubview(sousoubizhuanrangView)
        let sousoubizhuanrang = UIButton(frame: CGRect(x: 20, y: 4, width: sousoubizhuanrangView.frame.size.width - 40, height: 32))
        sousoubizhuanrang.center = CGPoint(x: sousoubizhuanrangView.frame.size.width/2, y: sousoubizhuanrangView.frame.size.height/2)
        sousoubizhuanrang.layer.borderColor = UIColor.white.cgColor//设置边框颜色
        sousoubizhuanrang.layer.borderWidth = 1.0;//设置边框宽度
        sousoubizhuanrang.setTitle("转让", for: .normal)
        sousoubizhuanrang.setTitleColor(UIColor.white, for: .normal)
        sousoubizhuanrang.backgroundColor = UIColor.clear
        sousoubizhuanrang.addTarget(self, action: #selector(Sousoubizhuanrang), for: .touchUpInside)
        sousoubizhuanrangView.addSubview(sousoubizhuanrang)
        
        //        let sousoubitixian = UIButton(frame: CGRect(x: YuEView.frame.maxX*2, y: Height/3 - 66, width: YuEView.frame.maxX, height: 44))
        let sousoubitixianView = UIView(frame: CGRect(x: YuEView.frame.maxX*2, y: 184, width: YuEView.frame.maxX, height: 44))
        shangView.addSubview(sousoubitixianView)
        let sousoubitixian = UIButton(frame: CGRect(x: 20, y: 4, width: sousoubitixianView.frame.size.width - 40, height: 32))
        sousoubitixian.center = CGPoint(x: sousoubitixianView.frame.size.width/2, y: sousoubitixianView.frame.size.height/2)
        sousoubitixian.layer.borderColor = UIColor.white.cgColor//设置边框颜色
        sousoubitixian.layer.borderWidth = 1.0;//设置边框宽度
        sousoubitixian.setTitle("提现", for: .normal)
        sousoubitixian.setTitleColor(UIColor.white, for: .normal)
        sousoubitixian.backgroundColor = UIColor.clear
        sousoubitixian.addTarget(self, action: #selector(Sousoubitixian), for: .touchUpInside)
        sousoubitixianView.addSubview(sousoubitixian)
        
        //        let xiaoshoutixian = UIButton(frame: CGRect(x: YuEView.frame.maxX*3, y: Height/3 - 66, width: YuEView.frame.maxX, height: 44))
        let xiaoshoutixianView = UIView(frame: CGRect(x: YuEView.frame.maxX*3, y: 184, width: YuEView.frame.maxX, height: 44))
        shangView.addSubview(xiaoshoutixianView)
        let xiaoshoutixian = UIButton(frame: CGRect(x: 20, y: 4, width: xiaoshoutixianView.frame.size.width - 40, height: 32))
        xiaoshoutixian.center = CGPoint(x: xiaoshoutixianView.frame.size.width/2, y: xiaoshoutixianView.frame.size.height/2)
        xiaoshoutixian.layer.borderColor = UIColor.white.cgColor//设置边框颜色
        xiaoshoutixian.layer.borderWidth = 1.0;//设置边框宽度
        xiaoshoutixian.setTitle("提现", for: .normal)
        xiaoshoutixian.setTitleColor(UIColor.white, for: .normal)
        xiaoshoutixian.backgroundColor = UIColor.clear
        xiaoshoutixian.addTarget(self, action: #selector(Xiaoshoutixian), for: .touchUpInside)
        xiaoshoutixianView.addSubview(xiaoshoutixian)
        
    }
    func zhongjianUI() {
        jinrisousoubi = UILabel(frame: CGRect(x: 16, y: shangView.frame.size.height + 8, width: Width/2, height: 40))
        jinrisousoubi.text = "今日飕飕币价格:"
        jinrisousoubi.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(jinrisousoubi)
        
        Mon = UIButton(frame: CGRect(x: Width - 100, y: shangView.frame.size.height + 8, width: 40, height: 40))
        Mon.setTitle("月", for: .normal)
        Mon.setTitleColor(UIColor.black, for: .normal)
        Mon.addTarget(self, action: #selector(dianjiyue), for: .touchUpInside)
        self.view.addSubview(Mon)
        
        zhou = UIButton(frame: CGRect(x: Width - 150, y: shangView.frame.size.height + 8, width: 40, height: 40))
        zhou.setTitle("周", for: .normal)
        zhou.setTitleColor(UIColor.orange, for: .normal)
        zhou.addTarget(self, action: #selector(dianjizhou), for: .touchUpInside)
        self.view.addSubview(zhou)
        
        ZY = 1
        zoushi(dateFlag: ZY)
    }
    func qiye() {
        let method = "/user/findUserInfo"
        let userId = userDefaults.value(forKey: "userId")
        let dicc:[String:Any] = ["userId":userId!]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.isPass = data["isPass"] as! Int
                self.youhui()
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
    func youhui() {
        let method = "/user/wallat"
        let userId = userDefaults.value(forKey: "userId")
        let dicc:[String:Any] = ["userId":userId!]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.minimumAmount = data["minimumAmount"] as! Double
                //给 YuE SouSouBi XiaoShou 赋值
                self.zhuanhua = String(format: "%.4f", data["percentage"] as! Double)
                self.jinrisousoubi.text = "今日飕飕币价格:" + " " + self.zhuanhua
                self.YuE = String(format: "%.2f", data["balance"] as! Double)
                self.SouSouBi = String(format: "%.4f", data["ssMoney"]! as! Double)
                self.XiaoShou = String(format: "%.2f", data["saleMoney"] as! Double)
                self.chongzhihjiangli = String(format: "%@",data["rechargeRule"] as! String )
                self.shouxufei = String(format: "%@",data["withdraw"] as! String )
                self.YinCangJieMian()
                self.shangViewUI()
            }else{
                XL_waringBox().warningBoxModeText(message: "退款次数不足", view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    @objc func dianjizhou() {
        zhou.setTitleColor(UIColor.orange, for: .normal)
        Mon.setTitleColor(UIColor.black, for: .normal)
        ZY = 1
        zoushi(dateFlag: ZY)
    }
    @objc func dianjiyue() {
        Mon.setTitleColor(UIColor.orange, for: .normal)
        zhou.setTitleColor(UIColor.black, for: .normal)
        ZY = 2
        zoushi(dateFlag: ZY)
    }
    func zoushi(dateFlag:Int) {
        let method = "/user/ssbExchange"
        let dicc:[String:Any] = ["dateFlag":dateFlag]// 1 周 2 月
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                
                let ratioList  = data["ratioList"] as! [[String: Any]]
                self.hengArr = []
                self.shuArr = []
                for iii in 0..<ratioList.count {
                    self.hengArr.append(ratioList[iii]["day"]! as! String)
                    let shu = ratioList[iii]["percentage"]! as! String
                    //                    let Y:Float = Float(shu)!
                    let Y:NSDecimalNumber = NSDecimalNumber(string: shu)
                    
                    print(shu)
                    print(Y)
                    self.shuArr.append(Y)
                    print(self.shuArr)
                }
                
                let chartModel = AAChartModel.init()
                    .chartType(AAChartType.Line)
                    .title("飕飕币兑换比率走势图")
                    .inverted(false)
                    .yAxisTitle("飕飕币兑换比率")
                    .legendEnabled(false)
                    .tooltipValueSuffix("")
                    .categories(self.hengArr)
                    .colorsTheme(["#fe117c"])//主题颜色数组
                    .series([
                        AASeriesElement()
                            .name("飕飕币兑换比率")
                            .data(self.shuArr)
                            .toDic()!,])
                self.aaChartView.aa_refreshChartWholeContentWithChartModel(chartModel)
                //ratioList
                // percentage    day
            }else{
                XL_waringBox().warningBoxModeText(message: "退款次数不足", view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func qian(title: String, Iview: UIView) {
        let GuoDu = XL_PaoMaView(frame: CGRect(x: 0, y: 0, width: Iview.frame.size.width, height: Iview.frame.size.height), title: title,color:UIColor.white, Font: 30, xxx: false)
        Iview.addSubview(GuoDu)
    }
    func hou(title: String, Iview: UIView) {
        let GuoDu = XL_PaoMaView(frame: CGRect(x: 0, y: 0, width: Iview.frame.size.width, height: Iview.frame.size.height), title: title,color:UIColor.black, Font: 16, xxx: false)
        Iview.addSubview(GuoDu)
    }
    func youAnniu() {
        let item = UIBarButtonItem(title:"账单",style: .plain,target:self,action:#selector(YouActio))
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio() {
        if keyBoardisHidden == false {
            self.view.endEditing(true)
        }else{
            if yinying.isHidden == false {
                yyyyy()
            }else{
                let WDXX: XL_WDzhangdan_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdzhangdan") as? XL_WDzhangdan_ViewController
                self.navigationController?.pushViewController(WDXX!, animated: true)
            }
        }
    }
    @objc func Yuechongzhi() {
        print("1")
        chongzhiViewInit()
        yinying.isHidden = false
    }
    @objc func Sousoubizhuanrang() {
        print("2")
        ZhuanrangViewInit()
        yinying.isHidden = false
    }
    @objc func Sousoubitixian() {
        print("3")
        tanchu()
    }
    @objc func Xiaoshoutixian() {
        print("4")
        tixianviewInit()
        yinying.isHidden = false
    }
    func tanchu()  {
        self.view.endEditing(true)
        let alertController = UIAlertController(title: "提现方式", message: "您可以通过以下方式实现提现",
                                                preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let yueAction = UIAlertAction(title: "提现到余额", style: .default) { (ss) in
            self.tixianyueInit()
            self.yinying.isHidden = false
        }
        let zhiweiAction = UIAlertAction(title: "提现到支付宝或微信", style: .default) { (ss) in
            self.tichengxianjinViewInit()
            self.yinying.isHidden = false
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(yueAction)
        alertController.addAction(zhiweiAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func YinCangJieMian() {
        self.view.isUserInteractionEnabled = true
        yinying = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        yinying.alpha = 0.8
        yinying.backgroundColor = UIColor.black
        yinying.isHidden = true
        let yyyy = UITapGestureRecognizer(target: self, action: #selector(yyyyy))
        yinying.addGestureRecognizer(yyyy)
        yinying.isUserInteractionEnabled = true
        self.view.addSubview(yinying)
    }
    func ZhuanrangViewInit() {
        //转让
        let Shoujihao = UILabel(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 24))
        Shoujihao.font = UIFont.systemFont(ofSize: 15)
        Shoujihao.textColor = UIColor.darkGray
        Shoujihao.text = "输入转让手机号:"
        
        let shoujihao = UITextField(frame: CGRect(x: 20, y: 56, width: Width - 40, height: 32))
        shoujihao.tag = 12
        shoujihao.textAlignment = .center
        shoujihao.keyboardType = .numberPad
        shoujihao.placeholder = "请输入转让手机号"
        shoujihao.delegate = self
        
        let Zhuanrangsousoubi = UILabel(frame: CGRect(x: 20, y: 96, width: Width - 40, height: 24))
        Zhuanrangsousoubi.font = UIFont.systemFont(ofSize: 15)
        Zhuanrangsousoubi.textColor = UIColor.darkGray
        Zhuanrangsousoubi.text = "输入转让飕飕币:"
        
        let zhuanrangsousoubi = UITextField(frame: CGRect(x: 20, y: 136, width: Width - 40, height: 32))
        zhuanrangsousoubi.tag = 11
        zhuanrangsousoubi.textAlignment = .center
        zhuanrangsousoubi.keyboardType = .decimalPad
        zhuanrangsousoubi.placeholder = "请输入转让飕飕币"
        zhuanrangsousoubi.delegate = self
        
        let zhuanquxiao = UILabel(frame: CGRect(x: Width - 150 , y: 186, width: 50, height: 30))
        zhuanquxiao.text = "取消"
        zhuanquxiao.textColor = UIColor.orange
        let zhuanqu = UITapGestureRecognizer(target: self, action: #selector(Zhuanquxiao))
        zhuanquxiao.addGestureRecognizer(zhuanqu)
        zhuanquxiao.isUserInteractionEnabled = true
        
        let zhuanqueding = UILabel(frame: CGRect(x: Width - 80 , y: 186, width: 50, height: 30))
        zhuanqueding.text = "确定"
        zhuanqueding.textColor = UIColor.orange
        let zhuanque = UITapGestureRecognizer(target: self, action: #selector(Zhuanqueding))
        zhuanqueding.addGestureRecognizer(zhuanque)
        zhuanqueding.isUserInteractionEnabled = true
        
        ZhuanrangView = UIView(frame: CGRect(x: 0, y: Height/3, width: Width, height: Height*2/3))
        ZhuanrangView.tag = 10090
        ZhuanrangView.backgroundColor = UIColor.white
        ZhuanrangView.addSubview(Shoujihao)
        ZhuanrangView.addSubview(shoujihao)
        ZhuanrangView.addSubview(zhuanrangsousoubi)
        ZhuanrangView.addSubview(Zhuanrangsousoubi)
        ZhuanrangView.addSubview(zhuanquxiao)
        ZhuanrangView.addSubview(zhuanqueding)
        //        ZhuanrangView.isHidden = true
        self.view.addSubview(ZhuanrangView)
    }
    func chongzhiViewInit() {
        //充值
        let chongzhijine = UILabel(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 24))
        chongzhijine.font = UIFont.systemFont(ofSize: 15)
        chongzhijine.textColor = UIColor.darkGray
        chongzhijine.text = "输入充值金额:"
        
        let shurukuang = UITextField(frame: CGRect(x: 20, y: 56, width: Width - 40, height: 32))
        shurukuang.tag = 10
        shurukuang.textAlignment = .center
        shurukuang.keyboardType = .decimalPad
        shurukuang.placeholder = "请输入充值金额"
        shurukuang.delegate = self
        
        let xuanzezhifu = UILabel(frame: CGRect(x: 20, y: 96, width: Width, height: 24))
        xuanzezhifu.font = UIFont.systemFont(ofSize: 15)
        xuanzezhifu.text = "选择支付方式:"
        xuanzezhifu.textColor = UIColor.darkGray
        
        let zhiwei = zhizhiweiwei(xx: 1)
        
        let chongquxiao = UILabel(frame: CGRect(x: Width - 150 , y: 232, width: 50, height: 30))
        chongquxiao.text = "取消"
        chongquxiao.textColor = UIColor.orange
        let chongqu = UITapGestureRecognizer(target: self, action: #selector(Chongquxiao))
        chongquxiao.addGestureRecognizer(chongqu)
        chongquxiao.isUserInteractionEnabled = true
        
        let chongqueding = UILabel(frame: CGRect(x: Width - 80 , y: 232, width: 50, height: 30))
        chongqueding.text = "确定"
        chongqueding.textColor = UIColor.orange
        let chongque = UITapGestureRecognizer(target: self, action: #selector(Chongqueding))
        chongqueding.addGestureRecognizer(chongque)
        chongqueding.isUserInteractionEnabled = true
        
        let chongzhengce = UIView(frame: CGRect(x: 20, y: 278, width: Width - 40, height: 30))
        hou(title: chongzhihjiangli, Iview: chongzhengce)
        
        chongzhiView = UIView(frame: CGRect(x: 0, y: Height/3, width: Width, height: Height*2/3))
        chongzhiView.tag = 10089
        chongzhiView.backgroundColor = UIColor.white
        chongzhiView.addSubview(chongzhijine)
        chongzhiView.addSubview(shurukuang)
        chongzhiView.addSubview(xuanzezhifu)
        chongzhiView.addSubview(zhiwei)
        chongzhiView.addSubview(chongquxiao)
        chongzhiView.addSubview(chongqueding)
        //    chongzhiView.isHidden = true
        chongzhiView.addSubview(chongzhengce)
        self.view.addSubview(chongzhiView)
    }
    func tixianyueInit() {
        //飕飕币提现到余额
        let tidaoyue = UILabel(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 24))
        tidaoyue.font = UIFont.systemFont(ofSize: 15)
        tidaoyue.textColor = UIColor.darkGray
        tidaoyue.text = "输入提现飕飕币:"
        
        let tidaoyueTF = UITextField(frame: CGRect(x: 20, y: 56, width: Width - 40, height: 32))
        tidaoyueTF.tag = 13
        tidaoyueTF.textAlignment = .center
        tidaoyueTF.keyboardType = .decimalPad
        tidaoyueTF.placeholder = "请输入提现飕飕币"
        tidaoyueTF.delegate = self
        
        tidaozhuanhua = UILabel(frame: CGRect(x: 20, y: 96, width: Width, height: 32))
        tidaozhuanhua.text = "飕飕币转换成余额: ¥0.00"
        tidaozhuanhua.textColor = UIColor.darkGray
        
        let tidaoquxiao = UILabel(frame: CGRect(x: Width - 150 , y: 144, width: 50, height: 30))
        tidaoquxiao.text = "取消"
        tidaoquxiao.textColor = UIColor.orange
        let tidao = UITapGestureRecognizer(target: self, action: #selector(Tidaoquxiao))
        tidaoquxiao.addGestureRecognizer(tidao)
        tidaoquxiao.isUserInteractionEnabled = true
        
        let tidaoqueding = UILabel(frame: CGRect(x: Width - 80 , y: 144, width: 50, height: 30))
        tidaoqueding.text = "确定"
        tidaoqueding.textColor = UIColor.orange
        let tidaoque = UITapGestureRecognizer(target: self, action: #selector(Tidaoqueding))
        tidaoqueding.addGestureRecognizer(tidaoque)
        tidaoqueding.isUserInteractionEnabled = true
        
        tixianyue = UIView(frame: CGRect(x: 0, y: Height/3, width: Width, height: Height*2/3))
        tixianyue.tag = 10088
        tixianyue.backgroundColor = UIColor.white
        tixianyue.addSubview(tidaoyue)
        tixianyue.addSubview(tidaoyueTF)
        tixianyue.addSubview(tidaozhuanhua)
        tixianyue.addSubview(tidaoquxiao)
        tixianyue.addSubview(tidaoqueding)
        //        tixianyue.isHidden = true
        self.view.addSubview(tixianyue)
    }
    func tichengxianjinViewInit() {
        //提现成现金
        let tichengxianjin = UILabel(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 24))
        tichengxianjin.font = UIFont.systemFont(ofSize: 15)
        tichengxianjin.textColor = UIColor.darkGray
        tichengxianjin.text = "输入提现飕飕币:"
        
        let tichengxianjinTF = UITextField(frame: CGRect(x: 20, y: 56, width: Width - 40, height: 32))
        tichengxianjinTF.tag = 14
        tichengxianjinTF.textAlignment = .center
        tichengxianjinTF.keyboardType = .decimalPad
        tichengxianjinTF.placeholder = "最小提现额度\(minimumAmount)个飕飕币"
        tichengxianjinTF.delegate = self
        
        let zhiwei1 = zhizhiweiwei(xx: 2)
        
        tichengzhuanhua = UILabel(frame: CGRect(x: 20, y: 96, width: Width, height: 32))
        tichengzhuanhua.text = "飕飕币转换成人民币: ¥0.00"
        tichengzhuanhua.textColor = UIColor.darkGray
        
        let shouxu = UILabel(frame: CGRect(x: 20, y: 136, width: Width, height: 24))
        shouxu.font = UIFont.systemFont(ofSize: 14)
        shouxu.textColor = UIColor.darkGray
        shouxu.text = "手续费:" + " " + shouxufei
        
        let tichengquxiao = UILabel(frame: CGRect(x: Width - 150 , y: 248, width: 50, height: 30))
        tichengquxiao.text = "取消"
        tichengquxiao.textColor = UIColor.orange
        let ticheng = UITapGestureRecognizer(target: self, action: #selector(Tichengquxiao))
        tichengquxiao.addGestureRecognizer(ticheng)
        tichengquxiao.isUserInteractionEnabled = true
        
        let tichengqueding = UILabel(frame: CGRect(x: Width - 80 , y: 248, width: 50, height: 30))
        tichengqueding.text = "确定"
        tichengqueding.textColor = UIColor.orange
        let tichengque = UITapGestureRecognizer(target: self, action: #selector(Tichengqueding))
        tichengqueding.addGestureRecognizer(tichengque)
        tichengqueding.isUserInteractionEnabled = true
        
        tichengxianjinView = UIView(frame: CGRect(x: 0, y: Height/3, width: Width, height: Height*2/3))
        tichengxianjinView.tag = 10087
        tichengxianjinView.backgroundColor = UIColor.white
        tichengxianjinView.addSubview(tichengxianjin)
        tichengxianjinView.addSubview(tichengxianjinTF)
        tichengxianjinView.addSubview(tichengzhuanhua)
        tichengxianjinView.addSubview(zhiwei1)
        tichengxianjinView.addSubview(shouxu)
        tichengxianjinView.addSubview(tichengquxiao)
        tichengxianjinView.addSubview(tichengqueding)
        //        tichengxianjinView.isHidden = true
        self.view.addSubview(tichengxianjinView)
    }
    func tixianviewInit(){
        //销售提现
        let xiaoshoutixian = UILabel(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 24))
        xiaoshoutixian.font = UIFont.systemFont(ofSize: 15)
        xiaoshoutixian.textColor = UIColor.darkGray
        xiaoshoutixian.text = "输入提现金额:"
        
        let xiaoshouTF = UITextField(frame: CGRect(x: 20, y: 56, width: Width - 40, height: 32))
        xiaoshouTF.tag = 15
        xiaoshouTF.textAlignment = .center
        xiaoshouTF.keyboardType = .decimalPad
        xiaoshouTF.placeholder = "请输入提现金额"
        xiaoshouTF.delegate = self
        
        let zhiwei2 = zhizhiweiwei(xx: 1)
        
        let xiaoshouxu = UILabel(frame: CGRect(x: 20, y: 96, width: Width, height: 24))
        xiaoshouxu.font = UIFont.systemFont(ofSize: 14)
        xiaoshouxu.textColor = UIColor.darkGray
        xiaoshouxu.text = "手续费:" + " " + shouxufei
        
        let tixianquxiao = UILabel(frame: CGRect(x: Width - 150 , y: 232, width: 50, height: 30))
        tixianquxiao.text = "取消"
        tixianquxiao.textColor = UIColor.orange
        let tixian = UITapGestureRecognizer(target: self, action: #selector(Tixianquxiao))
        tixianquxiao.addGestureRecognizer(tixian)
        tixianquxiao.isUserInteractionEnabled = true
        
        let tixianqueding = UILabel(frame: CGRect(x: Width - 80 , y: 232, width: 50, height: 30))
        tixianqueding.text = "确定"
        tixianqueding.textColor = UIColor.orange
        let tixianque = UITapGestureRecognizer(target: self, action: #selector(Tixianqueding))
        tixianqueding.addGestureRecognizer(tixianque)
        tixianqueding.isUserInteractionEnabled = true
        
        tixianView = UIView(frame: CGRect(x: 0, y: Height/3, width: Width, height: Height*2/3))
        tixianView.tag = 10086
        tixianView.backgroundColor = UIColor.white
        tixianView.addSubview(xiaoshoutixian)
        tixianView.addSubview(xiaoshouTF)
        tixianView.addSubview(xiaoshouxu)
        tixianView.addSubview(zhiwei2)
        tixianView.addSubview(tixianquxiao)
        tixianView.addSubview(tixianqueding)
        //        tixianView.isHidden = true
        self.view.addSubview(tixianView)
    }
    func zhizhiweiwei(xx:Int) -> UIView {
        let zhiwei = UIView()
        if xx == 1 {
            zhiwei.frame = CGRect(x: 20, y: 120, width: Width - 40, height: 96)
        }else if xx == 2 {
            zhiwei.frame = CGRect(x: 20, y: 160, width: Width - 40, height: 96)
        }
        zhiwei.isUserInteractionEnabled = true
        zhiwei.isUserInteractionEnabled = true
        let zhiImage = UIImageView(frame: CGRect(x: 0, y: 16, width: 24, height: 24))
        zhiImage.image = UIImage(named: "支付-支付宝")
        zhiwei.addSubview(zhiImage)
        
        let weiImage = UIImageView(frame: CGRect(x: 0, y: 56, width: 24, height: 24))
        weiImage.image = UIImage(named: "支付-微信")
        zhiwei.addSubview(weiImage)
        
        let zhiName = UILabel(frame: CGRect(x: 40, y: 16, width: 150, height: 24))
        zhiName.font = UIFont.systemFont(ofSize: 15)
        zhiName.text = "支付宝支付"
        zhiwei.addSubview(zhiName)
        
        let weiName = UILabel(frame: CGRect(x: 40, y: 56, width: 150, height: 24))
        weiName.font = UIFont.systemFont(ofSize: 15)
        weiName.text = "微信支付"
        zhiwei.addSubview(weiName)
        
        zhiImageView = UIImageView(frame: CGRect(x: zhiwei.frame.size.width - 24, y: 16, width: 24, height: 24))
        zhiImageView.image = UIImage(named: "圆圈未选中")
        let top1 = UITapGestureRecognizer(target: self, action: #selector(ZhiImageView))
        zhiImageView.addGestureRecognizer(top1)
        zhiImageView.isUserInteractionEnabled = true
        zhiwei.addSubview(zhiImageView)
        
        weiImageView = UIImageView(frame: CGRect(x: zhiwei.frame.size.width - 24, y: 56, width: 24, height: 24))
        weiImageView.image = UIImage(named: "圆圈未选中")
        let top2 = UITapGestureRecognizer(target: self, action: #selector(WeiImageView))
        weiImageView.addGestureRecognizer(top2)
        weiImageView.isUserInteractionEnabled = true
        zhiwei.addSubview(weiImageView)
        
        return zhiwei
    }
    @objc func yyyyy() {
        if keyBoardisHidden == true {
            yinying.isHidden = true
            for view in self.view.subviews{
                if view.tag == 10086 || view.tag == 10087 || view.tag == 10088 || view.tag == 10089 || view.tag == 10090 {
                    view.removeFromSuperview()
                }
            }
            ZHIWEI = 0
            tichengzhuanhua.text = "飕飕币转换成人民币: ¥0.00"
            tidaozhuanhua.text = "飕飕币转换成余额: ¥0.00"
        }else{
            self.view.endEditing(true)
        }
    }
    @objc func Tixianqueding() {
        //销售提现
        if keyBoardisHidden == false {
            yyyyy()
        }else{
            if nil != self.shuruDic["15"] && self.shuruDic["15"]!.count > 0 {
                
                if self.ZHIWEI != 0{
                    yyyyy()
                    let time: TimeInterval = 0.3
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        //code
                        print("销售提现")
                        var lalala = ""
                        
                        lalala = self.shuruDic["15"]!
                        
                        // 跳页 传值 完善信息 图片上传 判断支付mi码
                        
                        if userDefaults.value(forKey: "isPayPassWord") as! Int == 2 {
                            // 跳 设置支付密码
                            self.tiaoye(rukou: "1")
                        }else{
                            if nil == userDefaults.value(forKey: "xemmzf") || !(userDefaults.value(forKey: "xemmzf") as! Bool) {
                                // 不免密 跳验证密码
                                if  userDefaults.value(forKey: "isPayPassWord") as! Int == 1{
                                    //输入支付密码验证后再跳页
                                    let payAlert = PayAlert(frame: UIScreen.main.bounds, jineHide: true, jine: "",isMove:true)
                                    payAlert.tag = 909090
                                    payAlert.show(view: self.view)
                                    payAlert.completeBlock = ({(password:String) -> Void in
                                        //调验证支付吗接口
                                        self.yanzhengzhifumima(password: password, lalala: lalala, withdrawType: "3")
                                        print("输入的密码是:" + password)
                                    })
                                }
                            }else{
                                //直接接口
                                self.TXVIEW(lalala: lalala, withdrawType: "3")
                            }
                        }
                    }
                }else{
                    XL_waringBox().warningBoxModeText(message: "请选择提现方式!", view: self.view)
                }
            }else{
                XL_waringBox().warningBoxModeText(message: "提现金额要大于0哟～", view: self.view)
            }
        }
    }
    func yanzhengzhifumima(password:String,lalala:String,withdrawType:String) {
        let method = "/user/verifyPayPassword"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"payPassword":password]
        XL_waringBox().warningBoxModeIndeterminate(message: "密码验证中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                //                self.tiaoye(rukou: "1")
                self.TXVIEW(lalala: lalala, withdrawType: withdrawType)
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
    func TXVIEW(lalala:String,withdrawType:String) {
        /*
         userType(String):用户类型
         money(double):提现金额，
         withdrawMethod(int):提现方式（1.支付宝、2.微信）
         withdrawType(String):提现类型(1,飕飕币,2余额,3销售额)
         */
        var userType = "1"
        let lalala = lalala
        if isPass == 4 {
            userType = "2"
        }
        self.yyyyy()
        let wwddxq: XL_TX_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tx") as? XL_TX_ViewController
        wwddxq?.userType = userType
        wwddxq?.lalala = lalala
        wwddxq?.withdrawMethod = String(format: "%d", ZHIWEI)
        wwddxq?.withdrawType = withdrawType
        self.navigationController?.pushViewController(wwddxq!, animated: true)
    }
    func tiaoye(rukou:String) {
        let AnQuanSZ: XL_WHMM_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "whmm") as? XL_WHMM_ViewController
        AnQuanSZ?.rukou = rukou
        self.navigationController?.pushViewController(AnQuanSZ!, animated: true)
    }
    @objc func Tixianquxiao() {
        yyyyy()
    }
    @objc func Tichengqueding() {
        //提成现金接口
        if keyBoardisHidden == false {
            yyyyy()
        }else{
            print("提成现金")
            if nil != self.shuruDic["14"] && self.shuruDic["14"]!.count > 0 {
                if self.ZHIWEI != 0{
                    yyyyy()
                    let time: TimeInterval = 0.3
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        //code
                        var lalala = ""
                        lalala = self.shuruDic["14"]!
                        
                        if userDefaults.value(forKey: "isPayPassWord") as! Int == 2 {
                            // 跳 设置支付密码
                            self.tiaoye(rukou: "1")
                        }else{
                            if nil == userDefaults.value(forKey: "xemmzf") || !(userDefaults.value(forKey: "xemmzf") as! Bool) {
                                // 不免密 跳验证密码
                                if  userDefaults.value(forKey: "isPayPassWord") as! Int == 1{
                                    //输入支付密码验证后再跳页
                                    let payAlert = PayAlert(frame: UIScreen.main.bounds, jineHide: true, jine: "",isMove:true)
                                    payAlert.tag = 909091
                                    payAlert.show(view: self.view)
                                    payAlert.completeBlock = ({(password:String) -> Void in
                                        //调验证支付吗接口
                                        self.yanzhengzhifumima(password: password, lalala: lalala, withdrawType: "1")
                                        print("输入的密码是:" + password)
                                    })
                                }
                            }else{
                                //直接接口
                                self.TXVIEW(lalala: lalala, withdrawType: "1")
                            }
                        }
                    }
                }else{
                    XL_waringBox().warningBoxModeText(message: "请选择提现方式!", view: self.view)
                }
            }else{
                //            XL_waringBox().warningBoxModeText(message: "飕飕币数需要大于0哟！", view: self.view)
            }
        }
    }
    @objc func Tichengquxiao() {
        yyyyy()
    }
    @objc func Tidaoqueding() {
        // 转账到余额接口
        if keyBoardisHidden == false {
            yyyyy()
        }else{
            print("转到余额确定")
            if nil != self.shuruDic["13"] && self.shuruDic["13"]!.count > 0 {
                XL_waringBox().warningBoxModeIndeterminate(message: "正在努力转帐中...", view: self.view)
                let time: TimeInterval = 0.3
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    //code
                    print("1 秒后输出")
                    var lalala = "" , phone = ""
                    lalala = self.shuruDic["13"]!
                    var userType = "1"
                    if self.isPass == 4 {
                        userType = "2"
                    }
                    let method = "/user/ssWithdrawals"
                    let userId = userDefaults.value(forKey: "userId")
                    let dicc:[String:Any] = ["userId":userId!,"turnoverType":"2","ssTurnoverCount":lalala,"phone":phone,"userType":userType]
                    XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
                        print(res)
                        XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                        if (res as! [String: Any])["code"] as! String == "0000" {
                            //                    let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                            XL_waringBox().warningBoxModeText(message: "转账成功", view: self.view)
                            self.yyyyy()
                            self.youhui()
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
            }else{
                XL_waringBox().warningBoxModeText(message: "飕飕币数需要大于0哟！", view: self.view)
            }
        }
    }
    @objc func Tidaoquxiao() {
        yyyyy()
    }
    @objc func Chongqueding() {
        //转账接口
        if keyBoardisHidden == false {
            yyyyy()
        }else{
            self.view.endEditing(true)
            if nil != self.shuruDic["10"] && self.shuruDic["10"]!.count > 0 {
                if self.ZHIWEI != 0{
                    let time: TimeInterval = 0.3
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        //code
                        print("1 秒后输出")
                        print("充值确定")
                        var lalala = ""
                        lalala = self.shuruDic["10"]!
                        let now = Date()
                        let timeInterval:TimeInterval = now.timeIntervalSince1970
                        let timeStamp = Int(timeInterval)
                        let outRefundNo = String(format: "%@%d", userDefaults.value(forKey: "userId") as! String ,timeStamp)
                        userDefaults.set(lalala, forKey: "hahaha")
                        userDefaults.set(2, forKey: "xixi")
                        if self.ZHIWEI == 1 {
                            self.zhifubaoZhiFu(string: outRefundNo, jine: lalala)
                        }else if self.ZHIWEI == 2 {
                            self.WXZhiFu(string: outRefundNo, jine: lalala)
                        }
                    }
                }else{
                    XL_waringBox().warningBoxModeText(message: "请选择支付方式！", view: self.view)
                }
            }else{
                XL_waringBox().warningBoxModeText(message: "请填写充值金额!", view: self.view)
            }
        }
    }
    func WXZhiFu(string:String,jine:String) {
        let method = "/weipay/App"
        let totalAmount = Float(jine)! * 100
        
        let dicc:[String:Any] = ["outTradeNo":string,"totalAmount":totalAmount]
        userDefaults.set(string, forKey: "dingdanhao")
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().SanFangWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            let data :[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
            self.yyyyy()
            let orderBody = XL_weixinObjc()
            orderBody.appid = data["appid"] as? String
            orderBody.noncestr = data["noncestr"] as? String
            orderBody.package = data["package"] as? String
            orderBody.partnerid = data["partnerid"] as? String
            orderBody.prepayid = data["prepayid"] as? String
            orderBody.sign = data["sign"] as? String
            orderBody.timestamp = data["timestamp"] as? String
            let req = PayReq()
            req.partnerId = orderBody.partnerid
            req.prepayId = orderBody.prepayid
            req.nonceStr = orderBody.noncestr
            req.timeStamp = UInt32(orderBody.timestamp!)!
            req.package = orderBody.package
            req.sign = orderBody.sign
            WXApi.send(req)
            
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func zhifubaoZhiFu(string:String,jine:String) {
        let method = "/AliPay/App"
        let totalAmount = Float(jine)!
        userDefaults.set(string, forKey: "dingdanhao")
        let dicc:[String:Any] = ["outTradeNo":string,"totalAmount":totalAmount]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().SanFangWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            let data :[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
            let appScheme = "TuSouSou"
            let orderString = data["orderString"] as! String
            self.yyyyy()
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme) { (resultDic) -> () in
                for (key,value) in resultDic! {
                    print("\(key) : \(value)")
                }
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
        
    }
    
    @objc func Chongquxiao() {
        yyyyy()
    }
    
    @objc func Zhuanqueding() {
        //转账接口
        print("转账确定")
        if keyBoardisHidden == false {
            yyyyy()
        }else{
            if nil != self.shuruDic["11"] && Double(self.shuruDic["11"]!)! > 0.0 {
                if nil != self.shuruDic["12"] && self.shuruDic["12"]!.isPhoneNumber() != false{
                    XL_waringBox().warningBoxModeIndeterminate(message: "正在努力转帐中...", view: self.view)
                    let time: TimeInterval = 0.3
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        //code
                        var lalala = "" , phone = ""
                        
                        
                        lalala = self.shuruDic["11"]!
                        phone = self.shuruDic["12"]!
                        var userType = "1"
                        if self.isPass == 4 {
                            userType = "2"
                        }
                        
                        let method = "/user/ssWithdrawals"
                        let userId = userDefaults.value(forKey: "userId")
                        let dicc:[String:Any] = ["userId":userId!,"turnoverType":"1","ssTurnoverCount":lalala,"phone":phone,"userType":userType]
                        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
                            print(res)
                            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                            if (res as! [String: Any])["code"] as! String == "0000" {
                                //                    let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                                XL_waringBox().warningBoxModeText(message: "转账成功", view: self.view)
                                self.yyyyy()
                                self.youhui()
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
                }else{
                    XL_waringBox().warningBoxModeText(message: "请填写正确的手机号！", view: self.view)
                }
            }else{
                XL_waringBox().warningBoxModeText(message: "飕飕币数需要大于0哟！", view: self.view)
            }
        }
    }
    @objc func Zhuanquxiao() {
        print("转账取消")
        yyyyy()
    }
    
    @objc func ZhiImageView() {
        print("点击支付")
        zhiImageView.image = UIImage(named: "圆圈选中")
        weiImageView.image = UIImage(named: "圆圈未选中")
        ZHIWEI = 1
    }
    @objc func WeiImageView() {
        print("点击微信")
        zhiImageView.image = UIImage(named: "圆圈未选中")
        weiImageView.image = UIImage(named: "圆圈选中")
        ZHIWEI = 2
    }
    func zhexiantu() {
        let chartViewWidth = Width
        let chartViewHeight = Height/2
        
        aaChartView.frame = CGRect(x:0,y:shangView.frame.size.height + 56,width:chartViewWidth,height:chartViewHeight)
        // 设置 aaChartView 的内容高度(content height)
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.view.addSubview(aaChartView)
        let chartModel = AAChartModel.init()
            .chartType(AAChartType.Line)
            .title("飕飕币兑换比率走势图")
            .inverted(false)
            .yAxisTitle("飕飕币兑换比率")
            .legendEnabled(false)
            .tooltipValueSuffix("")
            .categories([])
            .colorsTheme(["#fe117c"])//主题颜色数组
            .series([
                AASeriesElement()
                    .name("飕飕币兑换比率")
                    .data([])
                    .toDic()!,])
        /*图表视图对象调用图表模型对象,绘制最终图形*/
        aaChartView.aa_drawChartWithChartModel(chartModel)
        self.view.addSubview(aaChartView)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField.tag == 10/*充值输入框*/ {
            if newString.contains(".") {
                let arr = newString.components(separatedBy: ".")
                if  arr[1].count > 0 {
                    if arr[1].count > 2 {
                        return false
                    }
                }
            }
        }else if textField.tag == 11/*输入飕飕币*/ {
            if newString.contains(".") {
                let arr = newString.components(separatedBy: ".")
                if  arr[1].count > 0 {
                    if arr[1].count > 4 {
                        return false
                    }
                }
            }
        }else if textField.tag == 12/*输入手机号*/ {
            if newString.count > 11 {
                return false
            }
        }else if textField.tag == 13/*输入飕飕币*/ {
            jisuan(string: newString)
            if newString.contains(".") {
                let arr = newString.components(separatedBy: ".")
                if  arr[1].count > 0 {
                    if arr[1].count > 4 {
                        jisuan(string: newString)
                        return false
                    }
                }
            }
        }else if textField.tag == 14/*输入飕飕币*/ {
            jisuan(string: newString)
            if newString.contains(".") {
                let arr = newString.components(separatedBy: ".")
                if  arr[1].count > 0 {
                    if arr[1].count > 4 {
                        jisuan(string: newString)
                        return false
                    }
                }
            }
        }else if textField.tag == 15/*输入金钱*/ {
            if newString.contains(".") {
                let arr = newString.components(separatedBy: ".")
                if  arr[1].count > 0 {
                    if arr[1].count > 2 {
                        return false
                    }
                }
            }
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 10/*充值输入框*/ {
            shuruDic["10"] = textField.text!
        }else if textField.tag == 11/*输入飕飕币*/ {
            if textField.text! == ""{
                textField.text = "0"
            }
            if Float(SouSouBi)! - Float(textField.text!)! >= 0{
                shuruDic["11"] = textField.text!
                jisuan(string: textField.text!)
            }else{
                textField.text = "0"
                XL_waringBox().warningBoxModeText(message: "飕飕币数量不足了哟～～", view: self.view)
            }
            
        }else if textField.tag == 12/*输入手机号*/ {
            if textField.text?.isPhoneNumber() == false{
                textField.text = ""
                XL_waringBox().warningBoxModeText(message: "请输入正确的手机号！", view: self.view)
            }
            shuruDic["12"] = textField.text!
        }else if textField.tag == 13/*输入飕飕币*/ {
            if textField.text! == ""{
                textField.text = "0"
            }
            if Float(SouSouBi)! - Float(textField.text!)! >= 0{
                shuruDic["13"] = textField.text!
                jisuan(string: textField.text!)
            }else{
                textField.text = "0"
                shuruDic["13"] = textField.text!
                jisuan(string: textField.text!)
                XL_waringBox().warningBoxModeText(message: "飕飕币数量不足了哟～～", view: self.view)
            }
            
        }else if textField.tag == 14/*输入飕飕币*/ {
            if textField.text! == ""{
                textField.text = "0"
            }
            if Double(textField.text!)! < minimumAmount {
                textField.text = ""
                XL_waringBox().warningBoxModeText(message: "飕飕币数量不能小于\(minimumAmount)个哟～", view: self.view)
                jisuan(string: "0")
            }else{
                if Float(SouSouBi)! - Float(textField.text!)! >= 0{
                    shuruDic["14"] = textField.text!
                    jisuan(string: textField.text!)
                }else{
                    textField.text = "0"
                    shuruDic["14"] = textField.text!
                    jisuan(string: textField.text!)
                    XL_waringBox().warningBoxModeText(message: "飕飕币数量不足了哟～～", view: self.view)
                }
            }
        }else if textField.tag == 15/*输入金钱*/ {
            if textField.text! == ""{
                textField.text = "0"
            }
            if Float(XiaoShou)! - Float(textField.text!)! >= 0{
                shuruDic["15"] = textField.text!
            }else{
                textField.text = "0"
                shuruDic["15"] = textField.text!
                jisuan(string: textField.text!)
                XL_waringBox().warningBoxModeText(message: "销售金额不足了哟～～", view: self.view)
            }
            
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func jisuan(string:String) {
        var xx = string
        if string.count == 0 {
            xx = "0"
        }
        let zz = String(format: "%.2f", Float(zhuanhua)! * Float(xx)!)
        tichengzhuanhua.text = "飕飕币转换成人民币: ¥\(zz)"
        tidaozhuanhua.text = "飕飕币转换成余额: ¥\(zz)"
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews {
            if view.tag == 909090 || view.tag == 909091 {
                print("进来了")
                return
            }else{
                self.view.endEditing(true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.youhui()
    }
    //mark: 当键盘显示时
    @objc func handleKeyboardDisShow(notification: NSNotification) {
        //得到键盘frame
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            if UIDevice.current.isX() {
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve), animations: {
                                
                                self.view.frame = CGRect(x: 0, y: -intersection.height
                                    + 120, width: self.view.frame.width, height: self.view.frame.height)
                                
                }, completion: nil)
            }else {
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve), animations: {
                                
                                self.view.frame = CGRect(x: 0, y: -intersection.height
                                    + 100, width: self.view.frame.width, height: self.view.frame.height)
                                
                }, completion: nil)
            }
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
