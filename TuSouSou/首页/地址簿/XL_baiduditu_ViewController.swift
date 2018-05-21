//
//  XL_baiduditu_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/19.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_baiduditu_ViewController: UIViewController,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableviewtop: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dituView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    typealias baidudizhi = (String) -> ()
    var baidudizhi: baidudizhi?
    
    //地图视图
    var _mapView: BMKMapView!
    //定位
    var _locService: BMKLocationService!
    //大头针
    var pointAnnotation: BMKPointAnnotation!
    //周边检索
    var _poisearch: BMKPoiSearch!
    //周边信息
    var _geocodesearch: BMKGeoCodeSearch!
    //是否第一次调地图
    var isFirst: Bool = true
    //周围信息列表
    var poiLisrArray: [[String]] = []
    //当前城市
    var city: String!
    
    
    override func viewDidLoad() {
        initMapUI()
        initSearchBar()
        tableviewDelegate()
        //        self.navigationController?.navigationBar.isTranslucent = false
    }
    func initMapUI() {
        _mapView = BMKMapView.init(frame: CGRect(x: 0, y: 0, width: dituView.frame.size.width, height: dituView.frame.size.height))
        _mapView.zoomLevel = 18
        _mapView.userTrackingMode = BMKUserTrackingModeNone
        _mapView.showsUserLocation = true
        dituView.addSubview(_mapView)
        _locService = BMKLocationService()
        _locService.delegate = self
        _locService.startUserLocationService()
        _geocodesearch = BMKGeoCodeSearch()
        _poisearch = BMKPoiSearch()
    }
    func tableviewDelegate()  {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        }
