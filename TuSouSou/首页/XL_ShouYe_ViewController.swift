//
//  XL_ShouYe_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
import CoreLocation

class XL_ShouYe_ViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,UIPopoverPresentationControllerDelegate ,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    var locationManager = CLLocationManager()
    var city: String = ""
    var weizhi:String?

   
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    //页码
    var pageNo = 1
    let pageSize = 10
    var count = 0
    
    var leixingInt: Int?
    var searchBar = UISearchBar()
    var daohang: Int?
    var Pan = 0
    
    //详细地址传值
    var shangDiZhi = ""
    var shangXiangQing = ""
    var xiaDiZhi = ""
    var xiaXiangQing = ""
    
    //地址详情
    @IBAction func xia_DZB(_ sender: Any) {
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            if JianPanhuishou() {
                let tianjiadizhi: XL_dizhi_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhi") as! XL_dizhi_ViewController
                tianjiadizhi.Shei = "shoujian"
                
                if self.xiaName.text != "收件人姓名"{
                    tianjiadizhi.namename = xiaName.text!
                }
                if self.xiaPhone.text != "收件人电话"{
                    var shang = self.xiaPhone.text!
                    if isJiabaliu(string: self.xiaPhone.text!){
                        shang = self.xiaPhone.text!.substring(fromIndex: 4)
                    }
                    tianjiadizhi.diandianhua = shang
                }
                tianjiadizhi.didizhi = self.xiaDiZhi
                tianjiadizhi.xiangqing = self.xiaXiangQing
                tianjiadizhi.lon = self.xiaLon
                tianjiadizhi.lat = self.xiaLat
                
                //block 传值调用
                tianjiadizhi.dixiang = {(diBody: [String: String]) in
                    self.xiaName.text = diBody["name"]
                    self.xiaPhone.text = diBody["phone"]
                    self.xiaDZOutlet.text = "\(diBody["dizhi"]!)\(diBody["xiangzhi"]!)"
                    self.xiaDiZhi = "\(diBody["dizhi"]!)"
                    self.xiaXiangQing = "\(diBody["xiangzhi"]!)"
                    
                    self.xiaLon = diBody["lon"]!
                    self.xiaLat = diBody["lat"]!
                }
                self.navigationController?.pushViewController(tianjiadizhi, animated: true)
            }
        }
    }
    //地址详情
    @IBAction func shang_DZB(_ sender: Any) {
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            if JianPanhuishou(){
                let tianjiadizhi: XL_dizhi_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhi") as! XL_dizhi_ViewController
                if daohang == 1 {
                    tianjiadizhi.Shei = "jijian"
                }else{
                    tianjiadizhi.Shei = "qujian"
                }
                
                if self.shangName.text != "寄件人姓名" && self.shangName.text != "取件人姓名"{
                    tianjiadizhi.namename = shangName.text!
                }
                if self.shangPhone.text != "寄件人电话" && self.shangPhone.text != "取件人电话"{
                    var shang = self.shangPhone.text!
                    if isJiabaliu(string: self.shangPhone.text!){
                        shang = self.shangPhone.text!.substring(fromIndex: 4)
                    }
                    tianjiadizhi.diandianhua = shang
                }
                tianjiadizhi.didizhi = self.shangDiZhi
                tianjiadizhi.xiangqing = self.shangXiangQing
                tianjiadizhi.lon = self.shangLon
                tianjiadizhi.lat = self.shangLat
                
                //block 传值调用
                tianjiadizhi.dixiang = {(diBody: [String: String]) in
                    self.shangName.text = diBody["name"]
                    self.shangPhone.text = diBody["phone"]
                    self.shDZOutlet.text = "\(diBody["dizhi"]!)\(diBody["xiangzhi"]!)"
                    self.shangLon = diBody["lon"]!
                    self.shangLat = diBody["lat"]!
                    self.shangDiZhi = "\(diBody["dizhi"]!)"
                    self.shangXiangQing = "\(diBody["xiangzhi"]!)"
                }
                self.navigationController?.pushViewController(tianjiadizhi, animated: true)
            }
        }
    }
    //地址簿列表
    @IBAction func shangDizhi(_ sender: Any) {
        //跳页，回调到地址栏
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            if JianPanhuishou(){
                let dizhibu: XL_Dizhibu_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhibu") as! XL_Dizhibu_ViewController
                if daohang == 1 {
                    dizhibu.biaoti = "1"
                }else{
                    dizhibu.biaoti = "2"
                }
                
                //block 传值调用
                dizhibu.xuanzhiBody = {(xuanzhiBody: [String: String]) in
                    self.shangName.text = xuanzhiBody["name"]
                    self.shangPhone.text = xuanzhiBody["phone"]
                    self.shDZOutlet.text = xuanzhiBody["dizhi"]
                    self.shangXiangQing = xuanzhiBody["xiangqing"]!
                    self.shangDiZhi = xuanzhiBody["didizhi"]!
                    self.shangLat = xuanzhiBody["lat"]!
                    self.shangLon = xuanzhiBody["lon"]!
                }
                self.navigationController?.pushViewController(dizhibu, animated: true)
            }
        }
    }
    //地址簿列表
    @IBAction func xiaDizhi(_ sender: Any) {
        //跳页，回调到地址栏
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            if JianPanhuishou(){
                let dizhibu: XL_Dizhibu_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhibu") as! XL_Dizhibu_ViewController
                dizhibu.biaoti = "3"
                //block 传值调用
                dizhibu.xuanzhiBody = {(xuanzhiBody: [String: String]) in
                    self.xiaName.text = xuanzhiBody["name"]
                    self.xiaPhone.text = xuanzhiBody["phone"]
                    self.xiaDZOutlet.text = xuanzhiBody["dizhi"]
                    self.xiaXiangQing = xuanzhiBody["xiangqing"]!
                    self.xiaDiZhi = xuanzhiBody["didizhi"]!
                    self.xiaLat = xuanzhiBody["lat"]!
                    self.xiaLon = xuanzhiBody["lon"]!
                }
                self.navigationController?.pushViewController(dizhibu, animated: true)
            }
        }
    }
    
    @IBOutlet weak var xiadananniu: UIButton!

    @IBOutlet weak var jinrisousouBi: UILabel!
    @IBOutlet weak var jiqushangView: UIView!
    @IBOutlet weak var touOutlet: UIButton!
    @IBOutlet weak var jiqujianView: UIView!
    @IBOutlet weak var jijianOutlet: UIButton!
    @IBOutlet weak var shangchengOutlet: UIButton!
    @IBOutlet weak var qujianOutlet: UIButton!
    
    @IBOutlet weak var shangPhone: UILabel!
    @IBOutlet weak var shangName: UILabel!
    @IBOutlet weak var shDZOutlet: UILabel!
     @IBOutlet weak var shangtuPutlet: UIImageView!
    @IBOutlet weak var xiaPhone: UILabel!
    @IBOutlet weak var xiaName: UILabel!
    @IBOutlet weak var xiaDZOutlet: UILabel!
     @IBOutlet weak var xiatuOutlet: UIImageView!
    var shangLat:String = ""
    var shangLon = ""
    var xiaLat:String = ""
    var xiaLon = ""
    
    var classifyList:[[String:Any]] = []
    var labelList:[[String:Any]] = []
    var excellentMerchantList:[[String:Any]] = []
    
    //托物类型
    @IBOutlet weak var yin: UIImageView!
    @IBOutlet weak var hua: UIImageView!
    @IBOutlet weak var wen: UIImageView!
    @IBOutlet weak var shui: UIImageView!
    @IBOutlet weak var qi: UIImageView!
    
    @IBOutlet weak var shuliang: UITextField!

    var _tableView = UITableView()
    
    //MARK：侧滑栏
    @IBAction func zuoanniu(_ sender: UIBarButtonItem) {
//        XL_DrawerViewController.shareDrawer?.openLeftMenu()
        //个人中心  XL_GeRenViewController
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            let geren: XL_GeRenViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "geren") as? XL_GeRenViewController
            self.navigationController?.pushViewController(geren!, animated: true)
        }
        
    }
    //MARK:跳页到城市列表，回调改变城市
    @IBAction func touButton(_ sender: Any) {
        if JianPanhuishou(){
            let chengshiList: XL_chengshiListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chengshilist") as! XL_chengshiListViewController
            //block 传值调用
            chengshiList.Cityblock = {(cityname: [String:Any]) in
                self.city = cityname["cityName"] as! String
                userDefaults.set(cityname["cityName"]!, forKey: "cityName")
                self.dizhi()
            }
            self.navigationController?.pushViewController(chengshiList, animated: true)
        }
    }
    //MARK:签到入口
    @IBAction func you(_ sender: Any) {
        //跳页
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            if JianPanhuishou(){
                let xiadan: XL_QD_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qd") as? XL_QD_ViewController
                self.navigationController?.pushViewController(xiadan!, animated: true)
            }
        }
    }
    var window: UIWindow?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        classifyList = []
        labelList = []
        excellentMerchantList = []
        let tap = UITapGestureRecognizer(target: self, action: #selector(tiaoqianbao))
        jinrisousouBi.addGestureRecognizer(tap)
        jinrisousouBi.isUserInteractionEnabled = true
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        //从广告页跳转到详情
        let name = Notification.Name(rawValue: "pushtoad")
        NotificationCenter.default.addObserver(self, selector: #selector(pushToad(notification:)), name: name, object:  nil)
        leixingInt = 1
        leixing(lei: leixingInt!)
        daohang = 1
        self.TableViewDelegate()
        self.title = ""
        //键盘弹出监听
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(XL_ShouYe_ViewController.keyboardWillChange(_:)),
                                               name: .UIKeyboardWillChangeFrame, object: nil)
        delegate()
        shangjiemian()
        loadLocation()
        shangchengjiekou()
    }
    @objc func tiaoqianbao() {
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            let wanshan: XL_WDQB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdqb") as? XL_WDQB_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }
    }
    @objc func pushToad(notification: NSNotification){
        let adVC: XL_GGXQViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ggxq") as? XL_GGXQViewController
        //添加广告地址
        adVC?.urlstring = notification.userInfo!["webURL"] as? String
        self.navigationController?.pushViewController(adVC!, animated: false)
    }
    
    @objc func headerRefresh() {
        footer.endRefreshingWithMoreData()
        pageNo = 1
        excellentMerchantList = []
        shangchengjiekou()
        _tableView.mj_header.endRefreshing()
    }
    
    @objc func footerRefresh() {
        print("上拉刷新")
        
        if count > pageNo * pageSize {
            _tableView.mj_footer.endRefreshing()
            pageNo = pageNo + 1
            shangchengjiekou()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
    }
    @IBAction func jian(_ sender: Any) {
        let num: Int = Int(shuliang.text!)!
        if  num > 1 {
            shuliang.text = String(num - 1)
        }
    }
    
    @IBAction func jia(_ sender: Any) {
        let num: Int = Int(shuliang.text!)!
        shuliang.text = String(num + 1)
    }
    
    @IBAction func xiadanButton(_ sender: Any) {
        //jiekou
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            if userDefaults.value(forKey: "isNotPay") as! String == "1" {
                let WDDD: XL_WDdingdanViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wddingdan") as? XL_WDdingdanViewController
                WDDD?.state = "1"
                self.navigationController?.pushViewController(WDDD!, animated: true)
            }else{
                var shang = shangPhone.text!
                var xia = xiaPhone.text!
                if isJiabaliu(string: shangPhone.text!){
                    shang = shangPhone.text!.substring(fromIndex: 4)
                }
                if isJiabaliu(string: xiaPhone.text!) {
                    xia = xiaPhone.text!.substring(fromIndex: 4)
                }
                
                if !shang.isPhoneNumber() || !xia.isPhoneNumber() {
                    XL_waringBox().warningBoxModeText(message: "请填写正确的手机号", view: self.view)
                }else{
                    xiadanjiekou(shang:shang,xia:xia)
                }
            }
            
        }
    }
    func isJiabaliu(string:String) -> Bool {
        if string.contains("+ 86") {
            return true
        }
        return false
    }
    /**orderType: 1.寄件订单2. 取件订单 3.商城
     commoditiesType   1. 食品饮料2.鲜花 3.蛋糕,4文件，5水果生鲜，6其他
     */
    func xiadanjiekou(shang:String,xia:String){
        let method = "/order/placeAnOrder"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!,"longitudeJi":shangLon,"latitudeJi":shangLat,"longitudeShou":xiaLon,"latitudeShou":xiaLat,"orderType":daohang!,"addressLocation":xiaDZOutlet.text!,"addressName":xiaName.text!,"addressPhone":xia,"senderLocation":shDZOutlet.text!,"senderName":shangName.text!,"senderPhone":shang,"commoditiesType":leixingInt!,"weight":shuliang.text!]
        XL_waringBox().warningBoxModeIndeterminate(message: "下单中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "下单成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                let juli = dic["instance"] as! String
                let zhinazhisong = dic["directSendMoney"] as! Float
                let dingdanjine = dic["orderCount"] as! Float
                let dingdanhao = dic["orderCode"] as! String // 订单号？？
                let dingdanID = dic["orderId"] as! String
                let xiadan: XL_KuaiDixiadan_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kuaidixiadan") as? XL_KuaiDixiadan_ViewController
                xiadan?.dingdanID = dingdanID
                xiadan?.dingdanjine = String(format:" %.2f", dingdanjine)
                xiadan?.dingdanhao = dingdanhao
                xiadan?.zhinazhisong = String(format:" %.2f", zhinazhisong)
                xiadan?.orderType = self.daohang
                xiadan?.julili = juli
                self.navigationController?.pushViewController(xiadan!, animated: true)
                
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }

    }
    //MARK:下边整体界面 除了商城
    func xiajiemian() {
        switch daohang {
        case 1?:
            jiqujianView.isHidden = false
            shangtuPutlet.image = UIImage(named:"ji")
            xiatuOutlet.image = UIImage(named:"shou")
            shDZOutlet.text = "寄件人地址"
            xiaDZOutlet.text = "收件人地址"
            xiaName.text = "收件人姓名"
            xiaPhone.text = "收件人电话"
            shangName.text = "寄件人姓名"
            shangPhone.text = "寄件人电话"
            _tableView.isHidden = true
        case 2?:
            jiqujianView.isHidden = false
            shangtuPutlet.image = UIImage(named:"qu")
            xiatuOutlet.image = UIImage(named:"shou")
            shDZOutlet.text = "取件人地址"
            shangName.text = "取件人姓名"
            shangPhone.text = "取件人电话"
            xiaDZOutlet.text = "收件人地址"
            xiaName.text = "收件人姓名"
            xiaPhone.text = "收件人电话"
            _tableView.isHidden = true
        case 3?:
            jiqujianView.isHidden = true
            _tableView.isHidden = false
        default:
            break
        }
    }
    //MARK: tableviewDelegate
    func TableViewDelegate() {
        let hei = jiqushangView.frame.origin.y + jiqushangView.frame.height
        
        _tableView = UITableView(frame: CGRect(x: 0, y: hei, width: Width - 0, height: Height - hei))
        self.view.addSubview(_tableView)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.tableFooterView = UIView()
        _tableView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            if UIDevice.current.isX() {
                _tableView.frame = CGRect(x: 0, y: hei + 30, width: Width, height: Height - hei - 30)
            }
            _tableView.contentInsetAdjustmentBehavior = .automatic
        }
        _tableView.isHidden = true
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        _tableView.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        _tableView.mj_footer = footer
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "shangcheng")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 44
        }
        return 8
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            let VV = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 44))
            VV.backgroundColor = UIColor(hexString: "f7f7f7")
            let shu = UIView(frame: CGRect(x: 0, y: 8, width: 5, height: 28))
            shu.backgroundColor = UIColor.orange
            VV.addSubview(shu)
            let jingxuan = UILabel(frame: CGRect(x: 20, y: 8, width: 200, height: 28))
            jingxuan.text = "精选商家"
            let quanbushangjiaButton = UIButton(frame: CGRect(x: Width - 120, y: 8, width: 100, height: 28))
            quanbushangjiaButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            quanbushangjiaButton.setTitleColor(UIColor.black, for: .normal)
            quanbushangjiaButton.setTitle("查看全部商家", for: .normal)
            quanbushangjiaButton.addTarget(self, action: #selector(quanbushangjiaAction), for: .touchUpInside)
            VV.addSubview(quanbushangjiaButton)
            VV.addSubview(jingxuan)
            return VV
        }
        return nil
    }
    @objc func quanbushangjiaAction()  {
        print("点击时间")
        let DP: XL_SJLB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sjlb") as? XL_SJLB_ViewController
        DP?.classifyTypeId = ""
        self.navigationController?.pushViewController(DP!, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 120
        }else if indexPath.section == 2 {
            return 150
        }else if indexPath.section == 3 {
            return 112
        }
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 1
        }else{
            return excellentMerchantList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "shangcheng"
        let cell = (_tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.section == 0 {
            searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: Width - 0, height: 44))
            searchBar.backgroundImage = UIImage()
            searchBar.placeholder = "输入商家或商品名称"
            searchBar.delegate = self
            cell.contentView.addSubview(searchBar)
            
        }
        if indexPath.section == 1 {
            let scroll = self.scrollViewUI()
            cell.contentView.addSubview(scroll)
        }
        if indexPath.section == 2 {
            let View1 = UIImageView(frame: CGRect(x: 0, y: 0, width: Width/3 - 1, height: 150))
            View1.isUserInteractionEnabled = true
            let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(view1Action(sender:)))
            View1.addGestureRecognizer(tapGR1)
            var ax:String = ""
            if labelList.count > 0{
                if nil != labelList[0]["classifyImage"]{
                    ax = labelList[0]["classifyImage"] as! String
                }
            }
            
            let newString = TupianUrl + ax
            let uuu:URL = URL(string: String(format: "%@",newString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
            View1.sd_setImage(with: uuu, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            
            let View2 = UIImageView(frame: CGRect(x: Width/3, y: 0, width: Width*2/3, height: 74))
            View2.isUserInteractionEnabled = true
            let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(view2Action(sender:)))
            View2.addGestureRecognizer(tapGR2)
            var ax1:String = ""
            if labelList.count > 1{
            if nil != labelList[1]["classifyImage"]{
                ax1 = labelList[1]["classifyImage"] as! String
            }
            }
            let rrr:URL = URL(string:TupianUrl + ax1)!
            View2.sd_setImage(with: rrr, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            
            let View3 = UIImageView(frame: CGRect(x: Width/3, y: 75, width: Width/3 - 1, height: 75))
            View3.isUserInteractionEnabled = true
            let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(view3Action(sender:)))
            View3.addGestureRecognizer(tapGR3)
            var ax2:String = ""
            if labelList.count > 2{
            if nil != labelList[2]["classifyImage"]{
                ax2 = labelList[2]["classifyImage"] as! String
            }
            }
            let lll:URL = URL(string:TupianUrl + ax2)!
            View3.sd_setImage(with: lll, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            
            let View4 = UIImageView(frame: CGRect(x: Width*2/3, y: 75, width: Width/3, height: 75))
            View4.isUserInteractionEnabled = true
            let tapGR4 = UITapGestureRecognizer(target: self, action: #selector(view4Action(sender:)))
            View4.addGestureRecognizer(tapGR4)
            var ax3:String = ""
            if labelList.count > 3{
            if nil != labelList[3]["classifyImage"]{
                ax3 = labelList[3]["classifyImage"] as! String
            }
            }
            let sss:URL = URL(string:TupianUrl + ax3)!
            View4.sd_setImage(with: sss, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            
            cell.contentView.addSubview(View4)
            cell.contentView.addSubview(View3)
            cell.contentView.addSubview(View2)
            cell.contentView.addSubview(View1)
            
        }
        if indexPath.section == 3 {
            var jiee:String = ""
            if excellentMerchantList.count != 0{
                if nil != excellentMerchantList[indexPath.row]["logoUrl"]{
                    jiee = excellentMerchantList[indexPath.row]["logoUrl"] as! String
                }
            }
            
            let newString1 = TupianUrl + jiee
            let uul:URL = URL(string: String(format: "%@",newString1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
            let imageview = UIImageView(frame: CGRect(x: 8, y: 8, width: Width/3 - 20, height: 96))
            imageview.sd_setImage(with: uul, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            let gongsiName = UILabel(frame: CGRect(x: Width/3 + 8, y: 10, width: Width*2/3 - 20, height: 24))
            gongsiName.text = ""
            if excellentMerchantList.count != 0{
                gongsiName.text = excellentMerchantList[indexPath.row]["merchantName"] as? String
            }
            
            gongsiName.font = UIFont.systemFont(ofSize: 19)
            let imageDizhi = UIImageView(frame: CGRect(x: Width/3 + 8, y: 48, width: 10, height: 16))
            imageDizhi.image = UIImage(named: "位置2")
            let imageDianhua = UIImageView(frame: CGRect(x: Width/3 + 8, y: 88, width: 10, height: 16))
            imageDianhua.image = UIImage(named: "电话")
            
            let DDZZ = UILabel(frame: CGRect(x: Width/3 + 24, y: 40, width: Width*2/3 - 40, height: 40))
            DDZZ.numberOfLines = 2
            DDZZ.font = UIFont.systemFont(ofSize: 15)
            DDZZ.textColor = UIColor(hexString: "6e6e6e")
            DDZZ.text = ""
            if excellentMerchantList.count != 0{
                DDZZ.text = excellentMerchantList[indexPath.row]["address"] as? String
            }
            let DDHH = UILabel(frame: CGRect(x: Width/3 + 24, y: 84, width: Width*2/3 - 40, height: 24))
            DDHH.font = UIFont.systemFont(ofSize: 15)
            DDHH.textColor = UIColor(hexString: "6e6e6e")
            var phoneNum = ""
            if excellentMerchantList.count != 0{
            if nil != excellentMerchantList[indexPath.row]["phone"]{
                phoneNum = excellentMerchantList[indexPath.row]["phone"] as! String
                }
            }
            DDHH.text = "+86\(phoneNum)"
            
            cell.contentView.addSubview(imageview)
            cell.contentView.addSubview(gongsiName)
            cell.contentView.addSubview(imageDizhi)
            cell.contentView.addSubview(imageDianhua)
            cell.contentView.addSubview(DDZZ)
            cell.contentView.addSubview(DDHH)
        }
        //(cityList?[indexPath.row] as! NSDictionary).value(forKey: "cityname") as? String
        //        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            print(indexPath.row)
            if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
                userDefaults.set("0", forKey: "isDengLu")
                let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
                self.navigationController?.pushViewController(wanshan!, animated: true)
            }else{
                let xiadan: XL_DPliebiaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpliebiao") as? XL_DPliebiaoViewController
                xiadan?.lll = String(format: "%d",(excellentMerchantList[indexPath.row]["merchantId"] as? Int)!)
                xiadan?.ttt = excellentMerchantList[indexPath.row]["merchantName"] as? String
                //        xiada
                self.navigationController?.pushViewController(xiadan!, animated: true)
            }
        }
    }
  
    func shangchengjiekou() {
        let method = "/store/home"
//        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["pageNo":pageNo,"pageSize":pageSize,"cityName":city]
//        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                //                XL_waringBox().warningBoxModeText(message: "评价成功", view: self.view)
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.classifyList = data["classifyList"] as! [[String:Any]]
                self.labelList = data["labelList"] as! [[String:Any]]
                self.excellentMerchantList += data["excellentMerchantList"] as! [[String:Any]]
                self._tableView.reloadData()
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    @objc func view1Action(sender: UITapGestureRecognizer) {
        print("红色")
        let xiadan: XL_SJLB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sjlb") as? XL_SJLB_ViewController
        xiadan?.classifyTypeId = labelList[0]["classifyId"] as? String
        self.navigationController?.pushViewController(xiadan!, animated: true)
    }
    @objc func view2Action(sender: UITapGestureRecognizer) {
        print("蓝色")
        let xiadan: XL_SJLB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sjlb") as? XL_SJLB_ViewController
        xiadan?.classifyTypeId = labelList[1]["classifyId"] as? String
        self.navigationController?.pushViewController(xiadan!, animated: true)
    }
    @objc func view3Action(sender: UITapGestureRecognizer) {
        print("绿色")
        let xiadan: XL_SJLB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sjlb") as? XL_SJLB_ViewController
        xiadan?.classifyTypeId = labelList[2]["classifyId"] as? String
        self.navigationController?.pushViewController(xiadan!, animated: true)
    }
    @objc func view4Action(sender: UITapGestureRecognizer) {
        print("橘黄色")
        let xiadan: XL_SJLB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sjlb") as? XL_SJLB_ViewController
        xiadan?.classifyTypeId = labelList[3]["classifyId"] as? String
        self.navigationController?.pushViewController(xiadan!, animated: true)
    }
    func scrollViewUI() -> (UIScrollView) {
        let scroll = UIScrollView();
        scroll.tag = 999994
//        scroll.backgroundColor = UIColor.gray
        var tuhuaArray: [String]  = []
        var titiess:[String] = []
        
        for dic in 0..<classifyList.count {
            if nil != classifyList[dic]["classifyImage"]{
                tuhuaArray.append(TupianUrl + (classifyList[dic]["classifyImage"] as! String))
                titiess.append(classifyList[dic]["classifyName"] as! String)
            }
        }
        scroll.frame = CGRect(x: 0, y: 0, width: Width - 0, height: 120)  //设置scrollview的大小
        scroll.contentSize = CGSize(width: 90 * tuhuaArray.count + 10, height: 0)   //内容大小
        scroll.isPagingEnabled = false                 //是否支持分页
        scroll.isUserInteractionEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        for i:Int in 0..<tuhuaArray.count {
            let url: URL = URL(string: tuhuaArray[i])!
            let imageView =  UIImageView()
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            imageView.frame = CGRect(x: 80 * i + 10 * (i + 1), y:10, width: 80, height: 80)
            imageView.tag = 600 + i
            imageView.isUserInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(DianjiTuPian(sender:)))
            imageView.addGestureRecognizer(tapGR)
            let titles: UILabel = UILabel(frame: CGRect(x: 80 * i + 10 * (i + 1), y:95, width: 80, height: 20))
            titles.textAlignment = .center
            titles.font = UIFont.systemFont(ofSize: 13)
            titles.textColor = UIColor.darkGray
            titles.text = titiess[i]
            scroll.addSubview(titles)
            scroll.addSubview(imageView)
        }
        return scroll
    }
    @objc func DianjiTuPian(sender: UITapGestureRecognizer) {
        let imageView: UIImageView = sender.view as! UIImageView
        //跳页到 imageView.tag - 600 的页面
        print(imageView.tag - 600)
        let DP: XL_SJLB_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sjlb") as? XL_SJLB_ViewController
        DP?.classifyTypeId = classifyList[imageView.tag - 600]["classifyId"] as? String
    
        self.navigationController?.pushViewController(DP!, animated: true)
        
    }
    //MARK: searchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let sousuo: XL_SCsousuoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scsousuo") as? XL_SCsousuoViewController
        sousuo?.lll = searchBar.text!
        self.navigationController?.pushViewController(sousuo!, animated: true)
    }
    //MARK:定位的那个地址
    func dizhi()  {
        touOutlet.setTitle(self.city, for: .normal)
        xiajiemian()
    }
    //MARK: 原生定位初始化
    func loadLocation() {
        locationManager.delegate = self
        //定位方式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //更新距离
        locationManager.distanceFilter = 100
        //发出授权请求
        locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            //允许使用定位服务的话，开始定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
            
        }else{
            print("权限未开启")
        }
    }
    //    MARK:定位代理实现
    
    //获取定位信息
    var currLocation: CLLocation?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取得locations数组的最后一个
        currLocation = locations.last!
        userDefaults.set((currLocation?.coordinate.longitude.description)!, forKey: "longitude")
        userDefaults.set((currLocation?.coordinate.latitude.description)!, forKey: "latitude")
        LonLatToCity()
        //停止定位
        locationManager.stopUpdatingLocation()
    }
    
    //出现错误
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print(error as Any)
    }
    
    ///将经纬度转换为城市名
    func LonLatToCity(){
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation((currLocation)!) { (placemark, error) -> Void in
            
            if(error == nil)
            {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                //省
                let State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                //区
                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
                //城市
                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                //街道
                let Street: String = (mark.addressDictionary! as NSDictionary).value(forKey: "Street") as! String
                //首页上边显示的
                self.city = city
                userDefaults.set(city, forKey: "cityName")
                //当前位置显示的
//                self.weizhi = State + city + (SubLocality as String) + Street
                self.dizhi()
            }
            else
            {
                print(error as Any)
            }
        }
    }
    
    //MARK: 侧滑方法
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.none
//    }
    
