//
//  XL_QiyeRZ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/1.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_QiyeRZ_ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var yyy = 0
    
    var qiyeDic:[String:String] = [:]
    
    let zuoArr:[String] = ["企业名称:","企业地址:","法人姓名:","身份证号:","执照编号:","联系人姓名:","联系人电话:"]
    let youArr:[String] = ["请填写企业名称","请填写企业地址","请填写法人姓名","请填写身份证号","请填写执照编号","请填写联系人姓名","请填写联系人电话"]

    var imageDic:[String : Any] = [:]
    var isSHX = 0
    
    
    @IBOutlet weak var tableQiye: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDelegate()
        self.title = "企业认证"
//        if yyy == 1 {
//            //左上角为X
//            fanhuidaoRoot()
//        }
    }
//    func fanhuidaoRoot() {
//        let leftBarBtn = UIBarButtonItem(title: "X", style: .plain, target: self,action: #selector(backToPrevious))
//        self.navigationItem.leftBarButtonItem = leftBarBtn
//    }
//    @objc func backToPrevious()  {
//
//    }
    //MARK:tableviewDelegate
    func tableDelegate() {
        tableQiye.delegate = self
        tableQiye.dataSource = self
        tableQiye.tableFooterView = UIView()
        tableQiye.register(UITableViewCell.self, forCellReuseIdentifier: "qiyerz")
        tableQiye.backgroundColor = UIColor(hexString: "f0eff5")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        }else if section == 1 {
            if nil != imageDic["xia"]{
                return 3
            }else if nil != imageDic["shang"] {
                return 2
            }else {
                return 1
            }
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 56
        }else if indexPath.section == 1 {
            return 155
        }else{
            return 120
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "qiyerz"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 56))
            view.backgroundColor = UIColor.white
            let zuoLable = UILabel(frame: CGRect(x: 16, y: 12, width: 104, height: 32))
            zuoLable.text = zuoArr[indexPath.row]
            zuoLable.font = UIFont.systemFont(ofSize: 15)
            let youTF: UITextField = UITextField(frame: CGRect(x: 112, y: 12, width: Width - 128, height: 32))
            youTF.textColor = UIColor.darkGray
            youTF.tag = indexPath.row + 330
            youTF.delegate = self
            if nil != qiyeDic["\(indexPath.row)"]{
                youTF.text = qiyeDic["\(indexPath.row)"]!
            }
            youTF.placeholder = youArr[indexPath.row]
            view.addSubview(zuoLable)
            view.addSubview(youTF)
            cell.contentView.addSubview(view)
        }else if indexPath.section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 150))
            view.backgroundColor = UIColor.white
            let imageView = UIImageView(frame:CGRect(x: Width/4, y: 8, width: Width/2, height: 118))
            let xiazi = UILabel(frame: CGRect(x: 20, y: 132, width: Width - 40, height: 20))
            xiazi.textAlignment = .center
            xiazi.font = UIFont.systemFont(ofSize: 15)
            xiazi.textColor = UIColor.darkGray
            imageView.image = UIImage(named: "shoppicture")
            //互动
            /////设置允许交互属性
            imageView.isUserInteractionEnabled = true
            
            /////添加tapGuestureRecognizer手势
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick(sender:)))
            imageView.addGestureRecognizer(singleTapGesture)
            singleTapGesture.view!.tag = indexPath.row
            imageView.contentMode = .scaleAspectFit
            if indexPath.row == 0 {
                xiazi.text = "上传法人照片"
                if nil != imageDic["shang"] {
                    imageView.image = imageDic["shang"] as? UIImage
                }
            }else if indexPath.row == 1{
                xiazi.text = "上传营业执照"
                if nil != imageDic["xia"] {
                    imageView.image = imageDic["xia"] as? UIImage
                }
            }else {
                xiazi.text = "上传法人身份证"
                if nil != imageDic["fa"] {
                    imageView.image = imageDic["fa"] as? UIImage
                }
            }
            view.addSubview(xiazi)
            view.addSubview(imageView)
            cell.contentView.addSubview(view)
        }else{
            //确认按钮
            let button = UIButton(frame: CGRect(x: 20, y: 48, width: Width - 40, height: 64))
            button.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
            button.setBackgroundImage(UIImage(named: "button_normal_light"), for: .highlighted)
            button.setTitle("确认", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(queding), for: .touchUpInside)
            //            button.isUserInteractionEnabled = true
            //去掉当前cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            cell.backgroundColor = UIColor(hexString: "f0eff5")
            cell.contentView.addSubview(button)
        }
        cell.selectionStyle = .none
        return cell
    }
    //MARK: textfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField.tag == 333 {
            if newString.length > 18 {
                return false
            }
        }
        if textField.tag == 336 {
            if newString.length > 11 {
                return false
            }
        }
        qiyeDic["\(textField.tag - 330)"] = newString
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 333 {
            if !textField.text!.chk18PaperId() {
                textField.text = ""
                self.view.endEditing(true)
                XL_waringBox().warningBoxModeText(message: "请输入正确的身份证号,如果X需大写哟～", view: self.view)
                return false
            }
        }
        if textField.tag == 336 {
            if !textField.text!.isPhoneNumber() {
                textField.text = ""
                XL_waringBox().warningBoxModeText(message: "请输入正确的手机号", view: self.view)
                return false
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        qiyeDic["\(textField.tag - 330)"] = textField.text!
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag != 330 + 6 {
            let index = IndexPath(row: textField.tag - 330 + 1, section: 0)
            let cell = tableQiye.cellForRow(at: index)
            (cell?.viewWithTag(textField.tag + 1) as! UITextField).becomeFirstResponder()
        }else{
           self.view.endEditing(true)
        }
        return true
    }

    @objc func queding() {
        print("调接口")
        qiyerenzhengjiekou()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    //////手势处理函数
    @objc func imageViewClick(sender:UITapGestureRecognizer) {
        //弹出选择相册、照相
        //选完之后刷新tableview，
        self.view.endEditing(true)
        print(sender.view!.tag)
        if sender.view!.tag == 0 {
            isSHX = 1
        }else if sender.view!.tag == 1{
            isSHX = 2
        }else {
            isSHX = 3
        }
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
        if let photo = info[UIImagePickerControllerEditedImage] as! UIImage?{
            if self.isSHX == 1 {
                self.imageDic["shang"] = photo
            }else if self.isSHX == 2 {
                self.imageDic["xia"] = photo
            }else if self.isSHX == 3 {
                self.imageDic["fa"] = photo
            }
            tableQiye.reloadData()
        }
    }
    func qiyerenzhengjiekou() {
       
        if imageDic.keys.count != 3 {
            XL_waringBox().warningBoxModeText(message: "请拍照必要照片！", view: self.view)
        }else{
            let method = "/user/realAuthentication"
            let userId:String = userDefaults.value(forKey: "userId") as! String
           
            let imagearr:[Any] = [imageDic["shang"]!,imageDic["xia"]!,imageDic["fa"]!]
            let namearr:[Any] = ["FacePic","licensePic","idCardPic1"]
            let keyArr = ["userId","firmName","firmAddress","firmLinkman","idCard","licenseNo","corporation","phone","cityName"]
            var valueArr = [userId]
            var xxxx = 0
            for i in 0..<7 {
                if nil != qiyeDic["\(i)"]{
                    valueArr.append(qiyeDic["\(i)"]!)
                }else{
                    xxxx = 1
                    valueArr.append("")
                }
            }
            valueArr.append(userDefaults.value(forKey: "cityName") as! String)
            if xxxx == 1  {
                XL_waringBox().warningBoxModeText(message: "请填写完整信息！", view: self.view)
            }else{
                XL_waringBox().warningBoxModeIndeterminate(message: "信息提交中...", view: self.view)
                
                XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, keyArray: keyArr, valueArray: valueArr, methodName: method, success: { (res) in
                    XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                    if (res as! [String: Any])["code"] as! String == "0000" {
                        
                        userDefaults.set(2, forKey: "isFirmAdit")
                        if self.yyy == 2 {
                            //跳登陆。或者直接登录
                            //
                            let sheet  = UIAlertController(title: "提示", message: "企业认证资料提交成功，请等待审核，现已可以用此账号进行登录。", preferredStyle: .alert)
                            let queding = UIAlertAction(title: "确定", style: .cancel, handler: { (ss) in
                                for controller: UIViewController in (self.navigationController?.viewControllers)! {
                                    if controller.isKind(of: XL_Denglu_ViewController.self) == true{
                                        let a = controller as! XL_Denglu_ViewController
                                        self.navigationController?.popToViewController(a, animated: true)
                                        
                                    }
                                }
                            })
                            sheet.addAction(queding)
                            self.present(sheet, animated: true, completion: nil)
                        }else if self.yyy == 1 {
                           XL_waringBox().warningBoxModeText(message: "等待审核中～～", view: (self.navigationController?.view)!)
                            self.navigationController?.popToRootViewController(animated: true)
                        }else{
                           XL_waringBox().warningBoxModeText(message: "等待审核中～～", view: (self.navigationController?.view)!)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }else{
                        let Msg = (res as! [String: Any])["msg"] as! String
                        XL_waringBox().warningBoxModeText(message: Msg, view: self.view)
                    }
                }) { (error) in
                    XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                    XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
                    print(error)
                }
            }
        }
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
