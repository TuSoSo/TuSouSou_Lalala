//
//  XL_DDGL_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_DDGL_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tablejiedan: UITableView!
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    var DDArr:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单管理"
        youshangjiao()
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tablejiedan.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tablejiedan.mj_footer = footer
        tableDelegate()
        
        
        jiekou()
        // Do any additional setup after loading the view.
    }
    
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        DDArr = []
        jiekou()
        tablejiedan.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            tablejiedan.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            jiekou()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    func jiekou() {
        let method = "/order/merOrderManager"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"pageNo":pageNo,"pageSize":pageSize]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                //                XL_waringBox().warningBoxModeText(message: "加载成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.DDArr += dic["orderList"] as! [[String : Any]]
                self.count = dic["count"] as! Int
                self.tablejiedan.reloadData()
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
        tablejiedan.delegate = self
        tablejiedan.dataSource = self
        tablejiedan.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DDArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "jiedancell"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        
        let dingdanhao: UILabel = cell.viewWithTag(1100) as! UILabel
        let zhuangtai: UILabel = cell.viewWithTag(1101) as! UILabel
        let shijian: UILabel = cell.viewWithTag(1102) as! UILabel
        let jine: UILabel = cell.viewWithTag(1103) as! UILabel
        let quxiao: UILabel = cell.viewWithTag(1104) as! UILabel
        let jiedan: UILabel = cell.viewWithTag(1105) as! UILabel
       
        let top0 = UITapGestureRecognizer(target: self, action: #selector(quxiao(sender:)))
        quxiao.isUserInteractionEnabled = true
        quxiao.addGestureRecognizer(top0)
        let top1 = UITapGestureRecognizer(target: self, action: #selector(jiedan(sender:)))
        jiedan.isUserInteractionEnabled = true
        jiedan.addGestureRecognizer(top1)
        dingdanhao.text = ""
        if DDArr.count != 0 {
            dingdanhao.text = String(format: "订单编号: %@", (DDArr[indexPath.row]["orderCode"] as? String)!)
        }
        zhuangtai.text = ""
        if DDArr.count != 0 {
            let orderState:String =  DDArr[indexPath.row]["orderState"] as! String
            switch orderState {
            case "0":
                zhuangtai.text = "初始化"
            case "1":
                zhuangtai.text = "待支付"
                quxiao.isHidden = false
                jiedan.isHidden = false
            case "2":
                zhuangtai.text = "待接单"
                quxiao.isHidden = false
                jiedan.isHidden = false
            case "3":
                zhuangtai.text = "待配送员接单"
                quxiao.isHidden = false
                jiedan.isHidden = true
            case "4":
                zhuangtai.text = "待配送"
                quxiao.isHidden = false
                jiedan.isHidden = true
            case "5":
                zhuangtai.text = "配送中"
                quxiao.isHidden = true
                jiedan.isHidden = true
            case "6":
                zhuangtai.text = "已完成"
                quxiao.isHidden = true
                jiedan.isHidden = true
            case "7":
                zhuangtai.text = "已取消"
                quxiao.isHidden = true
                jiedan.isHidden = true
            default:
                break
            }
        }
        shijian.text = ""
        if DDArr.count != 0 {
            shijian.text = String(format: "下单时间: %@", (DDArr[indexPath.row]["createTime"] as? String)!)
        }
        jine.text = ""
        if DDArr.count != 0 {
            jine.text = String(format: "订单金额: ¥%@", (DDArr[indexPath.row]["productPrice"] as? String)!)
        }
        
       
        cell.selectionStyle = .none
        return cell
    }

    @objc func quxiao(sender:UIGestureRecognizer) {
        let location = sender.location(in: tablejiedan)
        let indexPath = tablejiedan.indexPathForRow(at: location)
//        let orderId = DDArr[(indexPath?.row)!]["id"] as! String
        let orderCode = DDArr[(indexPath?.row)!]["orderCode"] as! String
        let payMethod = DDArr[(indexPath?.row)!]["payMethod"] as! String
        //        let jine = DDArr[(indexPath?.row)!]["productPrice"] as! String
        let zongjia = DDArr[(indexPath?.row)!]["amount"] as! String
        let sheet = UIAlertController(title: "提示", message: "确定要取消订单?", preferredStyle: .alert)
        let queding = UIAlertAction(title: "确定", style: .default) { (ss) in
            switch payMethod {
            case "1":
//                self.dingdanjiekou(orderId: orderId, isOrder: isOrder)
                //order/rufundAfterHandler
                self.xxxx(orderCode: orderCode)
            case "2":
                self.zhifubaoquxiao(dingdanhao: orderCode, jine: zongjia)
            case "3":
                self.WXquxiao(dingdanhao: orderCode, jine: zongjia)
            default:
                break
            }
        }
        let quxiao = UIAlertAction(title: "取消", style: .cancel, handler:  nil)
        sheet.addAction(queding)
        sheet.addAction(quxiao)
        self.present(sheet, animated: true, completion: nil)
        
        
        
    }
    func xxxx(orderCode:String) {
        let method = "/order/rufundAfterHandler"
        print(orderCode)
        let dicc:[String:Any] = ["orderCode":orderCode]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            self.DDArr = []
            self.jiekou()
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
            self.DDArr = []
            self.jiekou()
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
            self.DDArr = []
            self.jiekou()
            userDefaults.set("", forKey: "dingdanhao")
        }) { (error) in
            
            print(error)
        }
    }
    @objc func jiedan(sender:UIGestureRecognizer) {
        let location = sender.location(in: tablejiedan)
        let indexPath = tablejiedan.indexPathForRow(at: location)
        let orderId = DDArr[(indexPath?.row)!]["id"] as! String
        let isOrder = "1"
        dingdanjiekou(orderId: orderId, isOrder: isOrder)
    }
    func dingdanjiekou(orderId:String, isOrder:String) {
        let method = "/order/merchantOrderTake"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"orderId":orderId,"isOrder":isOrder]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                self.DDArr = []
                
                self.jiekou()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wwddxq: XL_WDDDXQ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdddxq") as? XL_WDDDXQ_ViewController
        wwddxq?.dingdanId = DDArr[indexPath.row]["id"] as? String
        wwddxq?.leixing = DDArr[indexPath.row]["orderState"] as? String
        wwddxq?.shangLX = "3"
        self.navigationController?.pushViewController(wwddxq!, animated: true)
    }
    func youshangjiao()  {
        var item = UIBarButtonItem()
        
        item = UIBarButtonItem(title:"销量统计",style: .plain,target:self,action:#selector(YouActio))
        
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio() {
        let xiadan: XL_XLTJ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "xltj") as? XL_XLTJ_ViewController
        self.navigationController?.pushViewController(xiadan!, animated: true)
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
