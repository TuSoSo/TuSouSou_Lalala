//
//  XL_SJLB_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/13.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_SJLB_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    
    var tpye = "1"
    
    var businessList:[[String:Any]] = []
    
    var classifyTypeId:String?
    
    @IBOutlet weak var tablesjlb: UITableView!
    @IBOutlet weak var xiaolianggaoview: UIView!
    @IBOutlet weak var xiaolianggao: UIButton!
    @IBOutlet weak var liwojinview: UIView!
    @IBOutlet weak var liwojin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        liwojin.isSelected = true
        xiaolianggao.isSelected = false
        xiaolianggaoview.backgroundColor = UIColor.white
        self.title = "商家列表"
        // Do any additional setup after loading the view.
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tablesjlb.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tablesjlb.mj_footer = footer
        jiekou(string: tpye)
        delegate()
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        businessList = []
        jiekou(string: tpye)
        tablesjlb.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            tablesjlb.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            jiekou(string: tpye)
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    func delegate() {
        tablesjlb.delegate = self
        tablesjlb.dataSource = self
        tablesjlb.tableFooterView = UIView()
        tablesjlb.register(UITableViewCell.self, forCellReuseIdentifier: "sjlb")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "sjlb"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        var jiee:String = ""
        if businessList.count != 0{
            if nil != businessList[indexPath.row]["logoUrl"]{
                jiee = businessList[indexPath.row]["logoUrl"] as! String
            }
        }
        
        let newString1 = TupianUrl + jiee
        let uul:URL = URL(string: String(format: "%@",newString1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
        let imageview = UIImageView(frame: CGRect(x: 8, y: 8, width: Width/3 - 20, height: 96))
        imageview.sd_setImage(with: uul, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
        let gongsiName = UILabel(frame: CGRect(x: Width/3 + 8, y: 10, width: Width*2/3 - 20, height: 24))
        gongsiName.text = ""
        if businessList.count != 0{
            gongsiName.text = businessList[indexPath.row]["merchantName"] as? String
        }
        
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
        if businessList.count != 0{
            DDZZ.text = businessList[indexPath.row]["address"] as? String
        }
        let DDHH = UILabel(frame: CGRect(x: Width/3 + 24, y: 84, width: Width*2/3 - 40, height: 24))
        DDHH.font = UIFont.systemFont(ofSize: 15)
        DDHH.textColor = UIColor(hexString: "6e6e6e")
        var phoneNum = ""
        if businessList.count != 0{
            if nil != businessList[indexPath.row]["phone"]{
                phoneNum = businessList[indexPath.row]["phone"] as! String
            }
        }
        DDHH.text = "+86\(phoneNum)"
        
        cell.contentView.addSubview(imageview)
        cell.contentView.addSubview(gongsiName)
        cell.contentView.addSubview(imageDizhi)
        cell.contentView.addSubview(imageDianhua)
        cell.contentView.addSubview(DDZZ)
        cell.contentView.addSubview(DDHH)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let xiadan: XL_DPliebiaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpliebiao") as? XL_DPliebiaoViewController
        xiadan?.lll = String(format: "%d",(businessList[indexPath.row]["merchantId"] as? Int)!)
        xiadan?.ttt = businessList[indexPath.row]["merchantName"] as? String
        //        xiada
        self.navigationController?.pushViewController(xiadan!, animated: true)
    }
    
    @IBAction func liwoanniu(_ sender: Any) {
        if liwojin.isSelected != true {
            businessList = []
            tpye = "1"
            xiaolianggao.isSelected = false
            liwojin.isSelected = true
            xiaolianggaoview.backgroundColor = UIColor.white
            liwojinview.backgroundColor = UIColor.orange
            jiekou(string:tpye)
        }
    }
    
    @IBAction func xiaolianganniu(_ sender: Any) {
        if xiaolianggao.isSelected != true {
            businessList = []
            tpye = "2"
            xiaolianggao.isSelected = true
            liwojin.isSelected = false
            xiaolianggaoview.backgroundColor = UIColor.orange
            liwojinview.backgroundColor = UIColor.white
            jiekou(string:tpye)
        }
        
    }
    func jiekou(string:String) {
        let method = "/business/businessList"
//        let userId = userDefaults.value(forKey: "userId")
        let latitude = userDefaults.value(forKey: "latitude")
        let longitude = userDefaults.value(forKey: "longitude")
        let city:String = userDefaults.value(forKey: "cityName") as! String
        
        let dic:[String:Any] = ["longitude":longitude!,"latitude":latitude!,"classifyTypeId":classifyTypeId!,"searchType":string,"pageNo":pageNo,"pageSize":pageSize,"cityName":city]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.businessList += dic["businessList"] as! [[String:Any]]
                self.tablesjlb.reloadData()
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
