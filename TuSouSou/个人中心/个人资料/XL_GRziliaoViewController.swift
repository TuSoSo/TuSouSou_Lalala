//
//  XL_GRziliaoViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/28.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_GRziliaoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var Dic:[String:Any]?

    @IBOutlet weak var tableGRziliao: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        tableDelegate()
        yonghuxinxichaxun()
        // Do any additional setup after loading the view.
    }
    func yonghuxinxichaxun() {
        let method = "/user/findUserInfo"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "登录成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.Dic = dic
                self.tableGRziliao.reloadData()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func tableDelegate() {
        tableGRziliao.delegate = self
        tableGRziliao.dataSource = self
        tableGRziliao.register(UITableViewCell.self, forCellReuseIdentifier: "grziliao")
        tableGRziliao.tableFooterView = UIView()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        }else if section == 1{
            return 2
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 60
            }else{
                return 44
            }
        }else if indexPath.section == 1{
            return 44
        }else{
            return 80
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 8
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 8))
            view.backgroundColor = UIColor(hexString: "f0eff5")
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "grziliao"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.section == 0 {
            let zuoLabel = UILabel(frame: CGRect(x: 16, y: 11, width: 80, height: 22))
            zuoLabel.font = UIFont.systemFont(ofSize: 14)
            zuoLabel.textColor = UIColor.darkGray
            
            if indexPath.row == 0 {
                zuoLabel.frame = CGRect(x: 16, y: 19, width: 80, height: 22)
                zuoLabel.text = "头像"
                let imageTou = UIImageView(frame: CGRect(x: Width - 60, y: 10, width: 40, height: 40))
                imageTou.image = UIImage(named: "引导3")
                cell.contentView.addSubview(imageTou)
                cell.contentView.addSubview(zuoLabel)
            }else if indexPath.row == 1{
                zuoLabel.text = "用户名"
                let nameFD = UITextField(frame: CGRect(x: Width - 120, y: 11, width: 100, height: 22))
                nameFD.delegate = self
                nameFD.placeholder = "请输入用户名"
                nameFD.font = UIFont.systemFont(ofSize: 14)
                nameFD.textAlignment = .right
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(nameFD)
                
            }else if indexPath.row == 2{
                zuoLabel.text = "手机号"
                let phoneLabel = UILabel(frame: CGRect(x: Width - 100, y: 11, width: 80, height: 22))
                phoneLabel.text = "未绑定"
                phoneLabel.textColor = UIColor.darkGray
                phoneLabel.textAlignment = .right
                phoneLabel.font = UIFont.systemFont(ofSize: 14)
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(phoneLabel)
                
            }else if indexPath.row == 3{
                zuoLabel.text = "微信号"
                let WeChatLabel = UILabel(frame: CGRect(x: Width - 100, y: 11, width: 80, height: 22))
                WeChatLabel.text = "未绑定"
                WeChatLabel.textColor = UIColor.darkGray
                WeChatLabel.textAlignment = .right
                WeChatLabel.font = UIFont.systemFont(ofSize: 14)
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(WeChatLabel)
            }else if indexPath.row == 4{
                zuoLabel.text = "安全设置"
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(zuoLabel)
            }
        }else if indexPath.section == 1 {
            let zuoLabel = UILabel(frame: CGRect(x: 16, y: 11, width: 80, height: 22))
            zuoLabel.font = UIFont.systemFont(ofSize: 14)
            zuoLabel.textColor = UIColor.darkGray
            if indexPath.row == 0{
                zuoLabel.text = "实名认证"
                let shimingLabel = UILabel(frame: CGRect(x: Width - 100, y: 11, width: 70, height: 22))
                shimingLabel.font = UIFont.systemFont(ofSize: 14)
                shimingLabel.text = "未认证"
                shimingLabel.textColor = UIColor.darkGray
                shimingLabel.textAlignment = .right
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(shimingLabel)
            }else{
                zuoLabel.text = "企业认证"
                let qiyeLabel = UILabel(frame: CGRect(x: Width - 100, y: 11, width: 70, height: 22))
                qiyeLabel.font = UIFont.systemFont(ofSize: 14)
                qiyeLabel.text = "未认证"
                qiyeLabel.textColor = UIColor.darkGray
                qiyeLabel.textAlignment = .right
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(qiyeLabel)
            }
        }else{
            let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
//            button.layer.cornerRadius = 15
//            button.backgroundColor = UIColor.orange
            button.setBackgroundImage(UIImage(named: "立即签到背景"), for: .normal)
            button.setTitle("保存", for: .normal)
            button.addTarget(self, action: #selector(yonghuxinxixiugai), for: .touchUpInside)
            button.setTitleColor(UIColor.white, for: .normal)
//            button.isUserInteractionEnabled = true
            //去掉当前cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            cell.backgroundColor = UIColor(hexString: "f0eff5")
            cell.contentView.addSubview(button)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //选择，相册/照相
            }
            else if indexPath.row == 4 {
                //跳页到安全设置
                let AnQuanSZ: XL_AnQuanSZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anquansz") as? XL_AnQuanSZ_ViewController
                self.navigationController?.pushViewController(AnQuanSZ!, animated: true)
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                //跳实名认证
                let ShimingRZ: XL_ShimingRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shimingrz") as? XL_ShimingRZ_ViewController
                self.navigationController?.pushViewController(ShimingRZ!, animated: true)
            }else if indexPath.row == 1 {
                //跳企业认证
                let qiyeRZ: XL_QiyeRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qiyerz") as? XL_QiyeRZ_ViewController
                self.navigationController?.pushViewController(qiyeRZ!, animated: true)
            }
        }
    }
    @objc func yonghuxinxixiugai() {
        let method = "/user/updateUserInfo"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        let image = UIImage(named: "")
        let imagearr:[Any] = [image!]
        let namearr:[Any] = ["photo"]
        
        let dic:[String:Any] = ["userId":userId,"name":""]
        
        
        XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, methodName: method, rucan: dic, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "登录成功", view: self.view)
                
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
