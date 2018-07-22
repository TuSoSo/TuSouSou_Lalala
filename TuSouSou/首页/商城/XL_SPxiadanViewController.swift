//
//  XL_SPxiadanViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/7.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_SPxiadanViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate {
    
    var shangpinList:[[String:Any]] = []
    var HJJE = UILabel()
    var jiage = "0"
    var mingzi = ""
    var dizhi = ""
    var uuuu: URL?
    var shangID :String?
    var diLoction = ""
    var diName = ""
    var diPhone = ""
    var pei = UILabel()
    var li = UILabel()
    var julili = "0"
    
    var cicishushu = 0
    
    //合计的view
    var ddView = UIView()
    var tomorrowTimes:[String] = []
    var todayTimes:[String] = []
    
    let jintableView = UITableView()
    let mingtableView = UITableView()
    
    var peisongfei = "0"
    var zhinazhi = "0"
    //明细
    var baiVV = UIView()
    var zhinazhisongLa = UILabel()
    var peisongfeiLa = UILabel()
    var juliLa = UILabel()
    var xiaofeiLa = UILabel()
    var dikouLa = UILabel()
    var shiyongssbLa = UILabel()
    
    var sousoubishuliang = "0"
    var dangqianyue = "0"
    var sousouzhuanhualv = "1"
    
    //详细地址传值
    var shangDiZhi = ""
    var shangXiangQing = ""
    
    @IBOutlet weak var tablequeren: UITableView!
    let SwitchAnniu = UISwitch()
    var beizhuTF = UITextView()
    var placeholderLabel = UILabel()
    var bounds: CGRect! = CGRect(x: 0, y: 0, width: 0, height: 40)
    var sousoubiView: XL_PaoMaView?
    var yueView: XL_PaoMaView?
    var zhifuButton0 = UIButton()
    var zhifuButton1 = UIButton()
    var zhifuButton2 = UIButton()
    var yangjiao = UILabel()
    var souBzhiF = UITextField()
    var DiKou = UILabel()
    var JJE = UILabel()
    var yueLabel = UILabel()
    var datePicker = UIDatePicker()
    //    let HJjine = "0.00"
    var dikoudejine:String = "0"
    var ZuoLabel = UILabel()
    var isToday = "1"
    var sendTime = ""
    var tipType = "2"
    var paymentMethod = ""
    var banview = UIView()
    
    var shouName = UILabel()
    var shouPhone = UILabel()
    var shouLoction = UILabel()
    var shangLon = ""
    var shangLat = ""
    //价格表数据
    var jiageView = UIView()
    var standardWeight = UILabel()
    var standardDistance = UILabel()
    var standardWeightMoney = UILabel()
    var standardDistanceMoney = UILabel()
    var overweightMoney = UILabel()
    var overdistanceMoney = UILabel()
        
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
                                    + 88, width: self.view.frame.width, height: self.view.frame.height)
                }, completion: nil)
            }else{
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve), animations: {
                                
                                self.view.frame = CGRect(x: 0, y: -intersection.height
                                    + 64, width: self.view.frame.width, height: self.view.frame.height)
                }, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "支付成功")
        NotificationCenter.default.addObserver(self, selector: #selector(chenggongle(notification:)), name: name, object:  nil)
        print("\(mingzi)\n\(dizhi)\n\(uuuu)")
        Delegate()
        lianggetableviewUI()
        jiekouyue()
        youAnniu()
        jiagebiao()
        self.title = "确认订单"
        jiekouJintianMingtian()
        jisuanyixia()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisShow(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Do any additional setup after loading the view.
    }
    @objc func chenggongle(notification:NSNotification) {
        let adVC: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
        //添加广告地址
        adVC?.xll = 1
        self.navigationController?.pushViewController(adVC!, animated: false)
    }
    //MARK: tableviewdelegate
    func Delegate() {
        SwitchAnniu.isOn = false
        tablequeren.delegate = self
        tablequeren.dataSource = self
        tablequeren.register(UITableViewCell.self, forCellReuseIdentifier: "queren")
        tableviewUI()
        ddViewX()
    }
    func lianggetableviewUI() {
        jintableView.delegate = self
        mingtableView.delegate = self
        jintableView.dataSource = self
        mingtableView.dataSource = self
        jintableView.register(UITableViewCell.self, forCellReuseIdentifier: "jincell")
        mingtableView.register(UITableViewCell.self, forCellReuseIdentifier:"mingcell")
        jintableView.tableFooterView = UIView()
        mingtableView.tableFooterView = UIView()
        jintableView.isHidden = true
        mingtableView.isHidden = true
        self.view.addSubview(jintableView)
        self.view.addSubview(mingtableView)
        jintableView.Top.layout(constrain: self.view.CenterY, constant: 0)
            .Left.layout(constrain: self.view.Left, constant: 0)
            .Right.layout(constrain: self.view.CenterX, constant: 0)
            .Bottom.layout(constrain: self.view.Bottom, constant: 0)
        mingtableView.Top.layout(constrain: self.view.CenterY, constant: 0)
            .Left.layout(constrain: self.view.CenterX, constant: 0)
            .Right.layout(constrain: self.view.Right, constant: 0)
            .Bottom.layout(constrain: self.view.Bottom, constant: 0)
    }
    func ddViewX() {
        if UIDevice.current.isX() {
            ddView.frame = CGRect(x: 0, y: Height - 150, width: Width, height: 60)
        }else{
            ddView.frame = CGRect(x: 0, y: Height - 120, width: Width, height: 60)
        }
        //        ddView.backgroundColor = UIColor.blue
        let hengxian = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 1))
        hengxian.backgroundColor = UIColor(hexString: "f2f2f2")
        let Label = UILabel(frame: CGRect(x: 8, y: 15, width: 40, height: 30))
        Label.font = UIFont.systemFont(ofSize: 15)
        Label.text = "合计:"
        HJJE = UILabel(frame: CGRect(x: 56, y: 12, width: 150, height: 36))
        jisuanyixia()
        HJJE.font = UIFont.systemFont(ofSize: 19)
        HJJE.textColor = UIColor.orange
        let wenhaobutton = UIButton(frame: CGRect(x: Width/2, y: 12, width: 36, height: 36))
        wenhaobutton.setImage(UIImage(named: "wenhao"), for: .normal)
        wenhaobutton.addTarget(self, action: #selector(wahaha), for: .touchUpInside)
        
        let XiaDanButton = UIButton(frame: CGRect(x: Width - 140, y: 12, width: 120, height: 36))
        XiaDanButton.addTarget(self, action: #selector(ZFaction), for: .touchUpInside)
        XiaDanButton.setTitle("确认支付", for: .normal)
        XiaDanButton.tintColor = UIColor.white
        XiaDanButton.setBackgroundImage(UIImage(named: "按钮背景2"), for: .normal)
        ddView.addSubview(hengxian)
        ddView.addSubview(Label)
        ddView.addSubview(wenhaobutton)
        ddView.addSubview(HJJE)
        ddView.addSubview(XiaDanButton)
        self.view.addSubview(ddView)
        
        banview = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        banview.backgroundColor = UIColor.black
        banview.alpha = 0.8
        banview.isUserInteractionEnabled = true
        self.view.bringSubview(toFront: banview)
        banview.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ss))
        tapGesture.numberOfTapsRequired = 1
        banview.addGestureRecognizer(tapGesture)
        banview.isHidden = true
        self.view.addSubview(banview)
        jiageView = UIView(frame: CGRect(x: 24, y: Height/2 - 200, width: Width - 48, height: 250))
        jiageView.backgroundColor = UIColor.white
        jiageView.isHidden = true
        banview.bringSubview(toFront: jiageView)
        let titi = UILabel(frame: CGRect(x: 24, y: 16, width: jiageView.frame.size.width - 36, height: 24))
        titi.font = UIFont.systemFont(ofSize: 20)
        titi.text = "配送费价格表"
        standardWeight = UILabel(frame: CGRect(x: 24, y: 48, width: jiageView.frame.size.width - 36, height: 24))
        standardWeight.font = UIFont.systemFont(ofSize: 15)
        standardDistance = UILabel(frame: CGRect(x: 24, y: 80, width: jiageView.frame.size.width - 36, height: 24))
        standardDistance.font = UIFont.systemFont(ofSize: 15)
        standardWeightMoney = UILabel(frame: CGRect(x: 24, y: 112, width: jiageView.frame.size.width - 36, height: 24))
        standardWeightMoney.font = UIFont.systemFont(ofSize: 15)
        standardDistanceMoney = UILabel(frame: CGRect(x: 24, y: 144, width: jiageView.frame.size.width - 36, height: 24))
        standardDistanceMoney.font = UIFont.systemFont(ofSize: 15)
        overweightMoney = UILabel(frame: CGRect(x: 24, y: 176, width: jiageView.frame.size.width - 36, height: 24))
        overweightMoney.font = UIFont.systemFont(ofSize: 15)
        overdistanceMoney = UILabel(frame: CGRect(x: 24, y: 208, width: jiageView.frame.size.width - 36, height: 24))
        overdistanceMoney.font = UIFont.systemFont(ofSize: 15)
        let button1 = UIButton(frame: CGRect(x: jiageView.frame.size.width - 74, y: jiageView.frame.size.height - 44, width: 50, height: 32))
        button1.setTitle("确定", for: .normal)
        button1.setTitleColor(UIColor.orange, for: .normal)
        button1.addTarget(self, action: #selector(ss), for: .touchUpInside)
        jiageView.addSubview(standardWeight)
        jiageView.addSubview(standardDistance)
        jiageView.addSubview(standardWeightMoney)
        jiageView.addSubview(standardDistanceMoney)
        jiageView.addSubview(overweightMoney)
        jiageView.addSubview(overdistanceMoney)
        jiageView.addSubview(titi)
        jiageView.addSubview(button1)
        self.view.addSubview(jiageView)
        mingxi()
    }
    @objc func wahaha() {
        banview.isHidden = false
        baiVV.isHidden = false
    }
    func mingxi() {
//        小费变成合计金额
        baiVV = UIView(frame: CGRect(x: 24, y: Height/2 - 200, width: Width - 48, height: 280))
        baiVV.backgroundColor = UIColor.white
        baiVV.isHidden = true
        let weixintishi = UILabel(frame: CGRect(x: 24, y: 16, width: baiVV.frame.size.width - 36, height: 24))
        weixintishi.font = UIFont.systemFont(ofSize: 30)
        weixintishi.text = "明细"
        
        zhinazhisongLa = UILabel(frame: CGRect(x: 24, y: 48, width: baiVV.frame.size.width - 36, height: 24))
        zhinazhisongLa.text = "商品金额: ¥ \(jiage)"
        zhinazhisongLa.font = UIFont.systemFont(ofSize: 15)
        peisongfeiLa = UILabel(frame: CGRect(x: 24, y: 80, width: baiVV.frame.size.width - 36, height: 24))
        peisongfeiLa.text = "直拿直送: ¥ 0.0"
        peisongfeiLa.font = UIFont.systemFont(ofSize: 15)
        juliLa = UILabel(frame: CGRect(x: 24, y: 112, width: baiVV.frame.size.width - 36, height: 24))
        juliLa.text = "配送费: ¥ \(peisongfei)"
        juliLa.font = UIFont.systemFont(ofSize: 15)
        xiaofeiLa = UILabel(frame: CGRect(x: 24, y: 144, width: baiVV.frame.size.width - 36, height: 24))
        xiaofeiLa.text = "距离: \(julili) 公里"
        xiaofeiLa.font = UIFont.systemFont(ofSize: 15)
        dikouLa = UILabel(frame: CGRect(x: 24, y: 176, width: baiVV.frame.size.width - 36, height: 24))
        dikouLa.text = "抵扣: ¥ 0.0"
        dikouLa.font = UIFont.systemFont(ofSize: 15)
        shiyongssbLa = UILabel(frame: CGRect(x: 24, y: 208, width: baiVV.frame.size.width - 36, height: 24))
        shiyongssbLa.text = "使用飕飕币: 0.0 个"
        shiyongssbLa.font = UIFont.systemFont(ofSize: 15)
        //        let peisong = UILabel(frame: CGRect(x: 24, y: 80, width: baiVV.frame.size.width - 36, height: 24))
        //        peisong.font = UIFont.systemFont(ofSize: 16)
        //        peisong.text = "配送费：¥ \(peisongfei)"
        //
        //        let zhina = UILabel(frame: CGRect(x: 24, y: 120, width: baiVV.frame.size.width - 36, height: 24))
        //        zhina.font = UIFont.systemFont(ofSize: 16)
        //        zhina.text = "直拿直送：¥ \(zhinazhi)"
        let button = UIButton(frame: CGRect(x: baiVV.frame.size.width - 74, y: baiVV.frame.size.height - 44, width: 50, height: 32))
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.addTarget(self, action: #selector(ss), for: .touchUpInside)
        baiVV.addSubview(zhinazhisongLa)
        baiVV.addSubview(peisongfeiLa)
        baiVV.addSubview(juliLa)
        baiVV.addSubview(xiaofeiLa)
        baiVV.addSubview(dikouLa)
        baiVV.addSubview(shiyongssbLa)
        baiVV.addSubview(button)
        baiVV.addSubview(weixintishi)
        self.view.addSubview(baiVV)
    }
    @objc func ZFaction() {
        if shouName.text != "收件人姓名"  {
            if paymentMethod.count == 0 {
                XL_waringBox().warningBoxModeText(message: "请选择支付方式", view: self.view)
            }else{
                if zhifuButton0.isSelected == true {
                    zhifu_xiao()
                }else if zhifuButton1.isSelected == true {
                    zhifu_xiao()
                }else if zhifuButton2.isSelected == true{
                    //判断支付密码，没有的话 跳  设置支付密码按钮，有的话 判断是否是免密  如果没有免密，弹出支付密码界面，并调支付密码接口，成功后调取 支付接口
                    if userDefaults.value(forKey: "isPayPassWord") as! Int == 2 {
                        // 跳 设置支付密码
                        self.tiaoye(rukou: "1")
                    }else{
                        if nil == userDefaults.value(forKey: "xemmzf") || !(userDefaults.value(forKey: "xemmzf") as! Bool) {
                            // 不免密 跳验证密码
                            if  userDefaults.value(forKey: "isPayPassWord") as! Int == 1{
                                //输入支付密码验证后再跳页
                                let payAlert = PayAlert(frame: UIScreen.main.bounds, jineHide: false, jine: HJJE.text!,isMove:true)
                                payAlert.show(view: self.view)
                                payAlert.completeBlock = ({(password:String) -> Void in
                                    //调验证支付吗接口
                                    self.yanzhengzhifumima(password: password)
                                    print("输入的密码是:" + password)
                                })
                            }
                        }else{
                            //直接接口
                            zhifu_xiao()
                        }
                    }
                }
            }
        }else{
            XL_waringBox().warningBoxModeText(message: "请填写收件人信息哟～", view: self.view)
        }
    }
    func yanzhengzhifumima(password:String) {
        let method = "/user/verifyPayPassword"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"payPassword":password]
        XL_waringBox().warningBoxModeIndeterminate(message: "密码验证中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                //                self.tiaoye(rukou: "1")
                self.zhifu_xiao()
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
    func tiaoye(rukou:String) {
        let AnQuanSZ: XL_WHMM_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "whmm") as? XL_WHMM_ViewController
        AnQuanSZ?.rukou = rukou
        self.navigationController?.pushViewController(AnQuanSZ!, animated: true)
    }
    func isJiabaliu(string:String) -> Bool {
        if string.contains("+ 86") {
            return true
        }
        return false
    }
    func zhifu_xiao (){
      
        var isDirectSend = "1"
        if SwitchAnniu.isOn == false {
            isDirectSend = "2"
        }
        if paymentMethod.count == 0 {
            XL_waringBox().warningBoxModeText(message: "请选择支付方式", view: self.view)
        }else{
            let method = "/order/merchantOrder"
            let userId = userDefaults.value(forKey: "userId")
//            "tipType":tipType,
            var list:[[String:Any]] = []
            for dd:[String:Any] in shangpinList {
                var xxdic:[String:Any] = [:]
                xxdic["productId"] = dd["productId"]
                xxdic["productName"] = dd["productName"]
                xxdic["productNum"] = dd["number"]
                xxdic["productPrice"] = dd["productPrice"]
                xxdic["picture"] = dd["picture"]
                xxdic["productSpec"] = dd["productSpec"]
                list.append(xxdic)
            }
            var shang = shouPhone.text!
            
            if isJiabaliu(string: shouPhone.text!){
                shang = shouPhone.text!.substring(fromIndex: 4)
            }
            let dic:[String:Any] = ["merchantUserId":shangID!,"userId":userId!,"sendTime":sendTime,"isToday":isToday,"isDirectSend":isDirectSend,"remarks":beizhuTF.text!,"paymentMethod":paymentMethod,"amount":HJJE.text!,"postAmount":peisongfei,"ssbSum":souBzhiF.text!,"addressName":shouName.text!,"addressPhone":shang,"addressLocation":shouLoction.text!,"longitude":shangLon,"latitude":shangLat,"list":list,"dkAmount":dikoudejine]
            //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
            XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
                print(res)
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                if (res as! [String: Any])["code"] as! String == "0000" {
                    let  data = (res as! [String: Any])["data"] as! [String:Any]
                    let orderCode = data["orderCode"] as! String
                    if self.zhifuButton0.isSelected == true {
                        self.zhifubaoZhiFu(string:orderCode)
                    }else if self.zhifuButton1.isSelected == true {
                        self.WXZhiFu(string:orderCode)
                    }else {
                        self.zhifuhuidiao(string:orderCode)
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
        
    }
    func zhifuhuidiao(string:String) {
        let method = "/order/payAfterHandler"
        let dicc:[String:Any] = ["orderCode":string]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            userDefaults.set("", forKey: "dingdanhao")
            XL_waringBox().warningBoxModeText(message: "下单成功了哟～", view: (self.navigationController?.view)!)
            //跳转到 订单
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            
            print(error)
        }
    }
    func WXZhiFu(string:String) {
        let method = "/weipay/App"
        let totalAmount = Float(HJJE.text!)! * 100
        
        let dicc:[String:Any] = ["outTradeNo":string,"totalAmount":totalAmount]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().SanFangWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            let data :[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
            
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
    func zhifubaoZhiFu(string:String) {
        let method = "/AliPay/App"
        let totalAmount = Float(HJJE.text!)!
        
        let dicc:[String:Any] = ["outTradeNo":string,"totalAmount":totalAmount]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().SanFangWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            let data :[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
            let appScheme = "TuSouSou"
            let orderString = data["orderString"] as! String
            
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
    func tableviewUI() {
        
        
        zhifuButton0 = UIButton(frame: CGRect(x: Width - 32, y: 16, width: 16, height: 16))
        zhifuButton0.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        zhifuButton0.setImage(UIImage(named: "圆圈选中"), for: .selected)
        zhifuButton0.isSelected = false
        zhifuButton0.addTarget(self, action:                #selector(zfzhifuButton0), for: .touchUpInside)
        
        zhifuButton1 = UIButton(frame: CGRect(x: Width - 32, y: 16, width: 16, height: 16))
        zhifuButton1.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        zhifuButton1.setImage(UIImage(named: "圆圈选中"), for: .selected)
        zhifuButton1.isSelected = false
        zhifuButton1.addTarget(self, action: #selector(zfzhifuButton1), for: .touchUpInside)
        
        zhifuButton2 = UIButton(frame: CGRect(x: Width - 32, y: 16, width: 16, height: 16))
        zhifuButton2.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        zhifuButton2.setImage(UIImage(named: "圆圈选中"), for: .selected)
        zhifuButton2.isSelected = true
        paymentMethod = "1"
        zhifuButton2.addTarget(self, action: #selector(zfzhifuButton2), for: .touchUpInside)
        
        beizhuTF = UITextView(frame: CGRect(x: 92, y: 8, width: Width - 130, height: 32))
        beizhuTF.isScrollEnabled = false
        beizhuTF.delegate = self
        beizhuTF.font = UIFont.systemFont(ofSize: 14)
        
        //手动提示
        self.placeholderLabel.frame = CGRect(x: 0 , y: 5, width: 100, height: 20)
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        self.placeholderLabel.text = "20字以内"
        beizhuTF.addSubview(self.placeholderLabel)
        self.placeholderLabel.textColor = UIColor(red:72/256 , green: 82/256, blue: 93/256, alpha: 1)
        souBzhiF = UITextField(frame: CGRect(x: 122, y: 8, width: 100, height: 32))
        souBzhiF.keyboardType = .decimalPad
        souBzhiF.delegate = self
        souBzhiF.layer.borderWidth = 1
        souBzhiF.layer.borderColor = UIColor(hexString: "f7ead3").cgColor
        
        DiKou = UILabel(frame: CGRect(x: Width - 138, y: 8, width: 30, height: 32))
        DiKou.text = "抵扣"
        DiKou.font = UIFont.systemFont(ofSize: 14)
        JJE = UILabel(frame: CGRect(x: Width - 100, y: 8, width: 86, height: 32))
        JJE.font = UIFont.systemFont(ofSize: 17)
        JJE.textColor = UIColor.orange
        
        yueLabel = UILabel(frame: CGRect(x: Width - 100, y: 8, width: 84, height: 32))
        yueLabel.text = "余额不足"
        
        yueLabel.textAlignment = .right
        yueLabel.font = UIFont.systemFont(ofSize: 16)
        yueLabel.textColor = UIColor.orange
        
        yangjiao = UILabel(frame: CGRect(x: 210, y: 8, width: 10, height: 32))
        
       
    }
    func jiagebiao() {
        let method = "/order/getPostMoney"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.standardWeight.text = String(format: "基准重量(公斤) : %.1f", data["standardWeight"] as! Double)
                self.standardDistance.text = String(format: "基准距离(公里) : %.1f", data["standardDistance"] as! Double)
                self.standardWeightMoney.text = String(format: "基准重量金额(元) : %.2f",  data["standardWeightMoney"] as! Double)
                self.standardDistanceMoney.text = String(format: "基准距离金额(元) : %.2f", data["standardDistanceMoney"] as! Double)
                self.overweightMoney.text = String(format: "超重每公斤金额(元) : %.2f", data["overweightMoney"] as! Double)
                self.overdistanceMoney.text = String(format: "超出每公里金额(元) : %.2f", data["overdistanceMoney"] as! Double)
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
    @objc func ss() {
        banview.isHidden = true
        jintableView.isHidden = true
        baiVV.isHidden = true
        mingtableView.isHidden = true
        jiageView.isHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tablequeren {
            return 4
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == jintableView {
            return todayTimes.count
        }else if tableView == mingtableView {
            return tomorrowTimes.count
        }else{
            if section == 0 {
                return shangpinList.count
            }else if section == 1 {
                return 1
            }else if section == 2 {
                return 4
            }else {
                return 4
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tablequeren{
            if section == 0 {
                return 64
            }else if section == 1 {
                return 1
            }else if section == 2 {
                return 1
            }else {
                return 44
            }
        }else{
            return 44
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tablequeren {
            if section == 0 {
                let View = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 64))
                let xiaxian = UIView(frame: CGRect(x: 24, y: 63, width: Width, height: 1))
                xiaxian.backgroundColor = UIColor(hexString: "f0f0f0")
                let shangxian = UIView(frame: CGRect(x: 24, y: 0, width: Width, height: 1))
                shangxian.backgroundColor = UIColor(hexString: "f0f0f0")
                let imageView = UIImageView(frame: CGRect(x: 8, y: 10, width: 60, height: 48))
                let newString = uuuu?.absoluteString
                let uuu:URL = URL(string: String(format: "%@",newString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
                
                imageView.sd_setImage(with:uuu , placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
                let name = UILabel(frame: CGRect(x: 84, y: 8, width: Width - 142, height: 24))
                name.textColor = UIColor(hexString: "8e8e8e")
                name.text = mingzi
                let jieshao = UILabel(frame: CGRect(x: 84, y: 32, width: Width - 142, height: 32))
                jieshao.font = UIFont.systemFont(ofSize: 13)
                jieshao.textColor = UIColor(hexString: "6e6e6e")
                jieshao.numberOfLines = 2
                let weizhi = dizhi
                
                jieshao.text = "购买地:\(weizhi)"
                View.addSubview(imageView)
                View.addSubview(jieshao)
                View.addSubview(name)
                View.addSubview(shangxian)
                View.addSubview(xiaxian)
                View.backgroundColor = UIColor.white
                
                return View
            }else if section == 3 {
                let View = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 44))
                View.backgroundColor = UIColor(hexString: "f2f2f2")
                let label = UILabel(frame: CGRect(x: 16, y: 8, width: 180, height: 30))
                label.text = "付款方式:"
                label.textColor = UIColor(hexString: "727272")
                View.addSubview(label)
                return View
            }else{
                let View = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 1))
                View.backgroundColor = UIColor(hexString: "f2f2f2")
                return View
            }
        }else if tableView == jintableView{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width/2, height: 44))
            view.backgroundColor = UIColor(hexString: "f2f2f2")
            let label = UILabel(frame: CGRect(x: 0, y: 11, width: Width/2, height: 22))
            label.text = "今天"
            label.textAlignment = .center
            view.addSubview(label)
            return view
        }else if tableView == mingtableView{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width/2, height: 44))
            view.backgroundColor = UIColor(hexString: "f2f2f2")
            let label = UILabel(frame: CGRect(x: 0, y: 11, width: Width/2, height: 22))
            label.text = "明天"
            label.textAlignment = .center
            view.addSubview(label)
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tablequeren {
            if indexPath.section == 0 {
                return 80
            }else if indexPath.section == 1 {
                return 112
            }else if indexPath.section == 2 {
                if indexPath.row == 3 {
                    return bounds.height + 16
                }else{
                    return 44
                }
            }else {
                return 44
            }
        }else{
            return 44
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellString = "queren"
        if tableView == jintableView {
            cellString = "jincell"
        }else if tableView == mingtableView{
            cellString = "mingcell"
        }
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if tableView == tablequeren {
            if indexPath.section == 0 {
                let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 80, height: 64))
                var jiee:String = ""
                if shangpinList.count != 0{
                    if nil != shangpinList[indexPath.row]["picture"]{
                        jiee = shangpinList[indexPath.row]["picture"] as! String
                    }
                }
                
                let newString1 = TupianUrl + jiee
                let uul:URL = URL(string: String(format: "%@",newString1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
                imageView.sd_setImage(with: uul, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
                let name = UILabel(frame: CGRect(x: 96, y: 16, width: Width - 142, height: 24))
                name.font = UIFont.systemFont(ofSize: 15)
                name.textColor = UIColor(hexString: "8e8e8e")
                var xox = ""
                if shangpinList.count != 0{
                    xox = (shangpinList[indexPath.row]["productName"] as? String)!
                    name.text = xox
                }
                if shangpinList.count != 0 && nil != shangpinList[indexPath.row]["productSpec"] {
                    name.text = xox + " " + (shangpinList[indexPath.row]["productSpec"] as? String)!
                }
                let jiaqian = UILabel(frame: CGRect(x: 100, y: 36, width: Width - 142, height: 40))
                jiaqian.font = UIFont.systemFont(ofSize: 18)
                jiaqian.textColor = UIColor.orange
                jiaqian.numberOfLines = 2
                jiaqian.text = ""
                if shangpinList.count != 0{
                    jiaqian.text = "¥ " + (shangpinList[indexPath.row]["productPrice"] as? String)!
                }
                let shuliang = UILabel(frame: CGRect(x: Width - 48, y: 50, width: 40, height: 30))
                shuliang.font = UIFont.systemFont(ofSize: 14)
                if shangpinList.count != 0{
                    shuliang.text = "x " + (shangpinList[indexPath.row]["number"] as? String)!
                }
                cell.contentView.addSubview(shuliang)
                cell.contentView.addSubview(imageView)
                cell.contentView.addSubview(jiaqian)
                cell.contentView.addSubview(name)
            }else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    //收件人信息
                    
                    
                    let imageview = UIImageView(frame: CGRect(x: 16, y: 38, width: 44, height: 44))
                    imageview.image = UIImage(named: "shou")
                    
                    shouName = UILabel(frame: CGRect(x: 76, y: 16, width: Width - 90, height: 24))
                    shouName.text = "收件人姓名"
                    if diName.count != 0 {
                        shouName.text = diName
                    }
                    shouName.textColor = UIColor(hexString: "8f8f8f")
                    shouName.font = UIFont.systemFont(ofSize: 14)
                    shouPhone = UILabel(frame: CGRect(x: 76, y: 44, width: Width - 90, height: 24))
                    shouPhone.text = "收件人电话"
                    if diPhone.count != 0 {
                        shouPhone.text = diPhone
                    }
                    shouPhone.textColor = UIColor(hexString: "8e8e8e")
                    shouPhone.font = UIFont.systemFont(ofSize: 14)
                    shouLoction = UILabel(frame: CGRect(x: 76, y: 72, width: Width - 180, height: 21))
                    shouLoction.numberOfLines = 2
                    shouLoction.text = "收件人地址"
                    if diLoction.count != 0 {
                        shouLoction.text = diLoction
                    }
                    shouLoction.textColor = UIColor(hexString: "8e8e8e")
                    shouLoction.font = UIFont.systemFont(ofSize: 14)
                    let dizhibu = UILabel(frame: CGRect(x: Width - 64, y: 64, width: 52, height: 30))
                    dizhibu.text = "地址簿"
                    dizhibu.font = UIFont.systemFont(ofSize: 15)
                    dizhibu.textColor = UIColor.orange
                    let imageloc = UIImageView(frame: CGRect(x: Width - 52, y: 32, width: 18, height: 24))
                    imageloc.image = UIImage(named: "位置2")
                    
                    let shuxian = UIView(frame: CGRect(x: Width - 73, y: 26, width: 1, height: 60))
                    shuxian.backgroundColor = UIColor(hexString: "d2d2d2")
                    
                    let imageJT = UIImageView(frame: CGRect(x: Width - 90, y: 46, width: 13, height: 20))
                    imageJT.image = UIImage(named: "arrow_right_grey")
                    cell.contentView.isUserInteractionEnabled = true
                    let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: Width - 73, height: 112))
                    button1.addTarget(self, action: #selector(dizhizhi), for: .touchUpInside)
                    let button2 = UIButton(frame: CGRect(x: Width - 73, y: 0, width: 72, height: 112))
                    button2.addTarget(self, action: #selector(dizhibubu), for: .touchUpInside)
                    cell.contentView.addSubview(imageJT)
                    cell.contentView.addSubview(shuxian)
                    cell.contentView.addSubview(imageloc)
                    cell.contentView.addSubview(dizhibu)
                    cell.contentView.addSubview(imageview)
                    cell.contentView.addSubview(shouName)
                    cell.contentView.addSubview(shouPhone)
                    cell.contentView.addSubview(shouLoction)
                    cell.contentView.addSubview(button1)
                    cell.contentView.addSubview(button2)
                }
            }else if indexPath.section == 2 {
                if indexPath.row == 0 {
                    //立即送出
                    ZuoLabel = UILabel(frame: CGRect(x: 16, y: 8, width: 150, height: 28))
                    ZuoLabel.text = "立即送出"
                    ZuoLabel.font = UIFont.systemFont(ofSize: 15)
                    ZuoLabel.textColor = UIColor(hexString: "727272")
                    cell.accessoryType = .disclosureIndicator
                    cell.contentView.addSubview(ZuoLabel)
                }else if indexPath.row == 1 {
                    //直拿直送
                    let zhina = UILabel(frame: CGRect(x: 16, y: 8, width: 150, height: 28))
                    zhina.text = "直拿直送"
                    zhina.font = UIFont.systemFont(ofSize: 15)
                    zhina.textColor = UIColor(hexString: "727272")
                    SwitchAnniu.frame = CGRect(x: Width - 72, y: 8, width: 60, height: 30)
                    SwitchAnniu.addTarget(self, action:  #selector(switchDidChange), for:.valueChanged)
                    cell.contentView.addSubview(zhina)
                    cell.contentView.addSubview(SwitchAnniu)
                }else if indexPath.row == 2{
                    let zhina = UILabel(frame: CGRect(x: 16, y: 8, width: 150, height: 28))
                    zhina.text = "配送费:"
                    zhina.font = UIFont.systemFont(ofSize: 15)
                    zhina.textColor = UIColor(hexString: "727272")
                    let juli = UILabel(frame: CGRect(x: Width/2 - 16, y: 8, width: 80, height: 32))
                    juli.tag = 99994
                    juli.font = UIFont.systemFont(ofSize: 14)
                    juli.text = "距离:"
                    juli.textColor = UIColor(hexString: "727272")
                    pei = UILabel(frame: CGRect(x: 80, y: 8, width: 100, height: 32))
                    pei.textColor = UIColor(hexString: "727272")
                    pei.text = "¥ \(peisongfei)"
                    pei.font = UIFont.systemFont(ofSize: 15)
                    
                    li = UILabel(frame: CGRect(x: Width/2 + 32, y: 8, width: 100, height: 32))
                    li.textColor = UIColor(hexString: "727272")
                    li.text = "\(julili) 公里"
                    li.font = UIFont.systemFont(ofSize: 15)
                    cell.contentView.addSubview(zhina)
                    cell.contentView.addSubview(juli)
                    cell.contentView.addSubview(pei)
                    cell.contentView.addSubview(li)
                }else{
                    //备注
                    let beizhu = UILabel(frame: CGRect(x: 16, y: 8, width: 60, height: 30))
                    beizhu.text = "备注:"
                    beizhu.font = UIFont.systemFont(ofSize: 15)
                    beizhu.textColor = UIColor(hexString: "727272")
                    cell.contentView.addSubview(beizhu)
                    cell.contentView.addSubview(beizhuTF)
                }
            }else {
                if indexPath.row == 0 {
                    //飕飕币
                    self.gundongDonghua(string: "飕飕币剩余(\(sousoubishuliang)")
                    JJE.text = "¥\(dikoudejine)"
                    cell.contentView.addSubview(JJE)
                    cell.contentView.addSubview(DiKou)
                    cell.contentView.addSubview(souBzhiF)
                    cell.contentView.addSubview(sousoubiView!)
                }else if indexPath.row == 1 {
                    //余额
                    self.gundongDonghua(string: "余额(¥ \(dangqianyue))支付")
                     cicishushu += 1
                    if Float(HJJE.text!)! <= Float(dangqianyue)!{
//                        if cicishushu < 3{
                        if paymentMethod == "" {
                            zhifuButton2.isSelected = true
                            paymentMethod = "1"
                        }
                        cell.contentView.addSubview(zhifuButton2)
                    }else{
                        cell.contentView.addSubview(yueLabel)
                        zhifuButton2.isSelected = false
                        if paymentMethod == "1"{
                            paymentMethod = ""
                        }
                    }
                    cell.contentView.addSubview(yueView!)
                }else if indexPath.row == 2{
                    //支付宝
                    let ZFImage = UIImageView(frame: CGRect(x: 16, y: 12, width: 24, height: 24))
                    ZFImage.image = UIImage(named: "支付-支付宝")
                    let zuolabel = UILabel(frame: CGRect(x: 48, y: 9, width: 100, height: 32))
                    zuolabel.text = "支付宝支付"//"剩余(¥\(body["qian"]))支付"
                    cell.contentView.addSubview(zhifuButton0)
                    cell.contentView.addSubview(ZFImage)
                    cell.contentView.addSubview(zuolabel)
                }else {
                    //微信
                    let ZFImage = UIImageView(frame: CGRect(x: 16, y: 12, width: 24, height: 24))
                    ZFImage.image = UIImage(named: "支付-微信")
                    let zuolabel = UILabel(frame: CGRect(x: 48, y: 9, width: 100, height: 32))
                    zuolabel.text = "微信支付"
                    cell.contentView.addSubview(zhifuButton1)
                    cell.contentView.addSubview(ZFImage)
                    cell.contentView.addSubview(zuolabel)
                }
            }
        }else if tableView == jintableView{
            cell.textLabel?.text = todayTimes[indexPath.row]
        }else{
            cell.textLabel?.text = tomorrowTimes[indexPath.row]
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tablequeren {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    // 跳收件地址簿  选择完之后调用获取配送费接口
                    //跳页，回调到地址栏
                   
                }
            }else if indexPath.section == 2{
                if indexPath.row == 0 {
                    jintableView.isHidden = false
                    mingtableView.isHidden = false
                    banview.isHidden = false
                }
            }else if indexPath.section == 3 {
                // 如果余额大于合计、则 有row == 1 判断
                if indexPath.row == 1 {
                    if zhifuButton2.isSelected == false {
                        zhifuButton2.isSelected = true
                        paymentMethod = "1"
                    }else{
                        zhifuButton2.isSelected = false
                        paymentMethod = ""
                    }
                    zhifuButton1.isSelected = false
                    zhifuButton0.isSelected = false
                    tablequeren.reloadData()
                }
                if indexPath.row == 2 {
                    if HJJE.text != "0.00" {
                    if zhifuButton0.isSelected == false {
                        zhifuButton0.isSelected = true
                        paymentMethod = "2"
                    }else{
                        zhifuButton0.isSelected = false
                        paymentMethod = ""
                    }
                    zhifuButton1.isSelected = false
                    zhifuButton2.isSelected = false
                    tablequeren.reloadData()
                    }
                }
                if indexPath.row == 3 {
                    if HJJE.text != "0.00" {
                    if zhifuButton1.isSelected == false {
                        zhifuButton1.isSelected = true
                        paymentMethod = "3"
                    }else{
                        zhifuButton1.isSelected = false
                        paymentMethod = ""
                    }
                    zhifuButton0.isSelected = false
                    zhifuButton2.isSelected = false
                    tablequeren.reloadData()
                    }
                }
                
            }
        }else if tableView == jintableView{
            ZuoLabel.text = "今天 " + todayTimes[indexPath.row]
            isToday = "1"
            sendTime = todayTimes[indexPath.row]
            banview.isHidden = true
            jintableView.isHidden = true
            mingtableView.isHidden = true
        }else{
            ZuoLabel.text = "明天 " + tomorrowTimes[indexPath.row]
            isToday = "2"
            sendTime = tomorrowTimes[indexPath.row]
            banview.isHidden = true
            jintableView.isHidden = true
            mingtableView.isHidden = true
        }
    }
    @objc func dizhizhi() {
        print("1")
        let tianjiadizhi: XL_dizhi_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhi") as! XL_dizhi_ViewController
        tianjiadizhi.Shei = "shoujian"
        
        if self.shouName.text != "收件人姓名"{
            tianjiadizhi.namename = shouName.text!
        }
        if self.shouPhone.text != "收件人电话"{
            var shang = self.shouPhone.text!
            if isJiabaliu(string: self.shouPhone.text!){
                shang = self.shouPhone.text!.substring(fromIndex: 4)
            }
            tianjiadizhi.diandianhua = shang
        }
        tianjiadizhi.didizhi = self.shangDiZhi
        tianjiadizhi.xiangqing = self.shangXiangQing
        tianjiadizhi.lon = self.shangLon
        tianjiadizhi.lat = self.shangLat
        
        //block 传值调用
        tianjiadizhi.dixiang = {(diBody: [String: String]) in
            self.diName = diBody["name"]!
            self.shouName.text = diBody["name"]
            self.diPhone = diBody["phone"]!
            self.shouPhone.text = diBody["phone"]
            self.diLoction = "\(diBody["dizhi"]!)\(diBody["xiangzhi"]!)"
            self.shouLoction.text = "\(diBody["dizhi"]!)\(diBody["xiangzhi"]!)"
            self.shangDiZhi = "\(diBody["dizhi"]!)"
            self.shangXiangQing = "\(diBody["xiangzhi"]!)"
            self.shangLat = diBody["lat"]!
            self.shangLon = diBody["lon"]!
            self.jiekoupeisong()
        }
        self.navigationController?.pushViewController(tianjiadizhi, animated: true)
    }
    @objc func dizhibubu() {
        print("2")
        let dizhibu: XL_Dizhibu_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhibu") as! XL_Dizhibu_ViewController
        dizhibu.biaoti = "4"
        //block 传值调用
        dizhibu.xuanzhiBody = {(xuanzhiBody: [String: String]) in
            self.diName = xuanzhiBody["name"]!
            self.shouName.text = xuanzhiBody["name"]
            self.diPhone = xuanzhiBody["phone"]!
            self.shouPhone.text = xuanzhiBody["phone"]
            self.diLoction = xuanzhiBody["dizhi"]!
            self.shouLoction.text = xuanzhiBody["dizhi"]
            self.shangLat = xuanzhiBody["lat"]!
            self.shangLon = xuanzhiBody["lon"]!
            self.shangDiZhi = xuanzhiBody["didizhi"]!
            self.shangXiangQing = xuanzhiBody["xiangqing"]!
            self.jiekoupeisong()
        }
        self.navigationController?.pushViewController(dizhibu, animated: true)
    }
    func gundongDonghua(string: String) {
        sousoubiView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 100, height: 32), title: string, color:UIColor.black, Font: 14, xxx: true)
        sousoubiView?.tag = 99991
        yueView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 140, height: 32), title: string, color:UIColor.black, Font: 14, xxx: true)
        yueView?.tag = 99992
    }
    //MARK: textFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let text = textField.text!
//
//        let len = text.count + string.count - range.length
        var zhuan = "0"
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newString.count != 0 {
            zhuan = newString
        }
        if Float(zhuan)! > Float(sousoubishuliang)! {
            showConfirm(title: "温馨提示", message: "yoyo~ 您没有足够飕飕币哟~", in: self, confirme: { (s) in
                self.souBzhiF.text = ""
                self.dikoujisuan(string: "0")
            }) { (w) in
                self.souBzhiF.text = self.sousoubishuliang
                self.dikoujisuan(string: self.souBzhiF.text!)
            }
        }
//        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if zhuan.contains(".") {
            let arr = zhuan.components(separatedBy: ".")
            if  arr[1].count > 0 {
                if arr[1].count > 4 {
                    return false
                }
            }
        }
        self.dikoujisuan(string:zhuan)
        return true
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        textField.text = preciseDecimal(x: textField.text!, p: 4)
//
//        jisuanyixia()
//    }
    //MARK: textviewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.placeholderLabel.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = false
        }else{
            self.placeholderLabel.isHidden = true
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        if textView.text.count >= 20 {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        bounds = textView.bounds
        let maxSize = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        
        let newSize = textView.sizeThatFits(maxSize)
        bounds.size.height = newSize.height
        beizhuTF.frame = CGRect(x: 92, y: 8, width: bounds.width, height: bounds.height)
        tablequeren.beginUpdates()
        tablequeren.endUpdates()
    }
    @objc func switchDidChange() {
        if shouName.text! == "收件人姓名" {
            self.SwitchAnniu.isOn = false
            self.showConfirm(title: "温馨提示", message: "选择直拿直送之前需要确定收件人信息哟～", in: self, confirme: { (_) in
            }) { (_) in
                let dizhibu: XL_Dizhibu_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhibu") as! XL_Dizhibu_ViewController
                dizhibu.biaoti = "3"
                //block 传值调用
                dizhibu.xuanzhiBody = {(xuanzhiBody: [String: String]) in
                    self.shouName.text = xuanzhiBody["name"]
                    self.shouPhone.text = xuanzhiBody["phone"]
                    self.shouLoction.text = xuanzhiBody["dizhi"]
                    self.shangLat = xuanzhiBody["lat"]!
                    self.shangLon = xuanzhiBody["lon"]!
                    self.jiekoupeisong()
                    self.SwitchAnniu.isOn = true
                }
                self.navigationController?.pushViewController(dizhibu, animated: true)
            }
        }else{
            if SwitchAnniu.isOn == true {
                self.showConfirm(title: "温馨提示", message: "开启后，骑士从发货地到收货地的整个配送过程将无法再接其他订单，来确保您的订单能够最快送达", in: self, confirme: { (_) in
                    self.SwitchAnniu.isOn = false
                    self.jisuanyixia()
                }) { (_) in
                    self.SwitchAnniu.isOn = true
                    self.jisuanyixia()
                }
            }else{
                self.jisuanyixia()
            }
        }
    }
    //MARK：提示框
    func showConfirm(title: String, message: String, in viewController: UIViewController,confirme:((UIAlertAction)->Void)?,
                     confirm: ((UIAlertAction)->Void)?) {
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: confirme))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
        viewController.present(alert, animated: true)
    }
    
    //zhifuxuanze
    @objc func zfzhifuButton0()  {
        if HJJE.text != "0.00" {
        if zhifuButton0.isSelected == false {
            zhifuButton0.isSelected = true
            paymentMethod = "2"
        }else{
            zhifuButton0.isSelected = false
            paymentMethod = ""
        }
        zhifuButton1.isSelected = false
        zhifuButton2.isSelected = false
        }
    }
    @objc func zfzhifuButton1()  {
        if HJJE.text != "0.00" {
        if zhifuButton1.isSelected == false {
            zhifuButton1.isSelected = true
            paymentMethod = "3"
        }else{
            zhifuButton1.isSelected = false
            paymentMethod = ""
        }
        zhifuButton0.isSelected = false
        zhifuButton2.isSelected = false
        }
    }
    @objc func zfzhifuButton2()  {
        if zhifuButton2.isSelected == false {
            zhifuButton2.isSelected = true
            paymentMethod = "1"
        }else{
            zhifuButton2.isSelected = false
            paymentMethod = ""
        }
        zhifuButton0.isSelected = false
        zhifuButton1.isSelected = false
    }
    func dikoujisuan(string:String){
        dikoudejine = String(format:"%.2f", Float(string)! * Float(sousouzhuanhualv)!)
        shiyongssbLa.text = "使用飕飕币: \(string)个"
        dikouLa.text = "抵扣: ¥ \(dikoudejine)"
        JJE.text = dikoudejine
        jisuanyixia()
    }
    func jisuanyixia() {
        //        jiage +
        let pei:Float = Float(peisongfei)!
        var zhi:Float = Float(zhinazhi)!
        let dikou:Float = Float(dikoudejine)!
        let jia:Float = Float(jiage)!
        self.peisongfeiLa.text = "直拿直送: ¥ \(self.zhinazhi)"
        if SwitchAnniu.isOn == false {
            zhi = 0
            self.peisongfeiLa.text = "直拿直送: ¥ 0.0"
        }
        self.HJJE.text = String(format: "%.2f",jia + pei + zhi  - dikou)
        if  Float(HJJE.text!)! < 0 {
            HJJE.text = "0.00"
            zhifuButton2.isSelected = true
            paymentMethod = "1"
            zhifuButton1.isSelected = false
            zhifuButton0.isSelected = false
//            self.dikoujisuan(string: self.souBzhiF.text!)
//            showConfirm(title: "温馨提示", message: "yoyo~ 您的飕飕币使用太多了哟~", in: self, confirme: { (s) in
//                self.souBzhiF.text = "0"
//                self.dikoujisuan(string: self.souBzhiF.text!)
//            }) { (w) in
//                self.souBzhiF.text = "0"
//                self.dikoujisuan(string: self.souBzhiF.text!)
//            }
        }
        let indexPath = IndexPath(row: 1, section: 3)
        tablequeren.reloadRows(at: [indexPath], with: .fade)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func jiekoupeisong() {
        let method = "/order/getPostAmount"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"merchantUserId":shangID!,"longitude":shangLon,"latitude":shangLat]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.julili = String(format: "%@", data["instance"] as! String)
                self.xiaofeiLa.text = "距离: \(self.julili) 公里"
                self.li.text = "\(self.julili) 公里"
                self.peisongfei = String(format: "%.2f", data["postAmount"] as! Double)
                self.pei.text = "¥ \(self.peisongfei)"
                self.juliLa.text = "配送费: ¥ \(self.peisongfei)"
                self.zhinazhi = String(format: "%.2f", data["directSendMoney"] as! Double)
                self.jisuanyixia()
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            print(error)
        }
    }
    func jiekouJintianMingtian() {
        let method = "/order/getTimes"
        let dic:[String:Any] = ["orderType":"2","merchantUserId":shangID!]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                if nil != data["todayTimes"] && !(data["todayTimes"] is String) {
                    if nil == data["todayTimes"] || (data["todayTimes"] as! [String]).count == 0  {
                        
                    }else{
                        self.todayTimes = data["todayTimes"] as! [String]
                    }
                }
                
                self.tomorrowTimes = data["tomorrowTimes"] as! [String]
                self.jintableView.reloadData()
                self.mingtableView.reloadData()
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            print(error)
        }
    }
    func jiekouyue(){
        let method = "/account/find"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let  data = (res as! [String: Any])["data"] as! [String:Any]
                self.sousoubishuliang = self.preciseDecimal(x: data["ssMoney"] as! String, p: 4)
                self.dangqianyue = self.preciseDecimal(x: data["balance"] as! String, p: 2)
                self.sousouzhuanhualv = "\((data["percentage"] as? Double)!)"
                self.tablequeren.reloadData()
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
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
    func youAnniu() {
        let item = UIBarButtonItem(title:"价格表",style: .plain,target:self,action:#selector(YouActio))
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio()  {
        jiageView.isHidden = false
        banview.isHidden = false
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
