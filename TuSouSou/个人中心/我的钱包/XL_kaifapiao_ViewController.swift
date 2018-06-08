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
    let zuoGeren = ["发票类型","抬头类型","发票抬头","发票税号","发票内容","收件姓名","联系方式","详细地址","发票金额"]
    var dianziFP = UIButton(); var zhizhiFP = UIButton()
    var qiyeTT = UIButton(); var GerenTT = UIButton()
    var TFDic:[String: Any] = [:]
    var DDjine = UILabel()
    
    
    
    @IBOutlet weak var tablekaifapiao: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        delegeteTable()
        self.title = "开发票"
        FPLXBtn()
    }
    func FPLXBtn() {
        DDjine = UILabel(frame: CGRect(x: Width - 150, y: 8, width: 118, height: 32))
        DDjine.textAlignment = .right
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
        }
    }
    @objc func geren() {
        if GerenTT.isSelected == true {
            
        }else{
            GerenTT.isSelected = true
            qiyeTT.isSelected = false
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
            if indexPath.row == 7 || indexPath.row == 8 {
                return 120
            }
        }
        if zhizhiFP.isEnabled == true {
            if indexPath.row == 9 || indexPath.row == 10 {
                return 120
            }
        }
        return 48
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dianziFP.isSelected == true{
            return 9
        }else {
            return 11
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
            Arr = zuoDian
            
        }else{
            Arr = zuoGeren
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
                TF.tag = indexPath.row
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
                    DDjine.text = TFDic["jine"] as? String
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
            if indexPath.row == 8 {
                let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
                //            button.layer.cornerRadius = 15
                //            button.backgroundColor = UIColor.orange
                button.setBackgroundImage(UIImage(named: "立即签到背景"), for: .normal)
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
        }else{
            if indexPath.row == 10 {
                let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
                //            button.layer.cornerRadius = 15
                //            button.backgroundColor = UIColor.orange
                button.setBackgroundImage(UIImage(named: "立即签到背景"), for: .normal)
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
        }
       
        cell.selectionStyle = .none
        cell.contentView.addSubview(zuoLabel)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dianziFP.isSelected == true {
            if indexPath.row == 6{
                //跳页 block 传值 订单金额
                let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
                WDDD?.state = "2"
                WDDD?.Dingdanblock = {(dingdanjine: String) in
                    self.TFDic["jine"] = dingdanjine
                    self.tablekaifapiao.reloadData()
                }
                self.navigationController?.pushViewController(WDDD!, animated: true)
                
            }
        }else{
            if indexPath.row == 8 {
                //跳页 block 传值 订单金额
                let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
                WDDD?.state = "2"
                WDDD?.Dingdanblock = {(dingdanjine: String) in
                    self.TFDic["jine"] = dingdanjine
                    self.tablekaifapiao.reloadData()
                }
                self.navigationController?.pushViewController(WDDD!, animated: true)
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
