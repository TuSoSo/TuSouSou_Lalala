//
//  XL_dizhi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/19.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_dizhi_ViewController: UIViewController{

    var Shei:String?
    
    @IBOutlet weak var shiFouButton: UIButton!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Pone: UITextField!
    @IBOutlet weak var XiangZhi: UITextField!
    @IBOutlet weak var dingweiDZ: UILabel!
    
    typealias Dibody = ([String:String]) -> ()
    var dixiang: Dibody?
    override func viewDidLoad() {
        super.viewDidLoad()

        switch Shei {
        case "jijian"?:
            title(title: "寄件")
        case "shoujian"?:
            title(title: "收件")
        case "qujian"?:
            title(title: "取件")
        case ""?:
            title(title: "空白")
        default:
            break
        }
        
    }
    func title(title: String) -> () {
        self.title = "\(title)详址"
        shiFouButton.setTitle("保存到\(title)人地址簿", for: .normal)
    }
    
    @IBAction func ShiFouAnNiu(_ sender: Any) {
    }
    
    @IBAction func baiDudiTu(_ sender: Any) {
    }
    
    @IBAction func DianHuanBen(_ sender: Any) {
    }
    @IBAction func queding(_ sender: Any) {
        
        //点击列表给city赋值
        let dic = ["name":"崔海斌","phone":"15545457012","dizhi":"大河向东流"]
        
        if let block = self.dixiang {
            block(dic)
        }
        self.navigationController?.popViewController(animated: true)
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
