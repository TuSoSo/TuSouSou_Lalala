//
//  XL_Dizhibu_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/19.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_Dizhibu_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var biaoti: String?
    var type = ""
    //页码
    var pageNo = 0
    let pageSize = 10
    var count = 0
    
    var cityList:[[String:Any]] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    typealias Xuanzhibody = ([String:String]) -> ()
    var xuanzhiBody: Xuanzhibody?
    
    override func viewWillAppear(_ animated: Bool) {
        //刷新界面
        cityList = []
        pageNo = 0
        jiekou()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tableView.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableView.mj_footer = footer
        
        let biaotiArr = ["1":"寄件人地址簿","2":"取件人地址簿","3":"收件人地址簿"]
        switch biaoti {
        case "1":
            type = "2"
        case "2":
            type = "3"
        case "3":
            type = "1"
        default:
            break
        }
        self.title = biaotiArr[biaoti!]
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(tiaoye))
        self.navigationItem.rightBarButtonItem = item
        Delegate()
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 0
        cityList = []
        jiekou()
        tableView.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        pageNo = pageNo + 1
        if count > pageNo * pageSize {
            tableView.mj_footer.endRefreshing()
            jiekou()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    @objc func tiaoye() {
        let tianjiadizhi: XL_dizhi_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhi") as! XL_dizhi_ViewController
        switch biaoti {
        case "1":
            tianjiadizhi.Shei = "jijian"
            type = "2"
        case "2":
            tianjiadizhi.Shei = "qujian"
            type = "3"
        case "3":
            tianjiadizhi.Shei = "shoujian"
            type = "1"
        default:
            break
        }
        self.navigationController?.pushViewController(tianjiadizhi, animated: true)
    }
    func Delegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
        //删除多余行
        tableView.tableFooterView = UIView()
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
        let cellString = "dizhibu"
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
//        let touimage: UIImageView = cell.viewWithTag(131) as! UIImageView
        let nameString:UILabel = cell.viewWithTag(132) as! UILabel
        let phoneString:UILabel = cell.viewWithTag(133) as! UILabel
        let dizhiString:UILabel = cell.viewWithTag(134) as! UILabel
        if cityList.count != 0 {
            nameString.text = (cityList[indexPath.row])["userName"] as? String
            phoneString.text = "+ 86" + ((cityList[indexPath.row])["phone"]! as! String)
            dizhiString.text = ((cityList[indexPath.row])["location"]! as! String) + ((cityList[indexPath.row])["address"]! as! String)
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = (cityList[indexPath.row])["userName"] as? String
        let phone = "+ 86" + ((cityList[indexPath.row])["phone"]! as! String)
        let dizhi = ((cityList[indexPath.row])["location"]! as! String) + ((cityList[indexPath.row])["address"]! as! String)
        let Lon = (cityList[indexPath.row])["longitude"]! as! String
        let Lat = (cityList[indexPath.row])["latitude"]! as! String
        let dic = ["name":name,"phone":phone,"dizhi":dizhi,"lon":Lon,"lat":Lat]
        
        if let block = self.xuanzhiBody {
            block(dic as! [String : String])
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
        
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
                self.tableView!.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
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
    func jiekou() {
        let method = "/address/addressList"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId,"type":type,"pageSize":pageSize,"pageNo":pageNo]
//        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "加载成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.cityList += (dic["addressList"] as? [[String : Any]])!
                self.count = dic["count"] as! Int
                self.tableView.reloadData()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
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