//    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
//        return true
//    }
    //MARK:寄件取件商城切换
    @IBAction func jijianButton(_ sender: Any) {
        daohang = 1
        self.shangDiZhi = ""
        self.shangXiangQing = ""
        shangjiemian()
        xiajiemian()
    }
    
    @IBAction func qujianButton(_ sender: Any) {
        daohang = 2
        self.shangDiZhi = ""
        self.shangXiangQing = ""
        shangjiemian()
        xiajiemian()
    }
    
    @IBAction func shangchengButton(_ sender: Any) {
        daohang = 3
        shangjiemian()
        xiajiemian()
    }
    //寄件 1  取件 2  商城 3
    func shangjiemian() {
       jijianOutlet.setImage(UIImage(named:"jijian_dark"), for: .normal)
       qujianOutlet.setImage(UIImage(named:"qujian_dark"), for: .normal)
       shangchengOutlet.setImage(UIImage(named:"shangcheng_dark"), for: .normal)
        switch daohang {
        case 1?:
            jijianOutlet.setImage(UIImage(named:"jijian_light"), for: .normal)
            
        case 2?:
            qujianOutlet.setImage(UIImage(named:"qujian_light"), for: .normal)
            
        case 3?:
            shangchengOutlet.setImage(UIImage(named:"shangcheng_light"), for: .normal)
        default:
            break
        }
        
    }
    //MARK:UITextFiledDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        searchBar.text = ""
        if nil == userDefaults.value(forKey: "isDengLu") || userDefaults.value(forKey: "isDengLu") as! String == "0" {
            userDefaults.set("0", forKey: "isDengLu")
        }else{
            shouyejiekou()
        }
        //表头透明
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view .endEditing(true)
    }
    //MARK:各框架的代理
    func delegate() {
        shuliang.delegate = self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.count + string.count - range.length
        print(textField.text as Any)
        return textLength <= 3
    }
    // 键盘改变
    @objc func keyboardWillChange(_ notification: Notification) {
        if searchBar.isFirstResponder == true {
            print("不动")
        }else{
        if Pan == 0{
            Pan = 1
        }else{
            Pan = 0
        }
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve), animations: {
                            
                            self.view.frame = CGRect(x: 0, y: -intersection.height, width: self.view.frame.width, height: self.view.frame.height)
                            
            }, completion: nil)
        }
        }
    }
    func JianPanhuishou() -> Bool {
        if Pan == 1 {
            self.view.endEditing(true)
            Pan = 0
            return false
        }
        return true
    }
    @IBAction func shipin(_ sender: Any) {
        leixingInt = 1
        leixing(lei: leixingInt!)
    }
    @IBAction func xianhua(_ sender: Any) {
        leixingInt = 2
        leixing(lei: leixingInt!)
    }
    @IBAction func wenjian(_ sender: Any) {
        leixingInt = 3
        leixing(lei: leixingInt!)
    }
    @IBAction func shuiguo(_ sender: Any) {
        leixingInt = 4
        leixing(lei: leixingInt!)
    }
    @IBAction func qita(_ sender: Any) {
        leixingInt = 5
        leixing(lei: leixingInt!)
    }
    func leixing(lei: Int) {
        yin.image = UIImage(named:"yinliao_dark")
        hua.image = UIImage(named:"xianhua_dark")
        wen.image = UIImage(named:"wenjian_dark")
        shui.image = UIImage(named:"shouguo_dark")
        qi.image = UIImage(named:"qita_dark")
        switch lei {
        case 1:
            yin.image = UIImage(named:"yinliao_light")
        case 2:
            hua.image = UIImage(named:"xianhua_light")
        case 3:
            wen.image = UIImage(named:"wenjian_light")
        case 4:
            shui.image = UIImage(named:"shuiguo_light")
        case 5:
            qi.image = UIImage(named:"qita_light")
        default:
            break
        }
    }
