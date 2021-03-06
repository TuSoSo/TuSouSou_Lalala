//
//  XL_dizhi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/19.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
import ContactsUI

class XL_dizhi_ViewController: UIViewController,CLLocationManagerDelegate,CNContactPickerDelegate,UITextFieldDelegate{
    var lon = ""
    var lat = ""
    var type = ""
    
    var didizhi = ""
    var xiangqing = ""
    var namename = ""
    var diandianhua = ""
    
    var Shei:String?
    var locationManager = CLLocationManager()
    @IBOutlet weak var shiFouButton: UIButton!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Pone: UITextField!
    @IBOutlet weak var XiangZhi: UITextField!
    @IBOutlet weak var dingweiDZ: UILabel!
    
    typealias Dibody = ([String:String]) -> ()
    var dixiang: Dibody?
    override func viewDidLoad() {
        super.viewDidLoad()
        biao()
       
        Pone.keyboardType = .numberPad
        Name.text = namename
        Name.delegate = self
        Pone.text = diandianhua
        XiangZhi.text = xiangqing
        if didizhi == "" {
            dingweiDZ.text = "请选择地址"
        }else{
            dingweiDZ.text = didizhi
        }
//        loadLocation()
//        shiFouButton.isSelected = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case XiangZhi:
            XiangZhi.resignFirstResponder()
            Name.becomeFirstResponder()
        case Name:
            Name.resignFirstResponder()
            Pone.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == Pone {
            if newString.count > 11 {
                return false
            }
        }
        if textField == Name {
            if newString.count > 10 {
                return false
            }
        }
        return true
    }
    @IBAction func ShiFouAnNiu(_ sender: Any) {
        if shiFouButton.isSelected == true {
            shiFouButton.isSelected = false
        }else{
            shiFouButton.isSelected = true
        }
    }
    
    @IBAction func baiDudiTu(_ sender: Any) {
        let baiduditu: XL_baiduditu_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baiduditu") as! XL_baiduditu_ViewController
        baiduditu.baidudizhi = {(baidudizhi: [String:String]) in
                self.dingweiDZ.text = baidudizhi["dizhi"]
                self.lon = baidudizhi["lon"]!
                self.lat = baidudizhi["lat"]!
        }
        self.navigationController?.pushViewController(baiduditu, animated: true)
    }
    
    @IBAction func queding(_ sender: Any) {
        if dingweiDZ.text == "请选择地址" {
            XL_waringBox().warningBoxModeText(message: "请选择地址！", view: self.view)
        }else if Name.text?.count == 0 || dingweiDZ.text?.count == 0 {
            XL_waringBox().warningBoxModeText(message: "请完善信息！", view: self.view)
        }else if  !(Pone.text?.isPhoneNumber())!{
            XL_waringBox().warningBoxModeText(message: "请填写正确的手机号！", view: self.view)
        }else {
            //点击列表给city赋值
            let dic = ["name": Name.text!,"phone": Pone.text!,"dizhi": dingweiDZ.text!,"xiangzhi": XiangZhi.text!,"lat": lat,"lon": lon]
            
            if let block = self.dixiang {
                block(dic)
            }
            //判断是否调用保存接口
            if shiFouButton.isSelected == false{
                //调接口
                diaojiekou()
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func isJiabaliu(string:String) -> Bool {
        if string.contains("+ 86") {
            return true
        }
        return false
    }
    func diaojiekou() {
        let method = "/address/addressManager"
        let userId = userDefaults.value(forKey: "userId")
        var shang = Pone.text!
        
        if isJiabaliu(string: Pone.text!){
            shang = Pone.text!.substring(fromIndex: 4)
        }
        
        let dic:[String:Any] = ["userId":userId!,"location":dingweiDZ.text!,"address":XiangZhi.text!,"userName":Name.text!,"type":type,"phone":shang,"longitude":lon,"latitude":lat]
        XL_waringBox().warningBoxModeIndeterminate(message: "保存信息...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "保存成功", view: self.view)
                self.navigationController?.popViewController(animated: true)
                
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
    @IBAction func DianHuanBen(_ sender: Any) {
        // 1.创建联系人选择的控制器
        let cpvc = CNContactPickerViewController()
        
        // 2.设置代理
        cpvc.delegate = self
        
        // 3.弹出控制器
        present(cpvc, animated: true, completion: nil)
        
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        //去符号
        let lastname = contact.familyName
        let firstname = contact.givenName
        Name.text = "\(lastname)\(firstname)"
        let phones = contact.phoneNumbers
        let xxx = phones[0].value.stringValue
        var xx = xxx.components(separatedBy: NSCharacterSet.init(charactersIn: "0123456789").inverted as CharacterSet).joined()
        //去86
        if xx.count != 11 {
            print(xx)
            let startIndex = xx.index(xx.startIndex, offsetBy: 1)
            xx.removeSubrange(...startIndex)
        }
        Pone.text = xx
    }
    
    
    func biao() {
        switch Shei {
        case "jijian"?:
            title(title: "寄件")
            type = "2"
        case "shoujian"?:
            title(title: "收件")
            type = "1"
        case "qujian"?:
            title(title: "取件")
            type = "3"
        default:
            break
        }
    }
    func title(title: String) -> () {
        self.title = "\(title)详址"
        shiFouButton.setTitle("保存到\(title)人地址簿", for: .normal)
        shiFouButton.setTitle("保存到\(title)人地址簿", for: .selected)
        Name.placeholder = "\(title)人姓名"
        Pone.placeholder = "\(title)人电话"
    }
//    //MARK: 原生定位初始化
//    func loadLocation() {
//        locationManager.delegate = self
//        //定位方式
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        //更新距离
//        locationManager.distanceFilter = 100
//        //发出授权请求
//        locationManager.requestAlwaysAuthorization()
//
//        if (CLLocationManager.locationServicesEnabled()){
//            //允许使用定位服务的话，开始定位服务更新
//            locationManager.startUpdatingLocation()
//            print("定位开始")
//
//        }else{
//            print("权限未开启")
//        }
//    }
//    //    MARK:定位代理实现
//
//    //获取定位信息
//    var currLocation: CLLocation?
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //取得locations数组的最后一个
//        currLocation = locations.last!
//        if self.lon == "" {
//            lon = (currLocation?.coordinate.longitude.description)!
//        }
//        if self.lat == "" {
//            lat = (currLocation?.coordinate.latitude.description)!
//        }
//
//
//        LonLatToCity()
//        //停止定位
//        locationManager.stopUpdatingLocation()
//    }
//
//    //出现错误
//    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
//        print(error as Any)
//    }
//
//    ///将经纬度转换为城市名
//    func LonLatToCity(){
//        let geocoder: CLGeocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation((currLocation)!) { (placemark, error) -> Void in
//            
//            if(error == nil)
//            {
//                let array = placemark! as NSArray
//                let mark = array.firstObject as! CLPlacemark
//                //省
//                let State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
//                //区
//                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
//                //城市
//                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
//                //街道
//                let Street: String = (mark.addressDictionary! as NSDictionary).value(forKey: "Street") as! String
//                //当前位置显示的
//                let weizhi = State + city + (SubLocality as String) + Street
//                if self.didizhi == "" {
//                    self.dingweiDZ.text = weizhi
//                }
//            }
//            else
//            {
//                print(error as Any)
//            }
//        }
//    }
    override func viewWillDisappear(_ animated: Bool) {
          self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
