//
//  XL_SPxiadanViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/7.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_SPxiadanViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate {
    
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
    let HJjine = "0.00"
    
    let GouArr = ["","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Delegate()
        self.title = "确认订单"
        // Do any additional setup after loading the view.
    }

    //MARK: tableviewdelegate
    func Delegate() {
        SwitchAnniu.isOn = false
        tablequeren.delegate = self
        tablequeren.dataSource = self
        tablequeren.register(UITableViewCell.self, forCellReuseIdentifier: "queren")
        tableviewUI()
        ddView()
    }
    func ddView() {
        let ddView = UIView()
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
        let JE = UILabel(frame: CGRect(x: 56, y: 12, width: 150, height: 36))
        JE.text = "¥\(HJjine)"
        JE.font = UIFont.systemFont(ofSize: 19)
        JE.textColor = UIColor.orange
        let XiaDanButton = UIButton(frame: CGRect(x: 2/3 * Width - 20, y: 5, width: Width/3, height: 46))
        XiaDanButton.addTarget(self, action: #selector(ZFaction), for: .touchUpInside)
        XiaDanButton.setTitle("确认支付", for: .normal)
        XiaDanButton.tintColor = UIColor.white
        XiaDanButton.backgroundColor = UIColor.orange
        ddView.addSubview(hengxian)
        ddView.addSubview(Label)
        ddView.addSubview(JE)
        ddView.addSubview(XiaDanButton)
        self.view.addSubview(ddView)
        
        
    }
    @objc func ZFaction() {
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
        zhifuButton2.isSelected = false
        zhifuButton2.addTarget(self, action: #selector(zfzhifuButton2), for: .touchUpInside)
        
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
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return GouArr.count
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 3
        }else {
            return 4
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 1
        }else {
            return 44
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let View = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 64))
            let xiaxian = UIView(frame: CGRect(x: 24, y: 63, width: Width, height: 1))
            xiaxian.backgroundColor = UIColor(hexString: "f0f0f0")
            let shangxian = UIView(frame: CGRect(x: 24, y: 0, width: Width, height: 1))
            shangxian.backgroundColor = UIColor(hexString: "f0f0f0")
            let imageView = UIImageView(frame: CGRect(x: 8, y: 10, width: 60, height: 48))
            let image: String = "广告页"
            imageView.image = UIImage(named: "\(image)")
            let name = UILabel(frame: CGRect(x: 84, y: 16, width: Width - 142, height: 24))
            name.textColor = UIColor(hexString: "8e8e8e")
            name.text = "小酒屋"
            let jieshao = UILabel(frame: CGRect(x: 84, y: 32, width: Width - 142, height: 32))
            jieshao.font = UIFont.systemFont(ofSize: 13)
            jieshao.textColor = UIColor(hexString: "6e6e6e")
            jieshao.numberOfLines = 2
            let weizhi = "哈尔滨香坊区红旗大街178号"
            
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
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }else if indexPath.section == 1 {
            return 112
        }else if indexPath.section == 2 {
            if indexPath.row == 2 {
                return bounds.height + 16
            }else{
               return 44
            }
        }else {
            return 44
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "queren"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.section == 0 {
            let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 80, height: 64))
            
            let image: String = "广告页"
            imageView.image = UIImage(named: "\(image)")
            let name = UILabel(frame: CGRect(x: 96, y: 16, width: Width - 142, height: 24))
            name.font = UIFont.systemFont(ofSize: 15)
            name.textColor = UIColor(hexString: "8e8e8e")
            name.text = "芝华士威士忌洋酒/250ml"
            let jiaqian = UILabel(frame: CGRect(x: 100, y: 36, width: Width - 142, height: 40))
            jiaqian.font = UIFont.systemFont(ofSize: 18)
            jiaqian.textColor = UIColor.orange
            jiaqian.numberOfLines = 2
            jiaqian.text = "¥100"
            let shuliang = UILabel(frame: CGRect(x: Width - 48, y: 50, width: 40, height: 30))
            shuliang.font = UIFont.systemFont(ofSize: 14)
            shuliang.text = "x1"
            cell.contentView.addSubview(shuliang)
            cell.contentView.addSubview(imageView)
            cell.contentView.addSubview(jiaqian)
            cell.contentView.addSubview(name)
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                //收件人信息
                let imageview = UIImageView(frame: CGRect(x: 16, y: 38, width: 44, height: 44))
                imageview.image = UIImage(named: "shou")
                let shouName = UILabel(frame: CGRect(x: 76, y: 20, width: Width - 90, height: 24))
                shouName.text = "收件人姓名"
                shouName.textColor = UIColor(hexString: "8f8f8f")
                shouName.font = UIFont.systemFont(ofSize: 14)
                let shouPhone = UILabel(frame: CGRect(x: 76, y: 48, width: Width - 90, height: 24))
                shouPhone.text = "收件人电话"
                shouPhone.textColor = UIColor(hexString: "8e8e8e")
                shouPhone.font = UIFont.systemFont(ofSize: 14)
                let shouLoction = UILabel(frame: CGRect(x: 76, y: 76, width: Width - 90, height: 24))
                shouLoction.text = "收件人地址"
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
                cell.contentView.addSubview(imageJT)
                cell.contentView.addSubview(shuxian)
                cell.contentView.addSubview(imageloc)
                cell.contentView.addSubview(dizhibu)
                cell.contentView.addSubview(imageview)
                cell.contentView.addSubview(shouName)
                cell.contentView.addSubview(shouPhone)
                cell.contentView.addSubview(shouLoction)
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                //立即送出
                let liji = UILabel(frame: CGRect(x: 16, y: 8, width: 150, height: 28))
                liji.text = "立即送出"
                liji.font = UIFont.systemFont(ofSize: 15)
                liji.textColor = UIColor(hexString: "727272")
                let shijian = UILabel(frame: CGRect(x: Width - 150, y: 8, width: 112, height: 28))
                shijian.text = "12:30"
                shijian.textAlignment = .right
                shijian.textColor = UIColor(hexString: "8e8e8e")
                shijian.font = UIFont.systemFont(ofSize: 15)
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(shijian)
                cell.contentView.addSubview(liji)
            }else if indexPath.row == 1 {
                //直拿直送
                let zhina = UILabel(frame: CGRect(x: 16, y: 8, width: 150, height: 28))
                zhina.text = "直拿直送"
                zhina.font = UIFont.systemFont(ofSize: 15)
                zhina.textColor = UIColor(hexString: "727272")
                SwitchAnniu.frame = CGRect(x: Width - 72, y: 8, width: 60, height: 30)
                SwitchAnniu.addTarget(self, action: #selector(switchDidChange), for:.valueChanged)
                cell.contentView.addSubview(zhina)
                cell.contentView.addSubview(SwitchAnniu)
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
                self.gundongDonghua(string: "飕飕币剩余(0.00)") //"剩余(¥\(body["qian"]))支付"
                JJE.text = "¥46.10"
                cell.contentView.addSubview(JJE)
                cell.contentView.addSubview(DiKou)
                cell.contentView.addSubview(souBzhiF)
                cell.contentView.addSubview(sousoubiView!)
            }else if indexPath.row == 1 {
                //余额
                self.gundongDonghua(string: "余额(¥0.00)支付")//"剩余(¥\(body["qian"]))支付"
                /*判断余额够不够
                 如果够 - 则添加zhifuButton2
                 如果不够 - 泽添加yueLabel
                 */
                cell.contentView.addSubview(yueLabel)
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            // 如果余额大于合计、则 有row == 1 判断
            if indexPath.row == 1 {
                if zhifuButton2.isSelected == false {
                    zhifuButton2.isSelected = true
                }else{
                    zhifuButton2.isSelected = false
                }
                zhifuButton1.isSelected = false
                zhifuButton0.isSelected = false
                tablequeren.reloadData()
            }
            if indexPath.row == 2 {
                if zhifuButton0.isSelected == false {
                    zhifuButton0.isSelected = true
                }else{
                    zhifuButton0.isSelected = false
                }
                zhifuButton1.isSelected = false
                zhifuButton2.isSelected = false
                tablequeren.reloadData()
            }
            if indexPath.row == 3 {
                if zhifuButton1.isSelected == false {
                    zhifuButton1.isSelected = true
                }else{
                    zhifuButton1.isSelected = false
                }
                zhifuButton0.isSelected = false
                zhifuButton2.isSelected = false
                tablequeren.reloadData()
            }

        }
    }
    func gundongDonghua(string: String) {
        sousoubiView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 100, height: 32), title: string, color:UIColor.black, Font: 14)
        sousoubiView?.tag = 99991
        yueView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 140, height: 32), title: string, color:UIColor.black, Font: 14)
        yueView?.tag = 99992
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
        tablequeren.beginUpdates()
        tablequeren.endUpdates()
    }
    @objc func switchDidChange() {
        if SwitchAnniu.isOn == true {
            self.showConfirm(title: "温馨提示", message: "开启后，骑士从发货地到收货地的整个配送过程将无法再接其他订单，来确保您的订单能够最快送达", in: self, confirme: { (_) in
                self.SwitchAnniu.isOn = false
            }) { (_) in
                self.SwitchAnniu.isOn = true
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
        if zhifuButton0.isSelected == false {
            zhifuButton0.isSelected = true
        }else{
            zhifuButton0.isSelected = false
        }
        zhifuButton1.isSelected = false
        zhifuButton2.isSelected = false
    }
    @objc func zfzhifuButton1()  {
        if zhifuButton1.isSelected == false {
            zhifuButton1.isSelected = true
        }else{
            zhifuButton1.isSelected = false
        }
        zhifuButton0.isSelected = false
        zhifuButton2.isSelected = false
    }
    @objc func zfzhifuButton2()  {
        if zhifuButton2.isSelected == false {
            zhifuButton2.isSelected = true
        }else{
            zhifuButton2.isSelected = false
        }
        zhifuButton0.isSelected = false
        zhifuButton1.isSelected = false
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
