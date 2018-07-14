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
    
    var lll:String?
    var ttt:String?
    var zuoIndex = 0
    
    var shuzi:UITextField = UITextField()
    
    var isOrder = 0 //是否可下单
    var isCollect = 0 // 是否可收藏
    
    var classifyList: [[String:Any]] = []
    var productInfoList: [[String:Any]] = []
    var JE = UILabel()
    var dianputupian: URL?
    var picture = ""
    
    @IBOutlet weak var DPicon: UIImageView!
    
    @IBOutlet weak var DPdizhi: UILabel!
    
    @IBOutlet weak var DPdianhua: UILabel!
    
    @IBOutlet weak var YYshijian: UILabel!
    
    @IBOutlet weak var tableZhonglei: UITableView!
    
    @IBOutlet weak var tableShangpin: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        TBDelgate()
        let selIndex = NSIndexPath(row: 0, section: 0)
        tableZhonglei.selectRow(at: selIndex as IndexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = ttt
        DPdizhi.adjustsFontSizeToFitWidth = true
        DDView()
        shangjiajiekou()
        //        tableShangpin.isHidden = true
        //        tableZhonglei.isHidden = true
        
    }
    
    
    @IBAction func tiaoHuanJing(_ sender: Any) {
        let DP: XL_huanjing_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "huanjing") as? XL_huanjing_ViewController
        DP?.picture = self.picture
        self.navigationController?.pushViewController(DP!, animated: true)
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
        JE = UILabel(frame: CGRect(x: 56, y: 12, width: 150, height: 36))
