//
//  XL_TX_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/29.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_TX_ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var userType = ""
    var lalala = ""
    var withdrawMethod = ""
    var withdrawType = ""
    var xxx = 0
    
    @IBOutlet weak var shoukuanma: UIImageView!
    @IBOutlet weak var zhanghao: UITextField!
    @IBOutlet weak var Name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func tanchu() {
        //弹出选择相册、照相
        //选完之后刷新tableview，
        self.view.endEditing(true)
        let alertController = UIAlertController(title: "照片来源", message: "你可以通过以下方式来获得照片",
                                                preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let paizhaoAction = UIAlertAction(title: "拍照", style: .default) { (ss) in
            print("拍照")
            self.ZHAOXIANG()
        }
        let xiangceAction = UIAlertAction(title: "选择相册", style: .default) { (ss) in
            print("选择相册")
            self.XIANGCE()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(paizhaoAction)
        alertController.addAction(xiangceAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func ZHAOXIANG() {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.cameraDevice = UIImagePickerControllerCameraDevice.front
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            self.present(picker, animated: true, completion: { () -> Void in
                
            })
        }else{
            XL_waringBox().warningBoxModeText(message: "为授予防问相机权限", view: self.view)
        }
    }
    func XIANGCE() {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            XL_waringBox().warningBoxModeText(message: "为授予防问相册权限", view: self.view)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        if let photo = info[UIImagePickerControllerOriginalImage] as! UIImage?{
            xxx = 1
            shoukuanma.image = photo
        }
    }
    @IBAction func queren(_ sender: Any) {
        jiekou()
    }
    func jiekou() {
        if (zhanghao.text?.count)! > 0 && (Name.text?.count)! > 0 && xxx == 1 {
            
            let method = "/distribution/withdrawDeposit"
            let userId = userDefaults.value(forKey: "userId")
            let withdrawMethod = self.withdrawMethod //1 zhifu 2 weixin
            XL_waringBox().warningBoxModeIndeterminate(message: "保存中...", view: self.view)
            let imagearr:[Any] = [shoukuanma.image!]
            let namearr:[Any] = ["withdrawUrl"]
            
            //        let dic:[String:Any] = ["userId":userId,"name":""]
            let keyarr = ["userId","userType","money","withdrawMethod","withdrawCode","withdrawNam","withdrawType"]
            let valuearr:[Any] = [userId!,userType,lalala,withdrawMethod,zhanghao.text!,Name.text!,withdrawType]
            
            
            XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, keyArray: keyarr, valueArray: valuearr, methodName: method, success: { (res) in
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                if (res as! [String: Any])["code"] as! String == "0000" {
                    XL_waringBox().warningBoxModeText(message: "提现成功", view: (self.navigationController?.view)!)
                    self.navigationController?.popViewController(animated: true)
                }
            }) { (error) in
                XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
                print(error)
            }
           
        }else{
            XL_waringBox().warningBoxModeText(message: "请认真填完整信息！", view: self.view)
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
