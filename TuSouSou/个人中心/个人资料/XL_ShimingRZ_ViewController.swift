//
//  XL_ShimingRZ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/1.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_ShimingRZ_ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var isZhao = 0
    var zhaopian = UIImage()
    
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var phtotImage: UIImageView!
    @IBOutlet weak var IDTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "实名认证"
        nameTF.delegate = self
        IDTF.delegate = self
        phtotImage.isUserInteractionEnabled = true
        IDTF.returnKeyType = .done
        
        /////添加tapGuestureRecognizer手势
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick(sender:)))
        phtotImage.addGestureRecognizer(singleTapGesture)
        phtotImage.contentMode = .scaleAspectFit
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            IDTF.becomeFirstResponder()
        }else {
            IDTF.resignFirstResponder()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func imageViewClick(sender:UITapGestureRecognizer) {
 
        ZHAOXIANG()

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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        if let photo = info[UIImagePickerControllerOriginalImage] as! UIImage?{
            isZhao = 1
            phtotImage.image = photo
            zhaopian = photo
        }
    }
    @IBAction func queren(_ sender: Any) {
        //还要判断是否照相了
        if nameTF.text?.count == 0 || IDTF.text?.count == 0  || isZhao == 0{
            XL_waringBox().warningBoxModeText(message: "请完善信息！", view: self.view)
        }else{
            //调认证接口
            shimingjiekou()
            print("通了")
        }
    }
    func shimingjiekou() {
        let method = "/user/realNameAuthentication"
        let userId:String = userDefaults.value(forKey: "userId") as! String
//        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        let image = zhaopian
        let imagearr:[Any] = [image]
        let namearr:[Any] = ["FacePic"]
        
        let keyArr = ["userId","corporation","idCard"]
        let valueArr = [userId,nameTF.text!,IDTF.text!]
        
        
        XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, keyArray: keyArr, valueArray: valueArr, methodName: method, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "提交成功", view: self.view)
               userDefaults.set("2", forKey: "isRealAuthentication")
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
}
