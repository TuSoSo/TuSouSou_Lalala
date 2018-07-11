//
//  XL_WDXXLB_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/1.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDXXLB_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let TZName: [String] = ["订单通知","公告通知","系统通知"]
    var index: Int?    
    var XXArr:[[String:Any]] = []
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    
    @IBOutlet weak var tablewdxxlb: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        //刷新界面
        XXArr = []
        pageNo = 1
        xiaoxiliebiaojiekou()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tablewdxxlb.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tablewdxxlb.mj_footer = footer
        self.title = TZName[index!]
        tableDelegate()
        // Do any additional setup after loading the view.
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        XXArr = []
        xiaoxiliebiaojiekou()
        tablewdxxlb.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            tablewdxxlb.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            xiaoxiliebiaojiekou()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    //MARK:tableviewdelegate
    func tableDelegate() {
        tablewdxxlb.delegate = self
        tablewdxxlb.dataSource = self
        tablewdxxlb.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return XXArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "xxlb"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let titleLabel:UILabel = cell.viewWithTag(225) as! UILabel
        let shijianLabel:UILabel = cell.viewWithTag(226) as! UILabel
       
        titleLabel.text = XXArr[indexPath.row]["title"] as? String
        shijianLabel.text = XXArr[indexPath.row]["pushTime"] as? String
        shijianLabel.adjustsFontSizeToFitWidth = true
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let WDXXXQ: XL_WDXXXQ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdxxxq") as? XL_WDXXXQ_ViewController
        WDXXXQ?.mssId = XXArr[indexPath.row]["id"] as? String
        self.navigationController?.pushViewController(WDXXXQ!, animated: true)
    }
    func xiaoxiliebiaojiekou() {
        let method = "/user/messageList"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"mssType":index! + 1,"pageNo":pageNo,"pageSize":pageSize]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
//                XL_waringBox().warningBoxModeText(message: "评价成功", view: self.view)
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                if nil == data["count"] {
                    self.count = 0
                }else{
                    self.count = data["count"] as! Int
                }
                self.XXArr += data["pushInfoList"] as! [[String:Any]]
                self.tablewdxxlb.reloadData()
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
