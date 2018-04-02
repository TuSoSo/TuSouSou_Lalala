//
//  XL_Dizhibu_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/19.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_Dizhibu_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var biaoti: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    typealias Xuanzhibody = ([String:String]) -> ()
    var xuanzhiBody: Xuanzhibody?
    
    override func viewWillAppear(_ animated: Bool) {
        //刷新界面
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let biaotiArr = ["1":"寄件人地址簿","2":"取件人地址簿","3":"收件人地址簿"]
        self.title = biaotiArr[biaoti!]
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(tiaoye))
        self.navigationItem.rightBarButtonItem = item
        Delegate()
    }
    @objc func tiaoye() {
        let tianjiadizhi: XL_dizhi_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhi") as! XL_dizhi_ViewController
        switch biaoti {
        case "1":
            tianjiadizhi.Shei = "jijian"
        case "2":
            tianjiadizhi.Shei = "qujian"
        case "3":
            tianjiadizhi.Shei = "shoujian"
        default:
            break
        }
        self.navigationController?.pushViewController(tianjiadizhi, animated: true)
    }
    func Delegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
        //删除多余行
        tableView.tableFooterView = UIView()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "dizhibu"
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let touimage: UIImageView = cell.viewWithTag(131) as! UIImageView
        let nameString:UILabel = cell.viewWithTag(132) as! UILabel
        let phoneString:UILabel = cell.viewWithTag(133) as! UILabel
        let dizhiString:UILabel = cell.viewWithTag(134) as! UILabel
        
        nameString.text = "Name"
        phoneString.text = "+861211211234567"
        dizhiString.text = "我家住在黄土高坡"
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = ["name":"地址斌","phone":"12345678910","dizhi":"大河向西流"]
        
        if let block = self.xuanzhiBody {
            block(dic)
        }
        self.navigationController?.popViewController(animated: true)
        
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
