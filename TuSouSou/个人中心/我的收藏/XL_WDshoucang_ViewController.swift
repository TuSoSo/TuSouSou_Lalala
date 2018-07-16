//
//  XL_WDshoucang_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/31.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDshoucang_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var shoucangArr: [[String:Any]] = []
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var biaoti: String?
    var type = ""
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    
    @IBOutlet weak var tableShoucang: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        jiekoukaishi()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tableShoucang.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableShoucang.mj_footer = footer
        tableDelegate()
        // Do any additional setup after loading the view.
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        shoucangArr = []
        jiekoukaishi()
        tableShoucang.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            tableShoucang.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            jiekoukaishi()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    //MARK:tableViewDelagete
    func tableDelegate() {
        tableShoucang.delegate = self
        tableShoucang.dataSource = self
        tableShoucang.tableFooterView = UIView()
        tableShoucang.register(UITableViewCell.self, forCellReuseIdentifier: "wdshoucang")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoucangArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "wdshoucang"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        let imageview = UIImageView(frame: CGRect(x: 8, y: 8, width: Width/3 - 20, height: 96))
        var ax:String = ""
        if shoucangArr.count > 0{
            if nil != shoucangArr[indexPath.row]["logoUrl"]{
                ax = shoucangArr[indexPath.row]["logoUrl"] as! String
            }
        }
        let newString = TupianUrl + ax
        let uuu:URL = URL(string: String(format: "%@",newString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
        imageview.sd_setImage(with: uuu, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
        let gongsiName = UILabel(frame: CGRect(x: Width/3 + 8, y: 10, width: Width*2/3 - 20, height: 24))
        if shoucangArr.count != 0{
            gongsiName.text = shoucangArr[indexPath.row]["name"] as? String
        }
//        gongsiName.text = "国云数据科技有限公司"
        gongsiName.font = UIFont.systemFont(ofSize: 19)
        let imageDizhi = UIImageView(frame: CGRect(x: Width/3 + 8, y: 48, width: 10, height: 16))
        imageDizhi.image = UIImage(named: "位置2")
        let imageDianhua = UIImageView(frame: CGRect(x: Width/3 + 8, y: 88, width: 10, height: 16))
        imageDianhua.image = UIImage(named: "电话")
        
        let DDZZ = UILabel(frame: CGRect(x: Width/3 + 24, y: 40, width: Width*2/3 - 40, height: 40))
        DDZZ.numberOfLines = 2
        DDZZ.font = UIFont.systemFont(ofSize: 15)
        DDZZ.textColor = UIColor(hexString: "6e6e6e")
        DDZZ.text = ""
        if shoucangArr.count != 0{
            DDZZ.text = shoucangArr[indexPath.row]["address"] as? String
        }
        let DDHH = UILabel(frame: CGRect(x: Width/3 + 24, y: 84, width: Width*2/3 - 40, height: 24))
        DDHH.font = UIFont.systemFont(ofSize: 15)
        DDHH.textColor = UIColor(hexString: "6e6e6e")
        var phoneNum = ""
        if shoucangArr.count != 0{
            if nil != shoucangArr[indexPath.row]["phone"]{
                phoneNum = shoucangArr[indexPath.row]["phone"] as! String
            }
        }
        DDHH.text = "+86\(phoneNum)"
        
        cell.contentView.addSubview(imageview)
        cell.contentView.addSubview(gongsiName)
        cell.contentView.addSubview(imageDizhi)
        cell.contentView.addSubview(imageDianhua)
        cell.contentView.addSubview(DDZZ)
        cell.contentView.addSubview(DDHH)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DPLiebiao: XL_DPliebiaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpliebiao") as? XL_DPliebiaoViewController
        DPLiebiao?.lll = String(format: "%d", shoucangArr[indexPath.row]["merchantId"] as! Int)
        DPLiebiao?.ttt = shoucangArr[indexPath.row]["name"] as? String
        self.navigationController?.pushViewController(DPLiebiao!, animated: true)
    }
//    func shoucangjiekou() {
//        let method = "/user/userCollection"
//        let userId = userDefaults.value(forKey: "userId")
//        let dic:[String:Any] = ["orderId":userId!]
//        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
//        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
//            print(res)
//            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
//            if (res as! [String: Any])["code"] as! String == "0000" {
//                //                XL_waringBox().warningBoxModeText(message: "评价成功", view: self.view)
//                    let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
//
//            }
//        }) { (error) in
//            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
//            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
//            print(error)
//        }
//    }
    func jiekoukaishi() {
        let method = "/user/userCollection"
        let userId = userDefaults.value(forKey: "userId")
       
        let dic:[String:Any] = ["userId":userId!,"pageNo":pageNo,"pageSize":pageSize]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.shoucangArr = data["businessList"] as! [[String:Any]]
                self.tableShoucang.reloadData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
