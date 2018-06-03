//
//  XL_WDshezhi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDshezhi_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let zuoArr: [String] = ["推送设置","意见反馈","关于我们","申请商户入驻","申请成为配送员"]
    
    @IBOutlet weak var tableshezhi: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        DelegateTable()
        // Do any additional setup after loading the view.
    }
    //MARK:Delegate TableView
    func DelegateTable() {
        tableshezhi.delegate = self
        tableshezhi.dataSource = self
        tableshezhi.tableFooterView = UIView()
        tableshezhi.register(UITableViewCell.self, forCellReuseIdentifier: "shezhi")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 120
        }
        return 64
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "shezhi"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.row == 5 {
            //      按钮
            //确认按钮
            let button = UIButton(frame: CGRect(x: 20, y: 48, width: Width - 40, height: 64))
            button.setBackgroundImage(UIImage(named: "立即签到背景"), for: .normal)
            button.setTitle("退出登录", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(tuichu), for: .touchUpInside)
            //            button.isUserInteractionEnabled = true
            //去掉当前cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            cell.backgroundColor = UIColor(hexString: "f0eff5")
            cell.contentView.addSubview(button)
        }else{
            let zuoLable  = UILabel(frame: CGRect(x: 16, y: 17, width: 150, height: 30))
            zuoLable.font = UIFont.systemFont(ofSize: 15)
            zuoLable.textColor = UIColor.darkGray
            zuoLable.text = zuoArr[indexPath.row]
            cell.contentView.addSubview(zuoLable)
            if indexPath.row != 0 {
                cell.accessoryType = .disclosureIndicator
                let Isrenzheng = UILabel(frame: CGRect(x: Width - 100, y: 17, width: 64, height: 30))
                Isrenzheng.font = UIFont.systemFont(ofSize: 15)
                Isrenzheng.textColor = UIColor.darkGray
                Isrenzheng.textAlignment = .right
                if indexPath.row == 3 {
                    //是否认证
                    Isrenzheng.text = "未认证"
                    cell.contentView.addSubview(Isrenzheng)
                }else if indexPath.row == 4 {
                    //是否认证
                    Isrenzheng.text = "未认证"
                    cell.contentView.addSubview(Isrenzheng)
                }
            }else {
                //uiswichButton
                
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    @objc func tuichu() {
        
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
