//
//  XL_GRziliaoViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/28.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_GRziliaoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableGRziliao: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDelegate()
        // Do any additional setup after loading the view.
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "grziliao"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.subviews {
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
                cell.addSubview(imageTou)
                cell.addSubview(zuoLabel)
            }else if indexPath.row == 1{
                zuoLabel.text = "用户名"
                let nameFD = UITextField(frame: CGRect(x: Width - 120, y: 11, width: 100, height: 22))
                nameFD.delegate = self
                nameFD.placeholder = "请输入用户名"
                nameFD.font = UIFont.systemFont(ofSize: 14)
                nameFD.textAlignment = .right
                cell.addSubview(zuoLabel)
                cell.addSubview(nameFD)
                
            }else if indexPath.row == 2{
                zuoLabel.text = "手机号"
                let phoneLabel = UILabel(frame: CGRect(x: Width - 100, y: 11, width: 80, height: 22))
                phoneLabel.text = "未绑定"
                phoneLabel.textAlignment = .right
                phoneLabel.font = UIFont.systemFont(ofSize: 14)
                cell.addSubview(zuoLabel)
                cell.addSubview(phoneLabel)
                
            }else if indexPath.row == 3{
                zuoLabel.text = "微信号"
                let WeChatLabel = UILabel(frame: CGRect(x: Width - 100, y: 11, width: 80, height: 22))
                WeChatLabel.text = "未绑定"
                WeChatLabel.textAlignment = .right
                WeChatLabel.font = UIFont.systemFont(ofSize: 14)
                cell.addSubview(zuoLabel)
                cell.addSubview(WeChatLabel)
            }else if indexPath.row == 4{
                zuoLabel.text = "安全设置"
                cell.accessoryType = .disclosureIndicator
                cell.addSubview(zuoLabel)
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
                shimingLabel.textAlignment = .right
                cell.accessoryType = .disclosureIndicator
                cell.addSubview(zuoLabel)
                cell.addSubview(shimingLabel)
            }else{
                zuoLabel.text = "企业认证"
                let qiyeLabel = UILabel(frame: CGRect(x: Width - 100, y: 11, width: 70, height: 22))
                qiyeLabel.font = UIFont.systemFont(ofSize: 14)
                qiyeLabel.text = "未认证"
                qiyeLabel.textAlignment = .right
                cell.accessoryType = .disclosureIndicator
                cell.addSubview(zuoLabel)
                cell.addSubview(qiyeLabel)
            }
        }else{
            let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
//            button.layer.cornerRadius = 15
//            button.backgroundColor = UIColor.orange
            button.setBackgroundImage(UIImage(named: "立即签到背景"), for: .normal)
            button.setTitle("保存", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
//            button.isUserInteractionEnabled = true
            //去掉当前cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            cell.backgroundColor = UIColor(hexString: "f0eff5")
            cell.addSubview(button)
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
