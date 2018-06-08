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
    @IBOutlet weak var HeJijine: UILabel!
    let _tableview: UITableView! = UITableView()
    let body: [String: String] = [:]
    let uiswitch0 = UISwitch()
    let uiswitch1 = UISwitch()
    var zhifuButton0 = UIButton()
    var zhifuButton1 = UIButton()
    var zhifuButton2 = UIButton()
    
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
    var yueLabel = UILabel()
    var datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewDelegate()
        self.TableviewCellUI()
//        self.gundongDonghua()
    }
    func gundongDonghua(string: String) {
        sousoubiView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 100, height: 32), title: string,color:UIColor.black, Font: 14)
        sousoubiView?.tag = 99998
        yueView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 140, height: 32), title: string,color:UIColor.black, Font: 14)
        yueView?.tag = 99999
    }
    func tableviewDelegate() {
        _tableview.delegate = self
        _tableview.dataSource = self
        _tableview?.register(UITableViewCell.self, forCellReuseIdentifier: "dingdan")
        _tableview.frame = CGRect(x: 0, y: 0, width: Width, height: Height - 120)
        _tableview.tableFooterView = UIView()
        _tableview.rowHeight = UITableViewAutomaticDimension;
//        _tableview.separatorStyle = .none
        _tableview.estimatedRowHeight = 100;
        self.view.addSubview(_tableview)
    }
    func TableviewCellUI() {
        uiswitch0.center = CGPoint(x: Width - 45, y: 24)
        uiswitch0.isOn = false
        uiswitch0.addTarget(self, action: #selector(switchDidChange0), for: .valueChanged)
        
        uiswitch1.center = CGPoint(x: Width - 45, y: 24)
        uiswitch1.isOn = false
        uiswitch1.addTarget(self, action: #selector(switchDidChange1), for: .valueChanged)
        
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
        
        souBzhiF = UITextField(frame: CGRect(x: 122, y: 8, width: 100, height: 32))
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
        
        beizhuTF = UITextView(frame: CGRect(x: 92, y: 8, width: Width - 130, height: 32))
        beizhuTF.isScrollEnabled = false
        beizhuTF.delegate = self
        beizhuTF.font = UIFont.systemFont(ofSize: 14)
        
        //手动提示
        self.placeholderLabel.frame = CGRect(x: 0 , y: 5, width: 100, height: 20)
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        self.placeholderLabel.text = "200字以内"
        beizhuTF.addSubview(self.placeholderLabel)
        self.placeholderLabel.textColor = UIColor(red:72/256 , green: 82/256, blue: 93/256, alpha: 1)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                return bounds.height + 16
            }
        }
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "dingdan"
        
        let cell = (_tableview.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        //去重合
        for v: UIView in cell.subviews {
            if v.tag == 99999 || v.tag == 99998 || v.tag == 99997 || v.tag == 99996 || v.tag == 99995 {
                v.removeFromSuperview()
            }
        }
        let ZuoLabel = UILabel(frame: CGRect(x: 16, y: 8, width: 80, height: 32))
        ZuoLabel.tag = 99997
        ZuoLabel.font = UIFont.systemFont(ofSize: 14)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                ZuoLabel.text = "立即送出"
                cell.accessoryType = .disclosureIndicator//右箭头
            case 1:
                ZuoLabel.text = "直拿直送"
                cell.addSubview(uiswitch0)
            case 2:
                ZuoLabel.text = "加小费"
                if uiswitch1.isOn == false {
                    yangjiao.isHidden = false
                    xiaofeiTF.placeholder = "1~500元"
                }else{
                    yangjiao.isHidden = true
                    xiaofeiTF.placeholder = ""
                }
                cell.addSubview(xiaofeiTF)
                cell.addSubview(yangjiao)
                cell.addSubview(uiswitch1)
            case 3:
                ZuoLabel.text = "备注:"
                
                cell.addSubview(beizhuTF)
            default:
                break
            }
            cell.addSubview(ZuoLabel)
        }else{
            let ZFImage = UIImageView(frame: CGRect(x: 16, y: 12, width: 24, height: 24))
            ZFImage.tag = 99995
            let zuolabel = UILabel(frame: CGRect(x: 48, y: 9, width: 100, height: 32))
            zuolabel.tag = 99996
            zuolabel.font = UIFont.systemFont(ofSize: 14)
            switch indexPath.row {
            case 0:
                
                self.gundongDonghua(string: "飕飕币剩余(0.00)") //"剩余(¥\(body["qian"]))支付"
                JJE.text = "¥46.10"
                cell.addSubview(JJE)
                cell.addSubview(DiKou)
                cell.addSubview(souBzhiF)
                cell.addSubview(sousoubiView!)
            case 1:
                self.gundongDonghua(string: "余额(¥0.00)支付")//"剩余(¥\(body["qian"]))支付"
                /*判断余额够不够
                  如果够 - 则添加zhifuButton2
                 如果不够 - 泽添加yueLabel
                 */
                cell.addSubview(yueLabel)
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.ShiJian()
            }
        }
        if indexPath.section == 1 {
            // 如果余额大于合计、则 有row == 1 判断
            if indexPath.row == 1 {
                if zhifuButton2.isSelected == false {
                    zhifuButton2.isSelected = true
                }else{
                    zhifuButton2.isSelected = false
                }
                zhifuButton1.isSelected = false
                zhifuButton0.isSelected = false
                _tableview.reloadData()
            }
            if indexPath.row == 2 {
                if zhifuButton0.isSelected == false {
                    zhifuButton0.isSelected = true
                }else{
                    zhifuButton0.isSelected = false
                }
                zhifuButton1.isSelected = false
                zhifuButton2.isSelected = false
                _tableview.reloadData()
            }
            if indexPath.row == 3 {
                if zhifuButton1.isSelected == false {
                    zhifuButton1.isSelected = true
                }else{
                    zhifuButton1.isSelected = false
                }
                zhifuButton0.isSelected = false
                zhifuButton2.isSelected = false
                _tableview.reloadData()
            }

        }
    }
    //MARK：tableviewHeader
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 50
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 50))
        view.backgroundColor = UIColor(hexString: "f2f2f2")
        let label = UILabel(frame: CGRect(x: 16, y: 8, width: 100, height: 40))
        label.text = "付款方式:"
        view.addSubview(label)
        if section == 1 {
            return view
        }
        return nil
    }
    func ShiJian() {
        let banview = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        banview.backgroundColor = UIColor.gray
        banview.alpha = 0.5
        banview.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        tapGesture.numberOfTapsRequired = 1
        banview.addGestureRecognizer(tapGesture)
        self.view.addSubview(banview)
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: Height - 300, width: Width, height: 300))
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.calendar = Calendar.current
        datePicker.date = Date(timeIntervalSinceNow: 900)
        datePicker.minuteInterval = 15
        datePicker.backgroundColor = UIColor.white
