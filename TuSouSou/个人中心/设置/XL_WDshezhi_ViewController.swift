//
//  XL_WDshezhi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDshezhi_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let zuoArr: [String] = ["推送设置","意见反馈","关于我们","申请商户入驻","申请成为配送员"]
    let uiswitch = UISwitch()
    @IBOutlet weak var tableshezhi: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"
        yonghuxinxichaxun()
        DelegateTable()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableshezhi.reloadData()
    }
    func yonghuxinxichaxun() {
        let method = "/user/approve"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
//                if nil != dic["isAuthentic"]{
//                    userDefaults.set(dic["isAuthentic"], forKey: "zhenshigeren")
//                }
//                if nil != dic["firmAuthentic"]{
//                    userDefaults.set(dic["firmAuthentic"], forKey: "zhenshiqiye")
//                }
                if nil != dic["attestation"] {
                    userDefaults.set(dic["attestation"], forKey: "attestation")
                }
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
    func yijian() {
        let alertController = UIAlertController(title: "意见反馈",
                                                message: "", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "请填写您的意见或建议"
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let login = alertController.textFields!.first!
            print("意见：\(login.text!) ")
            if login.text?.count == 0 {
                XL_waringBox().warningBoxModeText(message: "请填写您的意见及建议", view: self.view)
            }else {
                //调接口
                self.fankuijiekou(content: login.text!)
                //                XL_waringBox().warningBoxModeText(message: "反馈成功", view: self.view)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    func fankuijiekou(content:String) {
        let method = "/user/feedback"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"content":content]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "感谢您的宝贵意见", view: self.view)
                //                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                
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
    //MARK:Delegate TableView
    func DelegateTable() {
        tableshezhi.delegate = self
        tableshezhi.dataSource = self
        tableshezhi.tableFooterView = UIView()
        tableshezhi.register(UITableViewCell.self, forCellReuseIdentifier: "shezhi")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 120
        }
        return 64
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "shezhi"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.row == 5 {
            //      按钮
            //确认按钮
            let button = UIButton(frame: CGRect(x: 20, y: 48, width: Width - 40, height: 64))
            button.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
            button.setBackgroundImage(UIImage(named: "button_normal_light"), for: .highlighted)
            button.setTitle("退出登录", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(tuichu), for: .touchUpInside)
            //            button.isUserInteractionEnabled = true
            //去掉当前cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            cell.backgroundColor = UIColor(hexString: "f0eff5")
            cell.contentView.addSubview(button)
        }else{
            let zuoLable  = UILabel(frame: CGRect(x: 16, y: 17, width: 150, height: 30))
            zuoLable.font = UIFont.systemFont(ofSize: 15)
            zuoLable.textColor = UIColor.darkGray
            zuoLable.text = zuoArr[indexPath.row]
            cell.contentView.addSubview(zuoLable)
            if indexPath.row != 0 {
                cell.accessoryType = .disclosureIndicator
                let Isrenzheng = UILabel(frame: CGRect(x: Width - 100, y: 17, width: 64, height: 30))
                Isrenzheng.font = UIFont.systemFont(ofSize: 15)
                Isrenzheng.textColor = UIColor.darkGray
                Isrenzheng.textAlignment = .right
                if indexPath.row == 3 {
                    //是否认证
                    //                    Isrenzheng.text = "未认证"
                    let xx = userDefaults.value(forKey: "zhenshiqiye") as! Int
                    switch xx {
                    case 1:
                        Isrenzheng.text = "未认证"
                    case 2:
                        Isrenzheng.text = "认证中"
                    case 3:
                        Isrenzheng.text = "认证未通过"
                    case 4:
                        Isrenzheng.text = "已通过"
                    default:
                        Isrenzheng.text = "未认证"
                        break
                    }
                    
                    cell.contentView.addSubview(Isrenzheng)
                }else if indexPath.row == 4 {
                    //是否认证
                    
                    var xx = 1
                    if nil != userDefaults.value(forKey: "attestation"){
                        xx = userDefaults.value(forKey: "attestation") as! Int
                    }
                    switch xx {
                    case 1:
                        Isrenzheng.text = "未认证"
                    case 2:
                        Isrenzheng.text = "认证中"
                    case 3:
                        Isrenzheng.text = "认证未通过"
                    case 4:
                        Isrenzheng.text = "已通过"
                    default:
                        break
                    }
                    cell.contentView.addSubview(Isrenzheng)
                }
            }else {
                //uiswichButton
                
                
                uiswitch.center = CGPoint(x: Width - 45, y: 24)
                uiswitch.isOn = true
                if (userDefaults.value(forKey: "Tuisong") != nil) && !(userDefaults.value(forKey: "Tuisong") as! Bool) {
                    uiswitch.isOn = false
                }
                uiswitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
                cell.contentView.addSubview(uiswitch)
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            // 意见反馈
            yijian()
            
        }else if indexPath.row == 2 {
            //关于我们
            let WDXX: XL_Guanyuwomen_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "guanyuwomen") as? XL_Guanyuwomen_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 3 {
            //企业认证
            if userDefaults.value(forKey: "zhenshiqiye") as! Int == 4 || userDefaults.value(forKey: "zhenshiqiye") as! Int == 2 {
                
            }else{
                if userDefaults.value(forKey: "zhenshigeren") as! Int == 1 || userDefaults.value(forKey: "zhenshigeren") as! Int == 3{
                    //弹框 --- 请先完成实名认证
                    let sheet = UIAlertController(title: "温馨提示:", message: "请先完成实名认证再进行企业认证", preferredStyle: .alert)
                    let queding = UIAlertAction(title: "确定", style: .default) { (ss) in
                        //接口 取回 token 调 阿里
                        let ShimingRZ: XL_ShimingRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shimingrz") as? XL_ShimingRZ_ViewController
                        ShimingRZ?.jiemian = 1
                        ShimingRZ?.yyy = 1
                        self.navigationController?.pushViewController(ShimingRZ!, animated: true)
                    }
                    let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    sheet.addAction(queding)
                    sheet.addAction(cancel)
                    self.present(sheet, animated: true, completion: nil)
                }else if userDefaults.value(forKey: "zhenshigeren") as! Int == 4 {
                    //跳企业认证
                    let qiyeRZ: XL_QiyeRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qiyerz") as? XL_QiyeRZ_ViewController
                    self.navigationController?.pushViewController(qiyeRZ!, animated: true)
                }
            }
        }else if indexPath.row == 4 {
            //成为配送员
            if userDefaults.value(forKey: "attestation") as! Int == 1 || userDefaults.value(forKey: "attestation") as! Int == 3 {
                if userDefaults.value(forKey: "isoopp") as! Int == 1 {
                    let WDXX: XL_PeiSongYuan_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "peisongyuan") as? XL_PeiSongYuan_ViewController
                    self.navigationController?.pushViewController(WDXX!, animated: true)
                }else {
                    XL_waringBox().warningBoxModeText(message: "尚未开通，暂不能申请成为配送员", view: self.view)
                }
            }
        }
    }
    @objc func tuichu() {
        showConfirm(title: "温馨提示", message: "确定退出当前帐号吗?", in: self, Quxiao: { (quxiao) in
            
        }) { (queding) in
            let WDXX: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            userDefaults.set("0", forKey: "isDengLu")
            userDefaults.set("", forKey: "nickname")
            userDefaults.set(true, forKey: "Tuisong")
            JPUSHService.deleteAlias({ (iResCode, alias, aa) in
                print("\(iResCode)\n别名:  \(alias)\n\(aa)")
            }, seq: 1)
            WDXX?.xxjj = 1
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }
    }
    @objc func switchDidChange() {
        if uiswitch.isOn == false {
            self.showConfirm(title: "温馨提示", message: "关闭后，将不再受到订单等推送通知", in: self, Quxiao: { (_) in
                self.uiswitch.isOn = true
                userDefaults.set(true, forKey: "Tuisong")
                //                self.tuisonggaibian()
            }) { (_) in
                self.uiswitch.isOn = false
                userDefaults.set(false, forKey: "Tuisong")
                self.tuisonggaibian()
            }
        }else{
            userDefaults.set(true, forKey: "Tuisong")
            tuisonggaibian()
        }
    }
    func tuisonggaibian() {
        var alias: String = " "
        if nil == userDefaults.value(forKey: "Tuisong") ||  (userDefaults.value(forKey: "Tuisong") as! Bool){
            if nil != userDefaults.value(forKey: "userId"){
                alias = userDefaults.value(forKey: "userId") as! String
            }
        }
        if alias == " " {
            if nil != userDefaults.value(forKey: "userId"){
                alias = userDefaults.value(forKey: "userId") as! String
            }
            JPUSHService.deleteAlias({ (iResCode, alias, aa) in
                print("\(iResCode)\n别名:  \(alias)\n\(aa)")
            }, seq: 1)
        }else{
            JPUSHService.setAlias(alias, completion: { (iResCode, alias, aa) in
                print("\(iResCode)\n别名:  \(alias)\n\(aa)")
            }, seq: 1)
        }
    }
    //MARK：提示框
    func showConfirm(title: String, message: String, in viewController: UIViewController,Quxiao:((UIAlertAction)->Void)?,
                     Queding: ((UIAlertAction)->Void)?) {
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: Quxiao))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: Queding))
        viewController.present(alert, animated: true)
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
