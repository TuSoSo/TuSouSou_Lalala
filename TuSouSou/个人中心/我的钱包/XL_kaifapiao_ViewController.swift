//
//  XL_kaifapiao_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_kaifapiao_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    let zuoDian = ["发票类型","抬头类型","发票抬头","发票税号","发票内容","邮箱地址","发票金额"]
    let zuodianGR = ["发票类型","抬头类型","发票抬头","发票内容","邮箱地址","发票金额"]
    
    let zuoGeren = ["发票类型","抬头类型","发票抬头","发票税号","发票内容","收件姓名","联系方式","详细地址","发票金额"]
    let zuoGerenGR = ["发票类型","抬头类型","发票抬头","发票内容","收件姓名","联系方式","详细地址","发票金额"]
    var dianziFP = UIButton(); var zhizhiFP = UIButton()
    var qiyeTT = UIButton(); var GerenTT = UIButton()
    var TFDic:[String: Any] = [:]
    var DDjine = UILabel()
    
    
    
    @IBOutlet weak var tablekaifapiao: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        delegeteTable()
        self.title = "开发票"
        TFDic["4"] = "服务费"
        FPLXBtn()
    }
    func FPLXBtn() {
        DDjine = UILabel(frame: CGRect(x: 112, y: 8, width: Width - 128, height: 32))
        DDjine.font = UIFont.systemFont(ofSize:  15)
        DDjine.textColor = UIColor.orange
        
        dianziFP = anniu(button: dianziFP, name: "电子发票", frame: CGRect(x: 120, y: 8, width: 100, height: 32))
        dianziFP.isSelected = true
        dianziFP.addTarget(self, action: #selector(dianzi), for: .touchUpInside)
        zhizhiFP = anniu(button: zhizhiFP, name: "纸质发票", frame: CGRect(x: 236, y: 8, width: 100, height: 32))
        zhizhiFP.isSelected = false
        zhizhiFP.addTarget(self, action: #selector(zhizhi), for: .touchUpInside)
        qiyeTT = anniu(button: qiyeTT, name: "企业抬头", frame: CGRect(x: 120, y: 8, width: 100, height: 32))
        qiyeTT.isSelected = true
        qiyeTT.addTarget(self, action: #selector(qiye), for: .touchUpInside)
        GerenTT = anniu(button: GerenTT, name: "个人抬头", frame: CGRect(x: 236, y: 8, width: 100, height: 32))
        GerenTT.isSelected = false
        GerenTT.addTarget(self, action: #selector(geren), for: .touchUpInside)
    }
    
    @objc func dianzi() {
        if dianziFP.isSelected == true {
           
        }else{
            self.view.endEditing(true)
            TFDic = [:]
            if qiyeTT.isSelected == true {
                TFDic["4"] = "服务费"
            }else{
                TFDic["3"] = "服务费"
            }
            dianziFP.isSelected = true
            zhizhiFP.isSelected = false
            tablekaifapiao.reloadData()
        }
    }
    @objc func zhizhi() {
        if zhizhiFP.isSelected == true {
            
        }else{
            self.view.endEditing(true)
            TFDic = [:]
            if qiyeTT.isSelected == true {
                TFDic["4"] = "服务费"
            }else{
                TFDic["3"] = "服务费"
            }
            zhizhiFP.isSelected = true
            dianziFP.isSelected = false
            tablekaifapiao.reloadData()
        }
    }
    @objc func qiye() {
        if qiyeTT.isSelected == true {
            
        }else{
            qiyeTT.isSelected = true
            GerenTT.isSelected = false
            TFDic = [:]
            if qiyeTT.isSelected == true {
                TFDic["4"] = "服务费"
            }else{
                TFDic["3"] = "服务费"
            }
            tablekaifapiao.reloadData()
        }
    }
    @objc func geren() {
        if GerenTT.isSelected == true {
            
        }else{
            GerenTT.isSelected = true
            qiyeTT.isSelected = false
            TFDic = [:]
            if qiyeTT.isSelected == true {
                TFDic["4"] = "服务费"
            }else{
                TFDic["3"] = "服务费"
            }
            tablekaifapiao.reloadData()
        }
    }
    func delegeteTable(){
        tablekaifapiao.delegate = self
        tablekaifapiao.dataSource = self
        tablekaifapiao.tableFooterView = UIView()
        tablekaifapiao.register(UITableViewCell.self, forCellReuseIdentifier: "kaikai")
        tablekaifapiao.backgroundColor = UIColor(hexString: "f0eff5")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dianziFP.isSelected == true {
            if qiyeTT.isSelected == true {
                if indexPath.row == 7 || indexPath.row == 8 {
                    return 120
                }
            }else{
                if indexPath.row == 6 || indexPath.row == 7 {
                    return 120
                }
            }
            
        }
        if zhizhiFP.isEnabled == true {
            if qiyeTT.isSelected == true {
                if indexPath.row == 9 || indexPath.row == 10 {
                    return 120
                }
            }else{
                if indexPath.row == 8 || indexPath.row == 9 {
                    return 120
                }
            }
            
        }
        return 48
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dianziFP.isSelected == true{
            if qiyeTT.isSelected==true{
                return 9
            }else{
                return 8
            }
        }else {
            if qiyeTT.isSelected==true{
                return 11
            }else{
                return 10
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "kaikai"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        var Arr:[String]!
        if dianziFP.isSelected == true {
            if qiyeTT.isSelected == true{
                Arr = zuoDian
            }else{
                Arr = zuodianGR
            }
        }else{
            if qiyeTT.isSelected == true {
                Arr = zuoGeren
            }else{
                Arr = zuoGerenGR
            }
        }
        
        let zuoLabel = UILabel(frame: CGRect(x: 16, y: 8, width: 80, height: 32))
        zuoLabel.font = UIFont.systemFont(ofSize: 15)
        if indexPath.row == 0 {
            cell.contentView.addSubview(dianziFP)
            cell.contentView.addSubview(zhizhiFP)
        }else if indexPath.row == 1 {
            cell.contentView.addSubview(GerenTT)
            cell.contentView.addSubview(qiyeTT)
        }
        if indexPath.row <= Arr.count - 1 {
            zuoLabel.text = Arr[indexPath.row]
            if indexPath.row > 1 && indexPath.row < Arr.count - 1{
                let TF = UITextField(frame: CGRect(x: 112, y: 8, width: Width - 128, height: 32))
                TF.font = UIFont.systemFont(ofSize: 14)
                TF.tag = indexPath.row + 10086
                TF.textColor = UIColor.darkGray
                TF.delegate = self
                if nil != TFDic["\(indexPath.row)"]{
                    TF.text = TFDic["\(indexPath.row)"] as? String
                }else{
                    TF.text = ""
                }
                cell.contentView.addSubview(TF)
            }
            cell.accessoryType = .none
            if indexPath.row == Arr.count - 1 {
                if nil != TFDic["jine"] {
                    DDjine.text = String(format: "¥ %@", (TFDic["jine"] as? String)!)
                }else{
                    DDjine.text = ""
                }
                cell.contentView.addSubview(DDjine)
                cell.accessoryType = .disclosureIndicator
            }
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.backgroundColor = UIColor.white
        }
        if dianziFP.isSelected == true {
            if qiyeTT.isSelected == true{
                if indexPath.row == 8 {
                    let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
                    //            button.layer.cornerRadius = 15
                    //            button.backgroundColor = UIColor.orange
                    button.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
                    button.setBackgroundImage(UIImage(named: "button_normal_light"), for: .highlighted)
                    button.setTitle("保存", for: .normal)
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.addTarget(self, action: #selector(kaifaP), for: .touchUpInside)
                    //            button.isUserInteractionEnabled = true
                    //去掉当前cell的分割线
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                    cell.contentView.addSubview(button)
                    cell.accessoryType = .none
                }else if indexPath.row == 7 {
                    let neirong =  UILabel(frame: CGRect(x: 20, y: 20, width: Width - 40, height: 120))
                    neirong.font = UIFont.systemFont(ofSize: 15)
                    neirong.text = "说明：发票金额限于跑腿费，商城商品的金额无法通过平台开发票。（发票邮寄或电子）纸质发票需要每个月20日统一寄出上一个自然月的发票，电子发票随时发送"
                    neirong.textColor = UIColor.darkGray
                    neirong.numberOfLines = 0
                    cell.contentView.addSubview(neirong)
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                    
                }
            }else {
                if indexPath.row == 7 {
                    let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
                    //            button.layer.cornerRadius = 15
                    //            button.backgroundColor = UIColor.orange
                    button.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
                    button.setBackgroundImage(UIImage(named: "button_normal_light"), for: .highlighted)
                    button.setTitle("保存", for: .normal)
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.addTarget(self, action: #selector(kaifaP), for: .touchUpInside)
                    //            button.isUserInteractionEnabled = true
                    //去掉当前cell的分割线
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                    cell.contentView.addSubview(button)
                    cell.accessoryType = .none
                }else if indexPath.row == 6 {
                    let neirong =  UILabel(frame: CGRect(x: 20, y: 20, width: Width - 40, height: 120))
                    neirong.font = UIFont.systemFont(ofSize: 15)
                    neirong.text = "说明：发票金额限于跑腿费，商城商品的金额无法通过平台开发票。（发票邮寄或电子）纸质发票需要每个月20日统一寄出上一个自然月的发票，电子发票随时发送"
                    neirong.textColor = UIColor.darkGray
                    neirong.numberOfLines = 0
                    cell.contentView.addSubview(neirong)
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                    
                }
            }
            
        }else{
            if qiyeTT.isSelected == true{
                if indexPath.row == 10 {
                    let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
                    //            button.layer.cornerRadius = 15
                    //            button.backgroundColor = UIColor.orange
                    button.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
                    button.setBackgroundImage(UIImage(named: "button_normal_light"), for: .highlighted)
                    button.setTitle("保存", for: .normal)
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.addTarget(self, action: #selector(kaifaP), for: .touchUpInside)
                    //            button.isUserInteractionEnabled = true
                    //去掉当前cell的分割线
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                    cell.contentView.addSubview(button)
                }else if indexPath.row == 9 {
                    let neirong =  UILabel(frame: CGRect(x: 20, y: 20, width: Width - 40, height: 120))
                    neirong.font = UIFont.systemFont(ofSize: 15)
                    neirong.text = "说明：发票金额限于跑腿费，商城商品的金额无法通过平台开发票。（发票邮寄或电子）纸质发票需要每个月20日统一寄出上一个自然月的发票，电子发票随时发送"
                    neirong.textColor = UIColor.darkGray
                    neirong.numberOfLines = 0
                    cell.contentView.addSubview(neirong)
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                }
            }else {
                if indexPath.row == 9 {
                    let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
                    //            button.layer.cornerRadius = 15
                    //            button.backgroundColor = UIColor.orange
                    button.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
                    button.setBackgroundImage(UIImage(named: "button_normal_light"), for: .highlighted)
                    button.setTitle("保存", for: .normal)
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.addTarget(self, action: #selector(kaifaP), for: .touchUpInside)
                    //            button.isUserInteractionEnabled = true
                    //去掉当前cell的分割线
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                    cell.contentView.addSubview(button)
                }else if indexPath.row == 8 {
                    let neirong =  UILabel(frame: CGRect(x: 20, y: 20, width: Width - 40, height: 120))
                    neirong.font = UIFont.systemFont(ofSize: 15)
                    neirong.text = "说明：发票金额限于跑腿费，商城商品的金额无法通过平台开发票。（发票邮寄或电子）纸质发票需要每个月20日统一寄出上一个自然月的发票，电子发票随时发送"
                    neirong.textColor = UIColor.darkGray
                    neirong.numberOfLines = 0
                    cell.contentView.addSubview(neirong)
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
                    cell.backgroundColor = UIColor(hexString: "f0eff5")
                }
            }
            
        }
       
        cell.selectionStyle = .none
        cell.contentView.addSubview(zuoLabel)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dianziFP.isSelected == true {
            if qiyeTT.isSelected == true{
                if indexPath.row == 6{
                    //跳页 block 传值 订单金额
                    let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
                    WDDD?.state = "2"
                    WDDD?.Dingdanblock = {(dingdanjine: [String]) in
                        self.TFDic["jine"] = dingdanjine[0]
                        self.TFDic["dingdanhao"] = dingdanjine[1]
                        self.tablekaifapiao.reloadData()
                    }
                    self.navigationController?.pushViewController(WDDD!, animated: true)
                }
            }else {
                if indexPath.row == 5{
                    //跳页 block 传值 订单金额
                    let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
                    WDDD?.state = "2"
                    WDDD?.Dingdanblock = {(dingdanjine: [String]) in
                        self.TFDic["jine"] = dingdanjine[0]
                        self.TFDic["dingdanhao"] = dingdanjine[1]
                        self.tablekaifapiao.reloadData()
                    }
                    self.navigationController?.pushViewController(WDDD!, animated: true)
                }
            }
        }else{
            if qiyeTT.isSelected == true{
                if indexPath.row == 8 {
                    //跳页 block 传值 订单金额
                    let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
                    WDDD?.state = "2"
                    WDDD?.Dingdanblock = {(dingdanjine: [String]) in
                        self.TFDic["jine"] = dingdanjine[0]
                        self.TFDic["dingdanhao"] = dingdanjine[1]
                        self.tablekaifapiao.reloadData()
                    }
                    self.navigationController?.pushViewController(WDDD!, animated: true)
                }
            }else {
                if indexPath.row == 7 {
                    //跳页 block 传值 订单金额
                    let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
                    WDDD?.state = "2"
                    WDDD?.Dingdanblock = {(dingdanjine: [String]) in
                        self.TFDic["jine"] = dingdanjine[0]
                        self.TFDic["dingdanhao"] = dingdanjine[1]
                        self.tablekaifapiao.reloadData()
                    }
                    self.navigationController?.pushViewController(WDDD!, animated: true)
                }
            }
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        TFDic["\(textField.tag)"] = textField.text
        print(TFDic)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if qiyeTT.isSelected == true {
            if textField.tag == 10086 + 4 {
                return false
            }
        }else{
            if textField.tag == 10086 + 3 {
                return false
            }
        }
        return true
    }
    
    func anniu(button:UIButton, name: String,frame:CGRect) -> UIButton {
        button.frame = frame
        button.setTitle(name, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .selected)
        button.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        button.setImage(UIImage(named: "圆圈选中"), for: .selected)
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 75);
        //button标题的偏移量，这个偏移量是相对于图片的
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        return button
    }
    @objc func kaifaP() {
        var xlPP = 0
        if dianziFP.isSelected == true {
            if qiyeTT.isSelected == true{
                for xx in 2..<6{
                    if nil == TFDic["\(xx)"] {
                        xlPP = 1
                        break
                    }
                }
            }else{
                for xx in 2..<5{
                    if nil == TFDic["\(xx)"] {
                        xlPP = 1
                        break
                    }
                }
            }
        }else{
            if qiyeTT.isSelected == true{
                for xx in 2..<8{
                    if nil == TFDic["\(xx)"] {
                        xlPP = 1
                        break
                    }
                }
            }else{
                for xx in 2..<7{
                    if nil == TFDic["\(xx)"] {
                        xlPP = 1
                        break
                    }
                }
            }
        }
        if nil == TFDic["jine"] {
            xlPP = 1
        }
        if xlPP == 1 {
            XL_waringBox().warningBoxModeText(message: "请完整的填写信息！", view: self.view)
        }else{
            let method = "/user/nvoice"
            let userId = userDefaults.value(forKey: "userId")
            var titleType = "2" //1 企业 2 个人
            if GerenTT.isSelected == false {
                titleType = "1"
            }
            let title = TFDic["2"] as! String//taitou
            var taxNo = ""//suihao
            var conten = ""//neirong
            //        let invoiceType = ""//1 dianzi 2 zhizhi
            var amoun = "" // jine
            var recipients = "" //shoujianren
            var phone = "" // dianhua
            var address = ""//xiangxidizhi
            var email = "" // dianziyoujian
            let orderIdList = [["orderId":TFDic["dingdanhao"] as! String]]//dingdanhao
            var dicc:[String:Any] = [:]
            if dianziFP.isSelected == true {
                if qiyeTT.isSelected == true{
                    //dianzifapiao
                    taxNo = TFDic["3"] as! String//suihao
                    conten = TFDic["4"] as! String//neirong
                    email = TFDic["5"] as! String
                    amoun = TFDic["jine"] as! String
                    dicc = ["userId":userId!,"invoiceType":"1","titleType":titleType,"title":title,"taxNo":taxNo,"conten":conten,"email":email,"amoun":amoun,"orderIdList":orderIdList]
                    print(dicc)
                }else{
                    //dianzifapiao
                    //                taxNo = TFDic["3"] as! String//suihao
                    conten = TFDic["3"] as! String//neirong
                    email = TFDic["4"] as! String
                    amoun = TFDic["jine"] as! String
                    dicc = ["userId":userId!,"invoiceType":"1","titleType":titleType,"title":title,"taxNo":taxNo,"conten":conten,"email":email,"amoun":amoun,"orderIdList":orderIdList]
                    print(dicc)
                }
            }else{
                if qiyeTT.isSelected == true{
                    //zhizhifapiao
                    taxNo = TFDic["3"] as! String//suihao
                    conten = TFDic["4"] as! String//neirong
                    amoun = TFDic["jine"] as! String
                    recipients = TFDic["5"] as! String
                    phone = TFDic["6"] as! String
                    address = TFDic["7"] as! String
                    dicc = ["userId":userId!,"invoiceType":"2","titleType":titleType,"title":title,"taxNo":taxNo,"conten":conten,"recipients":recipients,"phone":phone,"address":address,"amoun":amoun,"orderIdList":orderIdList]
                    print(dicc)
                }else{
                    //zhizhifapiao
                    //                taxNo = TFDic["3"] as! String//suihao
                    conten = TFDic["3"] as! String//neirong
                    amoun = TFDic["jine"] as! String
                    recipients = TFDic["4"] as! String
                    phone = TFDic["5"] as! String
                    address = TFDic["6"] as! String
                    dicc = ["userId":userId!,"invoiceType":"2","titleType":titleType,"title":title,"taxNo":taxNo,"conten":conten,"recipients":recipients,"phone":phone,"address":address,"amoun":amoun,"orderIdList":orderIdList]
                    print(dicc)
                }
                
            }
            
            XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
                print(res)
                if (res as! [String: Any])["code"] as! String == "0000" {
                    //                    let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    let msg = (res as! [String: Any])["msg"] as! String
                    XL_waringBox().warningBoxModeText(message: msg, view: self.view)
                }
            }) { (error) in
                XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
                print(error)
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
