//
//  XL_GeRenViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/25.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_GeRenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var touxiang: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
   
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var tablegeren: UITableView!
    @IBOutlet weak var xiaoxi_tupian: UIImageView!
    
    let touarr = ["我的1","我的2","我的3","我的4","我的5","我的6"]
    let namearr = ["我的钱包","我的地址","我的客服","我的店铺","邀请好友","设置"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        tableDelegate()

//        sendWXFX(inScene: WXSceneTimeline)
//        sendWXFX(inScene: WXSceneSession)
    }
    
    //inScene可选的值有三个：WXSceneTimeline（朋友圈）、WXSceneSession（聊天界面） 、WXSceneFavorite（收藏）
    
    //分享文本
    func sendWXFX(inScene: WXScene){
        let webpage = WXWebpageObject()
        webpage.webpageUrl = "www.baidu.com"
        let msg = WXMediaMessage()
        msg.mediaObject = webpage
        msg.title = "欢迎注册使用飕飕网递"
        msg.description = "飕飕网递应用分享"
//      msg.setThumbImage(UIImage(named: "引导1")) msg.setThumbImage(Data.sharedManager.searchArticle.imagedic[content.contentImg])
        let req = SendMessageToWXReq()
        req.message = msg
        req.scene = Int32(inScene.rawValue)
        WXApi.send(req)
        
    }
    
    @IBAction func GRziliao(_ sender: Any) {
        let GRziliao: XL_GRziliaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grziliao") as? XL_GRziliaoViewController
        self.navigationController?.pushViewController(GRziliao!, animated: true)
    }
    @IBAction func shoucang(_ sender: Any) {
    }
    
    @IBAction func dingdan(_ sender: Any) {
        let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
        self.navigationController?.pushViewController(WDDD!, animated: true)
        
    }
    
    @IBAction func xiaoxi(_ sender: Any) {
    }
    
    func tableDelegate() {
        tablegeren.delegate = self
        tablegeren.dataSource = self
        //删除多余行
        tablegeren.tableFooterView = UIView()
        tablegeren.isScrollEnabled = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "geren"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let touimage: UIImageView = cell.viewWithTag(141) as! UIImageView
        let nameString:UILabel = cell.viewWithTag(142) as! UILabel
        
        touimage.image = UIImage(named: "\(touarr[indexPath.row])")
        nameString.text = "\(namearr[indexPath.row])"
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
