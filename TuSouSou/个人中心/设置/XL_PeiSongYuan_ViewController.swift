//
//  XL_PeiSongYuan_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/7/14.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_PeiSongYuan_ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    
    @IBOutlet weak var tablepeisong: UITableView!
    
    var qiyeDic:[String:String] = [:]
    
    let zuoArr:[String] = ["真实姓名:","身份证号:"]
    let youArr:[String] = ["请填写真实姓名","请填写身份证号"]
    
    var imageDic:[String : Any] = [:]
    var isSHX = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDelegate()
        self.title = "配送员申请"
        // Do any additional setup after loading the view.
    }

    func tableDelegate() {
        tablepeisong.delegate = self
        tablepeisong.dataSource = self
        tablepeisong.tableFooterView = UIView()
        tablepeisong.register(UITableViewCell.self, forCellReuseIdentifier: "peisong")
        tablepeisong.backgroundColor = UIColor(hexString: "f0eff5")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 2
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
        let cellString = "peisong"
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
                xiazi.text = "上传身份证照片"
                if nil != imageDic["shang"] {
                    imageView.image = imageDic["shang"] as? UIImage
                }
            }else if indexPath.row == 1{
                xiazi.text = "上传手持身份证半身照"
                if nil != imageDic["xia"] {
                    imageView.image = imageDic["xia"] as? UIImage
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 16
        }
        return 0
    }
    //MARK: textfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField.tag == 331 {
            if newString.length > 18 {
                return false
            }
        }
        qiyeDic["\(textField.tag - 330)"] = newString
        return true
    }
    @objc func queding() {
        print("调接口")
        peisongyuanjiekou()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 331 {
            if !textField.text!.chk18PaperId() {
                self.view.endEditing(true)
                textField.text = ""
                XL_waringBox().warningBoxModeText(message: "请输入正确的身份证号,如果X需大写哟～", view: self.view)
                return false
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        qiyeDic["\(textField.tag - 330)"] = textField.text!
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag != 330 + 1 {
            let index = IndexPath(row: textField.tag - 330 + 1, section: 0)
            let cell = tablepeisong.cellForRow(at: index)
            (cell?.viewWithTag(textField.tag + 1) as! UITextField).becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
        return true
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
            }
            tablepeisong.reloadData()
        }
    }
    func peisongyuanjiekou() {
        let method = "/distribution/attestation2"
//        let userId:String = userDefaults.value(forKey: "userId") as! String
        var xxxx = 0
        if nil != imageDic["shang"] && nil != imageDic["xia"] {
            let imagearr:[Any] = [imageDic["shang"]!,imageDic["xia"]!]
            let namearr:[Any] = ["idCardPic1","bareheadedPhoto"]
            let keyArr = ["cityName","mobile","realName","idNumber"]
            let cityName = userDefaults.value(forKey: "cityName") as! String
            let mobile = userDefaults.value(forKey: "phone")as! String
            var valueArr = [cityName,mobile]
            for i in 0..<2 {
                if nil != qiyeDic["\(i)"]{
                    valueArr.append(qiyeDic["\(i)"]!)
                }else{
                    xxxx = 1
                    valueArr.append("")
                }
            }
            if xxxx == 1  {
                XL_waringBox().warningBoxModeText(message: "请填写完整信息！", view: self.view)
            }else{
                XL_waringBox().warningBoxModeIndeterminate(message: "申请中...", view: self.view)
                XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, keyArray: keyArr, valueArray: valueArr, methodName: method, success: { (res) in
                    XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
                    if (res as! [String: Any])["code"] as! String == "0000" {
                        XL_waringBox().warningBoxModeText(message: "提交成功", view: self.view)
                        userDefaults.set(2, forKey: "attestation")
                        self.navigationController?.popViewController(animated: true)
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
        }else{
            XL_waringBox().warningBoxModeText(message: "请选择必要照片！", view: self.view)
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