//    //自动登录
//    func zidongdenglu(loginMethod: String,loginName:String,passWord:String,authCode:String, openID: String) {
//        let method = "/user/logined"
//        let dic = ["loginPlatform":"1","loginMethod":loginMethod,"loginName":loginName,"passWord":passWord,"authCode":authCode,"openID":openID]
////        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
//        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
//            print(res)
//            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
//            if (res as! [String: Any])["code"] as! String == "0000" {
//                XL_waringBox().warningBoxModeText(message: "登录成功", view: self.view)
//                let dic = (res as! [String: Any])["data"] as! [String:Any]
//                userDefaults.set(dic["userId"], forKey: "userId")
//                userDefaults.set(dic["isPayPassWord"], forKey: "isPayPassWord")
//                userDefaults.set(dic["userPhone"], forKey: "userPhone")
//                userDefaults.set(dic["invitationCode"], forKey: "invitationCode")
//                userDefaults.set(loginMethod, forKey: "loginMethod")
//                userDefaults.set(passWord, forKey: "passWord")
//                userDefaults.set(openID, forKey: "openID")
//                userDefaults.set("1", forKey: "isDengLu")
//                userDefaults.set(dic["accessToken"], forKey: "accessToken")
//                AppDelegate().method()
//                let time: TimeInterval = 1
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
//                    self.shouyejiekou()
//                }
//            }else{
//                let msg = (res as! [String: Any])["msg"] as! String
//                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
//            }
//        }) { (error) in
//            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
//            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
//            print(error)
//        }
//    }
    func shouyejiekou(){
        let method = "/user/Home"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId,"cityName":city]
