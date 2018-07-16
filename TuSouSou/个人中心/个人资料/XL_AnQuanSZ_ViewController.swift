//
//  XL_AnQuanSZ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/1.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_AnQuanSZ_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var swichButton = UISwitch()
    @IBOutlet weak var tableanquan: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全设置"
        Delegate()
    }
    //MARK:TableviewDelegate
    func Delegate() {
        swichButton.center = CGPoint(x: Width - 48, y: 32)
        swichButton.isOn = false;
        swichButton.addTarget(self, action: #selector(switchDidChange), for:.valueChanged)
        tableanquan.delegate = self
        tableanquan.dataSource = self
        tableanquan.tableFooterView = UIView()
        tableanquan.register(UITableViewCell.self, forCellReuseIdentifier: "anquansz")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "anquansz"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        let zuoLable = UILabel(frame: CGRect(x: 16, y: 17, width: Width/2, height: 30))
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            zuoLable.text = "设置登录密码"
            cell.contentView.addSubview(zuoLable)
        }else if indexPath.row == 1 {
            zuoLable.text = "设置支付密码"
            cell.contentView.addSubview(zuoLable)
        }else {
            zuoLable.text = "小额免密支付"
            if (userDefaults.value(forKey: "xemmzf") != nil) && userDefaults.value(forKey: "xemmzf") as! Bool {
                swichButton.isOn = true
            }else {
                swichButton.isOn = false
            }
            cell.accessoryType = .none
            cell.contentView.addSubview(zuoLable)
            cell.contentView.addSubview(swichButton)
            
        }
        return cell
    }
    @objc func switchDidChange() {
        if swichButton.isOn == false {
            userDefaults.set(false, forKey: "xemmzf")
        }else {
            let sheet = UIAlertController(title: "温馨提示", message: "开启后,再用余额付款时将不再输入支付密码。", preferredStyle: .alert)
            let queding = UIAlertAction(title: "确定", style: .default) { (ss) in
               
                //支付密码界面
                //是否有支付密码
                if  userDefaults.value(forKey: "isPayPassWord") as! Int == 1{
                    //输入支付密码验证后再跳页
                    self.swichButton.isOn = false
                    userDefaults.set(false, forKey: "xemmzf")
                    let payAlert = PayAlert(frame: UIScreen.main.bounds, jineHide: true, jine: "", isMove:false)
                    payAlert.show(view: self.view)
                    payAlert.completeBlock = ({(password:String) -> Void in
                        //调验证支付吗接口
                        self.yanzhengzhifumima(password: password, gai:2)
                        print("输入的密码是:" + password)
                    })
                }else{
                    self.tiaoye(rukou: "1")
                }
            }
            let quxiao = UIAlertAction(title: "取消", style: .cancel) { (ss) in
                self.swichButton.isOn = false
                userDefaults.set(false, forKey: "xemmzf")
            }
            sheet.addAction(queding)
            sheet.addAction(quxiao)
            self.present(sheet, animated: true, completion: nil)
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 跳页密码设置
           tiaoye(rukou: "0")
        }else if indexPath.row == 1 {
            //跳页密码设置
            if  userDefaults.value(forKey: "isPayPassWord") as! Int == 1{
                //输入支付密码验证后再跳页
                let payAlert = PayAlert(frame: UIScreen.main.bounds, jineHide: true, jine: "", isMove:false)
                payAlert.show(view: self.view)
                payAlert.completeBlock = ({(password:String) -> Void in
                    //调验证支付吗接口
                    self.yanzhengzhifumima(password: password, gai: 1)
                    print("输入的密码是:" + password)
                })
            }else{
                tiaoye(rukou: "1")
            }
            
        }
    }
    func yanzhengzhifumima(password:String,gai:Int) {
        let method = "/user/verifyPayPassword"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"payPassword":password]
        XL_waringBox().warningBoxModeIndeterminate(message: "密码验证中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                if gai == 2 {
                    self.swichButton.isOn = true
                    userDefaults.set(true, forKey: "xemmzf")
                }else{
                   self.tiaoye(rukou: "1")
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
    func tiaoye(rukou:String) {
        let AnQuanSZ: XL_WHMM_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "whmm") as? XL_WHMM_ViewController
        AnQuanSZ?.rukou = rukou
        self.navigationController?.pushViewController(AnQuanSZ!, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
