//
//  XL_huanjing_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/7/10.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_huanjing_ViewController: UIViewController {

    var picture = ""
    
    @IBOutlet weak var tupian2: UIImageView!
    @IBOutlet weak var tupian1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "店铺环境"
        if picture.count > 0 {
            let arr:[String] = picture.components(separatedBy: ";")
            zhaop(arr: arr)
        }
        // Do any additional setup after loading the view.
    }
    func zhaop(arr:[String]) {
        var jiee = ""
        
        jiee = arr[0]
        
        //        let uul = URL(string: TupianUrl + jiee)
        let newString = TupianUrl + jiee
        let uuu:URL = URL(string: String(format: "%@",newString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
        tupian1.sd_setImage(with: uuu, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
        var jiee1 = ""
        jiee1 = arr[1]
        let newString1 = TupianUrl + jiee1
        let uul1:URL = URL(string: String(format: "%@",newString1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))!
        tupian2.sd_setImage(with: uul1, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: nil)
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
