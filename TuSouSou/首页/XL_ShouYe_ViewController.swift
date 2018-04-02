//
//  XL_ShouYe_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
import CoreLocation

class XL_ShouYe_ViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,UIPopoverPresentationControllerDelegate {
    
    var locationManager = CLLocationManager()
    var city: String?
    var weizhi:String?
    
    var leixingInt: Int?
    
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
                self.xiaDZOutlet.text = "\(diBody["dizhi"] as! String)\(diBody["xiangzhi"] as! String)"
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

    //MARK：侧滑栏
    @IBAction func zuoanniu(_ sender: UIBarButtonItem) {
        XL_DrawerViewController.shareDrawer?.openLeftMenu()
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
        leixingInt = 1
        leixing(lei: leixingInt!)
        daohang = 1
        self.title = ""
        //键盘弹出监听
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(XL_ShouYe_ViewController.keyboardWillChange(_:)),
                                               name: .UIKeyboardWillChangeFrame, object: nil)
        //从广告页跳转到详情
        let name = Notification.Name(rawValue: "pushtoad")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pushToad(notification:)),
                                               name: name, object: nil)
        
        delegate()
        shangjiemian()
        loadLocation()
    }
    @objc func pushToad (notification: NSNotification){
        let adVC: XL_GGXQViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ggxq") as? XL_GGXQViewController
        //添加广告地址
        
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
    }
    //MARK:下边整体界面 除了商城
    func xiajiemian() {
        switch daohang {
        case 1?:
            shangtuPutlet.image = UIImage(named:"ji")
            xiatuOutlet.image = UIImage(named:"shou")
            shDZOutlet.text = weizhi
            xiaDZOutlet.text = "收件人地址"
            xiaName.text = "收件人姓名"
            xiaPhone.text = "收件人电话"
            shangName.text = "寄件人姓名"
            shangPhone.text = "寄件人电话"
        case 2?:
            shangtuPutlet.image = UIImage(named:"qu")
            xiatuOutlet.image = UIImage(named:"shou")
            shDZOutlet.text = "取件人地址"
            shangName.text = "取件人姓名"
            shangPhone.text = "取件人电话"
            xiaDZOutlet.text = weizhi
            xiaName.text = "收件人姓名"
            xiaPhone.text = "收件人电话"
            
        default:
            break
        }
        
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
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
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
        //表头透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
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
    func JianPanhuishou() -> Bool {
        if Pan == 1 {
            self.view.endEditing(true)
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
