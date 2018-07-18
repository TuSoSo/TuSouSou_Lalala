//
//  XL_KuaiDixiadan_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/4/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
import Alamofire
let AP_SUBVIEW_XGAP  = 20.0
let AP_SUBVIEW_YGAP  = 30.0
let AP_SUBVIEW_WIDTH = (UIScreen.main.bounds.size.width) - CGFloat(2*(AP_SUBVIEW_XGAP))

let AP_BUTTON_HEIGHT = 60.0
let AP_INFO_HEIGHT   = 200.0

class XL_KuaiDixiadan_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    var isToday = "1"
    var sendTime = ""
    var tipType = "2"
    var paymentMethod = ""
    
    var dkAmount = ""
    
    var orderType:Int?
    var zhinazhisong:String?
    var dingdanjine:String?
    var peisongfei = "0"
    var zhinazhi = "0"
    var julili = "0"
    
    
    var dingdanID:String?
    var dingdanhao :String?
    
    var sousoubishuliang = "0"
    var dangqianyue = "0"
    var sousouzhuanhualv = "1"
    
    @IBOutlet weak var HeJijine: UILabel!
    let _tableview: UITableView! = UITableView()
    let body: [String: String] = [:]
    let uiswitch0 = UISwitch()
//    let uiswitch1 = UISwitch()
    var zhifuButton0 = UIButton()
    var zhifuButton1 = UIButton()
    var zhifuButton2 = UIButton()
    var banview = UIView()
    var baiVV = UIView()
    var xiaofeiTF = UITextField()
    var yangjiao = UILabel()
    var beizhuTF = UITextView()
    var placeholderLabel = UILabel()
    var bounds: CGRect! = CGRect(x: 0, y: 0, width: 0, height: 40)
    var sousoubiView: XL_PaoMaView?
    var yueView: XL_PaoMaView?
    var souBzhiF = UITextField()
    var DiKou = UILabel()
    var JJE = UILabel()
    var dikoudejine:String = "0"
    //小费的两个按钮
    var ButtonRMB = UIButton(); var ButtonSSB = UIButton()
    var yueLabel = UILabel()
    
    var tomorrowTimes:[String] = []
    var todayTimes:[String] = []
    
    let jintableView = UITableView()
    let mingtableView = UITableView()
    
    var ZuoLabel = UILabel()
    var li = UILabel()
    var pei = UILabel()
    
    //价格表数据
    var jiageView = UIView()
    var standardWeight = UILabel()
    var standardDistance = UILabel()
    var standardWeightMoney = UILabel()
    var standardDistanceMoney = UILabel()
    var overweightMoney = UILabel()
    var overdistanceMoney = UILabel()
    //明细
    var zhinazhisongLa = UILabel()
    var peisongfeiLa = UILabel()
    var juliLa = UILabel()
    var xiaofeiLa = UILabel()
    var dikouLa = UILabel()
    var shiyongssbLa = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认订单"
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisShow(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        let name = Notification.Name(rawValue: "支付成功")
        NotificationCenter.default.addObserver(self, selector: #selector(chenggongle(notification:)), name: name, object:  nil)
        self.tableviewDelegate()
        self.TableviewCellUI()
//        self.gundongDonghua()
        //去除空格
        let ddje = dingdanjine!.trimmingCharacters(in: .whitespaces)
        let znzs = zhinazhisong!.trimmingCharacters(in: .whitespaces)
        peisongfei = ddje
        zhinazhi = znzs
        youAnniu()
        tishiUI()
        zhanghuyue()
        jiekouJintianMingtian()
        lianggetableviewUI()
        HeJijine.text = ddje
    }
    @objc func chenggongle(notification:NSNotification) {
        let adVC: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
        //添加广告地址
        adVC?.xll = 1
        self.navigationController?.pushViewController(adVC!, animated: false)
    }
    func youAnniu() {
        let item = UIBarButtonItem(title:"价格表",style: .plain,target:self,action:#selector(YouActio))
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio()  {
        jiageView.isHidden = false
        banview.isHidden = false
    }
    
    @IBAction func wenhao(_ sender: Any) {
        banview.isHidden = false
        baiVV.isHidden = false
    }
    func zhanghuyue()  {
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
                self._tableview.reloadData()
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            print(error)
        }
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
   
    func jiekouJintianMingtian() {
        let method = "/order/getTimes"
        let dic:[String:Any] = ["orderType":"1","merchantUserId":""]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.todayTimes = data["todayTimes"] as! [String]
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
    func ButtonXF() {
        ButtonRMB = anniu(button: ButtonRMB, name: "人民币", frame: CGRect(x: Width - 180, y: 8, width: 80, height: 32))
        ButtonRMB.isSelected = true
        ButtonRMB.addTarget(self, action: #selector(renminbi), for: .touchUpInside)
        ButtonSSB = anniu(button: ButtonSSB, name: "飕飕币", frame: CGRect(x: Width - 90, y: 8, width: 80, height: 32))
        ButtonSSB.isSelected = false
        ButtonSSB.addTarget(self, action: #selector(sousousousoubi), for: .touchUpInside)
    }
//    @objc func switchDidChange1() {
//        xiaofeiTF.text = ""
//        if uiswitch1.isOn == true {
//            yangjiao.text = "飕飕币"
//            tipType = "1"
//        }else{
//            tipType = "2"
//            yangjiao.text = "¥"
//        }
//        jisuanfangfa()
//        _tableview.reloadData()
//    }
    @objc func renminbi() {
        if ButtonRMB.isSelected == true {
            
        }else{
            tipType = "2"
            xiaofeiTF.text = ""
            self.view.endEditing(true)
//            TFDic = [:]
            ButtonRMB.isSelected = true
            ButtonSSB.isSelected = false
            jisuanfangfa()
            _tableview.reloadData()
        }
    }
    @objc func sousousousoubi() {
        if ButtonSSB.isSelected == true {
            
        }else{
            tipType = "1"
            xiaofeiTF.text = ""
            self.view.endEditing(true)
            //            TFDic = [:]
            ButtonSSB.isSelected = true
            ButtonRMB.isSelected = false
            jisuanfangfa()
            _tableview.reloadData()
        }
    }
    func tishiUI() {
        banview = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        banview.backgroundColor = UIColor.black
        banview.alpha = 0.8
        banview.isUserInteractionEnabled = true
        banview.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ss))
        tapGesture.numberOfTapsRequired = 1
        banview.addGestureRecognizer(tapGesture)
        banview.isHidden = true
        self.view.addSubview(banview)
        
        jiageView = UIView(frame: CGRect(x: 24, y: Height/2 - 200, width: Width - 48, height: 280))
        jiageView.backgroundColor = UIColor.white
        jiageView.isHidden = true
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
        
        baiVV = UIView(frame: CGRect(x: 24, y: Height/2 - 200, width: Width - 48, height: 280))
        baiVV.backgroundColor = UIColor.white
        baiVV.isHidden = true
        let weixintishi = UILabel(frame: CGRect(x: 24, y: 16, width: baiVV.frame.size.width - 36, height: 24))
        weixintishi.font = UIFont.systemFont(ofSize: 30)
        weixintishi.text = "明细"
        zhinazhisongLa = UILabel(frame: CGRect(x: 24, y: 48, width: baiVV.frame.size.width - 36, height: 24))
        zhinazhisongLa.text = "直拿直送: ¥ 0"
        zhinazhisongLa.font = UIFont.systemFont(ofSize: 15)
        peisongfeiLa = UILabel(frame: CGRect(x: 24, y: 80, width: baiVV.frame.size.width - 36, height: 24))
        peisongfeiLa.text = "配送费: ¥ \(peisongfei)"
        peisongfeiLa.font = UIFont.systemFont(ofSize: 15)
        juliLa = UILabel(frame: CGRect(x: 24, y: 112, width: baiVV.frame.size.width - 36, height: 24))
        juliLa.text = "距离: \(julili) 公里"
        juliLa.font = UIFont.systemFont(ofSize: 15)
        xiaofeiLa = UILabel(frame: CGRect(x: 24, y: 144, width: baiVV.frame.size.width - 36, height: 24))
        xiaofeiLa.text = "小费: ¥0.0"
        xiaofeiLa.font = UIFont.systemFont(ofSize: 15)
        dikouLa = UILabel(frame: CGRect(x: 24, y: 176, width: baiVV.frame.size.width - 36, height: 24))
        dikouLa.text = "抵扣: ¥0.0"
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
        self.view.addSubview(banview)
        self.view.addSubview(baiVV)
        self.view.addSubview(jiageView)
        jiagebiao()
        
        
        pei = UILabel(frame: CGRect(x: 80, y: 8, width: 100, height: 32))
        pei.text = "¥ \(peisongfei)"
        pei.font = UIFont.systemFont(ofSize: 15)
        
        li = UILabel(frame: CGRect(x: Width/2 + 32, y: 8, width: 100, height: 32))
        li.text = "\(julili) 公里"
        li.font = UIFont.systemFont(ofSize: 15)
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
        baiVV.isHidden = true
        jiageView.isHidden = true
        jintableView.isHidden = true
        mingtableView.isHidden = true
    }
    func gundongDonghua(string: String) {
        sousoubiView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 100, height: 32), title: string,color:UIColor.black, Font: 14, xxx: true)
        sousoubiView?.tag = 99998
        yueView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 140, height: 32), title: string,color:UIColor.black, Font: 14, xxx: true)
        yueView?.tag = 99999
    }
    func tableviewDelegate() {
        _tableview.delegate = self
        _tableview.dataSource = self
        _tableview?.register(UITableViewCell.self, forCellReuseIdentifier: "dingdan")
        _tableview.frame = CGRect(x: 0, y: 0, width: Width, height: Height - 120)
        if UIDevice.current.isX() {
            _tableview.frame = CGRect(x: 0, y: 0, width: Width, height: Height - 172)
        }
        _tableview.tableFooterView = UIView()
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        self.view.addSubview(_tableview)
    }
    func TableviewCellUI() {
        ZuoLabel = UILabel(frame: CGRect(x: 16, y: 8, width: 80, height: 32))
        ZuoLabel.tag = 99997
        ZuoLabel.font = UIFont.systemFont(ofSize: 14)
        ZuoLabel.text = "立即送出"
        uiswitch0.center = CGPoint(x: Width - 45, y: 24)
        uiswitch0.isOn = false
        uiswitch0.addTarget(self, action: #selector(switchDidChange0), for: .valueChanged)
        
//        uiswitch1.center = CGPoint(x: Width - 45, y: 24)
//        uiswitch1.isOn = false
//        uiswitch1.addTarget(self, action: #selector(switchDidChange1), for: .valueChanged)
        
        zhifuButton0 = UIButton(frame: CGRect(x: Width - 32, y: 16, width: 16, height: 16))
        zhifuButton0.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        zhifuButton0.setImage(UIImage(named: "圆圈选中"), for: .selected)
        zhifuButton0.isSelected = false
        zhifuButton0.addTarget(self, action:                #selector(DidzhifuButton0), for: .touchUpInside)
        
        zhifuButton1 = UIButton(frame: CGRect(x: Width - 32, y: 16, width: 16, height: 16))
        zhifuButton1.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        zhifuButton1.setImage(UIImage(named: "圆圈选中"), for: .selected)
        zhifuButton1.isSelected = false
        zhifuButton1.addTarget(self, action: #selector(DidzhifuButton1), for: .touchUpInside)
        
        zhifuButton2 = UIButton(frame: CGRect(x: Width - 32, y: 16, width: 16, height: 16))
        zhifuButton2.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        zhifuButton2.setImage(UIImage(named: "圆圈选中"), for: .selected)
        zhifuButton2.isSelected = false
        zhifuButton2.addTarget(self, action: #selector(DidzhifuButton2), for: .touchUpInside)
        
        xiaofeiTF = UITextField(frame: CGRect(x: 102, y: 8, width: 100, height: 32))
        xiaofeiTF.delegate = self
        
        xiaofeiTF.layer.borderWidth = 1
        xiaofeiTF.layer.borderColor = UIColor(hexString: "f7ead3").cgColor
        ButtonXF()
        souBzhiF = UITextField(frame: CGRect(x: 122, y: 8, width: 100, height: 32))
        souBzhiF.delegate = self
        souBzhiF.layer.borderWidth = 1
        souBzhiF.layer.borderColor = UIColor(hexString: "f7ead3").cgColor
        souBzhiF.keyboardType = .decimalPad
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
        yueLabel.tag = 99990
        
        yangjiao = UILabel(frame: CGRect(x: 210, y: 8, width: 64, height: 32))
        yangjiao.adjustsFontSizeToFitWidth = true
        yangjiao.text = "¥"
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
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == _tableview {
            return 2
        }else{
           return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == _tableview {
            if section == 0 {
                return 5
            }else{
                return 4
            }
        }else if tableView == jintableView {
            return todayTimes.count
        }else{
            return tomorrowTimes.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == _tableview {
            if indexPath.section == 0 {
                if indexPath.row == 3 {
                    return bounds.height + 16
                }
            }
            return 48
        }else{
            return 48
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellString = "dingdan"
        if tableView == jintableView {
            cellString = "jincell"
        }else if tableView == mingtableView{
            cellString = "mingcell"
        }
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        if tableView == _tableview {
            //去重合
            for v: UIView in cell.subviews {
                if v.tag == 99999 || v.tag == 99998 || v.tag == 99997 || v.tag == 99996 || v.tag == 99995 || v.tag == 99990 || v.tag == 99994{
                    v.removeFromSuperview()
                }
            }
            let DuoLabel = UILabel(frame: CGRect(x: 16, y: 8, width: 80, height: 32))
            DuoLabel.tag = 99997
            DuoLabel.font = UIFont.systemFont(ofSize: 14)
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    cell.addSubview(ZuoLabel)
                    cell.accessoryType = .disclosureIndicator//右箭头
                case 1:
                    DuoLabel.text = "直拿直送"
                    cell.addSubview(DuoLabel)
                    cell.addSubview(uiswitch0)
                case 2:
                    DuoLabel.text = "配送费:"
                    
                    let juli = UILabel(frame: CGRect(x: Width/2 - 16, y: 8, width: 80, height: 32))
                    juli.tag = 99994
                    juli.font = UIFont.systemFont(ofSize: 14)
                    juli.text = "距离:"
                    cell.addSubview(DuoLabel)
                    cell.addSubview(pei)
                    cell.addSubview(li)
                    cell.addSubview(juli)
                case 3:
                    DuoLabel.text = "加小费"
                    if ButtonRMB.isSelected == true{
                        xiaofeiTF.placeholder = "1~500元"
                    }else{
                        xiaofeiTF.placeholder = ""
                    }
                    xiaofeiTF.keyboardType = .decimalPad
                    cell.addSubview(DuoLabel)
                    cell.addSubview(xiaofeiTF)
                    cell.addSubview(ButtonRMB)
                    cell.addSubview(ButtonSSB)
                case 4:
                    DuoLabel.text = "备注:"
                    cell.addSubview(DuoLabel)
                    cell.addSubview(beizhuTF)
                default:
                    break
                }
                
            }else{
                let ZFImage = UIImageView(frame: CGRect(x: 16, y: 12, width: 24, height: 24))
                ZFImage.tag = 99995
                let zuolabel = UILabel(frame: CGRect(x: 48, y: 9, width: 100, height: 32))
                zuolabel.tag = 99996
                zuolabel.font = UIFont.systemFont(ofSize: 14)
                switch indexPath.row {
                case 0:
                    
                    self.gundongDonghua(string: "飕飕币剩余(\(sousoubishuliang))") //"剩余(¥\(body["qian"]))支付"
                    JJE.text = "¥\(dikoudejine)"
                    cell.addSubview(JJE)
                    cell.addSubview(DiKou)
                    cell.addSubview(souBzhiF)
                    cell.addSubview(sousoubiView!)
                case 1:
                    self.gundongDonghua(string: "余额(¥ \(dangqianyue))支付")
                    /*判断余额够不够
                     如果够 - 则添加zhifuButton2
                     如果不够 - 泽添加yueLabel
                     */
                  
                    if Float(HeJijine.text!)! <= Float(dangqianyue)!{
                        cell.addSubview(zhifuButton2)
                    }else{
                        cell.addSubview(yueLabel)
                        zhifuButton2.isSelected = false
                        if paymentMethod == "1"{
                            paymentMethod = ""
                        }
                    }
                    cell.addSubview(yueView!)
                case 2:
                    ZFImage.image = UIImage(named: "支付-支付宝")
                    zuolabel.text = "支付宝支付"//"剩余(¥\(body["qian"]))支付"
                    cell.addSubview(zhifuButton0)
                    cell.addSubview(ZFImage)
                    cell.addSubview(zuolabel)
                case 3:
                    ZFImage.image = UIImage(named: "支付-微信")
                    zuolabel.text = "微信支付"
                    cell.addSubview(zhifuButton1)
                    cell.addSubview(ZFImage)
                    cell.addSubview(zuolabel)
                default:
                    break
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
        if tableView == _tableview {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    //调一个接口/ 弄两个tableview显示 今天明天
                    jintableView.isHidden = false
                    mingtableView.isHidden = false
                    banview.isHidden = false
                }
            }
            if indexPath.section == 1 {
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
                    _tableview.reloadData()
                }
                if indexPath.row == 2 {
                    if zhifuButton0.isSelected == false {
                        zhifuButton0.isSelected = true
                        paymentMethod = "2"
                    }else{
                        zhifuButton0.isSelected = false
                        paymentMethod = ""
                    }
                    zhifuButton1.isSelected = false
                    zhifuButton2.isSelected = false
                    _tableview.reloadData()
                }
                if indexPath.row == 3 {
                    if zhifuButton1.isSelected == false {
                        zhifuButton1.isSelected = true
                        paymentMethod = "3"
                    }else{
                        zhifuButton1.isSelected = false
                        paymentMethod = ""
                    }
                    zhifuButton0.isSelected = false
                    zhifuButton2.isSelected = false
                    _tableview.reloadData()
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
    //MARK：tableviewHeader
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == _tableview {
            if section == 1{
                return 50
            }
        }else if tableView == jintableView {
            return 48
        }else if tableView == mingtableView {
            return 48
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == _tableview {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 50))
            view.backgroundColor = UIColor(hexString: "f2f2f2")
            let label = UILabel(frame: CGRect(x: 16, y: 8, width: 100, height: 40))
            label.text = "付款方式:"
            view.addSubview(label)
            if section == 1 {
                return view
            }
        }else if tableView == jintableView{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width/2, height: 48))
            view.backgroundColor = UIColor(hexString: "f2f2f2")
            let label = UILabel(frame: CGRect(x: 0, y: 12, width: Width/2, height: 24))
            label.text = "今天"
            label.textAlignment = .center
            view.addSubview(label)
            return view
        }else if tableView == mingtableView{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width/2, height: 48))
            view.backgroundColor = UIColor(hexString: "f2f2f2")
            let label = UILabel(frame: CGRect(x: 0, y: 12, width: Width/2, height: 24))
            label.text = "明天"
            label.textAlignment = .center
            view.addSubview(label)
            return view
        }
       
        return nil
    }

   //MARK: textFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let text = textField.text!
        
//        let len = text.count + string.count - range.length
        if textField == souBzhiF {
            var zhuan = "0"
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if newString.count != 0 {
                zhuan = newString
            }
            if newString.contains(".") {
                let arr = newString.components(separatedBy: ".")
                if  arr[1].count > 0 {
                    if arr[1].count > 4 {
                        return false
                    }
                }
            }
            if Float(zhuan)! > Float(sousoubishuliang)! {
                showConfirm(title: "温馨提示", message: "yoyo~ 您没有足够飕飕币哟~", in: self, confirme: { (s) in
                    self.souBzhiF.text = "0"
                    self.dikoujisuan(string: self.souBzhiF.text!)
                }) { (w) in
                    self.souBzhiF.text = self.sousoubishuliang
                    self.dikoujisuan(string: self.souBzhiF.text!)
                }
            }
            self.dikoujisuan(string:zhuan)
            
        }
        if textField == xiaofeiTF {
            if ButtonRMB.isSelected == true{
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                if newString.contains(".") {
                    let arr = newString.components(separatedBy: ".")
                    if  arr[1].count > 0 {
                        if arr[1].count > 2 {
                            return false
                        }
                    }
                }
            }else{
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                if newString.contains(".") {
                    let arr = newString.components(separatedBy: ".")
                    if  arr[1].count > 0 {
                        if arr[1].count > 4 {
                            return false
                        }
                    }
                }
                var zhuan = "0"
                if newString.count != 0 {
                    zhuan = newString
                }
                if Float(zhuan)! > Float(sousoubishuliang)! {
                    showConfirm(title: "温馨提示", message: "yoyo~ 您没有足够飕飕币哟~", in: self, confirme: { (s) in
                        self.xiaofeiTF.text = "0"
                    }) { (w) in
                        self.xiaofeiTF.text = self.sousoubishuliang
                    }
                }
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == xiaofeiTF {
            if ButtonRMB.isSelected == true {
                var xx = "0"
                if xiaofeiTF.text?.count != 0{
                    xx = xiaofeiTF.text!
                }
                if Float(xx)! > 500 {
                    textField.text = ""
                    showConfirm(title: "温馨提示", message: "小费最高为500 元", in: self, confirme: { (ss) in
                        textField.text = "0"
                    }) { (ss) in
                        textField.text = "500"
                    }
                }
            }else{
                textField.text = preciseDecimal(x: textField.text!, p: 4)
            }
            self.jisuanfangfa()
        }
    }
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
        _tableview.beginUpdates()
        _tableview.endUpdates()
    }
    //MARK：两个开关按钮
    @objc func switchDidChange0() {
        if uiswitch0.isOn == true {
            self.showConfirm(title: "温馨提示", message: "开启后，骑士从发货地到收货地的整个配送过程将无法再接其他订单，来确保您的订单能够最快送达", in: self, confirme: { (_) in
                self.uiswitch0.isOn = false
                self.jisuanfangfa()
            }) { (_) in
                self.uiswitch0.isOn = true
            }
        }
        self.jisuanfangfa()
        _tableview.reloadData()
    }
   
    @objc func DidzhifuButton0()  {
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
    @objc func DidzhifuButton1()  {
        
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
    @objc func DidzhifuButton2()  {
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
    @IBAction func querenzhifu(_ sender: Any) {

        if paymentMethod.count == 0 {
            XL_waringBox().warningBoxModeText(message: "请选择支付方式", view: self.view)
        }else{
            if zhifuButton0.isSelected == true {
                 zhifu_xiao()
                 zhifubaoZhiFu()
            }else if zhifuButton1.isSelected == true {
                WXZhiFu()
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
                            let payAlert = PayAlert(frame: UIScreen.main.bounds, jineHide: false, jine: HeJijine.text!,isMove:true)
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
                self.zhifuhuidiao()
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
    func zhifu_xiao (){
        var ssbSum = ""
        if ButtonSSB.isSelected == true {
            ssbSum = xiaofeiTF.text!
        }
        var isDirectSend = "1"
        
        if uiswitch0.isOn == false {
            isDirectSend = "2"
        }
        if paymentMethod.count == 0 {
             XL_waringBox().warningBoxModeText(message: "请选择支付方式", view: self.view)
        }else{
            
            let method = "/order/commitOrder"
            let dic:[String:Any] = ["orderId":dingdanID!,"sendTime":sendTime,"isToday":isToday,"isDirectSend":isDirectSend,"tipType":tipType,"tip":xiaofeiTF.text!,"remarks":beizhuTF.text!,"paymentMethod":paymentMethod,"postAmount":peisongfei,"amount":HeJijine.text!,"ssbSum":ssbSum,"dkAmount":dikoudejine]
            //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
            XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
                print(res)
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                if (res as! [String: Any])["code"] as! String == "0000" {
                    userDefaults.set(self.dingdanhao!, forKey: "dingdanhao")
                    if self.zhifuButton2.isSelected == true{
                        self.zhifuhuidiao()
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
    func zhifuhuidiao() {
        let method = "/order/payAfterHandler"
        let dicc:[String:Any] = ["orderCode":dingdanhao!]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            userDefaults.set("", forKey: "dingdanhao")
        self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            
            print(error)
        }
    }
    func WXZhiFu() {
        let method = "/weipay/App"
        let totalAmount = Float(HeJijine.text!)! * 100
        
        let dicc:[String:Any] = ["outTradeNo":dingdanhao!,"totalAmount":totalAmount]
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
    func zhifubaoZhiFu() {
        let method = "/AliPay/App"
        let totalAmount = Float(HeJijine.text!)!
        
        let dicc:[String:Any] = ["outTradeNo":dingdanhao!,"totalAmount":totalAmount]
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
    func dikoujisuan(string:String) {
        dikoudejine = String(format:"%.2f", Float(string)! * Float(sousouzhuanhualv)!)
        
        JJE.text = dikoudejine
        if ButtonSSB.isSelected == true {
            if (Float(xiaofeiTF.text!)! + Float(string)!) > Float(sousoubishuliang)! {
                showConfirm(title: "温馨提示", message: "yoyo~ 您的飕飕币不够了哟~", in: self, confirme: { (s) in
                    self.souBzhiF.text = "0"
                    self.dikoujisuan(string: self.souBzhiF.text!)
                }) { (w) in
                    self.souBzhiF.text = "0"
                    self.dikoujisuan(string: self.souBzhiF.text!)
                }
            }else{
                shiyongssbLa.text = "使用飕飕币: \(string) 个"
                jisuanfangfa()
            }
        }else{
            shiyongssbLa.text = "使用飕飕币: \(string) 个"
            jisuanfangfa()
        }
    }
    func jisuanfangfa() {
        let pei:Float = Float(peisongfei)!
        var xiao:Float = 0
        var zhi:Float = Float(zhinazhi)!
        zhinazhisongLa.text = "直拿直送: ¥ \(zhi)"
        let dikou:Float = Float(dikoudejine)!
        dikouLa.text = "抵扣: ¥\(dikou)"
        if tipType == "2" {
            if xiaofeiTF.text?.count != 0 {
                xiao = Float(xiaofeiTF.text!)!
                xiaofeiLa.text = "小费: ¥\(xiao)"
            }
        }else if tipType == "1" {
            if xiaofeiTF.text?.count != 0 {
                xiao = Float(xiaofeiTF.text!)! * Float(sousouzhuanhualv)!
                xiaofeiLa.text = "小费:\(xiaofeiTF.text!) 个飕飕币"
            }
        }
        
        if uiswitch0.isOn == false {
            zhi = 0
            zhinazhisongLa.text = "直拿直送: ¥ 0"
        }
        if ButtonSSB.isSelected == true {
             self.HeJijine.text = String(format: "%.2f", pei + zhi  - dikou)
        }else{
             self.HeJijine.text = String(format: "%.2f", pei + zhi + xiao - dikou)
        }
       
        if  Float(HeJijine.text!)! < 0 {
            HeJijine.text = "0.00"
//            self.dikoujisuan(string: self.souBzhiF.text!)
//            showConfirm(title: "温馨提示", message: "yoyo~ 您的飕飕币使用太多了哟~", in: self, confirme: { (s) in
//                self.souBzhiF.text = "0"
//                self.dikoujisuan(string: self.souBzhiF.text!)
//            }) { (w) in
//                self.souBzhiF.text = "0"
//                self.dikoujisuan(string: self.souBzhiF.text!)
//            }
        }
    }
    func isPurnFloat(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Float = 0
        
        return scan.scanFloat(&val) && scan.isAtEnd
    }
    //MARK：提示框
    func showConfirm(title: String, message: String, in viewController: UIViewController,confirme:((UIAlertAction)->Void)?,
                     confirm: ((UIAlertAction)->Void)?) {
       
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: confirme))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
        viewController.present(alert, animated: true)
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
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
    func anniu(button:UIButton, name: String,frame:CGRect) -> UIButton {
        button.frame = frame
        button.setTitle(name, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .selected)
        button.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        button.setImage(UIImage(named: "圆圈选中"), for: .selected)
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 60);
        //button标题的偏移量，这个偏移量是相对于图片的
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        return button
    }
    
}
//MARK：扩展UIColor
extension UIColor{
    convenience init(hexString:String){
        //处理数值
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
}