//        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        self.view.addSubview(datePicker)
    }
    @objc func tapGestureAction() {
//        if 选择时间小于现在时间 {
//
//        }
        let choosePicker = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd日 HH:mm:ss"
        print(dateFormatter.string(from: choosePicker))
    }
    @objc func chooseDate(_datePicker: UIDatePicker) {
        let choosePicker = _datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd日 HH:mm:ss"
        print(dateFormatter.string(from: choosePicker))
        
        
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
        if textView.text.count >= 200 {
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
            }) { (_) in
                self.uiswitch0.isOn = true
            }
        }
        
        _tableview.reloadData()
    }
    @objc func switchDidChange1() {
        if uiswitch1.isOn == true {
//            uiswitch0.isOn = false
        }
        _tableview.reloadData()
    }
    @objc func DidzhifuButton0()  {
        if zhifuButton0.isSelected == false {
            zhifuButton0.isSelected = true
        }else{
            zhifuButton0.isSelected = false
        }
        zhifuButton1.isSelected = false
        zhifuButton2.isSelected = false
    }
    @objc func DidzhifuButton1()  {
        if zhifuButton1.isSelected == false {
            zhifuButton1.isSelected = true
        }else{
            zhifuButton1.isSelected = false
        }
        zhifuButton0.isSelected = false
        zhifuButton2.isSelected = false
    }
    @objc func DidzhifuButton2()  {
        if zhifuButton2.isSelected == false {
            zhifuButton2.isSelected = true
        }else{
            zhifuButton2.isSelected = false
        }
        zhifuButton0.isSelected = false
        zhifuButton1.isSelected = false
    }
    @IBAction func querenzhifu(_ sender: Any) {
 
//        let methodName = "/set/startPage"
//        let rucan = ["userId" : "3987"]
//        XL_QuanJu().PuTongWangluo(methodName: methodName, methodType: .post, rucan: rucan, success: { (result) in
//            print(result)
//        }) { (error) in
//            print(error)
//        }
        var imageArr: Array<UIImage>! = []
        let image0 = UIImage(named: "广告页")
        let image1 = UIImage(named: "启动页")
        imageArr.append(image0!)
        imageArr.append(image1!)
        let nameArray = ["licensePic","licensePic1"]
        let dic = ["userId":"1102","firmName":"10","firmAddress":"11","firmLinkman":"12","phone":"13312345678","idCard":"14"]
        
        
        XL_QuanJu().UploadWangluo(imageArray: imageArr, NameArray: nameArray, methodName: "/user/realAuthentication", rucan: dic, success: { (result) in
            print(result)
        }) { (error) in
            print(error)
        }
        
        
        if zhifuButton0.isSelected == true {
            self.zhifubaoZhiFu()
        }else if zhifuButton1.isSelected == true {
            self.WXZhiFu()
        }
    }

   
    func WXZhiFu() {
        let dic = [ "appid": "wx678a8d37c4aec635",
                    "noncestr": "dQy2zTPRg48jQPul",
                    "package": "Sign=WXPay",
                    "partnerid": "1392226802",
                    "prepayid": "wx19153207255703ecd268bfba1625016896",
                    "sign": "D1613083301F75B33041CEB0C32A172D",
                    "timestamp": "1524123128"]
        let orderBody = XL_weixinObjc()
        orderBody.appid = dic["appid"]
        orderBody.noncestr = dic["noncestr"]
        orderBody.package = dic["package"]
        orderBody.partnerid = dic["partnerid"]
        orderBody.prepayid = dic["prepayid"]
        orderBody.sign = dic["sign"]
        orderBody.timestamp = dic["timestamp"]
        let req = PayReq()
        req.partnerId = orderBody.partnerid
        req.prepayId = orderBody.prepayid
        req.nonceStr = orderBody.noncestr
        req.timeStamp = UInt32(orderBody.timestamp!)!
        req.package = orderBody.package
        req.sign = orderBody.sign
        
        
        WXApi.send(req)
        
    }
    func zhifubaoZhiFu() {
        let appID = "2016091801915805"
        let rsa2PrivateKey = "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDVjUwm4bB98pWKM11nHLofnSdVQVlohBu2wf/5d+xGeQ/fISQsE5zphDygcGBut8Zbe8w2jUKAwGPN89hUomoxyHO2epYsfmDEioB9h6wHOJtMxFu8Ua776VXv4ZsY7TRnPu9l07WT0DNHFX8bfKPHFpg2x+cOgjMiQDLtMOTYyV9eVZK+QEZP5tJqHiKGhRUg1lli+a6kUPylINQG2akbXniSOU6kp9Wkwz7sMbdtCnpNVfB3H35Ftizs0xjA/KYeMZdNbVPOXsFU1Epj+KanWinfZfTq2AhHA6Lu1Hsc4ZdPf4cOgYRNuvrKTrCmFqZHXc6fjL9+DzWrODdS0noVAgMBAAECggEADzNsnUPpZT20SU8YsfNIiGGOYDIzpA3rTxoGF4Liza1mZNKeGYkX3UNtcVoucxMfynlIcwWhGzsWn51g471f48VJ/05AjFA+oR7ewJC8vRLZcyBzCzehRgs488dSW/beiQ7gyZXFUg066S9tic5Ydh50nUmjd9PqweBh/6JAV/H0QawKlyVmT0Rt2054ah48h5Hrfw41/QmiKYdG5gKqxSZ2I4g5t76qzvaDmjUJ9hBuuUPmFL+Qs2JQiBNBHPweaOSa8ihPCss9PZ+6WWMm2l3IlcimC/sI7alw43rZQK5bvf86i+U5FaxU1Io7pmkMpi1KhG4V1nu9HW/sfebgzQKBgQD3gGhCT3yLXmONbXh0VzIQxC9H4izM8A1vSoVOVYLeMlN5yY/NagXrS4BIL5Dl/B9p8XDcx5WZt44RTPbWHB+Qczqy6Fkb29KYiRAsle8QE/+9LLv62KqLi3s1LhCYCDsW434QW/81cx28UWyLhl041RbF1Vfn+HRI0T+XpSXdKwKBgQDc4ncmcRHnk5QABXbix4RCxHRp2yS8phJRFyPQCPI3MTFyrxHP0GzDrk2GJSIZNtZG+lg+gkjk4yjviXuAljLj5NvKub1kgHF8w8+IQmdN8fsNLmXwYM/DRAvF/8cxvq4NKUb2cYwv2rN/EbYtpj5j/sPlTMetZnVbTwVp9rHlvwKBgAPD41Im7WkdXXxYTv3OGcfhhCqeyTmw6TNpOc/wQxZoQ5bVtydT1pU2x9PRTW4CQOQWtTXWn3MANNwUhKjLMru61QjFuh1PYcvKQgG7ojBnbXuOQ6nUQ/vteklb0wrNDUES4ucSzzYb8zbbMkCJIb/slfUagsTXpcU50bLX41STAoGARxn/ELjE8q5mrbsUkdt3j6Z9crXAFZm/u6qfNJAsp+eF60y/hw2odTTeb5f0aflk8GQVk8mMfWFCBBlVUAcJSqKYvaEcfgV6gpblbw8xAb4q+gs9dSs0tb5pq8qx7CldDY+D8ECMx7q2nOiuo/MnkjioBl+4xvB8RnAhZgKrMTECgYBrG++MQbHyBfHEFRd6jk8wttld7wb1WhDID33735Npyr1ku1jAR0dyFqzNZM568bYg28f/MJrRJ5IpynjFPEnAzUds78xrhMHBmdLIA+Ll9+RoU8wOJMgoMb7dyCH0BQJYHWv2mRVdjMJbubGt2tNJNky4AcreoTSuUXv75A+Jhw=="
        
        let order: APOrderInfo = APOrderInfo()
        order.app_id = appID
        order.method = "alipay.trade.app.pay"
        order.charset = "utf-8"
        let now = Date()
        // 创建一个日期格式器
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        order.timestamp = formatter.string(from:now)
        print(formatter.string(from: Date()))
        order.version = "1.0"
        order.sign_type = "RSA2"
        //商品数据
        order.biz_content = APBizContent()
        order.biz_content.body = "我是测试数据"
        order.biz_content.subject = "1"
        order.biz_content.out_trade_no = "songhaoran"//订单号
        order.biz_content.timeout_express = "30m"
        order.biz_content.total_amount = "0.01"
        let orderInfo = order.orderInfoEncoded(false)
        let orderInfoEncoded = order.orderInfoEncoded(true)
        print(orderInfo as Any)
        let signer: APRSASigner = APRSASigner(privateKey: rsa2PrivateKey)
        let signedSring = signer.sign(orderInfo, withRSA2: true)
        if signedSring?.count != 0 {
            let appScheme = "TuSouSou"
            let orderString = "alipay_sdk=alipay-sdk-java-dynamicVersionNo&app_id=2016091801915805&biz_content=%7B%22body%22%3A%22%E5%85%94%E9%A3%95%E9%A3%95%22%2C%22out_trade_no%22%3A%2285624788eed%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%E9%9B%AA%E7%A2%A7%22%2C%22timeout_express%22%3A%2215d%22%2C%22total_amount%22%3A%220.01%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fm5uy3m.natappfree.cc%2FAliPay%2Fnotify.do&sign=oZJOLr%2F%2FKfyTJfS6wfQ%2Fnc0h9sbGFu3OiUW9yq0AHaJkPKTJTg%2FB54WUhmV5uIo5dlHKXEh9N4g0E3xTjgy5vwteVcsmVCqyDAg9TjdPFjgLDsSPI6zJX1xvplnJaDjFcBK%2BAvGkdcvpfgVyIX8zpDj1gCtbrvHxpaEGStb643Vs2pY%2FIMLxdFd1%2B71J6fFPJQYkAGCV7Gnfb%2BkZ3Cmls8DS%2F1UTNkKLNuEXLNxz7IjzEQlLsdKyb8EQMOynF%2FonwLJAp2EALjiSFaivC8o5OsAB4vFSa%2FLgtqjS5oOzI23xeUlKGD8GcoQcVC7c1%2BtPhOVUY%2FNBVOtZjClQq0dTrQ%3D%3D&sign_type=RSA2&timestamp=2018-04-19+17%3A19%3A07&version=1.0"
                //"\(orderInfoEncoded!)&sign=\(signedSring!)"
            
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme) { (resultDic) -> () in
                for (key,value) in resultDic! {
                    print("\(key) : \(value)")
                }
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
