//
//  XL_TiaoShou_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/7.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_TiaoDeng_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    func tiaodenglu(YiDengLu: @escaping(_ result: Any) -> ()) {
        if isDengLu {
            let wanshan: XL_Denglu_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "denglu") as? XL_Denglu_ViewController
            self.navigationController?.pushViewController(wanshan!, animated: true)
        }else{
            let ss = ""
            
            YiDengLu(ss)
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
