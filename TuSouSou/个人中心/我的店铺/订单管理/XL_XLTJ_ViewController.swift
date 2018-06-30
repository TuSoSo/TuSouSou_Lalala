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
    var NwDatePicker = UIDatePicker()
    var banView = UIView()
    var shangdic:[String:String] = [:]
    var nage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "销量统计"
        tanchulai()
    }
    
    @IBAction func kaishi(_ sender: Any) {
        nage = 1
        chu()
    }
    
    @IBAction func jieshu(_ sender: Any) {
        nage = 2
        chu()
    }
    func chu()  {
        banView.isHidden = false
        NwDatePicker.isHidden = false
    }
    @objc func mei() {
        banView.isHidden = true
        NwDatePicker.isHidden = true
    }
    func tanchulai() {
        banView.frame = CGRect(x: 0, y: 0, width: Width, height: Height)
        banView.backgroundColor = UIColor.black
        banView.alpha = 0.8
        let top1 = UITapGestureRecognizer(target: self, action: #selector(mei))
        banView.addGestureRecognizer(top1)
        self.view.addSubview(banView)
        banView.isHidden = true
        NwDatePicker.frame = CGRect(x: 0, y: Height - 300, width: Width, height: 300)
        NwDatePicker.backgroundColor = UIColor.white
        NwDatePicker.locale = Locale.init(identifier: "zh_CN")
        NwDatePicker.isHidden = true
//        NwDatePicker.layer.borderWidth = 1
//        NwDatePicker.layer.borderColor = (UIColor.groupTableViewBackground as! CGColor)
        NwDatePicker.datePickerMode = .date
        NwDatePicker.addTarget(self, action: #selector(chooseDate( _:)), for:UIControlEvents.valueChanged)
        self.view.addSubview(NwDatePicker)
    }
    @objc func chooseDate(_ datePicker:UIDatePicker) {
        let  chooseDate = datePicker.date
        let  dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let date = dateFormater.string(from: chooseDate)
        if nage == 1 {
            kaishibutton.setTitle(date, for: .normal)
            shangdic["1"] = date
        }else{
            jieshubutton.setTitle(date, for: .normal)
            shangdic["2"] = date
        }
//        print(dateFormater.string(from: chooseDate))
    }
    @IBAction func chaxun(_ sender: Any) {
        //接口
        let method = "/order/orderSalesCounts"
        let userId = userDefaults.value(forKey: "userId")
        var xx = 1
        var beginTime = ""
        if nil != shangdic["1"] {
            beginTime = shangdic["1"]!
        }else{
            xx = 2
        }
        var endTime = ""
        if nil != shangdic["2"] {
            endTime = shangdic["2"]!
        }else{
            xx = 2
        }
        if xx == 1 {
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
        }else{
            XL_waringBox().warningBoxModeText(message: "请选择时间", view: self.view)
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
