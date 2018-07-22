//
//  XL_GRziliaoViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/5/28.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_GRziliaoViewController: UIViewController,UITableViewDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate {
    var Dic:[String:Any]? = [:]
    var nameFD = UITextField()
    var imageTou = UIImageView()
    var zhaozhao = 0
    var imageXX = UIImage()
    
    
    @IBOutlet weak var tableGRziliao: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        tableDelegate()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        yonghuxinxichaxun()
    }
    func yonghuxinxichaxun() {
        let method = "/user/findUserInfo"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
//        XL_waringBox().warningBoxModeIndeterminate(message: "登录中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
//                XL_waringBox().warningBoxModeText(message: "登录成功", view: self.view)
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.Dic = dic
                self.renzhengxinxi()
                
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func renzhengxinxi() {
        let method = "/user/approve"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic:[String:Any] = ["userId":userId]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                //实人
                if nil != dic["isAuthentic"]{
                    userDefaults.set(dic["isAuthentic"], forKey: "isRealAuthentication")
                }
                //企业
                if nil != dic["firmAuthentic"]{
                    userDefaults.set(dic["firmAuthentic"], forKey: "isFirmAdit")
                }
                //配送员
                if nil != dic["attestation"] {
                    userDefaults.set(dic["attestation"], forKey: "attestation")
                }
                self.tableGRziliao.reloadData()
            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func tableDelegate() {
        tableGRziliao.delegate = self
        tableGRziliao.dataSource = self
        tableGRziliao.register(UITableViewCell.self, forCellReuseIdentifier: "grziliao")
        tableGRziliao.tableFooterView = UIView()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        }else if section == 1{
            return 2
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 60
            }else{
                return 44
            }
        }else if indexPath.section == 1{
            return 44
        }else{
            return 80
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 8
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 8))
            view.backgroundColor = UIColor(hexString: "f0eff5")
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "grziliao"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.section == 0 {
            let zuoLabel = UILabel(frame: CGRect(x: 16, y: 11, width: 80, height: 22))
            zuoLabel.font = UIFont.systemFont(ofSize: 14)
            zuoLabel.textColor = UIColor.darkGray
            
            if indexPath.row == 0 {
                zuoLabel.frame = CGRect(x: 16, y: 19, width: 80, height: 22)
                zuoLabel.text = "头像"
                imageTou = UIImageView(frame: CGRect(x: Width - 60, y: 10, width: 40, height: 40))
                imageTou.layer.masksToBounds = true
                imageTou.contentMode = .scaleAspectFill
                imageTou.layer.cornerRadius = imageTou.frame.size.width/2
                if zhaozhao == 0 {
                    var ax:String = ""
                    if nil != Dic!["photo"]{
                        ax = Dic!["photo"] as! String
                    }
                    let newstring = TupianUrl + ax
                    let uuu = URL(string: String(format: "%@",newstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
                    
                    imageTou.sd_setImage(with: uuu, placeholderImage: UIImage(named: "head"), options: SDWebImageOptions.progressiveDownload, completed: nil)
                }else{
                    imageTou.image = imageXX
                }
                cell.contentView.addSubview(imageTou)
                cell.contentView.addSubview(zuoLabel)
            }else if indexPath.row == 1{
                zuoLabel.text = "用户名"
                nameFD = UITextField(frame: CGRect(x: Width - 120, y: 11, width: 100, height: 22))
                nameFD.delegate = self
                nameFD.placeholder = "请输入用户名"
                nameFD.text = ""
                if nil != Dic!["name"] {
                    nameFD.text = Dic!["name"] as? String
                }
                nameFD.font = UIFont.systemFont(ofSize: 14)
                nameFD.textAlignment = .right
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(nameFD)
                
            }else if indexPath.row == 2{
                zuoLabel.text = "手机号"
                let phoneLabel = UILabel(frame: CGRect(x: Width - 150, y: 11, width: 130, height: 22))
                phoneLabel.text = "未绑定"
                phoneLabel.textColor = UIColor.darkGray
                phoneLabel.text = ""
                if nil != Dic!["mobile"] {
                    phoneLabel.text = Dic!["mobile"] as? String
                }
                phoneLabel.textAlignment = .right
                phoneLabel.font = UIFont.systemFont(ofSize: 14)
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(phoneLabel)
                
            }else if indexPath.row == 3{
                zuoLabel.text = "微信号"
                let WeChatLabel = UILabel(frame: CGRect(x: 100, y: 11, width: Width - 120, height: 22))
                WeChatLabel.textAlignment = .right
                WeChatLabel.text = Dic!["weChatName"] as? String
              
                WeChatLabel.textColor = UIColor.darkGray
                WeChatLabel.textAlignment = .right
                WeChatLabel.font = UIFont.systemFont(ofSize: 14)
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(WeChatLabel)
            }else if indexPath.row == 4{
                zuoLabel.text = "安全设置"
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(zuoLabel)
            }
        }else if indexPath.section == 1 {
            let zuoLabel = UILabel(frame: CGRect(x: 16, y: 11, width: 80, height: 22))
            zuoLabel.font = UIFont.systemFont(ofSize: 14)
            zuoLabel.textColor = UIColor.darkGray
            if indexPath.row == 0{
                zuoLabel.text = "实名认证"
                let shimingLabel = UILabel(frame: CGRect(x: Width - 150, y: 11, width: 120, height: 22))
                shimingLabel.font = UIFont.systemFont(ofSize: 14)
                let xx = String(format: "%d",userDefaults.value(forKey: "isRealAuthentication") as! Int)
                switch xx {
                case "1":
                    shimingLabel.text = "未认证"
                case "2":
                    shimingLabel.text = "认证中"
                case "3":
                    shimingLabel.text = "认证未通过"
                case "4":
                    shimingLabel.text = "已通过"
                default:
                    break
                }
                shimingLabel.textColor = UIColor.darkGray
                shimingLabel.textAlignment = .right
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(shimingLabel)
            }else{
                zuoLabel.text = "企业认证"
                let qiyeLabel = UILabel(frame: CGRect(x: Width - 150, y: 11, width: 120, height: 22))
                qiyeLabel.font = UIFont.systemFont(ofSize: 14)
                qiyeLabel.text = "未认证"
                let xx = String(format: "%d", userDefaults.value(forKey: "isFirmAdit") as! Int)
                switch xx {
                case "1":
                    qiyeLabel.text = "未认证"
                case "2":
                    qiyeLabel.text = "认证中"
                case "3":
                    qiyeLabel.text = "认证未通过"
                case "4":
                    qiyeLabel.text = "已通过"
                default:
                    break
                }
                qiyeLabel.textColor = UIColor.darkGray
                qiyeLabel.textAlignment = .right
                cell.accessoryType = .disclosureIndicator
                cell.contentView.addSubview(zuoLabel)
                cell.contentView.addSubview(qiyeLabel)
            }
        }else{
            let button = UIButton(frame: CGRect(x: 20, y: 16, width: Width - 40, height: 56))
            button.setBackgroundImage(UIImage(named: "button_normal_dark"), for: .normal)
            button.setBackgroundImage(UIImage(named: "button_normal_light"), for: .normal)
            button.setTitle("保存", for: .normal)
            button.addTarget(self, action: #selector(yonghuxinxixiugai), for: .touchUpInside)
            button.setTitleColor(UIColor.white, for: .normal)
//            button.isUserInteractionEnabled = true
            //去掉当前cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            cell.backgroundColor = UIColor(hexString: "f0eff5")
            cell.contentView.addSubview(button)
        }
        return cell
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameFD {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if newString.count > 10 {
                return false
            }
        }
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //选择，相册/照相
                self.tanchu()
            }
            else if indexPath.row == 4 {
                //跳页到安全设置
                let AnQuanSZ: XL_AnQuanSZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anquansz") as? XL_AnQuanSZ_ViewController
                self.navigationController?.pushViewController(AnQuanSZ!, animated: true)
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                //跳实名认证
                if userDefaults.value(forKey: "isRealAuthentication") as! Int == 1 || userDefaults.value(forKey: "isRealAuthentication") as! Int == 3{
                    //接口 取回 token 调 阿里
                    let ShimingRZ: XL_ShimingRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shimingrz") as? XL_ShimingRZ_ViewController
                    ShimingRZ?.jiemian = 1
                self.navigationController?.pushViewController(ShimingRZ!, animated: true)
                }else if userDefaults.value(forKey: "isRealAuthentication") as! Int == 4 {
                    //显示界面
                    let ShimingRZ: XL_ShimingRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shimingrz") as? XL_ShimingRZ_ViewController
                    ShimingRZ?.jiemian = 2
                self.navigationController?.pushViewController(ShimingRZ!, animated: true)
                }
            }else if indexPath.row == 1 {
                //如果企业认证通过则不跳页
                if userDefaults.value(forKey: "isFirmAdit") as! Int == 4 || userDefaults.value(forKey: "isFirmAdit") as! Int == 2 {
                }else{
                if userDefaults.value(forKey: "isRealAuthentication") as! Int == 1 || userDefaults.value(forKey: "isRealAuthentication") as! Int == 3{
                    //弹框 --- 请先完成实名认证
                    let sheet = UIAlertController(title: "温馨提示:", message: "请先完成实名认证再进行企业认证", preferredStyle: .alert)
                    let queding = UIAlertAction(title: "确定", style: .default) { (ss) in
                        //接口 取回 token 调 阿里
                        let ShimingRZ: XL_ShimingRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shimingrz") as? XL_ShimingRZ_ViewController
                        ShimingRZ?.jiemian = 1
                        ShimingRZ?.yyy = 1
                self.navigationController?.pushViewController(ShimingRZ!, animated: true)
                    }
                    let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    sheet.addAction(queding)
                    sheet.addAction(cancel)
                    self.present(sheet, animated: true, completion: nil)
                }else if userDefaults.value(forKey: "isRealAuthentication") as! Int == 4 {
                    //跳企业认证
                    let qiyeRZ: XL_QiyeRZ_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "qiyerz") as? XL_QiyeRZ_ViewController
                    self.navigationController?.pushViewController(qiyeRZ!, animated: true)
                }
                }
            }
        }
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    @objc func yonghuxinxixiugai() {
        let method = "/user/updateUserInfoApp"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        XL_waringBox().warningBoxModeIndeterminate(message: "保存中...", view: self.view)
        let imagearr:[Any] = [imageTou.image!]
        let namearr:[Any] = ["photo"]
//        let dic:[String:Any] = ["userId":userId,"name":""]
        let keyarr = ["userId","name","photo2"]
        let valuearr = [userId,nameFD.text!,""]
        
        
        XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, keyArray: keyarr, valueArray: valuearr, methodName: method, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "保存成功", view: (self.navigationController?.view)!)
                self.navigationController?.popViewController(animated: true)

            }else{
                let msg = (res as! [String: Any])["msg"] as! String
                XL_waringBox().warningBoxModeText(message: msg, view: self.view)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
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
            zhaozhao = 1
            imageXX = photo
            tableGRziliao.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
