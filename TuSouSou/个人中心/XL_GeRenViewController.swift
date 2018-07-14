//
//  XL_GeRenViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/25.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_GeRenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var touxiang: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var tablegeren: UITableView!
    @IBOutlet weak var xiaoxi_tupian: UIImageView!
    let touarr = ["我的1","我的2","我的3","我的4","我的5","我的6"]
    let namearr = ["我的钱包","我的地址","我的客服","我的店铺","邀请好友","设置"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
        tableDelegate()
        touxiang.layer.masksToBounds = true
        touxiang.layer.cornerRadius = touxiang.frame.size.height/2
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if nil != userDefaults.value(forKey: "userId") {
            yonghuxinxichaxun()
        }else{
            //跳登陆
        }
    }
    @IBAction func GRziliao(_ sender: Any) {
        let GRziliao: XL_GRziliaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grziliao") as? XL_GRziliaoViewController
        self.navigationController?.pushViewController(GRziliao!, animated: true)
    }
    @IBAction func shoucang(_ sender: Any) {
        let WDshoucang: XL_WDshoucang_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdshoucang") as? XL_WDshoucang_ViewController
        self.navigationController?.pushViewController(WDshoucang!, animated: true)
    }
    
    @IBAction func dingdan(_ sender: Any) {
        let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
        WDDD?.state = "1"
        self.navigationController?.pushViewController(WDDD!, animated: true)
        
    }
    
    @IBAction func xiaoxi(_ sender: Any) {
        let WDXX: XL_WDxiaoxi_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdxiaoxi") as? XL_WDxiaoxi_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
    }
    
    func tableDelegate() {
        tablegeren.delegate = self
        tablegeren.dataSource = self
        //删除多余行
        tablegeren.tableFooterView = UIView()
        tablegeren.isScrollEnabled = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "geren"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let touimage: UIImageView = cell.viewWithTag(141) as! UIImageView
        let nameString:UILabel = cell.viewWithTag(142) as! UILabel
        
        touimage.image = UIImage(named: "\(touarr[indexPath.row])")
        nameString.text = "\(namearr[indexPath.row])"
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let WDXX: XL_WDQB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdqb") as? XL_WDQB_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 1 {
            let WDXX: XL_WDDZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddz") as? XL_WDDZ_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 2 {
            let WDXX: XL_WDKF_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdkf") as? XL_WDKF_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 3 {
            if userDefaults.value(forKey: "isFirmAdit") as! Int == 4  {
                let WDXX: XL_WDdianou_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddianpu") as? XL_WDdianou_ViewController
                self.navigationController?.pushViewController(WDXX!, animated: true)
            }
        }else if indexPath.row == 4 {
            let WDXX: XL_YQHY_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "yqhy") as? XL_YQHY_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 5 {
            let WDXX: XL_WDshezhi_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdshezhi") as? XL_WDshezhi_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }
        print("\(indexPath.row)")
    }
    func yonghuxinxichaxun() {
        
        let method = "/user/findUserInfo"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
        //        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                if nil != data["mobile"] {
                    self.phone.text = data["mobile"] as? String
                }
                userDefaults.set(data["largessRule"], forKey: "yaoqingyouhui")
                var ax:String = ""
                if nil != data["photo"]{
                    ax = data["photo"] as! String
                }
                
                let newstring = TupianUrl + ax
                let touurl = URL(string: String(format: "%@",newstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
                
                self.touxiang.sd_setImage(with: touurl, placeholderImage: UIImage(named: "head"), options: SDWebImageOptions.progressiveDownload, completed: nil)
                //企业认证不等于4 都是个人
                
                if nil != data["name"] {
                    userDefaults.set(0, forKey: "isFirmAdit")
                    self.name.text = (data["name"] as? String)! + " (个人版)"
                    if nil != data["isPass"] && data["isPass"] as!Int == 4{
                        self.name.text = (data["name"] as? String)! + " (企业版)"
                        userDefaults.set(4, forKey: "isFirmAdit")
                    }
                }
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
            
        }
    }
}
