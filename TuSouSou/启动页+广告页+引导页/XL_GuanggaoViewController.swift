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

    @IBOutlet weak var timebutton: UIButton!
    //延迟15s
    private var time:TimeInterval = 3.0
    
    private var cuntdownTimer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bigImg.image = UIImage(named: "广告页")
        timebutton.setTitle("3s", for: .normal)
        timebutton.backgroundColor = UIColor.lightGray
        timebutton.setTitleColor(UIColor.white, for: .normal)
        timebutton.clipsToBounds = true
        timebutton.layer.cornerRadius = 22
        
        //倒计时
        cuntdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
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
        zhijietiao(sender)
        //延时1秒执行
        let time: TimeInterval = 0.001
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
             NotificationCenter.default.post(name: NSNotification.Name("pushtoad"), object: self, userInfo: ["webURL":"www.baidu.com"])
        }
       
    }
}
