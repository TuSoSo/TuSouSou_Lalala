//
//  XL_baiduditu_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/19.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_baiduditu_ViewController: UIViewController,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate {
    //地图视图
    var _mapView: BMKMapView?
    //POI检索
    var _searcher: BMKPoiSearch?
    //大头针
    var pointAnnotation: BMKPointAnnotation?
    
    //定位
    var locationService : BMKLocationService!
    var geoCodeSearch : BMKGeoCodeSearch!
    var lat = Double()
    var lon = Double()
    //下列表数据
    var array: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage(named:"")
        
        _mapView?.viewWillAppear()
        _mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        geoCodeSearch.delegate = self
        locationService.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil // 不用时，置nil
        geoCodeSearch.delegate = nil
        locationService.delegate = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        customLocationAccurayCircle()
        addpointAnnotation()
    }
    func initUI() {
        //定位
        geoCodeSearch = BMKGeoCodeSearch()
        locationService = BMKLocationService()
        locationService.startUserLocationService()
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        _mapView?.delegate = self
        locationService.delegate = self
        
        
        //以下_mapView为BMKMapView对象
        _mapView?.showsUserLocation = true;//显示定位图层
        _mapView?.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
        _mapView?.zoomLevel = 20
        refreshView()
    }
    func refreshView() {
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
            
        }
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {

        //那么定位点置中
        _mapView?.centerCoordinate = locationService.userLocation.location.coordinate;
        locationService.stopUserLocationService()
        self.lat = userLocation.location.coordinate.latitude
        self.lon = userLocation.location.coordinate.longitude
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(self.lat, self.lon)
       
        print("目标位置:\(self.lat)\(self.lon)")
        //发送反编码请求.并返回是否成功
        let flag = geoCodeSearch.reverseGeoCode(reverseGeocodeSearchOption)

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
    //添加大头针
    func addpointAnnotation() {
        pointAnnotation = BMKPointAnnotation()
        var coor = CLLocationCoordinate2D()
        coor.latitude = self.lat
        coor.longitude = self.lon
        pointAnnotation?.coordinate = coor
        _mapView?.addAnnotation(pointAnnotation)
    }
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let AnnontationViewID = "renameMark"
        let newAnnotation: BMKPinAnnotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: AnnontationViewID)
        //设置颜色
        newAnnotation.pinColor = UInt(BMKPinAnnotationColorPurple)
        //天上掉下效果
        newAnnotation.animatesDrop = true
        //  可拖拽
        newAnnotation.isDraggable = true
        //气泡可弹出
        newAnnotation.canShowCallout = true
        //设置大头针
//        newAnnotation.image = UIImage(named:"location")
        return newAnnotation
        
        
    }
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        print("返回错误信息%@",error)
        
        
        if (error == BMK_SEARCH_NO_ERROR) {
            print("返回正常")
            print(result.address)
            
            //周边信息列表
            for dic in result.poiList {
                print((dic as AnyObject).address)
                array?.add((dic as AnyObject).address)
            }
            
        } else{
            print("返回错误....")
        }
    }

}
