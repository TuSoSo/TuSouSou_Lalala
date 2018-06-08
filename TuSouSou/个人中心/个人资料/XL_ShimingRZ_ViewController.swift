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
        }
    }
    @IBAction func queren(_ sender: Any) {
        //还要判断是否照相了
        if nameTF.text?.count == 0 || IDTF.text?.count == 0  || isZhao == 0{
            XL_waringBox().warningBoxModeText(message: "请完善信息！", view: self.view)
        }else{
            //调认证接口
            print("通了")
        }
    }
}
