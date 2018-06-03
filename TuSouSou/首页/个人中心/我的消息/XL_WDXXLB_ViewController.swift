//
//  XL_WDXXLB_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/1.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDXXLB_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let TZName: [String] = ["订单通知","公告通知","系统通知"]
    var index: Int?    
    var XXArr:[String] = []
    
    @IBOutlet weak var tablewdxxlb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = TZName[index!]
        XXArr = ["","",""]
        tableDelegate()
        // Do any additional setup after loading the view.
    }
    //MARK:tableviewdelegate
    func tableDelegate() {
        tablewdxxlb.delegate = self
        tablewdxxlb.dataSource = self
        tablewdxxlb.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return XXArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "xxlb"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let titleLabel:UILabel = cell.viewWithTag(225) as! UILabel
        let shijianLabel:UILabel = cell.viewWithTag(226) as! UILabel
       
        titleLabel.text = "【飕飕网递】 提醒您，订单已完成。"
        shijianLabel.text = "2018-05-08 16:43"
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let WDXXXQ: XL_WDXXXQ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdxxxq") as? XL_WDXXXQ_ViewController
        self.navigationController?.pushViewController(WDXXXQ!, animated: true)
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
