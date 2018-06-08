//
//  XL_chengshiListViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/12.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_chengshiListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    //MARK:block反向传值
    typealias CityName = ([String:String]) -> ()
    var Cityblock: CityName?
    func cityblock(block: CityName?) {
        self.Cityblock = block
    }
    
    var locationManager = CLLocationManager()
    var city: String?
    var weizhi:String?
    
    var cityList: [[String:String]]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dangqiancity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocation()
        self.title = "城市列表"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //删除多余行
        tableView.tableFooterView = UIView()
        yikaitongchengshiliebiao()
       
    }
    func yikaitongchengshiliebiao() {
        let method = "/user/openCity"
//        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["":""]
        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "登录成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.cityList = dic["cityList"] as? [[String : String]]
                self.tableView.reloadData()
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    @objc func doc() {
        self.navigationController?.popViewController(animated: true)
    }

    
    //MARK:tableviewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6//cityList!.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "chengshi"
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.textLabel?.text = (cityList![indexPath.row])["cityName"]
//        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //点击列表给city赋值
        if let block = self.Cityblock {
            block(cityList![indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 原生定位初始化
    func loadLocation() {
        locationManager.delegate = self
        //定位方式
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
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
                self.jiemianshang()
            }
            else
            {
                print(error as Any)
            }
        }
    }
    func jiemianshang() {
        dangqiancity.text = self.city
    }

}
