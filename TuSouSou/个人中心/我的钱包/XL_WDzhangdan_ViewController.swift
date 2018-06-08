//
//  XL_WDzhangdan_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDzhangdan_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    var zhangArr:[String] = []
    
    @IBOutlet weak var tablezhangdan: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        zhangArr = ["","",""]
        self.title = "账单列表"
        Delegate()
        youAnniu()
        // Do any additional setup after loading the view.
    }
    //MARK:tableviewDelegate
    func Delegate() {
        tablezhangdan.delegate = self
        tablezhangdan.dataSource = self
        tablezhangdan.tableFooterView = UIView()
        tablezhangdan.register(UITableViewCell.self, forCellReuseIdentifier: "zhangdan")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zhangArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "zhangdan"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }//明细背景1
        let imView = UIImageView(frame: CGRect(x: 0, y: 0, width: Width, height: 96))
        
        imView.image = UIImage(named: "明细背景1")
        let shangLable = UILabel(frame: CGRect(x: 48, y: 24, width: 80, height: 30))
        shangLable.text = "充值"
        shangLable.font = UIFont.systemFont(ofSize: 15)
        let xiaLable = UILabel(frame: CGRect(x: 48, y: 64, width: 120, height: 21))
        xiaLable.textColor = UIColor.darkGray
        xiaLable.font = UIFont.systemFont(ofSize: 14)
        xiaLable.text = "2018-03-14 22:38"
        let youLable = UILabel(frame: CGRect(x: Width - 150, y: 32, width: 130, height: 32))
        youLable.textAlignment = .right
        youLable.textColor = UIColor.orange
        youLable.text = "+ 100.00"
        cell.contentView.addSubview(imView)
        cell.contentView.addSubview(shangLable)
        cell.contentView.addSubview(xiaLable)
        cell.contentView.addSubview(youLable)
        
        
        
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func youAnniu() {
        let item = UIBarButtonItem(title:"开发票",style: .plain,target:self,action:#selector(YouActio))
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio()  {
        let WDXX: XL_kaifapiao_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kaifapiao") as? XL_kaifapiao_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
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
