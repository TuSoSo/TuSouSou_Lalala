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
    var city: String?
    var weizhi:String?
    
    var leixingInt: Int?
    var searchBar = UISearchBar()
    var daohang: Int?
    var Pan = 0
    //地址详情
    @IBAction func xia_DZB(_ sender: Any) {
        if JianPanhuishou() {
            let tianjiadizhi: XL_dizhi_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhi") as! XL_dizhi_ViewController
            tianjiadizhi.Shei = "shoujian"
            //block 传值调用
            tianjiadizhi.dixiang = {(diBody: [String: String]) in
                self.xiaName.text = diBody["name"]
                self.xiaPhone.text = diBody["phone"]
                self.xiaDZOutlet.text = "\(diBody["dizhi"]!)\(diBody["xiangzhi"]!)"
            }
            self.navigationController?.pushViewController(tianjiadizhi, animated: true)
            
        }
    }
    //地址详情
    @IBAction func shang_DZB(_ sender: Any) {
        if JianPanhuishou(){
            let tianjiadizhi: XL_dizhi_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhi") as! XL_dizhi_ViewController
            if daohang == 1 {
                tianjiadizhi.Shei = "jijian"
            }else{
                tianjiadizhi.Shei = "qujian"
            }
            //block 传值调用
            tianjiadizhi.dixiang = {(diBody: [String: String]) in
                self.shangName.text = diBody["name"]
                self.shangPhone.text = diBody["phone"]
                self.shDZOutlet.text = "\(diBody["dizhi"] as! String)\(diBody["xiangzhi"] as! String)"
            }
            self.navigationController?.pushViewController(tianjiadizhi, animated: true)
        }
    }
    //地址簿列表
    @IBAction func shangDizhi(_ sender: Any) {
        //跳页，回调到地址栏
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
            }
            self.navigationController?.pushViewController(dizhibu, animated: true)
        }
        
    }
    //地址簿列表
    @IBAction func xiaDizhi(_ sender: Any) {
        //跳页，回调到地址栏
        if JianPanhuishou(){
            let dizhibu: XL_Dizhibu_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dizhibu") as! XL_Dizhibu_ViewController
            dizhibu.biaoti = "3"
            //block 传值调用
            dizhibu.xuanzhiBody = {(xuanzhiBody: [String: String]) in
                self.xiaName.text = xuanzhiBody["name"]
                self.xiaPhone.text = xuanzhiBody["phone"]
                self.xiaDZOutlet.text = xuanzhiBody["dizhi"]
            }
            self.navigationController?.pushViewController(dizhibu, animated: true)
        }
    }
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
        let geren: XL_GeRenViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "geren") as? XL_GeRenViewController
        self.navigationController?.pushViewController(geren!, animated: true)
    }
    //MARK:跳页到城市列表，回调改变城市
    @IBAction func touButton(_ sender: Any) {
        if JianPanhuishou(){
            let chengshiList: XL_chengshiListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chengshilist") as! XL_chengshiListViewController
            //block 传值调用
            chengshiList.Cityblock = {(cityname: String) in
                self.city = cityname
                self.dizhi()
            }
            self.navigationController?.pushViewController(chengshiList, animated: true)
        }
    }
    //MARK:签到入口
    @IBAction func you(_ sender: Any) {
        //跳页
        if JianPanhuishou(){
            
        }
    }
    var window: UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
   
    @objc func pushToad(notification: NSNotification){
        let adVC: XL_GGXQViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ggxq") as? XL_GGXQViewController
        //添加广告地址
        adVC?.urlstring = notification.userInfo!["webURL"] as! String
        self.navigationController?.pushViewController(adVC!, animated: false)
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
        //MARK:测试
//        let xiadan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
//        self.navigationController?.pushViewController(xiadan!, animated: true)
        
        let xiadan: XL_KuaiDixiadan_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kuaidixiadan") as? XL_KuaiDixiadan_ViewController
        self.navigationController?.pushViewController(xiadan!, animated: true)
    }
    //MARK:下边整体界面 除了商城
    func xiajiemian() {
        switch daohang {
        case 1?:
            jiqujianView.isHidden = false
            shangtuPutlet.image = UIImage(named:"ji")
            xiatuOutlet.image = UIImage(named:"shou")
            shDZOutlet.text = weizhi
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
            xiaDZOutlet.text = weizhi
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
            VV.addSubview(jingxuan)
            return VV
        }
        return nil
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
            return 8
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
            let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(view1Action(sender:)))
            View1.addGestureRecognizer(tapGR1)
            View1.backgroundColor = UIColor.red
            
            let View2 = UIImageView(frame: CGRect(x: Width/3, y: 0, width: Width*2/3, height: 74))
            let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(view2Action(sender:)))
            View2.addGestureRecognizer(tapGR2)
            View2.backgroundColor = UIColor.blue
            
            let View3 = UIImageView(frame: CGRect(x: Width/3, y: 75, width: Width/3 - 1, height: 75))
            let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(view3Action(sender:)))
            View3.addGestureRecognizer(tapGR3)
            View3.backgroundColor = UIColor.green
            
            let View4 = UIImageView(frame: CGRect(x: Width*2/3, y: 75, width: Width/3, height: 75))
            let tapGR4 = UITapGestureRecognizer(target: self, action: #selector(view4Action(sender:)))
            View4.addGestureRecognizer(tapGR4)
            View4.backgroundColor = UIColor.orange
            
            cell.contentView.addSubview(View4)
            cell.contentView.addSubview(View3)
            cell.contentView.addSubview(View2)
            cell.contentView.addSubview(View1)
            
        }
        if indexPath.section == 3 {
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
        }
        //(cityList?[indexPath.row] as! NSDictionary).value(forKey: "cityname") as? String
        //        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            print(indexPath.row)
        }
    }
    @objc func view1Action(sender: UITapGestureRecognizer) {
        print("红色")
    }
    @objc func view2Action(sender: UITapGestureRecognizer) {
        print("蓝色")
    }
    @objc func view3Action(sender: UITapGestureRecognizer) {
        print("绿色")
    }
    @objc func view4Action(sender: UITapGestureRecognizer) {
        print("橘黄色")
    }
    func scrollViewUI() -> (UIScrollView) {
        let scroll = UIScrollView();
        scroll.tag = 999994
//        scroll.backgroundColor = UIColor.gray
        let tuhuaArray: Array = ["广告页","启动页","广告页","启动页","广告页","启动页","广告页"]
        scroll.frame = CGRect(x: 0, y: 0, width: Width - 0, height: 120)  //设置scrollview的大小
        scroll.contentSize = CGSize(width: 100 * tuhuaArray.count, height: 0)   //内容大小
        scroll.isPagingEnabled = false                 //是否支持分页
        scroll.isUserInteractionEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        for i:Int in 0..<tuhuaArray.count {
            let imageView =  UIImageView(image: UIImage(named: tuhuaArray[i]))
            imageView.frame = CGRect(x: Int((Width - 20) / 4) * i + 10, y:10, width: Int((Width - 20) / 4 - 10), height: 130)
            imageView.tag = 600 + i
            imageView.isUserInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(DianjiTuPian(sender:)))
            imageView.addGestureRecognizer(tapGR)
            scroll.addSubview(imageView)
        }
        return scroll
    }
    @objc func DianjiTuPian(sender: UITapGestureRecognizer) {
        let imageView: UIImageView = sender.view as! UIImageView
        //跳页到 imageView.tag - 600 的页面
        print(imageView.tag - 600)
        let DP: XL_DPliebiaoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpliebiao") as? XL_DPliebiaoViewController
        self.navigationController?.pushViewController(DP!, animated: true)
        
    }
    //MARK: searchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let sousuo: XL_SCsousuoViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scsousuo") as? XL_SCsousuoViewController
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
                //当前位置显示的
                self.weizhi = State + city + (SubLocality as String) + Street
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
        shangjiemian()
        xiajiemian()
    }
    
    @IBAction func qujianButton(_ sender: Any) {
        daohang = 2
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
        
        let textLength = text.characters.count + string.characters.count - range.length
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
}
extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
