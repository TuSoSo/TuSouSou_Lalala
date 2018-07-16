//
//  XL_WDdingdanViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/28.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDdingdanViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var state: String? //是否可查看详情
    var xll = 0
    @IBOutlet weak var daipingButton: UIButton!
    @IBOutlet weak var quanbuButton: UIButton!
    @IBOutlet weak var youView: UIView!
    @IBOutlet weak var zuoView: UIView!
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    
    var tpye = "1"
    
    var DDArr: [[String:Any]] = []
    
    typealias DDjine = ([String]) -> ()
    var Dingdanblock: DDjine?
    func dingdan(block: DDjine?) {
        self.Dingdanblock = block
    }
    override func viewWillAppear(_ animated: Bool) {
        //刷新界面
        footer.endRefreshingWithMoreData()
        DDArr = []
        pageNo = 1
        jiekou(index: tpye)
    }
    
    @IBOutlet weak var tableWDdingdan: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if xll == 1 {
            fanhuidaoRoot()
        }
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tableWDdingdan.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableWDdingdan.mj_footer = footer
        tableDelegate()
        tpye = "1"
        daipingButton.isSelected = false
        quanbuButton.isSelected = true
        youView.backgroundColor = UIColor.white
        zuoView.backgroundColor = UIColor.orange
