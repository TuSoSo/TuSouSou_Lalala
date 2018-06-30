//
//  XL_YiYaohaoyou_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_YiYaohaoyou_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
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
    var invitationList:[[String:Any]] = []

    @IBOutlet weak var tableyiyaoqing: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DelegateTable()
        self.title = "已邀请好友"
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tableyiyaoqing.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableyiyaoqing.mj_footer = footer
        yiyaoqingjiekou()
        // Do any additional setup after loading the view.
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        invitationList = []
        yiyaoqingjiekou()
        tableyiyaoqing.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        pageNo = pageNo + 1
        if count > pageNo * pageSize {
            tableyiyaoqing.mj_footer.endRefreshing()
            yiyaoqingjiekou()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    //MARK:tableviewDelegate
    func DelegateTable() {
        tableyiyaoqing.delegate = self
        tableyiyaoqing.dataSource = self
        tableyiyaoqing.tableFooterView = UIView()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitationList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "yiyaoqing"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let nameLabel:UILabel = cell.viewWithTag(590) as! UILabel
        let dianhuaLabel:UILabel = cell.viewWithTag(591) as! UILabel
        let shijianLabel:UILabel = cell.viewWithTag(592) as! UILabel
        nameLabel.text = invitationList[indexPath.row]["name"] as? String
        dianhuaLabel.text = invitationList[indexPath.row]["phone"] as? String
        shijianLabel.text = invitationList[indexPath.row]["createDate"] as? String
        
        cell.selectionStyle = .none
        return cell
    }
    func yiyaoqingjiekou() {
        let method = "/user/invitationList"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
        XL_waringBox().warningBoxModeIndeterminate(message: "删除中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                if nil != dic["invitationList"]{
                    self.invitationList += (dic["invitationList"] as? [[String : Any]])!
                    self.count = dic["count"] as! Int
                }
                
//                XL_waringBox().warningBoxModeText(message: "删除成功", view: self.view)
               
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
}
