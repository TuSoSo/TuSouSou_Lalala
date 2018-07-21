//
//  XL_WDDDXQ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/31.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDDDXQ_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,RatingBarDelegate {
    var leixing:String? //是否已完成
    var shangLX:String? //是否有商品
    var isPingjia = 0
    
    
    var evalClear:Float = 10.0
    var evalSpeed:Float = 10.0
    var evalServer:Float = 10.0
    
    var dingdanId:String?
    
    @IBOutlet weak var tablewdddxq: UITableView!
    var SPDic:[String:Any] = [:]
    var shuzu:[[String:Any]] = []
    //取件时间
    var qujianshijian = ""
    
    //评分
    var ratingBar1: WNRatingBar!
    var ratingLabel1:UILabel!
    var ratingLabel2:UILabel!
    var ratingLabel3:UILabel!
    var ratingValue:Float = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        print("\n\(leixing!)\n\(dingdanId!)")
        jiemianjiekou()
        tableviewdelegate()
        // Do any additional setup after loading the view.
    }
    func jiemianjiekou() {
        let method = "/order/orderDetail"
        //        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["orderId":dingdanId!]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                //                XL_waringBox().warningBoxModeText(message: "评价成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.SPDic = dic
                self.qujianshijian = dic["sendTime"] as! String
                if nil != dic["productList"]{
                    self.shuzu = dic["productList"] as! [[String:Any]]
                }
                self.tablewdddxq.reloadData()
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
    //MARK:tableViewDelegate
    func tableviewdelegate() {
        tablewdddxq.delegate = self
        tablewdddxq.dataSource = self
        tablewdddxq.tableFooterView = UIView()
        tablewdddxq.register(UITableViewCell.self, forCellReuseIdentifier: "wdddxq")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if leixing! == "6"{
            if shangLX! == "3" {
                return 6
            }else{
                return 5
            }
        }else{
            if shangLX! == "3" {
                return 4
            }else{
                return 3
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if leixing! == "6"{
            if shangLX! == "3" {
                if section == 0 {
                    return 6 // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
                }else if section == 1 {
                    return 4 //配送员，联系电话，配送地址，位置信息
                }else if section == 2 {
                    return shuzu.count //商品个数
                }else if section == 3 {
                    return 6//付款方式、配送、直拿、小费、抵扣、合计
                }else if section == 4 {
                    return 3 //评价
                }else {
                    return 1 // 确定按钮
                }
            }else{
                if section == 0 {
                    return 6 // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
                }else if section == 1 {
                    return 4 //配送员，联系电话，配送地址，位置信息
                }else if section == 2 {
                    return 6//付款方式、配送、直拿、小费、抵扣、合计
                }else if section == 3 {
                    return 3 //评价
                }else {
                    return 1 // 确定按钮
                }
            }
        }else{
            if shangLX! == "3" {
                if section == 0 {
                    return 6 // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
                }else if section == 1 {
                    return 4 //配送员，联系电话，配送地址，位置信息
                }else if section == 2 {
                    return shuzu.count //商品个数
                }else {
                    return 6//付款方式、配送、直拿、小费、抵扣、合计
                }
            }else{
                if section == 0 {
                    return 6 // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
                }else if section == 1 {
                    return 4 //配送员，联系电话，配送地址，位置信息
                }else {
                    return 6//付款方式、配送、直拿、小费、抵扣、合计
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if leixing! == "6"{
            if shangLX! == "3" {
                if indexPath.section == 0 {
                    if indexPath.row == 5{
                        return 80
                    }
                    return 44 // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
                }else if indexPath.section == 1 {
                    if indexPath.row == 2 {
                        return 80
                    }
                    return 44 //配送员，联系电话，配送地址，位置信息
                }else if indexPath.section == 2 {
                    return 80 //商品个数
                }else if indexPath.section == 3 {
                    return 44//付款方式、配送、直拿、小费、抵扣、合计
                }else if indexPath.section == 4 {
                    return 56 //评价
                }else {
                    return 120 // 确定按钮
                }
            }else{
                if indexPath.section == 0 {
                    if indexPath.row == 5{
                        return 80
                    }
                    return 44 // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
                }else if indexPath.section == 1 {
                    if indexPath.row == 2 {
                        return 80
                    }
                    return 44 //配送员，联系电话，配送地址，位置信息
                }else if indexPath.section == 2 {
                    return 44//付款方式、配送、直拿、小费、抵扣、合计
                }else if indexPath.section == 3 {
                    return 56 //评价
                }else {
                    return 120 // 确定按钮
                }
            }
        }else{
            if shangLX! == "3" {
                if indexPath.section == 0 {
                    if indexPath.row == 5{
                        return 80
                    }else if indexPath.row == 0{
                        return 60
                    }
                    return 44 // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
                }else if indexPath.section == 1 {
                    if indexPath.row == 2 {
                        return 80
                    }
                    return 44 //配送员，联系电话，配送地址，位置信息
                }else if indexPath.section == 2 {
                    return 80 //商品个数
                }else {
                    return 44//付款方式、配送、直拿、小费、抵扣、合计
                }
            }else{
                if indexPath.section == 0 {
                    if indexPath.row == 5 {
                        return 80
                    }
                    return 44 // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
                }else if indexPath.section == 1 {
                    if indexPath.row == 2 {
                        return 80
                    }
                    return 44 //配送员，联系电话，配送地址，位置信息
                }else {
                    return 44//付款方式、配送、直拿、小费、抵扣、合计
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if leixing! == "6" {
            if shangLX! == "3" {
                if section == 5 {
                    return 0
                }
            }else{
                if section == 4 {
                    return 0
                }
            }
        }
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 44))
        vi.backgroundColor = UIColor(hexString: "f0eff5")
        
        let zuo = UILabel(frame: CGRect(x: 16, y: 10, width: Width - 32, height: 24))
        zuo.textColor = UIColor.orange
        zuo.font = UIFont.systemFont(ofSize: 15)
        zuo.adjustsFontSizeToFitWidth = true
        if leixing! == "6" {
            if shangLX! == "3" {
                if section == 0 {
                    zuo.text = "订单信息(预约取件时间:\(qujianshijian)"
                    vi.addSubview(zuo)
                }else if section == 1 {
                    zuo.text = "配送信息"
                    vi.addSubview(zuo)
                }else if section == 2 {
                    zuo.text = "商品信息"
                    vi.addSubview(zuo)
                }else if section == 3 {
                    zuo.text = "消费信息"
                    vi.addSubview(zuo)
                }else if section == 4 {
                    zuo.text = "评价信息"
                    vi.addSubview(zuo)
                }else if section == 5 {
                    return nil
                }
            }else{
                if section == 0 {
                    zuo.text = "订单信息(预约取件时间:\(qujianshijian))"
                    vi.addSubview(zuo)
                }else if section == 1 {
                    zuo.text = "配送信息"
                    vi.addSubview(zuo)
                }else if section == 2 {
                    zuo.text = "消费信息"
                    vi.addSubview(zuo)
                }else if section == 3 {
                    zuo.text = "评价信息"
                    vi.addSubview(zuo)
                }else if section == 4 {
                    return nil
                }
            }
        }else{
            if shangLX! == "3" {
                if section == 0 {
                    zuo.text = "订单信息(预约取件时间:\(qujianshijian))"
                    vi.addSubview(zuo)
                }else if section == 1 {
                    zuo.text = "配送信息"
                    vi.addSubview(zuo)
                }else if section == 2 {
                    zuo.text = "商品信息"
                    vi.addSubview(zuo)
                }else if section == 3 {
                    zuo.text = "消费信息"
                    vi.addSubview(zuo)
                }
            }else{
                if section == 0 {
                    zuo.text = "订单信息(预约取件时间:\(qujianshijian))"
                    vi.addSubview(zuo)
                }else if section == 1 {
                    zuo.text = "配送信息"
                    vi.addSubview(zuo)
                }else if section == 2 {
                    zuo.text = "消费信息"
                    vi.addSubview(zuo)
                }
            }
        }
        return vi
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "wdddxq"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        cell.backgroundColor = UIColor.white
        let zuolabel = UILabel(frame: CGRect(x: 16, y: 11, width: 80, height: 22))
        zuolabel.font = UIFont.systemFont(ofSize: 15)
        zuolabel.textColor = UIColor.darkGray
    
        let youlabel = UILabel(frame: CGRect(x: 104, y: 11, width:  Width - 124, height: 22))
        youlabel.font = UIFont.systemFont(ofSize: 15)
        youlabel.textColor = UIColor.darkGray
//        youlabel.adjustsFontSizeToFitWidth = true
        youlabel.textAlignment = .right
//        youlabel.numberOfLines = 2
        
        let youlabel1 = UILabel(frame: CGRect(x: 96, y: 36, width:  Width - 120, height: 44))
//        youlabel1.adjustsFontSizeToFitWidth = true
        youlabel1.font = UIFont.systemFont(ofSize: 14)
        youlabel1.textColor = UIColor.darkGray
        youlabel1.textAlignment = .right
        youlabel1.numberOfLines = 2
//        youlabel1.sizeToFit()
        
        let dingddd = UILabel(frame: CGRect(x: 104, y: 4, width:  Width - 124, height: 44))
        dingddd.font = UIFont.systemFont(ofSize: 15)
        dingddd.textColor = UIColor.darkGray
        //        youlabel.adjustsFontSizeToFitWidth = true
        dingddd.textAlignment = .right
        dingddd.numberOfLines = 2
        
        if indexPath.section == 0 {
            // 订单编号、下单时间、取件时间、送达时间、订单备注、寄取地址
            if indexPath.row == 0 {
                zuolabel.text = "订单编号:"
                dingddd.text = SPDic["orderCode"] as? String
                cell.contentView.addSubview(dingddd)
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 1 {
                zuolabel.text = "下单时间:"
                youlabel.text = SPDic["placeOrderTime"] as? String
                cell.contentView.addSubview(youlabel)
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 2 {
                zuolabel.text = "取件时间:"
                youlabel.text = SPDic["postTime"] as? String
                cell.contentView.addSubview(youlabel)
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 3 {
                zuolabel.text = "送达时间:"
                youlabel.text = SPDic["arriveTime"] as? String
                cell.contentView.addSubview(youlabel)
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 4 {
                zuolabel.text = "订单备注:"
                youlabel.text = SPDic["remarks"] as? String
                cell.contentView.addSubview(youlabel)
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 5 {
                zuolabel.text = "寄取地址:"
//                youlabel.text = SPDic["arriveTime"] as? String
                var name = ""
                if nil != SPDic["merName"] {
                    name = SPDic["merName"] as! String
                }
                var phone = ""
                if nil != SPDic["merPhone"] {
                    phone = SPDic["merPhone"] as! String
                }
                var dizhi = ""
                if nil != SPDic["merAddress"] {
                    dizhi = SPDic["merAddress"] as! String
                }
                youlabel.text = name + "  " + phone
                youlabel1.text = dizhi
                cell.contentView.addSubview(youlabel1)
                cell.contentView.addSubview(youlabel)
                cell.contentView.addSubview(zuolabel)
            }
        }else if indexPath.section == 1 {
            //配送员，联系电话，配送地址，位置信息
            if indexPath.row == 0 {
                zuolabel.text = "配送员:"
                youlabel.text = SPDic["sendUserName"] as? String
                cell.contentView.addSubview(youlabel)
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 1 {
                zuolabel.text = "联系电话:"
                youlabel.text = SPDic["sendUserPhone"] as? String
                cell.contentView.addSubview(youlabel)
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 2 {
                zuolabel.text = "配送地址:"
                var name = ""
                if nil != SPDic["edSendUserName"] {
                    name = SPDic["edSendUserName"] as! String
                }
                var phone = ""
                if nil != SPDic["edSendUserIphone"] {
                    phone = SPDic["edSendUserIphone"] as! String
                }
                var dizhi = ""
                if nil != SPDic["edSendUserAddress"] {
                    dizhi = SPDic["edSendUserAddress"] as! String
                }
                youlabel.text = name + "  " + phone
                youlabel1.text = dizhi
                cell.contentView.addSubview(youlabel1)
                cell.contentView.addSubview(youlabel)
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 3 {
                zuolabel.text = "位置信息:"
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(zuolabel)
            }
        }
        if leixing! == "6"{
            if shangLX! == "3" {
                if indexPath.section == 2 {
                    //商品个数
                    shangpinUI(indexPath: indexPath, cell: cell)
                }else if indexPath.section == 3 {
                    //付款方式、配送、直拿、小费、抵扣、合计
                    if indexPath.row == 0 {
                        zuolabel.text = "付款方式:"
                        youlabel.text = ""
                        if SPDic["paymentMethod"] as? String == "1"{
                            youlabel.text = "余额支付"
                        }else if SPDic["paymentMethod"] as? String == "2"{
                            youlabel.text = "支付宝支付"
                        }else if SPDic["paymentMethod"] as? String == "3"{
                            youlabel.text = "微信支付"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 1 {
                        zuolabel.text = "配送费:"
                        if nil != SPDic["postAmount"]{
                            youlabel.text = String(format: "¥ %@", (SPDic["postAmount"] as? String)!)
                        }else{
                            youlabel.text = "¥ 0.00m"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 2 {
                        zuolabel.text = "直拿直送:"
                        var zhinazhi = "¥ 0.00"
                        if nil != SPDic["directSendAmount"] {
                            switch SPDic["directSendAmount"] {
                            case is String:
                                zhinazhi = "¥ 0.00"
                            default:
                                zhinazhi = String(format: "¥ %.2f", (SPDic["directSendAmount"] as? Float)!)
                                break
                                
                            }
                        }
                        youlabel.text = zhinazhi
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 3 {
                        zuolabel.text = "小费:"
                        var qian = "0.00"
                        youlabel.text = "¥ \(qian)"
                       if nil != SPDic["tip"] && (SPDic["tip"] as! String).count != 0 {
                            qian = SPDic["tip"] as! String
                        }
                        if nil != SPDic["tipType"] && SPDic["tipType"] as? String == "2"{
                            youlabel.text = "¥ \(qian)"
                        }else if nil != SPDic["tipType"] && SPDic["tipType"] as? String == "1"{
                            youlabel.text = "\(qian) 个飕飕币"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 4 {
                        zuolabel.text = "抵扣:"
                        var dikoudikou = "¥ 0.00"
                        if nil != SPDic["dkAmount"] {
                            dikoudikou = String(format: "¥ %.2f", (SPDic["dkAmount"] as? Float)!)
                        }
                        youlabel.text = dikoudikou
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 5 {
                        zuolabel.text = "合计:"
                        var hejiheji = "¥ 0.00"
                        if nil != SPDic["amount"] {
                            hejiheji = String(format: "¥ %@", (SPDic["amount"] as? String)!)
                        }
                        youlabel.text = hejiheji
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }
                }else if indexPath.section == 4 {
                    //评价
                    ratingBar1 = WNRatingBar()
                    ratingBar1.frame = CGRect(x: Width - 152, y: 8, width: 100, height: 40)
                    ratingBar1.setSeletedState("star_big1", halfSelectedName: "star_big2", fullSelectedName: "star_big3", starSideLength: 28, delegate: self)
                    ratingBar1.tag = indexPath.row
                    var fenshu: Float! = 5
                    ratingBar1.isIndicator = false
                    if indexPath.row == 0{
                        if nil != SPDic["evalSpeed"] {
                            fenshu = SPDic["evalSpeed"] as! Float
                        }
                        if fenshu == 0 {
                            isPingjia = 1
                            fenshu = 5
                        }
                        zuolabel.text = "配送速度"
                        ratingBar1.displayRating(fenshu)
                        cell.contentView.addSubview(ratingBar1)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 1 {
                        if nil != SPDic["evalServer"] {
                            fenshu = SPDic["evalServer"] as! Float
                        }
                        if fenshu == 0 {
                            fenshu = 5
                            isPingjia = 1
                        }
                        zuolabel.text = "服务态度"
                        ratingBar1.displayRating(fenshu)
                        cell.contentView.addSubview(ratingBar1)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 2 {
                        if nil != SPDic["evalClear"] {
                            fenshu = SPDic["evalClear"] as! Float
                        }
                        if fenshu == 0 {
                            isPingjia = 1
                            fenshu = 5
                        }
                        zuolabel.text = "衣着整洁"
                        ratingBar1.displayRating(fenshu)
                        cell.contentView.addSubview(ratingBar1)
                        cell.contentView.addSubview(zuolabel)
                    }
                }else if indexPath.section == 5{
                    // 确定按钮
                    let PJbutton = UIButton(frame: CGRect(x: Width/2 - 75, y: 16, width: 150, height: 56))
                    
//                    PJbutton.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
//                    PJbutton.setBackgroundImage(UIImage(named: "button_normal_light"), for: .highlighted)
                    PJbutton.isSelected = false
                    if isPingjia == 0 {
                        PJbutton.setTitle("已评价", for: .selected)
                        PJbutton.isSelected = true
                        PJbutton.backgroundColor = UIColor.orange
                    }else{
                        PJbutton.setTitle("提交评价", for: .normal)
                        PJbutton.isSelected = false
                        PJbutton.backgroundColor = UIColor.orange
                    }
                    PJbutton.setTitleColor(UIColor.white, for: .normal)
//                    PJbutton.isUserInteractionEnabled = true
                    PJbutton.addTarget(self, action: #selector(PJjiekou), for: .touchUpInside)
                    cell.contentView.addSubview(PJbutton)
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                }
            }else{
                if indexPath.section == 2 {
                    //付款方式、配送、直拿、小费、抵扣、合计
                    if indexPath.row == 0 {
                        zuolabel.text = "付款方式:"
                        youlabel.text = ""
                        if SPDic["paymentMethod"] as? String == "1"{
                            youlabel.text = "余额支付"
                        }else if SPDic["paymentMethod"] as? String == "2"{
                            youlabel.text = "支付宝支付"
                        }else if SPDic["paymentMethod"] as? String == "3"{
                            youlabel.text = "微信支付"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 1 {
                        zuolabel.text = "配送费:"
                        youlabel.text = SPDic["postAmount"] as? String
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 2 {
                        zuolabel.text = "直拿直送:"
                        var zhinazhi = "¥ 0.00"
                        if nil != SPDic["directSendAmount"] {
                            switch SPDic["directSendAmount"] {
                            case is String:
                                zhinazhi = "¥ 0.00"
                            default:
                                zhinazhi = String(format: "¥ %.2f", (SPDic["directSendAmount"] as? Float)!)
                                break
                                
                            }
                        }
                        youlabel.text = zhinazhi
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 3 {
                        zuolabel.text = "小费:"
                        var qian = "0.00"
                        youlabel.text = "¥ \(qian)"
                        if nil != SPDic["tip"] && (SPDic["tip"] as! String).count != 0 {
                            qian = SPDic["tip"] as! String
                        }
                        if nil != SPDic["tipType"] && SPDic["tipType"] as? String == "2"{
                            youlabel.text = "¥ \(qian)"
                        }else if nil != SPDic["tipType"] && SPDic["tipType"] as? String == "1"{
                            youlabel.text = "\(qian) 个飕飕币"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 4 {
                        zuolabel.text = "抵扣:"
                        var dikoudikou = "¥ 0.00"
                        if nil != SPDic["dkAmount"] {
                            dikoudikou = String(format: "¥ %.2f", (SPDic["dkAmount"] as? Float)!)
                        }
                        youlabel.text = dikoudikou
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 5 {
                        zuolabel.text = "合计:"
                        var hejiheji = "¥ 0.00"
                        if nil != SPDic["amount"] {
                            hejiheji = String(format: "¥ %@", (SPDic["amount"] as? String)!)
                        }
                        youlabel.text = hejiheji
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }
                }else if indexPath.section == 3 {
                    //评价
                    ratingBar1 = WNRatingBar()
                    ratingBar1.frame = CGRect(x: Width - 152, y: 8, width: 100, height: 40)
                    ratingBar1.setSeletedState("star_big1", halfSelectedName: "star_big2", fullSelectedName: "star_big3", starSideLength: 28, delegate: self)
                    ratingBar1.tag = indexPath.row
                    var fenshu: Float! = 10
                    ratingBar1.isIndicator = false
                    if indexPath.row == 0{
                        if nil != SPDic["evalSpeed"] {
                            fenshu = SPDic["evalSpeed"] as! Float
                        }
                        if fenshu == 0 {
                            fenshu = 5
                            isPingjia = 1
                        }
                        zuolabel.text = "配送速度"
                        ratingBar1.displayRating(fenshu)
                        cell.contentView.addSubview(ratingBar1)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 1 {
                        if nil != SPDic["evalServer"] {
                            fenshu = SPDic["evalServer"] as! Float
                        }
                        if fenshu == 0 {
                            fenshu = 5
                            isPingjia = 1
                        }
                        zuolabel.text = "服务态度"
                        ratingBar1.displayRating(fenshu)
                        cell.contentView.addSubview(ratingBar1)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 2 {
                        if nil != SPDic["evalClear"] {
                            fenshu = SPDic["evalClear"] as! Float
                        }
                        if fenshu == 0 {
                            fenshu = 5
                            isPingjia = 1
                        }
                        zuolabel.text = "衣着整洁"
                        ratingBar1.displayRating(fenshu)
                        cell.contentView.addSubview(ratingBar1)
                        cell.contentView.addSubview(zuolabel)
                    }
                }else if indexPath.section == 4{
                    // 确定按钮
                    let PJbutton = UIButton(frame: CGRect(x: Width/2 - 75, y: 16, width: 150, height: 56))
                    PJbutton.isSelected = false
                    if isPingjia == 0 {
                        PJbutton.setTitle("已评价", for: .selected)
                        PJbutton.isSelected = true
                        PJbutton.backgroundColor = UIColor.orange
                    }else {
                        PJbutton.setTitle("提交评价", for: .normal)
                        PJbutton.isSelected = false
                        PJbutton.backgroundColor = UIColor.orange
                    }
                    PJbutton.setTitleColor(UIColor.white, for: .normal)
//                    PJbutton.isUserInteractionEnabled = true
                    PJbutton.addTarget(self, action: #selector(PJjiekou), for: .touchUpInside)
                    cell.contentView.addSubview(PJbutton)
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                }
            }
        }else{
            if shangLX! == "3" {
                if indexPath.section == 2 {
                    //商品个数
                    shangpinUI(indexPath: indexPath, cell: cell)
                }else if indexPath.section == 3{
                    //付款方式、配送、直拿、小费、抵扣、合计
                    if indexPath.row == 0 {
                        zuolabel.text = "付款方式:"
                        youlabel.text = ""
                        if SPDic["paymentMethod"] as? String == "1"{
                            youlabel.text = "余额支付"
                        }else if SPDic["paymentMethod"] as? String == "2"{
                            youlabel.text = "支付宝支付"
                        }else if SPDic["paymentMethod"] as? String == "3"{
                            youlabel.text = "微信支付"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 1 {
                        zuolabel.text = "配送费:"
                        youlabel.text = SPDic["postAmount"] as? String
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 2 {
                        zuolabel.text = "直拿直送:"
                        //一会double一会string
                        var zhinazhi = "¥ 0.00"
                        
                        if nil != SPDic["directSendAmount"] {
//                            let ss = SPDic["directSendAmount"]
//                            guard ss is String else{
//                                zhinazhi = String(format: "¥ %.2f", (SPDic["directSendAmount"] as? Float)!)
//                                return zhinazhi
//                            }
                            switch SPDic["directSendAmount"] {
                            case is String:
                                zhinazhi = "¥ 0.00"
                            default:
                                zhinazhi = String(format: "¥ %.2f", (SPDic["directSendAmount"] as? Float)!)
                                break
                                
                            }
                        }
                        youlabel.text = zhinazhi
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 3 {
                        zuolabel.text = "小费:"
                        var qian = "0.00"
                        youlabel.text = "¥ \(qian)"
                        if nil != SPDic["tip"] && (SPDic["tip"] as! String).count != 0 {
                            qian = SPDic["tip"] as! String
                        }
                        if nil != SPDic["tipType"] && SPDic["tipType"] as? String == "2"{
                            youlabel.text = "¥ \(qian)"
                        }else if nil != SPDic["tipType"] && SPDic["tipType"] as? String == "1"{
                            youlabel.text = "\(qian) 个飕飕币"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 4 {
                        zuolabel.text = "抵扣:"
                        var dikoudikou = "¥ 0.00"
                        if nil != SPDic["dkAmount"] {
                            dikoudikou = String(format: "¥ %.2f", (SPDic["dkAmount"] as? Float)!)
                        }
                        youlabel.text = dikoudikou
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 5 {
                        zuolabel.text = "合计:"
                        var hejiheji = "¥ 0.00"
                        if nil != SPDic["amount"] {
                            hejiheji = String(format: "¥ %@", (SPDic["amount"] as? String)!)
                        }
                        youlabel.text = hejiheji
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }
                }
            }else{
                if indexPath.section == 2{
                    //付款方式、配送、直拿、小费、抵扣、合计
                    if indexPath.row == 0 {
                        zuolabel.text = "付款方式:"
                        youlabel.text = ""
                        if SPDic["paymentMethod"] as? String == "1"{
                            youlabel.text = "余额支付"
                        }else if SPDic["paymentMethod"] as? String == "2"{
                            youlabel.text = "支付宝支付"
                        }else if SPDic["paymentMethod"] as? String == "3"{
                            youlabel.text = "微信支付"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 1 {
                        zuolabel.text = "配送费:"
                        youlabel.text = SPDic["postAmount"] as? String
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 2 {
                        zuolabel.text = "直拿直送:"
                        var zhinazhi = "¥ 0.00"
                        if nil != SPDic["directSendAmount"] {
                            switch SPDic["directSendAmount"] {
                            case is String:
                                zhinazhi = "¥ 0.00"
                            default:
                                zhinazhi = String(format: "¥ %.2f", (SPDic["directSendAmount"] as? Float)!)
                                break
                                
                            }
                        }
                        youlabel.text = zhinazhi
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 3 {
                        zuolabel.text = "小费:"
                        var qian = "0.00"
                        youlabel.text = "¥ \(qian)"
                        if nil != SPDic["tip"] && (SPDic["tip"] as! String).count != 0 {
                            qian = SPDic["tip"] as! String
                        }
                        if nil != SPDic["tipType"] && SPDic["tipType"] as? String == "2"{
                            youlabel.text = "¥ \(qian)"
                        }else if nil != SPDic["tipType"] && SPDic["tipType"] as? String == "1"{
                            youlabel.text = "\(qian) 个飕飕币"
                        }else{
                            youlabel.text = "¥ \(qian)"
                        }
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 4 {
                        zuolabel.text = "抵扣:"
                        var dikoudikou = "¥ 0.00"
                        if nil != SPDic["dkAmount"] {
                            dikoudikou = String(format: "¥ %.2f", (SPDic["dkAmount"] as? Float)!)
                        }
                        youlabel.text = dikoudikou
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }else if indexPath.row == 5 {
                        zuolabel.text = "合计:"
                        var hejiheji = "¥ 0.00"
                        if nil != SPDic["amount"] {
                            hejiheji = String(format: "¥ %@", (SPDic["amount"] as? String)!)
                        }
                        youlabel.text = hejiheji
                        cell.contentView.addSubview(youlabel)
                        cell.contentView.addSubview(zuolabel)
                    }
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func shangpinUI(indexPath: IndexPath, cell:UITableViewCell) {
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 80, height: 64))
        var jiee = ""
        if nil != shuzu[indexPath.row]["picture"]{
            jiee = shuzu[indexPath.row]["picture"] as! String
        }
        let newString = TupianUrl + jiee
        let uuu:URL = URL(string: String(format: "%@",newString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
        imageView.sd_setImage(with: uuu, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
        let name = UILabel(frame: CGRect(x: 96, y: 16, width: Width - 142, height: 24))
        name.font = UIFont.systemFont(ofSize: 15)
        name.textColor = UIColor.darkGray
        if nil != shuzu[indexPath.row]["productName"] {
            name.text = shuzu[indexPath.row]["productName"] as? String
//            if nil != shuzu[indexPath.row]["productSpec"]{
//                name.text = (shuzu[indexPath.row]["productName"] as! String) + (shuzu[indexPath.row]["productSpec"] as! String)
//            }
        }
        let jiaqian = UILabel(frame: CGRect(x: 100, y: 36, width: Width - 142, height: 40))
        jiaqian.font = UIFont.systemFont(ofSize: 18)
        jiaqian.textColor = UIColor.orange
        jiaqian.numberOfLines = 2
        jiaqian.text = "¥ " + String(format: "%.2f",(shuzu[indexPath.row]["amount"] as? Float)! )
        let shuliang = UILabel(frame: CGRect(x: Width - 48, y: 50, width: 40, height: 30))
        shuliang.font = UIFont.systemFont(ofSize: 14)
        shuliang.text = "x " + (shuzu[indexPath.row]["productNum"] as? String)!
        cell.contentView.addSubview(shuliang)
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(jiaqian)
        cell.contentView.addSubview(name)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                //打电话 给
                var phone = ""
                if nil != SPDic["sendUserPhone"] && SPDic["sendUserPhone"] as! String != "" {
                    phone = SPDic["sendUserPhone"] as! String
                }
                if phone != "" {
                    UIApplication.shared.openURL(NSURL.init(string: "tel://\(phone)")! as URL)
                }
                
            }else if indexPath.row == 3 {
                //跳转到 位置信息 -- WEB页
                var msg = ""
                var isXS = 1
                switch leixing! {
                case "1":
                    msg = "您的订单还没有支付哟～"
                case "2":
                    msg = "您的订单还没有被接哟～"
                case "3":
                    msg = "您的订单还没有被接哟～"
                case "6":
                    msg = "您的订单已经完成啦～"
                case "7":
                    msg = "您的订单已经取消了呢～"
                default:
                    isXS = 2
                    break
                }
                if isXS == 2 {
                    let wwddxq: XL_PSYweizhi_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "psyweizhi") as? XL_PSYweizhi_ViewController
                    wwddxq?.longitudeJi = dingdanId!
                    self.navigationController?.pushViewController(wwddxq!, animated: true)
                }else{
                    XL_waringBox().warningBoxModeText(message: msg, view: self.view)
                }
            }
        }
    }
    func ratingChanged(_ ratingBar: WNRatingBar, newRating: Float) {
        if(ratingBar.tag == 0){
            ratingValue = newRating
            evalSpeed = newRating
            print("速度" + "\n\(ratingValue)")
        }else if ratingBar.tag == 1 {
            ratingValue = newRating
            evalServer = newRating
            print("态度" + "\n\(ratingValue)")
        }else if ratingBar.tag == 2 {
            ratingValue = newRating
            evalClear = newRating
            print("衣着" + "\n\(ratingValue)")
        }
    }
    @objc func PJjiekou() {
        print("评价接口")
        if isPingjia != 0 {
            pingjiajiekou()
        }
    }
    func pingjiajiekou() {
        let method = "/user/evaluate"
        let userId = userDefaults.value(forKey: "userId")
        let edUserId:String = SPDic["sendUserId"] as! String
        
        let dic:[String:Any] = ["userId":userId!,"userType":"1","orderId":dingdanId!,"edUserId":edUserId,"evalClear":evalClear,"evalSpeed":evalSpeed,"evalServer":evalServer]
        XL_waringBox().warningBoxModeIndeterminate(message: "认真评价中～～", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "评价成功", view: (self.navigationController?.view)!)
                self.navigationController?.popViewController(animated: true)
                //                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                //                self.DDArr = dic["orderList"] as! [[String : Any]]
                //                self.tableWDdingdan.reloadData()
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