//        tableView.addConstraints(<#T##constraints: [NSLayoutConstraint]##[NSLayoutConstraint]#>)
//        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(myAddressLabel.mas_bottom);
//            make.left.right.bottom.mas_offset(0);
//            }];
    }
    func initSearchBar()  {
        searchBar.delegate = self
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        //        searchBar.placeholder = "搜索"
        searchBar.showsCancelButton = true
        searchBar.alpha = 0.5
        (searchBar.value(forKey: "cancelButton") as! UIButton).setTitle("取消", for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        _mapView.viewWillAppear()
        _mapView.delegate = self
        _locService.delegate = self
        _geocodesearch.delegate = self;
        _poisearch.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        _mapView.viewWillDisappear()
        _mapView.delegate = nil
        _locService.delegate = nil;
        _geocodesearch.delegate = nil;
        _poisearch.delegate = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        customLocationAccurayCircle()
    }
    //MARK:百度地图定位及周边
    func didUpdate(_ userLocation: BMKUserLocation!) {
        _mapView.updateLocationData(userLocation)
        if isFirst == true {
            _mapView.centerCoordinate = _locService.userLocation.location.coordinate
            self.sousuo(la: userLocation.location.coordinate.latitude, lo: userLocation.location.coordinate.longitude)
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation.location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if (placemarks?.count)! > 0{
                let placemark = placemarks![0]
                self.city = placemark.locality
            }
        }
        
        _locService.stopUserLocationService()
    }
    func dealloc() {
        if _geocodesearch != nil {
            _geocodesearch = nil
        }
        if _mapView != nil {
            _mapView = nil
        }
    }
    //搜索周边信息（根据一点）
    func sousuo(la: Double, lo: Double) {
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(la, lo)
        let array = _mapView.annotations
        _mapView.removeAnnotations(array)
        pointAnnotation = BMKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(la, lo)
        _mapView.addAnnotation(pointAnnotation)
        //发送反编码请求.并返回是否成功
        let flag = _geocodesearch.reverseGeoCode(reverseGeocodeSearchOption)
        
        if (flag)
        {
            print("反geo检索发送成功")
        } else {
            print("反geo检索发送失败")
        }
    }
    //大头针设置
    func customLocationAccurayCircle() {
        let param: BMKLocationViewDisplayParam = BMKLocationViewDisplayParam()
        param.accuracyCircleStrokeColor = UIColor.purple
        param.accuracyCircleFillColor = UIColor.red
    }
    //地图移动（取地图中间点搜索周边信息）
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        if isFirst == false {
            var regron = BMKCoordinateRegion()
            let centerCoordinate: CLLocationCoordinate2D = mapView.region.center
            regron.center = centerCoordinate
            self.sousuo(la: regron.center.latitude, lo: regron.center.longitude)
        }else{
            isFirst = false
        }
    }
    //大头针更新
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let AnnotationViewID = "disanjk"
        //        var AnnotationView: BMKAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID)
        //        if AnnotationView.isEqual(nil) {
        let  AnnotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: AnnotationViewID)
        AnnotationView?.pinColor = UInt(BMKPinAnnotationColorPurple)
        AnnotationView?.animatesDrop = true
        //        }
        AnnotationView?.centerOffset = CGPoint(x: 0, y: -((AnnotationView?.frame.size.height)!/2))
        AnnotationView?.canShowCallout = true
        AnnotationView?.annotation = annotation
        return AnnotationView
    }
    //周边信息返回
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        print(result.address)
    }
    //周边信息反编译
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        poiLisrArray.removeAll()
        let array: Array = result.poiList
        for i in 0..<array.count {
            poiLisrArray.append([(array[i] as AnyObject).name, (array[i] as AnyObject).address])
        }
        print(poiLisrArray)
        //tableview 滑动到顶部
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tableviewtop.constant = 0.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.tableView.reloadData()
        }
    }
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        _mapView.updateLocationData(userLocation)
    }
    
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if errorCode == BMK_SEARCH_NO_ERROR {
            poiLisrArray.removeAll()
            if poiResult.poiInfoList.count != 0 {
            for i in 0..<poiResult.poiInfoList.count{
                var poi: BMKPoiInfo!
                poi = poiResult.poiInfoList[i] as! BMKPoiInfo
                print("\(poi.name)\n\(poi.address)")
                poiLisrArray.append([poi.address,poi.name])
            }
            tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            tableviewtop.constant = (-self.view.frame.height/2 + 94.0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                
                self.tableView.reloadData()
            }
            }else{
                XL_waringBox().warningBoxModeText(message: "搜索不到\(searchBar.text as! String)", view: self.view)
            }
        }
        else{
            XL_waringBox().warningBoxModeText(message: "搜索不到\(searchBar.text as! String)", view: self.view)
        }
    }
    
    //MARK：tableview delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poiLisrArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "choosedizhi"
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellString)!
        if cell.isEqual(nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellString)
        }
        
        let Name: UILabel = cell.viewWithTag(201) as! UILabel
        let address: UILabel = cell.viewWithTag(202) as! UILabel
        if poiLisrArray.count > indexPath.row {
            Name.text = poiLisrArray[indexPath.row][0]
            address.text = poiLisrArray[indexPath.row][1]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = "\(poiLisrArray[indexPath.row][0])_\(poiLisrArray[indexPath.row][1])"
        
        if let block = self.baidudizhi {
            block(str)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    //MARK: SearchBar Delegate
    ///实时监控输入的文字
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.alpha = 1
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let citySearchOption = BMKCitySearchOption()
        citySearchOption.pageIndex = 0
        citySearchOption.pageCapacity = 50
        citySearchOption.city = city
        citySearchOption.keyword = searchBar.text
        let flag: Bool = _poisearch.poiSearch(inCity: citySearchOption)
        if flag {
            print("POI成功")
        }else{
            print("POI失败")
        }
        searchBar.resignFirstResponder()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.alpha = 0.5
        searchBar.resignFirstResponder()
        tableviewtop.constant = 0.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.tableView.reloadData()
        }
    }
    ///文字过滤后放入显示框
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
}
