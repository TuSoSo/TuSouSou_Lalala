//
//  XL_WDDZ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/16.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDDZ_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var jijian: UIButton!
    
    @IBOutlet weak var jiView: UIView!
    @IBOutlet weak var shoujian: UIButton!
    
    @IBOutlet weak var shouView: UIView!
    @IBOutlet weak var qujian: UIButton!
    
    @IBOutlet weak var quView: UIView!
    
    @IBOutlet weak var tableDizhi: UITableView!
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var biaoti: String?
    var type = "2"
    //页码
    
    var pageNo = 1
    let pageSize = 10
    var count = 0
    
    
    var cityList:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的地址"
        jijian.isSelected = true
        qujian.isSelected = false
        shoujian.isSelected = false
        quView.backgroundColor = UIColor.white
        shouView.backgroundColor = UIColor.white
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(tiaoye))
        self.navigationItem.rightBarButtonItem = item
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tableDizhi.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableDizhi.mj_footer = footer
        Delegate()
        DizhiJiekou(string: type)
        // Do any additional setup after loading the view.
    }

    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        cityList = []
        DizhiJiekou(string: type)
        tableDizhi.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            tableDizhi.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            DizhiJiekou(string: type)
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    @objc func tiaoye() {
        let tianjiadizhi: XL_dizhi_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhi") as! XL_dizhi_ViewController
        switch type {
        case "2":
            tianjiadizhi.Shei = "jijian"
        case "3":
            tianjiadizhi.Shei = "qujian"
        case "1":
            tianjiadizhi.Shei = "shoujian"
        default:
            break
        }
        self.navigationController?.pushViewController(tianjiadizhi, animated: true)
    }
    func Delegate() {
        tableDizhi.delegate = self
        tableDizhi.dataSource = self
        
        //删除多余行
        tableDizhi.tableFooterView = UIView()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "wddz"
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let nameString:UILabel = cell.viewWithTag(1132) as! UILabel
        let phoneString:UILabel = cell.viewWithTag(1133) as! UILabel
        let dizhiString:UILabel = cell.viewWithTag(1134) as! UILabel
        
        nameString.text = (cityList[indexPath.row])["userName"] as? String
        phoneString.text = "+ 86" + ((cityList[indexPath.row])["phone"]! as! String)
        dizhiString.text = ((cityList[indexPath.row])["location"]! as! String) + ((cityList[indexPath.row])["address"]! as! String)
        
        
        
        return cell
    }
    
    //在这里修改删除按钮的文字
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "点击删除"
        
    }
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            
            let str:String = cityList[indexPath.row]["addressInfoId"] as! String
            self.shanchujiekou(addressInfoId:str, huidiao: {(ss)in
                self.cityList.remove(at: indexPath.row)
                print(self.cityList.count)
                self.tableDizhi!.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            })
        }
    }
    func shanchujiekou(addressInfoId:String,huidiao: @escaping(_ result: Any) -> ()) {
        
        let method = "/address/deleteAddress"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId,"addressInfoId":addressInfoId]
        XL_waringBox().warningBoxModeIndeterminate(message: "删除中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "删除成功", view: self.view)
                let ss = ""
                huidiao(ss)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func DizhiJiekou(string: String) {
        let method = "/address/addressList"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId,"type":type,"pageSize":pageSize,"pageNo":pageNo]
        print(dic)
        //        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "加载成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.cityList += (dic["addressList"] as? [[String : Any]])!
                self.count = dic["count"] as! Int
                self.tableDizhi.reloadData()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    @IBAction func jijianButton(_ sender: Any) {
        if jijian.isSelected != true {
            cityList = []
            type = "2"
            qujian.isSelected = false
            shoujian.isSelected = false
            jijian.isSelected = true
            quView.backgroundColor = UIColor.white
            shouView.backgroundColor = UIColor.white
            jiView.backgroundColor = UIColor.orange
            DizhiJiekou(string: type)
        }
    }
    

    @IBAction func qujianButton(_ sender: Any) {
        if qujian.isSelected != true {
            cityList = []
            type = "3"
            jijian.isSelected = false
            shoujian.isSelected = false
            qujian.isSelected = true
            jiView.backgroundColor = UIColor.white
            shouView.backgroundColor = UIColor.white
            quView.backgroundColor = UIColor.orange
            DizhiJiekou(string: type)
        }
    }
    
    @IBAction func shoujianButton(_ sender: Any) {
        if shoujian.isSelected != true {
            cityList = []
            type = "1"
            qujian.isSelected = false
            jijian.isSelected = false
            shoujian.isSelected = true
            quView.backgroundColor = UIColor.white
            jiView.backgroundColor = UIColor.white
            shouView.backgroundColor = UIColor.orange
            DizhiJiekou(string: type)
        }
    }
}
