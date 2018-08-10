//
//  XL_GuanggaoViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/13.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//
//广告页
import UIKit

class XL_GuanggaoViewController: UIViewController {
    @IBOutlet weak var bigImg: UIImageView!
    var guanggaoUrl: String?
    var isTrue = 0
    
    @IBOutlet weak var timebutton: UIButton!
    //延迟15s
    private var time:TimeInterval = 3.0
    
    private var cuntdownTimer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        qidong()
        timebutton.setTitle("3s", for: .normal)
        timebutton.backgroundColor = UIColor.lightGray
        timebutton.setTitleColor(UIColor.white, for: .normal)
        timebutton.clipsToBounds = true
        timebutton.layer.cornerRadius = 22
        
        //倒计时
        cuntdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    func qidong() {
        let Name = "/set/startPage"
        let dic:Dictionary = ["userId":"100"]
        
        XL_QuanJu().PuTongWangluo(methodName: Name, methodType: .post, rucan: dic, success: { (res) in
            let data:[String : Any] = (res as! [String: Any])["data"] as! [String : Any]
            if (res as! [String: Any])["code"] as! String == "0000" {
                let url  = "\(TupianUrl)\(data["image"] as! String)"
                self.donghua(url_str: url)
                self.guanggaoUrl = data["url"] as? String
                self.isTrue = 1
                userDefaults.set(data["isOpen"] as! Int, forKey: "isoopp")
            }
        }) { (error) in
            print(error)
        }
    }
    func donghua(url_str:String) {
        let url: URL = URL(string: url_str)!
        bigImg.sd_setImage(with: url, placeholderImage: UIImage(named: "welcome"), options: SDWebImageOptions.progressiveDownload, completed: nil)
    }
    @objc func updateTime(){
        time -= 1
        if time < 0 {
            cuntdownTimer?.invalidate()
            let ShouVC : XL_Navi_ViewController! = storyboard!.instantiateViewController(withIdentifier: "Navi") as! XL_Navi_ViewController
            let delegate = UIApplication.shared
            delegate.keyWindow?.rootViewController = ShouVC
            //            delegate.keyWindow?.makeKeyAndVisible()
            //            let leftVC = XL_LeftMenuViewController()
            //            let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            //            let delegate = UIApplication.shared
            //            delegate.keyWindow?.rootViewController = XL_DrawerViewController(mainVC: tabBarVC!, leftMenuVC: leftVC, leftWidth: 300)
        }
        timebutton.setTitle(String(format:"%.fs",time), for: .normal)
    }
    //点击直接跳转
    @IBAction func zhijietiao(_ sender: Any) {
        cuntdownTimer?.invalidate()
        //        let leftVC = XL_LeftMenuViewController()
        //        let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        //        let delegate = UIApplication.shared
        //        delegate.keyWindow?.rootViewController = XL_DrawerViewController(mainVC: tabBarVC!, leftMenuVC: leftVC, leftWidth: 300)
        let ShouVC : XL_Navi_ViewController! = storyboard!.instantiateViewController(withIdentifier: "Navi") as! XL_Navi_ViewController
        let delegate = UIApplication.shared
        delegate.keyWindow?.rootViewController = ShouVC
    }
    @IBAction func tiaoXQ(_ sender: Any) {
        //延时1秒执行
        if isTrue == 1 {
            zhijietiao(sender)
            let time: TimeInterval = 0.001
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                NotificationCenter.default.post(name: NSNotification.Name("pushtoad"), object: self, userInfo: ["webURL":self.guanggaoUrl!])
            }
        }
    }
}
