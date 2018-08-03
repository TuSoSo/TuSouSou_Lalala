//
//  XL_XLTJ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/26.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_XLTJ_ViewController: UIViewController {

    @IBOutlet weak var xiaoshoujine: UILabel!
    @IBOutlet weak var dingdanshuliang: UILabel!
    @IBOutlet weak var jieshubutton: UIButton!
    @IBOutlet weak var kaishibutton: UIButton!

    var shangdic:[String:String] = [:]
    var nage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "销量统计"
    }
    
    @IBAction func kaishi(_ sender: Any) {
        nage = 1
        shijian()
    }
    
    @IBAction func jieshu(_ sender: Any) {
        nage = 2
        shijian()
    }
    func shijian() {
        let dateFormatter = "yyyy-MM-dd"
        let datePicker = DatePickerView.datePicker(frame: CGRect(x: 0, y: 0, width: Width, height: Height), style: .yearMonthDay, scrollToDate: Date()) { date in
            guard let date = date else { return }
            
            let dateStr = date.toString(dateFormatter)
//            XL_waringBox().warningBoxModeText(message: "\(dateStr)", view: self.view)
            if self.nage == 1 {
                self.shangdic["1"] = dateStr
                self.kaishibutton.setTitle(dateStr, for: .normal)
                if nil != self.shangdic["2"] && (self.shangdic["2"]!).count>0{
                    if !self.shijianpanduan(kaiTime: self.shangdic["1"]!, guanTime: self.shangdic["2"]!) {
                        XL_waringBox().warningBoxModeText(message: "开始时间不能大于结束时间", view: self.view)
                        self.shangdic["1"] = ""
                        self.kaishibutton.setTitle("点击选择开始时间", for: .normal)
                    }
                }
                
            }else if self.nage == 2 {
                self.shangdic["2"] = dateStr
                self.jieshubutton.setTitle(dateStr, for: .normal)
                if nil != self.shangdic["1"] && (self.shangdic["1"]!).count>0{
                    if !self.shijianpanduan(kaiTime: self.shangdic["1"]!, guanTime: self.shangdic["2"]!) {
                        XL_waringBox().warningBoxModeText(message: "结束时间不能小于开始时间", view: self.view)
                        self.shangdic["2"] = ""
                        self.jieshubutton.setTitle("点击选择结束时间", for: .normal)
                    }
                }
            }
        }
        
        let date = Date.date("年月日", formatter: dateFormatter)
        datePicker.scrollToDate = date == nil ? Date.date(Date().toString(dateFormatter), formatter: dateFormatter)! : date!
        datePicker.show()
    }
    func shijianpanduan(kaiTime:String,guanTime:String) -> Bool {
        let kaiarr:[String] = kaiTime.components(separatedBy: "-")
        let guanarr:[String] = guanTime.components(separatedBy: "-")
        if Int(kaiarr[0])! < Int(guanarr[0])! {
            return true
        }else if Int(kaiarr[0])! == Int(guanarr[0])! {
            if Int(kaiarr[1])! < Int(guanarr[1])! {
                return true
            }else {
                if Int(kaiarr[1])! == Int(guanarr[1])! {
                    if Int(kaiarr[2])! <= Int(guanarr[2])! {
                        return true
                    }else {
                        return false
                    }
                }
                return false
            }
        }else {
            return false
        }
        
    }
    
    @IBAction func chaxun(_ sender: Any) {
        //接口
        if nil == shangdic["1"] || shangdic["1"]!.count == 0 {
            XL_waringBox().warningBoxModeText(message: "请选择开始时间", view: self.view)
        }else{
            if nil == shangdic["2"] || shangdic["2"]!.count == 0 {
                XL_waringBox().warningBoxModeText(message: "请选择结束时间", view: self.view)
            }else{
                let method = "/order/orderSalesCounts"
                let userId = userDefaults.value(forKey: "userId")
                let beginTime = shangdic["1"]!
                let endTime = shangdic["2"]!
                
                let dic:[String:Any] = ["userId":userId!,"beginTime":beginTime,"endTime":endTime]
                XL_waringBox().warningBoxModeIndeterminate(message: "查询中...", view: self.view)
                XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
                    print(res)
                    XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                    if (res as! [String: Any])["code"] as! String == "0000" {
                        let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                        self.jiemianjiazai(dic: data)
                        
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
       
       
    }
    func jiemianjiazai(dic:[String:Any]) {
        var salesMoney = (dic["salesMoney"] as? String)!
        if salesMoney.count == 0 {
            salesMoney = "0.00"
        }
        xiaoshoujine.text = String(format: "¥ %@", salesMoney)
        dingdanshuliang.text = String(format: "%d",(dic["salesCounts"] as? Int)!)
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