//        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        guard let accessToken = userDefaults.value(forKey: "accessToken") else {
            return
        }
        XL_QuanJu().TokenWangluo(methodName: method, methodType: .post, userId: userId, accessToken: accessToken as! String, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
//                XL_waringBox().warningBoxModeText(message: "登录成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                let jjj:String = String(format: "%f", dic["percentage"] as! Double)
                var bySsMoney = ""
                if  nil != dic["bySsMoney"]{
                    bySsMoney = dic["bySsMoney"] as! String
                }
                var isNotPay = "2"
                if nil != dic["isNotPay"]{
                    isNotPay = dic["isNotPay"] as! String
                }
                let jiage:String = self.preciseDecimal(x: jjj, p: 4)
                //jiage 转保留4位小数
                self.jinrisousouBi.text = "今日飕飕币价格：\(jiage)"
                self.jinrisousouBi.adjustsFontSizeToFitWidth = true
                var userType = 1
                if nil != dic["userType"]{
                    userType = dic["userType"] as! Int
                }
                var isFirmAdit = 1
                if nil != dic["isFirmAdit"]{
                    isFirmAdit = dic["isFirmAdit"] as! Int
                }
                var isRealAuthentication = 1
                if nil != dic["isRealAuthentication"]{
                    isRealAuthentication = dic["isRealAuthentication"] as! Int
                }
                var phone = ""
                if nil != dic["phone"]{
                    phone = dic["phone"] as! String
                }
                var isOpen = 1
                if nil != dic["isOpen"]{
                    isOpen = dic["isOpen"] as! Int
                }
                userDefaults.set(userType, forKey: "userType")
                userDefaults.set(isFirmAdit, forKey: "isFirmAdit")
                userDefaults.set(isRealAuthentication, forKey: "isRealAuthentication")
                userDefaults.set(phone, forKey: "phone")
                userDefaults.set(isOpen, forKey: "isOpen")
                if bySsMoney != "" {
                    //alert
                    let sheet = UIAlertController(title: "温馨提示:", message: "您获得了 \(bySsMoney)个飕飕币～", preferredStyle: .alert)
                    
                    let cancel = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    sheet.addAction(cancel)
                    self.present(sheet, animated: true, completion: nil)
                }
                userDefaults.set(isNotPay, forKey: "isNotPay")
                if isNotPay == "1"{
                    self.xiadananniu.setTitle("有未支付订单", for: .normal)
                }else if isNotPay == "2"{
                    self.xiadananniu.setTitle("立即下单", for: .normal)
                }
//                isOpen(int):是否开通配送员(1.是2否)
//                bySsMoney(String):被发送飕飕币数量

            }else if (res as! [String: Any])["code"] as! String == "1000" {
                let sheet = UIAlertController(title: "安全提示:", message: "您的账号在其它地方登录，注意账号安全，请重新登录。", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "确定", style: .cancel, handler: { (ss) in
                    let WDXX: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
                    userDefaults.set("0", forKey: "isDengLu")
                    userDefaults.set(true, forKey: "Tuisong")
                    JPUSHService.deleteAlias({ (iResCode, alias, aa) in
                        print("\(iResCode)\n别名:  \(alias)\n\(aa)")
                    }, seq: 1)
                    WDXX?.xxjj = 1
                    self.navigationController?.pushViewController(WDXX!, animated: true)
                })
                sheet.addAction(cancel)
                self.present(sheet, animated: true, completion: nil)
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    
    
    
    func preciseDecimal(x : String, p : Int) -> String {
        //        为了安全要判空
        if (Double(x) != nil) {
            //         四舍五入
            let decimalNumberHandle : NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode(rawValue: 0)!, scale: Int16(p), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let decimaleNumber : NSDecimalNumber = NSDecimalNumber(value: Double(x)!)
            let resultNumber : NSDecimalNumber = decimaleNumber.rounding(accordingToBehavior: decimalNumberHandle)
            //          生成需要精确的小数点格式，
            //          比如精确到小数点第3位，格式为“0.000”；精确到小数点第4位，格式为“0.0000”；
            //          也就是说精确到第几位，小数点后面就有几个“0”
            var formatterString : String = "0."
            let count : Int = (p < 0 ? 0 : p)
            for _ in 0 ..< count {
                formatterString.append("0")
            }
            let formatter : NumberFormatter = NumberFormatter()
            //      设置生成好的格式，NSNumberFormatter 对象会按精确度自动四舍五入
            formatter.positiveFormat = formatterString
            //          然后把这个number 对象格式化成我们需要的格式，
            //          最后以string 类型返回结果。
            return formatter.string(from: resultNumber)!
        }
        return "0"
    }
}
//extension Double {
//
//    /// Rounds the double to decimal places value
//
//    func roundTo(places:Int) -> Double {
//
//        let divisor = pow(10.0, Double(places))
//
//        return (self * divisor).rounded() / divisor
//
//    }
//
//}
extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
