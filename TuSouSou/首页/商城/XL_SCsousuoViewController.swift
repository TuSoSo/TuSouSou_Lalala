//
//  XL_SCsousuoViewController.swift
//  
//
//  Created by 斌小狼 on 2018/5/7.
//

import UIKit

class XL_SCsousuoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var lll:String?
    var tpye = "1"
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    
    
    @IBOutlet weak var liwojin: UIButton!
    @IBOutlet weak var liwojinview: UIView!
    @IBOutlet weak var xiaolianggaoview: UIView!
    @IBOutlet weak var xiaolianggao: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var businessList:[[String:Any]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "搜索结果"
        //        segment.frame = CGRect(x: 0, y: 8, width: Width, height: 44)
        liwojin.isSelected = true
        xiaolianggao.isSelected = false
        xiaolianggaoview.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SCsousuo")
        tableView.tableFooterView = UIView()
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tableView.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableView.mj_footer = footer
        jiekou(string: tpye)
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        businessList = []
        jiekou(string: tpye)
        tableView.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            tableView.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            jiekou(string: tpye)
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return businessList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for i in 0..<businessList.count {
            if i == section {
                var ass = 0
                if nil != businessList[i]["productLsit"]{
                    ass = (businessList[i]["productLsit"] as! [[String:Any]]).count
                }
                if ass > 2 {
                    ass = 2
                }
                return ass
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 5))
        vv.backgroundColor = UIColor(hexString: "f0eff5")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 72))
        let xiaxian = UIView(frame: CGRect(x: 24, y: 71, width: Width, height: 1))
        xiaxian.backgroundColor = UIColor(hexString: "f0f0f0")
        let shangxian = UIView(frame: CGRect(x: 24, y: 5, width: Width, height: 1))
        shangxian.backgroundColor = UIColor(hexString: "f0f0f0")
        let imageView = UIImageView(frame: CGRect(x: 8, y: 15, width: 48, height: 48))
        
        var jiee:String = ""
        if businessList.count != 0{
            if nil != businessList[section]["logoUrl"]{
                jiee = businessList[section]["logoUrl"] as! String
            }
        }
        let newString1 = TupianUrl + jiee
        let uul:URL = URL(string: String(format: "%@",newString1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
        imageView.sd_setImage(with: uul, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
        let name = UILabel(frame: CGRect(x: 72, y: 21, width: Width - 142, height: 24))
        name.textColor = UIColor(hexString: "8e8e8e")
        
        name.text = ""
        if businessList.count != 0{
            name.text = businessList[section]["merchantName"] as? String
        }
        let jieshao = UILabel(frame: CGRect(x: 72, y: 37, width: Width - 142, height: 34))
        jieshao.font = UIFont.systemFont(ofSize: 13)
        jieshao.textColor = UIColor(hexString: "6e6e6e")
        jieshao.numberOfLines = 2
        jieshao.text = ""
        if businessList.count != 0{
            jieshao.text = businessList[section]["address"] as? String
        }
        let butt = UIButton(frame: CGRect(x: 0, y: 0, width: Width, height: 72
        ))
        butt.tag = 140 + section
        butt.isUserInteractionEnabled = true
        butt.addTarget(self, action: #selector(dianji(sender:)), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(jieshao)
        view.addSubview(name)
        view.addSubview(shangxian)
        view.addSubview(xiaxian)
        view.addSubview(vv)
        view.backgroundColor = UIColor.white
        view.addSubview(butt)
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "SCsousuo"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 64, height: 64))
        var jiee = ""
        
        if nil != businessList[indexPath.section]["productLsit"]  && (businessList[indexPath.section]["productLsit"] as! [[String:Any]]).count != 0{
            let sss:[[String:Any]] = businessList[indexPath.section]["productLsit"] as! [[String : Any]]
            if nil != sss[indexPath.row]["picture"]{
                jiee = sss[indexPath.row]["picture"] as! String
            }
        }
        let newString1 = TupianUrl + jiee
        let uul:URL = URL(string: String(format: "%@",newString1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
        imageView.sd_setImage(with: uul, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
        let name = UILabel(frame: CGRect(x: 82, y: 16, width: Width - 142, height: 24))
        name.font = UIFont.systemFont(ofSize: 15)
        name.textColor = UIColor(hexString: "8e8e8e")
        
        name.text = ((businessList[indexPath.section]["productLsit"] as! [[String:Any]])[indexPath.row])["productName"] as? String
        let jieshao = UILabel(frame: CGRect(x: 88, y: 36, width: Width - 142, height: 40))
        jieshao.font = UIFont.systemFont(ofSize: 18)
        jieshao.textColor = UIColor.orange
        jieshao.numberOfLines = 2
        
        jieshao.text = "¥ " + (((businessList[indexPath.section]["productLsit"] as! [[String:Any]])[indexPath.row])["productPrice"] as? String)!
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(jieshao)
        cell.contentView.addSubview(name)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            let xiadan: XL_DPliebiaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpliebiao") as? XL_DPliebiaoViewController
            xiadan?.lll = String(format: "%d",(businessList[indexPath.section]["merchantId"] as? Int)!)
            xiadan?.ttt = businessList[indexPath.section]["merchantName"] as? String
            //        xiada
            self.navigationController?.pushViewController(xiadan!, animated: true)
        }
    }
    @objc func dianji(sender:UIButton?) {
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            let index = (sender?.tag)! - 140
            let xiadan: XL_DPliebiaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpliebiao") as? XL_DPliebiaoViewController
            xiadan?.lll = String(format: "%d",(businessList[index]["merchantId"] as? Int)!)
            xiadan?.ttt = businessList[index]["merchantName"] as? String
            //        xiada
            self.navigationController?.pushViewController(xiadan!, animated: true)
        }
    }
    func jiekou(string:String) {
        let method = "/business/search"
        //        let userId = userDefaults.value(forKey: "userId")
        let latitude = userDefaults.value(forKey: "latitude")
        let longitude = userDefaults.value(forKey: "longitude")
        let city:String = userDefaults.value(forKey: "cityName")! as! String
        
        let dic:[String:Any] = ["longitude":longitude!,"latitude":latitude!,"searchName":lll!,"searchType":string,"pageNo":pageNo,"pageSize":pageSize,"cityName":city]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.businessList += dic["businessList"] as! [[String:Any]]
                
                self.tableView.reloadData()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
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
    
}
