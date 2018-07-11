//
//  XL_SPLX_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/25.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_SPLX_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    var banView = UIView()
    var jie = UIView()
    var splb = UITextField()
    var pxbs = UITextField()
    var biaoshiID = ""
    var leibie = UILabel()
    var leiBArr:[[String:Any]] = []

    @IBOutlet weak var tablesplx: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tablesplx.mj_header = header
        self.title = "类别管理"
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tablesplx.mj_footer = footer
        youshangjiao()
        tableDelegate()
        jiekou()
        tianjiaUI()
        // Do any additional setup after loading the view.
    }
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        leiBArr = []
        jiekou()
        tablesplx.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            tablesplx.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            jiekou()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    func jiekou() {
        let method = "/user/findProType"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"pageNo":pageNo,"pageSize":pageSize]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.leiBArr = dic["pushTypeInfoList"] as! [[String : Any]]
                self.count = dic["count"] as! Int
                self.tablesplx.reloadData()
            }else {
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func tianjiaUI() {
        banView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        banView.backgroundColor = UIColor.black
        banView.alpha = 0.8
        self.view.addSubview(banView)
        jie = UIView(frame: CGRect(x: 20, y: 150, width: Width - 40, height: 210))
        jie.backgroundColor = UIColor.white
        leibie = UILabel(frame: CGRect(x: 20, y: 16, width: Width - 80, height: 44))
        leibie.font = UIFont.systemFont(ofSize: 20)
        leibie.text = "添加商品类型"
        let shangpinleixing = UILabel(frame: CGRect(x: 16, y: 76, width: 80, height: 44))
        shangpinleixing.font = UIFont.systemFont(ofSize: 15)
        shangpinleixing.text = "商品类型:"
        let biaoshi = UILabel(frame: CGRect(x: 16, y: 132, width: 80, height: 44))
        biaoshi.font = UIFont.systemFont(ofSize: 15)
        biaoshi.text = "排序标识:"
        splb = UITextField(frame: CGRect(x: 90, y: 76, width: 180, height: 44))
        splb.placeholder = "请填写商品类型名称"
        splb.delegate = self
        pxbs = UITextField(frame: CGRect(x: 90, y: 132, width: 180, height: 44))
        pxbs.keyboardType = .numberPad
        pxbs.placeholder = "请填写排序标识"
        pxbs.delegate = self
        let quxiao = UIButton(frame: CGRect(x: Width - 160, y: 170, width: 50, height: 30))
        quxiao.setTitle("取消", for: .normal)
        quxiao.setTitleColor(UIColor.orange, for: .normal)
        quxiao.addTarget(self, action: #selector(qu), for: .touchUpInside)
        let queding = UIButton(frame: CGRect(x: Width - 100, y: 170, width: 50, height: 30))
        queding.setTitle("确定", for: .normal)
        queding.setTitleColor(UIColor.orange, for: .normal)
        queding.addTarget(self, action: #selector(que), for: .touchUpInside)
        jie.addSubview(shangpinleixing)
        jie.addSubview(biaoshi)
        jie.addSubview(splb)
        jie.addSubview(pxbs)
        jie.addSubview(quxiao)
        jie.addSubview(queding)
        jie.addSubview(leibie)
        jie.isHidden = true
        self.view.addSubview(jie)
        banView.isHidden = true
    }
    @objc func qu() {
        jie.isHidden = true
        banView.isHidden = true
        self.view.endEditing(true)
    }
    @objc func que() {
        self.view.endEditing(true)
        //调接口
        let method = "/user/addProType"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"id":biaoshiID,"orderNo": pxbs.text!,"productType":splb.text!]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                self.biaoshiID = ""
                self.banView.isHidden = true
                self.jie.isHidden = true
                self.splb.text = ""
                self.pxbs.text = ""
                self.jiekou()
            }else {
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    //tableviewdelegate
    func tableDelegate() {
        tablesplx.delegate = self
        tablesplx.dataSource = self
        tablesplx.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leiBArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "leibie"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let leibieName:UILabel = cell.viewWithTag(700) as! UILabel
        let biaoshi:UILabel = cell.viewWithTag(701) as! UILabel
        leibieName.text = leiBArr[indexPath.row]["productTpyeName"] as? String
        biaoshi.text = leiBArr[indexPath.row]["orderNo"] as? String
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        splb.text = leiBArr[indexPath.row]["productTpyeName"] as? String
        pxbs.text = leiBArr[indexPath.row]["orderNo"] as? String
        biaoshiID = (leiBArr[indexPath.row]["id"] as? String)!
        leibie.text = "修改商品类型"
        banView.isHidden = false
        jie.isHidden = false
    }
    func youshangjiao()  {
        var item = UIBarButtonItem()
        
        item = UIBarButtonItem(title:"添加",style: .plain,target:self,action:#selector(YouActio))
        
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio() {
        //添加类别
        leibie.text = "添加商品类型"
        banView.isHidden = false
        jie.isHidden = false
    }
    //在这里修改删除按钮的文字
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "点击删除"
        
    }
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            
            let str:String = leiBArr[indexPath.row]["id"] as! String
            self.shanchujiekou(addressInfoId:str, huidiao: {(ss)in
                self.leiBArr.remove(at: indexPath.row)
                print(self.leiBArr.count)
                self.tablesplx!.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            })
        }
    }
    func shanchujiekou(addressInfoId:String,huidiao: @escaping(_ result: Any) -> ()) {
        
        let method = "/user/delProType"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId,"id":addressInfoId]
        XL_waringBox().warningBoxModeIndeterminate(message: "删除中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "删除成功", view: self.view)
                let ss = ""
                huidiao(ss)
            }else {
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
