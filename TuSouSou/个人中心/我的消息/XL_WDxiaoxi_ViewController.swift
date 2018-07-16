//
//  XL_WDxiaoxi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/1.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDxiaoxi_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    let dark_images: [String] = ["notice_dingdan_dark","notice_gonggao_dark","notice_xitong_dark"]
    let light_images: [String] = ["notice_dingdan_light","notice_gonggao_light","notice_xitong_light"]
    let names: [String] = ["订单通知","公告通知","系统通知"]
    //接收三个判断是否有新消息的字断
    var arr3ziduan: [String] = []
    
    @IBOutlet weak var tablexiao3hang: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "消息中心"
        
        DelegateTable()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        arr3ziduan = ["1","1","1"]
        if (nil != userDefaults.value(forKey: "dingtui")&&userDefaults.value(forKey: "dingtui")as!String=="1") {
            arr3ziduan[0] = "2"
        }else if (nil != userDefaults.value(forKey: "gongtui")&&userDefaults.value(forKey: "gongtui")as!String=="1"){
            arr3ziduan[1] = "2"
        } else if (nil != userDefaults.value(forKey: "xitui")&&userDefaults.value(forKey: "xitui")as!String=="1") {
            arr3ziduan[2] = "2"
        }
    }
    //MARK:tabledelegate
    func DelegateTable() {
        tablexiao3hang.delegate = self
        tablexiao3hang.dataSource = self
        tablexiao3hang.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "xiao3hang"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let touimage: UIImageView = cell.viewWithTag(222) as! UIImageView
        let nameString:UILabel = cell.viewWithTag(223) as! UILabel
        if arr3ziduan[indexPath.row] == "1" {
            //没有新消息
            touimage.image = UIImage(named: "\(dark_images[indexPath.row])")
        }else{
            touimage.image = UIImage(named: "\(light_images[indexPath.row])")
        }
        
        nameString.text = "\(names[indexPath.row])"
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let WDXXLB: XL_WDXXLB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdxxlb") as? XL_WDXXLB_ViewController
        WDXXLB?.index = indexPath.row
        self.navigationController?.pushViewController(WDXXLB!, animated: true)
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
