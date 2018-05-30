//
//  XL_DPliebiaoViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/7.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
//店铺列表
class XL_DPliebiaoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var DPicon: UIImageView!
     
    @IBOutlet weak var DPdizhi: UILabel!
    
    @IBOutlet weak var DPdianhua: UILabel!
    
    @IBOutlet weak var YYshijian: UILabel!
    
    @IBOutlet weak var tableZhonglei: UITableView!
    
    @IBOutlet weak var tableShangpin: UITableView!
    let HJjine = "0.00"
    let ArrZhonglei = ["啤酒","饮料","矿泉水","黯然销魂饭","瓜子"]
    override func viewWillAppear(_ animated: Bool) {
        TBDelgate()
        let selIndex = NSIndexPath(row: 0, section: 0)
        tableZhonglei.selectRow(at: selIndex as IndexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "商铺的名称"
        DDView()
        let dic: Dictionary = ["":""]
        Viewinit(dic: dic)
//        tableShangpin.isHidden = true
//        tableZhonglei.isHidden = true
        
    }

    func Viewinit(dic: Dictionary<String , Any>)  {
        DPicon.image = UIImage(named: "广告页")
        DPdizhi.text = "黑龙江省哈尔滨市南岗区红旗大街178号305室"
        DPdizhi.adjustsFontSizeToFitWidth = true
        DPdianhua.text = "1554545XXXX"
        YYshijian.text = "6:00 - 22:00"
        
    }
    func DDView() {
        let ddView = UIView()
        if UIDevice.current.isX() {
            ddView.frame = CGRect(x: 0, y: Height - 150, width: Width, height: 60)
        }else{
            ddView.frame = CGRect(x: 0, y: Height - 120, width: Width, height: 60)
        }
//        ddView.backgroundColor = UIColor.blue
        let hengxian = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 1))
        hengxian.backgroundColor = UIColor(hexString: "f2f2f2")
        let Label = UILabel(frame: CGRect(x: 8, y: 15, width: 40, height: 30))
        Label.font = UIFont.systemFont(ofSize: 15)
        Label.text = "合计:"
        let JE = UILabel(frame: CGRect(x: 56, y: 12, width: 150, height: 36))
        JE.text = "¥\(HJjine)"
        JE.textColor = UIColor.orange
        let XiaDanButton = UIButton(frame: CGRect(x: 2/3 * Width - 20, y: 5, width: Width/3, height: 46))
        XiaDanButton.addTarget(self, action: #selector(XDaction), for: .touchUpInside)
        XiaDanButton.setTitle("立即下单", for: .normal)
        XiaDanButton.tintColor = UIColor.white
        XiaDanButton.backgroundColor = UIColor.orange
        ddView.addSubview(hengxian)
        ddView.addSubview(Label)
        ddView.addSubview(JE)
        ddView.addSubview(XiaDanButton)
        self.view.addSubview(ddView)
        
        
    }
    @objc func XDaction() {
        //跳页
        let DP: XL_SPxiadanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spxiadan") as? XL_SPxiadanViewController
        
        self.navigationController?.pushViewController(DP!, animated: true)
    }
    //MARK:tableviewdelegate
    func TBDelgate() {
        tableZhonglei.delegate = self
        tableShangpin.delegate = self
        tableShangpin.dataSource = self
        tableZhonglei.dataSource = self
        tableZhonglei.register(UITableViewCell.self, forCellReuseIdentifier: "zhonglei")
        tableShangpin.register(UITableViewCell.self, forCellReuseIdentifier: "shangpin")
        tableShangpin.tableFooterView = UIView()
        tableZhonglei.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableShangpin {
            return 10
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableZhonglei {
            return 44
        }else{
            return 120
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellString = ""
        if tableView == tableZhonglei {
            cellString = "zhonglei"
        }else{
            cellString = "shangpin"
        }
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.subviews {
            v.removeFromSuperview()
        }
        if tableView == tableZhonglei {
            let zhonglei = UILabel(frame: CGRect(x: 8, y: 0, width: 56, height: 44))
            zhonglei.text = ArrZhonglei[indexPath.row]
            zhonglei.textAlignment = NSTextAlignment.center
            zhonglei.font = UIFont.systemFont(ofSize: 14)
            zhonglei.numberOfLines = 2
            zhonglei.textColor = UIColor.black
            zhonglei.highlightedTextColor = UIColor.orange
            zhonglei.tag = 1200 + indexPath.row
            if 1200 == zhonglei.tag {
                zhonglei.textColor = UIColor.orange
            }
            let shuxian = UIView(frame: CGRect(x: 71, y: 4, width: 1, height: 36))
            shuxian.backgroundColor = UIColor.clear
            shuxian.tag = 1300 + indexPath.row
            if 1300 == shuxian.tag {
                shuxian.backgroundColor = UIColor.orange
            }
            cell.addSubview(zhonglei)
            cell.addSubview(shuxian)
        }else{
            let imageView = UIImageView(frame: CGRect(x: 8, y: 12, width: 56, height: 56))
            imageView.image = UIImage(named: "广告页")
            let SPName = UILabel(frame: CGRect(x: 72, y: 8, width: Width - 72 - 72 - 8, height: 30))
            SPName.font = UIFont.systemFont(ofSize: 15)
            SPName.textColor = UIColor(hexString: "393939")
            SPName.text = "芝华士威士忌洋酒/250ml"
            let danjia = UILabel(frame: CGRect(x: 72, y: 50, width: Width - 152, height: 30))
            danjia.text = "¥100"
            danjia.textColor = UIColor.orange
            let imageJian = UIImageView(frame: CGRect(x: Width - 170 - 22, y: 78, width: 30, height: 30))
            imageJian.image = UIImage(named: "数量减")
            let imageAdd = UIImageView(frame: CGRect(x: Width - 50 - 72, y: 78, width: 30, height: 30))
            imageAdd.image = UIImage(named: "数量加")
            let shuzi = UITextField(frame: CGRect(x: Width - 135 - 22, y: 78, width: 40, height: 30))
            shuzi.textAlignment = NSTextAlignment.center
            shuzi.keyboardType = UIKeyboardType.decimalPad
            shuzi.text = "0"
            shuzi.delegate = self
            cell.addSubview(imageView)
            cell.addSubview(SPName)
            cell.addSubview(danjia)
            cell.addSubview(imageJian)
            cell.addSubview(shuzi)
            cell.addSubview(imageAdd)

        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableShangpin {
           //没有点击事件
            
        }else{
            let selIndex = NSIndexPath(row: 0, section: 0)
            let lala = tableZhonglei.cellForRow(at: selIndex as IndexPath)
            let zzz = lala?.viewWithTag(1200) as! UILabel
            zzz.textColor = UIColor.black
            let xxx = lala?.viewWithTag(1300)
            xxx?.backgroundColor = UIColor.clear
            
            let cell = tableZhonglei.cellForRow(at: indexPath)
            let zhonglei: UILabel = cell?.viewWithTag(1200 + indexPath.row) as! UILabel
            let shuxian = cell?.viewWithTag(1300 + indexPath.row)
            zhonglei.textColor = UIColor.orange
            shuxian?.backgroundColor = UIColor.orange
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == tableZhonglei {
            let cell = tableZhonglei.cellForRow(at: indexPath)
            let zhonglei: UILabel = cell?.viewWithTag(1200 + indexPath.row) as! UILabel
            let shuxian = cell?.viewWithTag(1300 + indexPath.row)
            zhonglei.textColor = UIColor.black
            shuxian?.backgroundColor = UIColor.clear
        }
    }
    //MARK: UITextFieldDelegate
    //最多三位数
    //判断是哪个cell
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreate d.
    }

}
