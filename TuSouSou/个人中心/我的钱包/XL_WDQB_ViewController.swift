//
//  XL_WDQB_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_WDQB_ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var YuEView: UIView!
    
    @IBOutlet weak var SouSouBiView: UIView!
    
    @IBOutlet weak var XiaoShouView: UIView!
    
    @IBOutlet weak var xiaView: UIView!
    @IBOutlet weak var xiaoshou: UIButton!
    @IBOutlet weak var sousoubi: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的钱包"
        sousoubi.titleLabel?.adjustsFontSizeToFitWidth = true
        xiaoshou.titleLabel?.adjustsFontSizeToFitWidth = true
        ShezhiQian()
        youAnniu()
        
    }
    func ShezhiQian() {
        qian(title: "0.00 元", Iview: YuEView)
        qian(title: "0.0000 个", Iview: SouSouBiView)
        qian(title: "0.00 元", Iview: XiaoShouView)
    }
    func qian(title: String, Iview: UIView) {
        let GuoDu = XL_PaoMaView(frame: CGRect(x: 0, y: 0, width: Iview.frame.size.width, height: Iview.frame.size.height), title: title,color:UIColor.white, Font: 40)
        Iview.addSubview(GuoDu)
    }
    
    func youAnniu() {
        let item = UIBarButtonItem(title:"账单",style: .plain,target:self,action:#selector(YouActio))
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio()  {
        let WDXX: XL_WDzhangdan_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wdzhangdan") as? XL_WDzhangdan_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
    }
    func YinCangJieMian() {
        let yinying = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        yinying.alpha = 0.5
        yinying.backgroundColor = UIColor.darkGray
        let chongzhi = UIView(frame: CGRect(x: 0, y: Height/3, width: Width, height: 2*Height/3))
        yinying.addSubview(chongzhi)
        let chongzhijine = UILabel(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 24))
        chongzhijine.font = UIFont.systemFont(ofSize: 15)
        chongzhijine.textColor = UIColor.darkGray
        chongzhijine.text = "输入充值金额:"
        let shurukuang = UITextField(frame: CGRect(x: 20, y: 56, width: Width - 40, height: 32))
        shurukuang.textAlignment = .center
        shurukuang.placeholder = "请输入充值金额"
        shurukuang.delegate = self
        
        
        
    }
    @IBAction func Chongzhi(_ sender: Any) {
        
    }
    

    @IBAction func Zhuanrang(_ sender: Any) {
        
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