//        jiekou(index: tpye)
        self.title = "我的订单"
        // Do any additional setup after loading the view.
    }
    func fanhuidaoRoot() {
        let leftBarBtn = UIBarButtonItem(title: "X", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    @objc func backToPrevious(){
        self.navigationController!.popToRootViewController(animated: true)
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        DDArr = []
        jiekou(index: tpye)
        tableWDdingdan.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        if count > pageNo * pageSize {
            tableWDdingdan.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            jiekou(index: tpye)
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    func jiekou(index:String) {
        let method = "/order/orderList"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"orderKind":index,"pageNo":pageNo,"pageSize":pageSize]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
//                XL_waringBox().warningBoxModeText(message: "加载成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.DDArr += dic["orderList"] as! [[String : Any]]
                self.count = dic["count"] as! Int
                self.tableWDdingdan.reloadData()
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
    func tableDelegate()  {
        tableWDdingdan.delegate = self
        tableWDdingdan.dataSource = self
        tableWDdingdan.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DDArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "wodedingdan"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        
        let tou: UILabel = cell.viewWithTag(640) as! UILabel
        let imageSHA: UIImageView = cell.viewWithTag(641) as! UIImageView
        let imageXIA: UIImageView = cell.viewWithTag(642) as! UIImageView
        let nameSHA: UILabel = cell.viewWithTag(643) as! UILabel
        let phoneSHA: UILabel = cell.viewWithTag(644) as! UILabel
        let nameXIA: UILabel = cell.viewWithTag(645) as! UILabel
        let phoneXIA: UILabel = cell.viewWithTag(646) as! UILabel
        let state: UILabel = cell.viewWithTag(647) as! UILabel
        let Jine: UILabel = cell.viewWithTag(648) as! UILabel
        let quxiao: UILabel = cell.viewWithTag(651) as! UILabel
        let zhifu: UILabel = cell.viewWithTag(652) as! UILabel
        let top0 = UITapGestureRecognizer(target: self, action: #selector(quxiaodingdan(sender:)))
        quxiao.isUserInteractionEnabled = true
        quxiao.addGestureRecognizer(top0)
        let top1 = UITapGestureRecognizer(target: self, action: #selector(zhifudingdan(sender:)))
        zhifu.isUserInteractionEnabled = true
        zhifu.addGestureRecognizer(top1)
        var orderType: String = "0"
        if DDArr.count > 0 {
            if nil != DDArr[indexPath.row]["orderType"] {
                orderType = DDArr[indexPath.row]["orderType"]! as! String
            }
        }
        
        switch orderType {
        case "1":
            tou.text = "网递订单(寄)"
             imageSHA.image = UIImage(named: "ji")
        case "2":
            tou.text = "网递订单(取)"
             imageSHA.image = UIImage(named: "qu")
        case "3":
            tou.text = "商品订单"
             imageSHA.image = UIImage(named: "ji")
        default:
            break
        }
        
        imageXIA.image = UIImage(named: "shou")
        var jidizhi = ""
        var jiren = ""
        if DDArr.count  > 0 {
            jidizhi = (DDArr[indexPath.row]["sendUserPhone"] as? String)!
            jiren = (DDArr[indexPath.row]["sendUserName"] as? String)!
        }
        nameSHA.text = jiren + "  " + jidizhi
        
        var shoudizhi = ""
        var shouren = ""
        if DDArr.count  > 0 {
            shoudizhi = (DDArr[indexPath.row]["userPhone"] as? String)!
            shouren = (DDArr[indexPath.row]["userName"] as? String)!
        }
        nameXIA.text = shouren + "  " + shoudizhi
        phoneSHA.text = ""
        phoneXIA.text = ""
        var orderState = ""
        if DDArr.count  > 0 {
            phoneSHA.text = DDArr[indexPath.row]["sendAddress"] as? String
            phoneXIA.text = DDArr[indexPath.row]["receiveAddress"] as? String
            orderState = (DDArr[indexPath.row]["orderState"] as? String)!
        }
        
        switch orderState {
        case "0":
            state.text = "初始化"
            zhifu.isHidden = true
            quxiao.isHidden = true
        case "1":
            state.text = "待支付"
            zhifu.isHidden = false
            quxiao.isHidden = false
        case "2":
            state.text = "待商家接单"
            zhifu.isHidden = true
            quxiao.isHidden = false
        case "3":
            state.text = "待配送员接单"
            zhifu.isHidden = true
            quxiao.isHidden = false
        case "4":
            state.text = "待配送"
            zhifu.isHidden = true
            quxiao.isHidden = false
        case "5":
            state.text = "配送中"
            zhifu.isHidden = true
            quxiao.isHidden = true
        case "6":
            state.text = "已完成"
            zhifu.isHidden = true
            quxiao.isHidden = true
        case "7":
            state.text = "已取消"
            zhifu.isHidden = true
            quxiao.isHidden = true
        default:
            break
        }
        
        Jine.text = ""
        if DDArr.count > 0 && nil != DDArr[indexPath.row]["amount"] {
            Jine.text = String(format: "%@", DDArr[indexPath.row]["amount"] as! String)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if state == "1"{
            let wwddxq: XL_WDDDXQ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdddxq") as? XL_WDDDXQ_ViewController
            wwddxq?.shangLX = DDArr[indexPath.row]["orderType"]! as? String
            wwddxq?.dingdanId = DDArr[indexPath.row]["id"] as? String
            wwddxq?.leixing = DDArr[indexPath.row]["orderState"] as? String
            self.navigationController?.pushViewController(wwddxq!, animated: true)
        }else if state == "2"{
            if DDArr[indexPath.row]["orderState"] as? String == "6"{
                if let block = self.Dingdanblock {
                    var ss: [String] = [String(format: "%@", DDArr[indexPath.row]["postAmount"] as! String)]
                    ss.append(DDArr[indexPath.row]["id"] as! String)
                    block(ss)
                }
                self.navigationController?.popViewController(animated: true)
            }else{
                XL_waringBox().warningBoxModeText(message: "只有已完成的订单才可以开发票哟～～", view: self.view)
            }
        }
    
    }
    @objc func quxiaodingdan(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.tableWDdingdan)
        let indexPath = self.tableWDdingdan.indexPathForRow(at: location)
        let sheet = UIAlertController(title: "提示", message: "确定要取消订单?", preferredStyle: .alert)
        let queding = UIAlertAction(title: "确定", style: .default) { (ss) in
            self.quxiao(str:(indexPath?.row)!)
        }
        let quxiao = UIAlertAction(title: "取消", style: .cancel, handler:  nil)
        sheet.addAction(queding)
        sheet.addAction(quxiao)
        self.present(sheet, animated: true, completion: nil)
    }
    @objc func zhifudingdan(sender: UITapGestureRecognizer) {
        let location = sender.location(in: tableWDdingdan)
        let indexPath = tableWDdingdan.indexPathForRow(at: location)
        jixuzhifu(str: (indexPath?.row)!)
    }
  
    func quxiao(str:Int) {
        let method = "/order/orderCancel"
        let userId = userDefaults.value(forKey: "userId")
        let orderId = DDArr[str]["id"]
        
        let dicc:[String:Any] = ["userId":userId!,"orderId":orderId!]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let quxiao = self.DDArr[str]["paymentMethod"] as! String
                let orderCode = self.DDArr[str]["orderCode"] as! String
                let jine = self.DDArr[str]["amount"] as! String
                
                if  quxiao == "1" {
                    //余额
                    self.quxiaohuidiao(dingdanhao: orderCode)
                }else if quxiao == "2" {
                    //支付宝
                    self.zhifubaoquxiao(dingdanhao: orderCode,jine:jine)
                }else if quxiao == "3" {
                    //weixin
                    self.WXquxiao(dingdanhao: orderCode,jine:jine)
                }
            }else{
                XL_waringBox().warningBoxModeText(message: "退款次数不足", view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func quxiaohuidiao(dingdanhao:String) {
        let method = "/order/rufundAfterHandler"
        print(dingdanhao)
        let dicc:[String:Any] = ["orderCode":dingdanhao]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            self.DDArr = []
            self.jiekou(index: self.tpye)
            userDefaults.set("", forKey: "dingdanhao")
        }) { (error) in
            
            print(error)
        }
    }
    func WXquxiao(dingdanhao:String,jine:String) {
        let method = "/weipay/Refund"
        let totalAmount = Float(jine)! * 100
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let outRefundNo = String(format: "%@%d", userDefaults.value(forKey: "userId") as! String ,timeStamp)
        let dicc:[String:Any] = ["outTradeNo":dingdanhao,"outRefundNo":outRefundNo,"totalFee":totalAmount,"refundFee":totalAmount]
        XL_QuanJu().SanFangWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            self.quxiaohuidiao(dingdanhao: dingdanhao)
            userDefaults.set("", forKey: "dingdanhao")
        }) { (error) in
            print(error)
        }
    }
    func zhifubaoquxiao(dingdanhao:String,jine:String) {
        let method = "/AliPay/Refund"
        let totalAmount = Float(jine)!
        let dicc:[String:Any] = ["outTradeNo":dingdanhao,"tradeNo":"","refundAmount":totalAmount,"refundReason":"","outRequestNo":""]
 
        XL_QuanJu().SanFangWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            self.quxiaohuidiao(dingdanhao: dingdanhao)
            userDefaults.set("", forKey: "dingdanhao")
        }) { (error) in
            
            print(error)
        }
    }
    func jixuzhifu(str:Int) {
        let paymentMethod = DDArr[str]["paymentMethod"] as! String
        let orderCode = DDArr[str]["orderCode"] as! String
        let jine = DDArr[str]["amount"] as! String
        
        shangchengzhifu(paymentMethod: paymentMethod, orderCode:orderCode,jine:jine )
       
    }
    func shangchengzhifu(paymentMethod:String,orderCode:String,jine:String) {
        if  paymentMethod == "1" {
            //余额
            zhifuhuidiao(string: orderCode)
        }else if paymentMethod == "2" {
            //支付宝
            zhifubaoZhiFu(string: orderCode,jine:jine)
        }else if paymentMethod == "3" {
            //weixin
            WXZhiFu(string: orderCode,jine:jine)
        }
    }
    func zhifuhuidiao(string:String) {
        let method = "/order/payAfterHandler"
        let dicc:[String:Any] = ["orderCode":string]
        
        //        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            userDefaults.set("", forKey: "dingdanhao")
            userDefaults.set("2", forKey: "isNotPay")
        }) { (error) in
            
            print(error)
        }
    }
    func WXZhiFu(string:String,jine:String) {
        let method = "/weipay/App"
        let totalAmount = Float(jine)! * 100
        
        let dicc:[String:Any] = ["outTradeNo":string,"totalAmount":"1"/*totalAmount*/]
       userDefaults.set(string, forKey: "dingdanhao")
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
    func zhifubaoZhiFu(string:String,jine:String) {
        let method = "/AliPay/App"
        let totalAmount = Float(jine)!
        userDefaults.set(string, forKey: "dingdanhao")
        let dicc:[String:Any] = ["outTradeNo":string,"totalAmount":"0.01"/*totalAmount*/]
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
    @IBAction func daipingjia(_ sender: Any) {
        if daipingButton.isSelected != true {
            DDArr = []
            tpye = "2"
            quanbuButton.isSelected = false
            daipingButton.isSelected = true
            zuoView.backgroundColor = UIColor.white
            youView.backgroundColor = UIColor.orange
            jiekou(index: tpye)
        }
    }
    @IBAction func quanbu(_ sender: Any) {
        if quanbuButton.isSelected != true {
            DDArr = []
            tpye = "1"
            daipingButton.isSelected = false
            quanbuButton.isSelected = true
            youView.backgroundColor = UIColor.white
            zuoView.backgroundColor = UIColor.orange
            jiekou(index: tpye)
        }
    }
}
