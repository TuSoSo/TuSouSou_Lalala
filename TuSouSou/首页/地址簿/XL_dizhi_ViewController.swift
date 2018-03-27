//
//  XL_dizhi_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/19.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
import ContactsUI

class XL_dizhi_ViewController: UIViewController,CNContactPickerDelegate{

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
        biao()
        
        
    }
  
    @IBAction func ShiFouAnNiu(_ sender: Any) {
        if shiFouButton.isSelected == true {
            shiFouButton.isSelected = false
        }else{
            shiFouButton.isSelected = true
        }
    }
    
    @IBAction func baiDudiTu(_ sender: Any) {
        let baiduditu: XL_baiduditu_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baiduditu") as! XL_baiduditu_ViewController
        self.navigationController?.pushViewController(baiduditu, animated: true)
    }
    
    @IBAction func queding(_ sender: Any) {
        
        //点击列表给city赋值
        let dic = ["name":"崔海斌","phone":"15545457012","dizhi":"大河向东流"]
        
        if let block = self.dixiang {
            block(dic)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DianHuanBen(_ sender: Any) {
        // 1.创建联系人选择的控制器
        let cpvc = CNContactPickerViewController()
        
        // 2.设置代理
        cpvc.delegate = self
        
        // 3.弹出控制器
        present(cpvc, animated: true, completion: nil)
        
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let lastname = contact.familyName
        let firstname = contact.givenName
        Name.text = "\(lastname)\(firstname)"
        let phones = contact.phoneNumbers
        let xxx = phones[0].value.stringValue
        let xx = xxx.components(separatedBy: NSCharacterSet.init(charactersIn: "0123456789").inverted as CharacterSet).joined()
        
//        NSString *pureNumbers = [[phoneNumberString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
        
        Pone.text = xx
        
//        for phone in phones {
//            let phoneLabel = phone.label
//            let phoneValue = phone.value.stringValue
//            print("phoneValue:\(phoneValue)")
//        }
    }
   
    
    func biao() {
        switch Shei {
        case "jijian"?:
            title(title: "寄件")
        case "shoujian"?:
            title(title: "收件")
        case "qujian"?:
            title(title: "取件")
        default:
            break
        }
    }
    func title(title: String) -> () {
        self.title = "\(title)详址"
        shiFouButton.setTitle("保存到\(title)人地址簿", for: .normal)
        shiFouButton.setTitle("保存到\(title)人地址簿", for: .selected)
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
