//
//  XL_SPK_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_SPK_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK:block反向传值
    typealias productId = (String) -> ()
    var ProductBlock: productId?
    func productblock(block: productId?) {
        self.ProductBlock = block
    }
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    var tpye = "1" // 1 左 2 右
    var DDArr:[[String:Any]] = []
    
    @IBOutlet weak var tablespk: UITableView!
    @IBOutlet weak var youView: UIView!
    @IBOutlet weak var zuoView: UIView!
    @IBOutlet weak var chushoubutton: UIButton!
    @IBOutlet weak var cangkubutton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商品库"
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tablespk.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tablespk.mj_footer = footer
        tableDelegate()
        
        cangkubutton.isSelected = false
        chushoubutton.isSelected = true
        youView.backgroundColor = UIColor.white
        zuoView.backgroundColor = UIColor.orange
        jiekou(index: tpye)
        // Do any additional setup after loading the view.
    }
    
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        DDArr = []
        jiekou(index: tpye)
        tablespk.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            tablespk.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            jiekou(index: tpye)
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    func jiekou(index:String) {
        let method = "/user/salePro"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"productState":index,"pageNo":pageNo,"pageSize":pageSize]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                //                XL_waringBox().warningBoxModeText(message: "加载成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.DDArr += dic["productInfoList"] as! [[String : Any]]
                self.count = dic["count"] as! Int
                self.tablespk.reloadData()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func tableDelegate()  {
        tablespk.delegate = self
        tablespk.dataSource = self
        tablespk.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DDArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "spkcell"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        
        let tupian: UIImageView = cell.viewWithTag(1000) as! UIImageView
        let name: UILabel = cell.viewWithTag(1001) as! UILabel
        let leibie: UILabel = cell.viewWithTag(1002) as! UILabel
        let jiaqian: UILabel = cell.viewWithTag(1003) as! UILabel
        let shuliang: UILabel = cell.viewWithTag(1004) as! UILabel
        let xiugai: UILabel = cell.viewWithTag(1005) as! UILabel
        let shXjia: UILabel = cell.viewWithTag(1006) as! UILabel
        if tpye == "2" {
            shXjia.text = "上架"
        }else{
            shXjia.text = "下架"
        }
        let top0 = UITapGestureRecognizer(target: self, action: #selector(xiugai(sender:)))
        xiugai.isUserInteractionEnabled = true
        xiugai.addGestureRecognizer(top0)
        let top1 = UITapGestureRecognizer(target: self, action: #selector(shangxiajia(sender:)))
        shXjia.isUserInteractionEnabled = true
        shXjia.addGestureRecognizer(top1)
        
        var jiee:String = ""
        if DDArr.count != 0{
            if nil != DDArr[indexPath.row]["picture"]{
                jiee = DDArr[indexPath.row]["picture"] as! String
            }
        }
        let newstring = TupianUrl + jiee
        
        let uul = URL(string: String(format: "%@",newstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
        tupian.sd_setImage(with: uul, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
        name.text = ""
        if DDArr.count != 0 {
            name.text = DDArr[indexPath.row]["productName"] as? String
        }
        leibie.text = ""
        if DDArr.count != 0 {
            leibie.text = DDArr[indexPath.row]["productTypeName"] as? String
        }
        jiaqian.text = "¥"
        if DDArr.count != 0 {
            jiaqian.text = String(format: "¥ %@",(DDArr[indexPath.row]["productPrice"] as? String)!)
        }
        shuliang.text = "x 0.00"
        if DDArr.count != 0 {
            shuliang.text = String(format: "x %@",(DDArr[indexPath.row]["productNum"] as? String)!)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    //在这里修改删除按钮的文字
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "点击删除"
        
    }
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            let str:String = DDArr[indexPath.row]["id"] as! String
            self.shanchujiekou(addressInfoId:str, huidiao: {(ss)in
                self.DDArr.remove(at: indexPath.row)
                print(self.DDArr.count)
                self.tablespk!.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            })
        }
    }
    func shanchujiekou(addressInfoId:String,huidiao: @escaping(_ result: Any) -> ()) {
        
        let method = "/user/removePro"
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
    @objc func xiugai(sender:UIGestureRecognizer) {
        let location = sender.location(in: tablespk)
        let indexPath = tablespk.indexPathForRow(at: location)
        let id:String = DDArr[(indexPath?.row)!]["id"] as! String
        //把产品Id传会给上一页
         if let block = self.ProductBlock {
               block(id)
         }
         self.navigationController?.popViewController(animated: true)
        
    }
    @objc func shangxiajia(sender:UIGestureRecognizer) {
        let location = sender.location(in: tablespk)
        let indexPath = tablespk.indexPathForRow(at: location)
        //上架下架接口
        let id:String = DDArr[(indexPath?.row)!]["id"] as! String
        shangxiajia(ss: id)
    }
    func shangxiajia(ss:String) {
        let method = "/user/commodityUpAndDown"
        let userId = userDefaults.value(forKey: "userId")
        var arr:[String] = []
        arr.append(ss)
        var isShelf = ""
        if tpye == "1" {
            isShelf = "2"
        }else{
            isShelf = "1"
        }
        let dic:[String:Any] = ["userId":userId!,"isShelf":isShelf,"array":arr]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                //                XL_waringBox().warningBoxModeText(message: "加载成功", view: self.view)
                self.DDArr = []
                self.jiekou(index: self.tpye)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    @IBAction func cangku(_ sender: Any) {
        if cangkubutton.isSelected != true {
            DDArr = []
            tpye = "2"
            chushoubutton.isSelected = false
            cangkubutton.isSelected = true
            zuoView.backgroundColor = UIColor.white
            youView.backgroundColor = UIColor.orange
            jiekou(index: tpye)
        }
    }
    @IBAction func chushou(_ sender: Any) {
        if chushoubutton.isSelected != true {
            DDArr = []
            tpye = "1"
            cangkubutton.isSelected = false
            chushoubutton.isSelected = true
            youView.backgroundColor = UIColor.white
            zuoView.backgroundColor = UIColor.orange
            jiekou(index: tpye)
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
