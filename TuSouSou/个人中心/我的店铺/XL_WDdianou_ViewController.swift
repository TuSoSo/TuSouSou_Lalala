//
//  XL_WDdianou_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDdianou_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的店铺"
        // Do any additional setup after loading the view.
    }

    @IBAction func dingdanshezhi(_ sender: Any) {
        let WDXX: XL_DDGL_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ddgl") as? XL_DDGL_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
    }
    @IBAction func shangpinshezhi(_ sender: Any) {
        let WDXX: XL_SPGL_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spgl") as? XL_SPGL_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
    }
    @IBAction func dianpushizhe(_ sender: Any) {
        
        let WDXX: XL_DPSZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpsz") as? XL_DPSZ_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
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
