//
//  XL_WDdingdanViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/28.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDdingdanViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var state: String?
    
    var DDArr: [String] = []
    
    typealias DDjine = (String) -> ()
    var Dingdanblock: DDjine?
    func dingdan(block: DDjine?) {
        self.Dingdanblock = block
    }
    @IBOutlet weak var tableWDdingdan: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableDelegate()
        DDArr = ["","",""]
        self.title = "我的订单"
        // Do any additional setup after loading the view.
    }
    func tableDelegate()  {
        tableWDdingdan.delegate = self
        tableWDdingdan.dataSource = self
        tableWDdingdan.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DDArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "wodedingdan"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        
        let tou: UILabel = cell.viewWithTag(640) as! UILabel
        let imageSHA: UIImageView = cell.viewWithTag(641) as! UIImageView
        let imageXIA: UIImageView = cell.viewWithTag(642) as! UIImageView
        let nameSHA: UILabel = cell.viewWithTag(643) as! UILabel
        let phoneSHA: UILabel = cell.viewWithTag(644) as! UILabel
        let nameXIA: UILabel = cell.viewWithTag(645) as! UILabel
        let phoneXIA: UILabel = cell.viewWithTag(646) as! UILabel
        let state: UILabel = cell.viewWithTag(647) as! UILabel
        let Jine: UILabel = cell.viewWithTag(648) as! UILabel
        
        
        tou.text = "商品订单"
        imageSHA.image = UIImage(named: "ji")
        imageXIA.image = UIImage(named: "shou")
        nameSHA.text = "上边的名字 + 地址"
        nameXIA.text = "下边的名字 + 地址"
        phoneSHA.text = "上边的电话就是这个"
        phoneXIA.text = "下边的电话到底是哪个"
        state.text = "完成"
        Jine.text = "¥ 1.23"
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if state == "1"{
            let wwddxq: XL_WDDDXQ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdddxq") as? XL_WDDDXQ_ViewController
            self.navigationController?.pushViewController(wwddxq!, animated: true)
        }else if state == "2"{
            if let block = self.Dingdanblock {
                block("26.8")
            }
            
            self.navigationController?.popViewController(animated: true)
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
