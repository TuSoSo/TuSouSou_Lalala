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
            let WDXX: XL_Dizhibu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhibu") as? XL_Dizhibu_ViewController
            WDXX?.biaoti = "3"
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 2 {
            let WDXX: XL_WDKF_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdkf") as? XL_WDKF_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 3 {
            let WDXX: XL_WDdianou_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddianpu") as? XL_WDdianou_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 4 {
            let WDXX: XL_YQHY_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "yqhy") as? XL_YQHY_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }else if indexPath.row == 5 {
            let WDXX: XL_WDshezhi_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdshezhi") as? XL_WDshezhi_ViewController
            self.navigationController?.pushViewController(WDXX!, animated: true)
        }
        print("\(indexPath.row)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
