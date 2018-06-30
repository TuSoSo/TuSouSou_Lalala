//
//  XL_WDzhangdan_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDzhangdan_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var sousoubiButton: UIButton!
    @IBOutlet weak var yueButton: UIButton!
    @IBOutlet weak var youView: UIView!
    @IBOutlet weak var zuoView: UIView!
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    var moneyType = 1 //1 sousoubi  2 yue
    
    var zhangArr:[[String:Any]] = []
    
    @IBOutlet weak var tablezhangdan: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "账单列表"
        sousoubiButton.isSelected = true
        yueButton.isSelected = false
        youView.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tablezhangdan.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tablezhangdan.mj_footer = footer
        jiekou()
        Delegate()
        youAnniu()
        // Do any additional setup after loading the view.
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        zhangArr = []
        jiekou()
        tablezhangdan.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        pageNo = pageNo + 1
        if count > pageNo * pageSize {
            tablezhangdan.mj_footer.endRefreshing()
            jiekou()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    func jiekou() {
        let method = "/user/withdrawals"
        let userId = userDefaults.value(forKey: "userId")
        let dicc:[String:Any] = ["userId":userId!,"moneyType":moneyType,"userType":"1","pageNo":pageNo,"pageSize":pageSize]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dicc, success: { (res) in
            print(res)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.zhangArr += data["flowRecord"] as! [[String:Any]]
                self.tablezhangdan.reloadData()
            }else{
                
            }
        }) { (error) in
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    //MARK:tableviewDelegate
    func Delegate() {
        tablezhangdan.delegate = self
        tablezhangdan.dataSource = self
        tablezhangdan.tableFooterView = UIView()
        tablezhangdan.register(UITableViewCell.self, forCellReuseIdentifier: "zhangdan")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zhangArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "zhangdan"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }//明细背景1
        let imView = UIImageView(frame: CGRect(x: 0, y: 0, width: Width, height: 96))
        
        imView.image = UIImage(named: "明细背景1")
        let shangLable = UILabel(frame: CGRect(x: 48, y: 24, width: 80, height: 30))
        shangLable.text = zhangArr[indexPath.row]["turnoverType"] as? String
        shangLable.font = UIFont.systemFont(ofSize: 15)
        let xiaLable = UILabel(frame: CGRect(x: 48, y: 64, width: 200, height: 21))
        xiaLable.textColor = UIColor.darkGray
        xiaLable.font = UIFont.systemFont(ofSize: 14)
        xiaLable.text = zhangArr[indexPath.row]["createTime"] as? String
        let youLable = UILabel(frame: CGRect(x: Width - 150, y: 32, width: 130, height: 32))
        youLable.textAlignment = .right
        youLable.textColor = UIColor.orange
        youLable.text = zhangArr[indexPath.row]["withdrawMoney"] as? String
        cell.contentView.addSubview(imView)
        cell.contentView.addSubview(shangLable)
        cell.contentView.addSubview(xiaLable)
        cell.contentView.addSubview(youLable)
        
        
        
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func youAnniu() {
        let item = UIBarButtonItem(title:"开发票",style: .plain,target:self,action:#selector(YouActio))
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio()  {
        let WDXX: XL_kaifapiao_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kaifapiao") as? XL_kaifapiao_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
    }
    
    @IBAction func yueDianji(_ sender: Any) {
        if yueButton.isSelected != true {
            zhangArr = []
            moneyType = 2
            sousoubiButton.isSelected = false
            yueButton.isSelected = true
            zuoView.backgroundColor = UIColor.white
            youView.backgroundColor = UIColor.orange
            jiekou()
        }
    }
    
    @IBAction func sousoubiDianji(_ sender: Any) {
        if sousoubiButton.isSelected != true {
            zhangArr = []
            moneyType = 1
            yueButton.isSelected = false
            sousoubiButton.isSelected = true
            youView.backgroundColor = UIColor.white
            zuoView.backgroundColor = UIColor.orange
            jiekou()
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
