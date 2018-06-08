//
//  XL_WDshoucang_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/31.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDshoucang_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var shoucangArr: [String] = []
    
    @IBOutlet weak var tableShoucang: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        shoucangArr = ["","",""]
        tableDelegate()
        // Do any additional setup after loading the view.
    }
    //MARK:tableViewDelagete
    func tableDelegate() {
        tableShoucang.delegate = self
        tableShoucang.dataSource = self
        tableShoucang.tableFooterView = UIView()
        tableShoucang.register(UITableViewCell.self, forCellReuseIdentifier: "wdshoucang")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoucangArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "wdshoucang"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        let imageview = UIImageView(frame: CGRect(x: 8, y: 8, width: Width/3 - 20, height: 96))
        imageview.image = UIImage(named: "广告页")
        let gongsiName = UILabel(frame: CGRect(x: Width/3 + 8, y: 10, width: Width*2/3 - 20, height: 24))
        gongsiName.text = "国云数据科技有限公司"
        gongsiName.font = UIFont.systemFont(ofSize: 19)
        let imageDizhi = UIImageView(frame: CGRect(x: Width/3 + 8, y: 48, width: 10, height: 16))
        imageDizhi.image = UIImage(named: "位置2")
        let imageDianhua = UIImageView(frame: CGRect(x: Width/3 + 8, y: 88, width: 10, height: 16))
        imageDianhua.image = UIImage(named: "电话")
        
        let DDZZ = UILabel(frame: CGRect(x: Width/3 + 24, y: 40, width: Width*2/3 - 40, height: 40))
        DDZZ.numberOfLines = 2
        DDZZ.font = UIFont.systemFont(ofSize: 15)
        DDZZ.textColor = UIColor(hexString: "6e6e6e")
        DDZZ.text = "黑龙江省哈尔滨市香坊区红旗大街178号"
        let DDHH = UILabel(frame: CGRect(x: Width/3 + 24, y: 84, width: Width*2/3 - 40, height: 24))
        DDHH.font = UIFont.systemFont(ofSize: 15)
        DDHH.textColor = UIColor(hexString: "6e6e6e")
        let phoneNum = "15545457012"
        DDHH.text = "+86\(phoneNum)"
        
        cell.contentView.addSubview(imageview)
        cell.contentView.addSubview(gongsiName)
        cell.contentView.addSubview(imageDizhi)
        cell.contentView.addSubview(imageDianhua)
        cell.contentView.addSubview(DDZZ)
        cell.contentView.addSubview(DDHH)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DPLiebiao: XL_DPliebiaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpliebiao") as? XL_DPliebiaoViewController
        
        self.navigationController?.pushViewController(DPLiebiao!, animated: true)
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
