//
//  XL_WDDDXQ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/31.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDDDXQ_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,RatingBarDelegate {
    var leixing:String?
    var dingdanId:String?
    
    @IBOutlet weak var tablewdddxq: UITableView!
    var SPDic:[String:Any] = [:]
    var shuzu:[[String:Any]] = []
    
    //评分
    var ratingBar1: WNRatingBar!
    var ratingLabel1:UILabel!
    var ratingLabel2:UILabel!
    var ratingLabel3:UILabel!
    var ratingValue:Float = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        print("\n\(leixing!)\n\(dingdanId!)")
        jiemianjiekou()
        tableviewdelegate()
        // Do any additional setup after loading the view.
    }
    func jiemianjiekou() {
        let method = "/order/orderDetail"
//        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["orderId":dingdanId!]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
//                XL_waringBox().warningBoxModeText(message: "评价成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.SPDic = dic
                if nil != dic["productList"]{
                    self.shuzu = dic["productList"] as! [[String:Any]]
                }
                self.tablewdddxq.reloadData()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    //MARK:tableViewDelegate
    func tableviewdelegate() {
        tablewdddxq.delegate = self
        tablewdddxq.dataSource = self
        tablewdddxq.tableFooterView = UIView()
        tablewdddxq.register(UITableViewCell.self, forCellReuseIdentifier: "wdddxq")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if leixing! == "6"{
            return 3
        }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return shuzu.count
        }else{
            return 4
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 4 {
                return 64
            }else{
                return 44
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 3 {
                return 80
            }else{
                return 56
            }
        }else{
            return 80
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 5))
        vi.backgroundColor = UIColor(hexString: "f0eff5")
        return vi
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "wdddxq"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.section == 0 {
            let zuolabel = UILabel(frame: CGRect(x: 16, y: 11, width: 80, height: 22))
            zuolabel.font = UIFont.systemFont(ofSize: 15)
            zuolabel.textColor = UIColor.darkGray
            let youlabel = UILabel(frame: CGRect(x: 112, y: 11, width: Width - 132, height: 22))
            youlabel.font = UIFont.systemFont(ofSize: 15)
            youlabel.textColor = UIColor.darkGray
            youlabel.textAlignment = .right
            if indexPath.row == 0 {
                zuolabel.text = "下单时间"
                youlabel.text = ""
                if !SPDic.isEmpty{
                    youlabel.text = SPDic["placeOrderTime"] as? String
                }
                cell.contentView.addSubview(zuolabel)
                cell.contentView.addSubview(youlabel)
            }else if indexPath.row == 1 {
                zuolabel.text = "配送员"
                youlabel.text = ""
                if !SPDic.isEmpty{
                    youlabel.text = SPDic["sendUserName"] as? String
                }
                cell.contentView.addSubview(zuolabel)
                cell.contentView.addSubview(youlabel)
            }else if indexPath.row == 2 {
                zuolabel.text = "联系电话"
                youlabel.text = ""
                if !SPDic.isEmpty{
                    youlabel.text = SPDic["sendUserPhone"] as? String
                }
                cell.contentView.addSubview(zuolabel)
                cell.contentView.addSubview(youlabel)
            }else if indexPath.row == 3 {
                zuolabel.text = "位置信息"
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(zuolabel)
            }else if indexPath.row == 4 {
                zuolabel.frame = CGRect(x: 16, y: 19, width: 80, height: 22 )
                zuolabel.text = "配送地址"
                youlabel.frame = CGRect(x: 112, y: 8, width: Width - 122, height: 44)
                youlabel.textAlignment = .left
                youlabel.text = ""
                if !SPDic.isEmpty{
                    youlabel.text = SPDic["edSendUserAddress"] as? String
                }
                youlabel.numberOfLines = 2
                cell.contentView.addSubview(zuolabel)
                cell.contentView.addSubview(youlabel)
            }
        }else if indexPath.section == 1{
            let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 80, height: 64))
            
            var jiee = ""
            if nil != shuzu[indexPath.row]["picture"]{
                jiee = shuzu[indexPath.row]["picture"] as! String
            }
            let uul = URL(string: TupianUrl + jiee)
            imageView.sd_setImage(with: uul, placeholderImage: UIImage(named: "广告页"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            let name = UILabel(frame: CGRect(x: 96, y: 16, width: Width - 142, height: 24))
            name.font = UIFont.systemFont(ofSize: 15)
            name.textColor = UIColor.darkGray
            if nil != shuzu[indexPath.row]["productName"] {
                name.text = shuzu[indexPath.row]["productName"] as! String
                if nil != shuzu[indexPath.row]["productSpec"]{
                    name.text = (shuzu[indexPath.row]["productName"] as! String) + (shuzu[indexPath.row]["productSpec"] as! String)
                }
            }
            let jiaqian = UILabel(frame: CGRect(x: 100, y: 36, width: Width - 142, height: 40))
            jiaqian.font = UIFont.systemFont(ofSize: 18)
            jiaqian.textColor = UIColor.orange
            jiaqian.numberOfLines = 2
            jiaqian.text = "¥ " + String(format: "%.2f",(shuzu[indexPath.row]["amount"] as? Float)! )
            let shuliang = UILabel(frame: CGRect(x: Width - 48, y: 50, width: 40, height: 30))
            shuliang.font = UIFont.systemFont(ofSize: 14)
            shuliang.text = "x " + (shuzu[indexPath.row]["productNum"] as? String)!
            cell.contentView.addSubview(shuliang)
            cell.contentView.addSubview(imageView)
            cell.contentView.addSubview(jiaqian)
            cell.contentView.addSubview(name)
        }
            //评价
        else if indexPath.section == 2 {
            if indexPath.row == 3 {
                let PJbutton = UIButton(frame: CGRect(x: 40, y: 18, width: Width - 80, height: 44))
                PJbutton.setImage(UIImage(named: ""), for: .normal)
                PJbutton.isUserInteractionEnabled = true
                PJbutton.addTarget(self, action: #selector(PJjiekou), for: .touchUpInside)
                cell.contentView.addSubview(PJbutton)
                cell.backgroundColor = UIColor(hexString: "f0eff5")
            }else{
                let zz = UILabel(frame: CGRect(x: 16, y: 11, width: 80, height: 34))
                zz.font = UIFont.systemFont(ofSize: 15)
                zz.textColor = UIColor.darkGray
                
                ratingBar1 = WNRatingBar()
                ratingBar1.frame = CGRect(x: Width - 152, y: 8, width: 100, height: 40)
                ratingBar1.setSeletedState("star_big1", halfSelectedName: "star_big2", fullSelectedName: "star_big3", starSideLength: 28, delegate: self)
                ratingBar1.tag = indexPath.row
                var fenshu: Float! = 10
                
                
                ratingBar1.isIndicator = false
                if indexPath.row == 0 {
                    fenshu = SPDic["evalSpeed"] as! Float
                }else if indexPath.row == 1 {
                    fenshu = SPDic["evalServer"] as! Float
                }else if indexPath.row == 2 {
                    fenshu = SPDic["evalClear"] as! Float
                }
               
                if indexPath.row == 0{
                    zz.text = "配送速度"
                    ratingBar1.displayRating(fenshu)
                    cell.contentView.addSubview(ratingBar1)
                    cell.contentView.addSubview(zz)
                }else if indexPath.row == 1 {
                    zz.text = "服务态度"
                    ratingBar1.displayRating(fenshu)
                    cell.contentView.addSubview(ratingBar1)
                    cell.contentView.addSubview(zz)
                }else if indexPath.row == 2 {
                    zz.text = "衣着整洁"
                    ratingBar1.displayRating(fenshu)
                    cell.contentView.addSubview(ratingBar1)
                    cell.contentView.addSubview(zz)
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                //打电话
                let dianPhone = "15545457012"
                UIApplication.shared.openURL(NSURL.init(string: "tel://\(dianPhone)")! as URL)
            }else if indexPath.row == 3 {
                //跳转到 位置信息 -- WEB页
                
            }
        }
    }
    func ratingChanged(_ ratingBar: WNRatingBar, newRating: Float) {
        if(ratingBar.tag == 0){
            ratingValue = newRating
            print("速度" + "\n\(ratingValue)")
        }else if ratingBar.tag == 1 {
            ratingValue = newRating
            print("态度" + "\n\(ratingValue)")
        }else if ratingBar.tag == 2 {
            ratingValue = newRating
            print("衣着" + "\n\(ratingValue)")
        }
    }
    @objc func PJjiekou() {
        print("评价接口")
        pingjiajiekou()
    }
    func pingjiajiekou() {
        let method = "/user/evaluate"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"userType":"1","orderId":"","edUserId":"","evalClea":"","evalSpeed":"","evalServer":""]
        XL_waringBox().warningBoxModeIndeterminate(message: "评价中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "评价成功", view: self.view)
//                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
//                self.DDArr = dic["orderList"] as! [[String : Any]]
//                self.tableWDdingdan.reloadData()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
}