//        JE.text = "¥\(HJjine)"
        jisuanfangfa()
        JE.textColor = UIColor.orange
        
        let XiaDanButton = UIButton(frame: CGRect(x: 2/3 * Width - 20, y: 5, width: Width/3, height: 46))
        XiaDanButton.addTarget(self, action: #selector(XDaction), for: .touchUpInside)
        XiaDanButton.setTitle("立即下单", for: .normal)
        if userDefaults.value(forKey: "isNotPay") as! String == "1" {
            XiaDanButton.setTitle("有未支付订单", for: .normal)
        }
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
        if userDefaults.value(forKey: "isNotPay") as! String == "1" {
            //跳到我的订单
            let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
            WDDD?.state = "1"
            self.navigationController?.pushViewController(WDDD!, animated: true)
        }else{
            var dddingdan:[[String:Any]] = []
            var x = 1
            
            for pro in classifyList {
                if nil != pro["productInfoList"] {
                    let prodectList:[[String:Any]] = pro["productInfoList"] as! [[String : Any]]
                    
                    for shangpin in prodectList {
                        if nil != shangpin["number"] && shangpin["number"] as! String != "0" {
                            dddingdan.append(shangpin)
                            x = 2
                        }
                    }
                }
            }
            if x == 1 {
                showConfirm(title: "温习提示", message: "请挑选商品再下订单哟～", in: self, Quxiao: { (quxiao) in
                    
                }) { (queding) in
                    
                }
            }else{
                let DP: XL_SPxiadanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spxiadan") as? XL_SPxiadanViewController
                DP?.shangpinList = dddingdan
                let jiage = (self.JE.text!).substring(fromIndex: 2)
                DP?.shangID = lll!
                DP?.jiage = jiage
                DP?.mingzi = ttt!
                DP?.dizhi = DPdizhi.text!
                DP?.uuuu = dianputupian
                self.navigationController?.pushViewController(DP!, animated: true)
            }
        }
    }
    func showConfirm(title: String, message: String, in viewController: UIViewController,Quxiao:((UIAlertAction)->Void)?,
                     Queding: ((UIAlertAction)->Void)?) {
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: Quxiao))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: Queding))
        viewController.present(alert, animated: true)
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
            return productInfoList.count
        }else{
            return classifyList.count
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
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if tableView == tableZhonglei {
            let zhonglei = UILabel(frame: CGRect(x: 8, y: 0, width: 56, height: 44))
            zhonglei.text = classifyList[indexPath.row]["productTpyeName"] as? String
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
            cell.contentView.addSubview(zhonglei)
            cell.contentView.addSubview(shuxian)
        }else{
            let imageView = UIImageView(frame: CGRect(x: 8, y: 12, width: 56, height: 56))
            var jiee:String = ""
            if productInfoList.count != 0{
                if nil != productInfoList[indexPath.row]["picture"]{
                    jiee = productInfoList[indexPath.row]["picture"] as! String
                }
            }
            let newString1 = TupianUrl + jiee
            let uul:URL = URL(string: String(format: "%@",newString1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
            imageView.sd_setImage(with: uul, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            let SPName = UILabel(frame: CGRect(x: 72, y: 8, width: Width - 72 - 72 - 8, height: 30))
            SPName.font = UIFont.systemFont(ofSize: 15)
            SPName.textColor = UIColor(hexString: "393939")
            SPName.text = ""
            var xox = ""
            if productInfoList.count != 0{
                xox = (productInfoList[indexPath.row]["productName"] as? String)!
                SPName.text = xox
            }
            if productInfoList.count != 0 && nil != productInfoList[indexPath.row]["productSpec"] {
                SPName.text = xox + " " + (productInfoList[indexPath.row]["productSpec"] as? String)!
            }
            
            let danjia = UILabel(frame: CGRect(x: 72, y: 50, width: Width - 152, height: 30))
            danjia.text = ""
            if productInfoList.count != 0{
                danjia.text = "¥ " + (productInfoList[indexPath.row]["productPrice"] as? String)!
            }
            danjia.textColor = UIColor.orange
            let imageJian = UIImageView(frame: CGRect(x: Width - 170 - 22, y: 78, width: 30, height: 30))
            imageJian.isUserInteractionEnabled = true
            imageJian.image = UIImage(named: "数量减")
            imageJian.tag = 10000 + indexPath.row
            let down = UITapGestureRecognizer(target: self, action: #selector(jian(sender:)))
            imageJian.addGestureRecognizer(down)
            let imageAdd = UIImageView(frame: CGRect(x: Width - 50 - 72, y: 78, width: 30, height: 30))
            imageAdd.isUserInteractionEnabled = true
            imageAdd.image = UIImage(named: "数量加")
            imageAdd.tag = 20000 + indexPath.row
            let up = UITapGestureRecognizer(target: self, action: #selector(jia(sender:)))
            imageAdd.addGestureRecognizer(up)
            shuzi = UITextField(frame: CGRect(x: Width - 135 - 22, y: 78, width: 40, height: 30))
            shuzi.textAlignment = NSTextAlignment.center
            shuzi.keyboardType = UIKeyboardType.numberPad
            shuzi.tag = 30000 + indexPath.row
            shuzi.text = "0"
            if ((classifyList[zuoIndex]["productInfoList"] as! [[String:Any]])[indexPath.row]).keys.contains("number") && (classifyList[zuoIndex]["productInfoList"] as! [[String:Any]])[indexPath.row]["number"] as! String != "0" {
                shuzi.text = (classifyList[zuoIndex]["productInfoList"] as! [[String:Any]])[indexPath.row]["number"] as? String
            }
            shuzi.delegate = self
            cell.contentView.addSubview(imageView)
            cell.contentView.addSubview(SPName)
            cell.contentView.addSubview(danjia)
            cell.contentView.addSubview(imageJian)
            cell.contentView.addSubview(shuzi)
            cell.contentView.addSubview(imageAdd)
            
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
            zuoIndex = indexPath.row
            productInfoList = []
            if nil != classifyList[indexPath.row]["productInfoList"] {
                productInfoList = classifyList[indexPath.row]["productInfoList"] as! [[String : Any]]
            }
            
            tableShangpin.reloadData()
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
    //MARK: 计算
    @objc func jian(sender: UITapGestureRecognizer) {
        let cell:UITableViewCell = sender.self.view?.superview?.superview as! UITableViewCell
        let index = tableShangpin.indexPath(for: cell)
        shuzi = cell.viewWithTag((index?.row)! + 30000) as! UITextField
        let sss = index?.row
        
        if shuzi.text! != "" && Int(shuzi.text!)! > 0 {
            if Int(shuzi.text!)! - 1 >= 0 {
                shuzi.text = String(format: "%d", Int(shuzi.text!)! - 1)
                
                var produ: [[String:Any]] = classifyList[zuoIndex]["productInfoList"] as! [[String : Any]]
                produ[sss!]["number"] = String(format: "%d", Int(shuzi.text!)!)
                classifyList[zuoIndex]["productInfoList"] = produ
                jisuanfangfa()
            }
            
        }
    }
    @objc func jia(sender: UITapGestureRecognizer) {
        let cell:UITableViewCell = sender.self.view?.superview?.superview as! UITableViewCell
        let index = tableShangpin.indexPath(for: cell)
        let sss = index?.row
        shuzi = cell.viewWithTag((index?.row)! + 30000) as! UITextField
        shuzi.text = String(format: "%d", Int(shuzi.text!)! + 1)
        var produ: [[String:Any]] = classifyList[zuoIndex]["productInfoList"] as! [[String : Any]]
        produ[sss!]["number"] = String(format: "%d", Int(shuzi.text!)!)
        classifyList[zuoIndex]["productInfoList"] = produ
        jisuanfangfa()
    }
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var produ: [[String:Any]] = classifyList[zuoIndex]["productInfoList"] as! [[String : Any]]
        if  newString.count > 0 {
            produ[textField.tag - 30000]["number"] = String(format: "%d", Int(newString)!)
            classifyList[zuoIndex]["productInfoList"] = produ
            jisuanfangfa()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textField.text = "0"
            var produ: [[String:Any]] = classifyList[zuoIndex]["productInfoList"] as! [[String : Any]]
            produ[textField.tag - 30000]["number"] = String(format: "%d", Int(textField.text!)!)
            classifyList[zuoIndex]["productInfoList"] = produ
            jisuanfangfa()
        }
    }
    func jisuanfangfa() {
        var qian:Float = 0
        for pro in classifyList {
            var prodectList:[[String:Any]] = []
            if nil != pro["productInfoList"] {
                prodectList = pro["productInfoList"] as! [[String : Any]]
            }
            
            for shangpin in prodectList {
                if nil != shangpin["number"] && shangpin["number"] as! String != "0" {
                    qian += Float(shangpin["number"] as! String)! * Float(shangpin["productPrice"] as! String)!
                }
            }
        }
        JE.text = "¥ " + String(format: "%.2f", qian)
    }
    //最多三位数
    //判断是哪个cell
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        self.navigationController?.navigationBar.isTranslucent = false
    //    }
    func shangjiajiekou()  {
        let method = "/mall/home"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["merchantId":lll!,"searchCriteria":"","userId":userId!]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.picture = data["picture"] as! String
                let logoUrl = data["logoUrl"] as! String
                let address = data["address"] as! String
                let phone = data["phone"] as! String
                let shopHours = data["shopHours"] as! String
                self.dianputupian = URL(string: TupianUrl + logoUrl)
                self.isCollect = data["isCollect"] as! Int
                self.isOrder = data["isOrder"] as! Int
                
                self.DPicon.sd_setImage(with: self.dianputupian, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
                self.DPdizhi.text = address
                self.DPdianhua.text = phone
                self.YYshijian.text = shopHours
                
                self.classifyList = data["classifyList"] as! [[String:Any]]
                if self.classifyList.count > 0 && nil != self.classifyList[0]["productInfoList"] {
                    self.productInfoList = self.classifyList[0]["productInfoList"] as! [[String : Any]]
                }
                
                self.tableZhonglei.reloadData()
                self.tableShangpin.reloadData()
                self.youshangjiao()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func youshangjiao()  {
        var item = UIBarButtonItem()
        
        if isCollect == 1 {
            item = UIBarButtonItem(title:"取消收藏",style: .plain,target:self,action:#selector(YouActio))
        }else{
            item = UIBarButtonItem(title:"收藏",style: .plain,target:self,action:#selector(YouActio))
        }
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio()  {
        var isValid = 0
        if self.isCollect == 1 {
            isValid = 2
        }else{
            isValid = 1
        }
        let method = "/mall/businessCollection"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["merchantId":lll!,"isValid":isValid,"userId":userId!]
        
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
//                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                if self.isCollect == 1 {
                    self.isCollect = 2
                }else{
                    self.isCollect = 1
                }
                self.youshangjiao()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
