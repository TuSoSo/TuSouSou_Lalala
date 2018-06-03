//
//  XL_YiYaohaoyou_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_YiYaohaoyou_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    var Arr:[String] = []

    @IBOutlet weak var tableyiyaoqing: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DelegateTable()
        self.title = "已邀请好友"
        Arr = ["","","",""]
        // Do any additional setup after loading the view.
    }
    //MARK:tableviewDelegate
    func DelegateTable() {
        tableyiyaoqing.delegate = self
        tableyiyaoqing.dataSource = self
        tableyiyaoqing.tableFooterView = UIView()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Arr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "yiyaoqing"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        let nameLabel:UILabel = cell.viewWithTag(590) as! UILabel
        let dianhuaLabel:UILabel = cell.viewWithTag(591) as! UILabel
        let shijianLabel:UILabel = cell.viewWithTag(592) as! UILabel
        nameLabel.text = "张无忌"
        dianhuaLabel.text = "188****7878"
        shijianLabel.text = "2018-05-08 16:43"
        
        cell.selectionStyle = .none
        return cell
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
