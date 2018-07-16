//
//  XL_SPGL_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_SPGL_ViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var xlxl = 0
    
    var DianpuDic:[String:String] = [:]
    
    let zuoArr:[String] = ["商品名称:","商品单价:","商品数量:","类别管理:","商品类别:"]
    var textFD = UITextField()
    var imageDic:[String : Any] = [:]
    var leiBArr:[[String:Any]] = []
    var leibie = ""
    var leibieId = ""
    var productId = ""
    
    
    @IBOutlet weak var tableshangpin: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDelegate()
        self.title = "商品管理"
        youshangjiao()
        // Do any additional setup after loading the view.
    }
    //MARK:tableviewDelegate
    func tableDelegate() {
        tableshangpin.delegate = self
        tableshangpin.dataSource = self
        tableshangpin.tableFooterView = UIView()
        tableshangpin.register(UITableViewCell.self, forCellReuseIdentifier: "dianpu")
        tableshangpin.backgroundColor = UIColor(hexString: "f0eff5")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 56
        }else if indexPath.section == 1{
            return 96
        }else if indexPath.section == 2 {
            return 120
        }else{
            return 120
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 56
        }else if section == 2 {
            return 56
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 56))
            view.backgroundColor = UIColor.groupTableViewBackground
            let lab = UILabel(frame: CGRect(x: 20, y: 0, width: Width, height: 56))
            lab.text = "商品描述"
            view.addSubview(lab)
            return view
        }else if section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 56))
            view.backgroundColor = UIColor.groupTableViewBackground
            let lab = UILabel(frame: CGRect(x: 20, y: 0, width: Width, height: 56))
            lab.text = "商品图片"
            view.addSubview(lab)
            return view
        }else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "dianpu"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        if indexPath.section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 56))
            view.backgroundColor = UIColor.white
            let zuoLable = UILabel(frame: CGRect(x: 16, y: 12, width: 80, height: 32))
            zuoLable.text = zuoArr[indexPath.row]
            zuoLable.font = UIFont.systemFont(ofSize: 15)
            let yuan = UILabel(frame: CGRect(x: Width - 30, y: 12, width: 20, height: 32))
            if indexPath.row == 1 {
                yuan.text = "元"
            }else{
                yuan.text = "个"
            }
            yuan.font = UIFont.systemFont(ofSize: 15)
            
            let youTF: UITextField = UITextField(frame: CGRect(x: 96, y: 12, width: Width - 136, height: 32))
            youTF.textColor = UIColor.darkGray
            youTF.textAlignment = .right
            youTF.tag = indexPath.row + 330
            youTF.font = UIFont.systemFont(ofSize: 14)
            youTF.delegate = self
            if nil != DianpuDic["\(indexPath.row)"]{
                youTF.text = DianpuDic["\(indexPath.row)"]!
            }
            if indexPath.row == 1 {
                youTF.keyboardType = .decimalPad
                view.addSubview(yuan)
            }
            if indexPath.row == 2 {
                youTF.keyboardType = .numberPad
                view.addSubview(yuan)
            }
            let label = UILabel(frame:CGRect(x: 88, y: 12, width: Width - 128, height: 32))
            label.textAlignment = .right
            label.textColor = UIColor(hexString: "c7c7cd")
            if nil != DianpuDic["\(indexPath.row)"]{
                label.text = DianpuDic["\(indexPath.row)"]!
                label.textColor = UIColor.black
            }
            label.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(zuoLable)
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
                view.addSubview(youTF)
            }else{
                view.addSubview(label)
                cell.accessoryType = .disclosureIndicator
            }
            cell.contentView.addSubview(view)
        }else if indexPath.section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 8, width: Width, height: 80))
            view.backgroundColor = UIColor.white
            textFD = UITextField(frame: CGRect(x: 20, y: 8, width: Width, height: 80))
            textFD.delegate = self
            textFD.font = UIFont.systemFont(ofSize: 14)
            textFD.placeholder = "点击在此处添加商品描述"
            if nil != DianpuDic["miaoshu"]{
                textFD.text = DianpuDic["miaoshu"]
            }
            view.addSubview(textFD)
            cell.contentView.addSubview(view)
        }else if indexPath.section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 120))
            view.backgroundColor = UIColor.groupTableViewBackground
            //去掉当前cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            let imageView = UIImageView(frame:CGRect(x: Width/4, y: 0, width: Width/2, height: 120))
            imageView.image = UIImage(named: "shoppicture")
            if nil != imageDic["shang"] {
                imageView.image = imageDic["shang"] as? UIImage
            }
            //互动
            /////设置允许交互属性
            imageView.isUserInteractionEnabled = true
            cell.backgroundColor = UIColor.groupTableViewBackground
            /////添加tapGuestureRecognizer手势
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick(sender:)))
            imageView.addGestureRecognizer(singleTapGesture)
            singleTapGesture.view!.tag = indexPath.row
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
            cell.contentView.addSubview(view)
        }else{
            //保存按钮
            let button = UIButton(frame: CGRect(x: 20, y: 48, width: Width/2 - 40, height: 64))
            button.setBackgroundImage(UIImage(named: "立即签到背景"), for: .normal)
            if xlxl == 1 {
                button.setTitle("修改到仓库", for: .normal)
            }else{
               button.setTitle("保存", for: .normal)
            }
            
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(baocun), for: .touchUpInside)
            //发布按钮
            let fabu = UIButton(frame: CGRect(x: Width/2 + 20, y: 48, width: Width/2 - 40, height: 64))
            fabu.setBackgroundImage(UIImage(named: "立即签到背景"), for: .normal)
            if xlxl == 1 {
                fabu.setTitle("修改到出售", for: .normal)
            }else{
                fabu.setTitle("发布", for: .normal)
            }
            fabu.setTitleColor(UIColor.white, for: .normal)
            fabu.addTarget(self, action: #selector(fabujiekou), for: .touchUpInside)
            //            button.isUserInteractionEnabled = true
            //去掉当前cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            cell.backgroundColor = UIColor(hexString: "f0eff5")
            cell.contentView.addSubview(button)
            cell.contentView.addSubview(fabu)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                //跳类别管理 天街类别
                let WDXX: XL_SPLX_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "splx") as? XL_SPLX_ViewController
                self.navigationController?.pushViewController(WDXX!, animated: true)
            }else if indexPath.row == 4 {
                //弹出商品类别
                leibiejiekou()
            }
        }
    }
    func tanLeibie() {
        self.view.endEditing(true)
        let alertController = UIAlertController(title: "类型", message: "你可以选择以下类型",
                                                preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        var paizhaoAction = UIAlertAction()
        for i in 0..<leiBArr.count {
            let title = leiBArr[i]["productTpyeName"] as! String
            
            paizhaoAction = UIAlertAction(title: title, style: .default) { (ss) in
                self.leibie = self.leiBArr[i]["productTpyeName"] as! String
                self.leibieId = self.leiBArr[i]["id"] as! String
                self.DianpuDic["4"] = self.leibie
                self.tableshangpin.reloadData()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(paizhaoAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func leibiejiekou() {
        let method = "/user/findProTypeApp"
        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["userId":userId!]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let dic:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                self.leiBArr = dic["pushTypeInfoList"] as! [[String : Any]]
                self.tanLeibie()
//                self.tablesplx.reloadData()
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
    //MARK: textfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != textFD {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            DianpuDic["\(textField.tag - 330)"] = newString
        }else{
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            DianpuDic["miaoshu"] = newString
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != textFD{
            DianpuDic["\(textField.tag - 330)"] = textField.text!
        }else{
            DianpuDic["miaoshu"] = textField.text!
        }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField.tag == 332 || textField.tag == 333 || textField.tag == 334 {
//            return false
//        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 330 {
            let index = IndexPath(row: textField.tag - 330 + 1, section: 0)
            let cell = tableshangpin.cellForRow(at: index)
            (cell?.viewWithTag(textField.tag + 1) as! UITextField).becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
        return true
    }
    
    @objc func baocun() {
        print("调接口")
        baocunjiekou()
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
            self.imageDic["shang"] = photo
            tableshangpin.reloadData()
        }
    }
    @objc func fabujiekou() {
        let method = "/user/publishPro2"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let imagearr:[Any] = [imageDic["shang"]!]
        let namearr:[Any] = ["picture"]
        
        let keyArr = ["userId","productId","productName","productPrice","productNum","productType","productTypeName","describe","isShelf"]
        var valueArr = [userId]
        valueArr.append(productId)
        valueArr.append(DianpuDic["0"]!)
        valueArr.append(DianpuDic["1"]!)
        valueArr.append(DianpuDic["2"]!)
        valueArr.append(leibieId)
        valueArr.append(DianpuDic["4"]!)
        valueArr.append(DianpuDic["miaoshu"]!)
        valueArr.append("1")
        XL_waringBox().warningBoxModeIndeterminate(message: "发布中...", view: self.view)
        XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, keyArray: keyArr, valueArray: valueArr, methodName: method, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "提交成功", view: self.view)
                let xiadan: XL_SPK_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spk") as? XL_SPK_ViewController
                xiadan?.ProductBlock = {(productId :String,image:UIImage) in
                    self.productId = productId
                    self.imageDic["shang"] = image
                    self.xiugaineirong(productInfoId: productId)
                    self.xlxl = 1
                }
                self.navigationController?.pushViewController(xiadan!, animated: true)
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
    func baocunjiekou() {
        let method = "/user/publishPro2"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let imagearr:[Any] = [imageDic["shang"]!]
        let namearr:[Any] = ["picture"]
        
        let keyArr = ["userId","productId","productName","productPrice","productNum","productType","productTypeName","describe","isShelf"]
        var valueArr = [userId]
        valueArr.append(productId)
        valueArr.append(DianpuDic["0"]!)
        valueArr.append(DianpuDic["1"]!)
        valueArr.append(DianpuDic["2"]!)
        valueArr.append(leibieId)
        valueArr.append(DianpuDic["4"]!)
        valueArr.append(DianpuDic["miaoshu"]!)
        valueArr.append("2")
        XL_waringBox().warningBoxModeIndeterminate(message: "保存中...", view: self.view)
        XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, keyArray: keyArr, valueArray: valueArr, methodName: method, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "提交成功", view: self.view)
                let xiadan: XL_SPK_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spk") as? XL_SPK_ViewController
                xiadan?.ProductBlock = {(productId :String,image:UIImage) in
                    self.productId = productId
                    self.imageDic["shang"] = image
                    self.xiugaineirong(productInfoId: productId)
                    self.xlxl = 1
                }
                self.navigationController?.pushViewController(xiadan!, animated: true)
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
    func xiugaineirong(productInfoId:String) {
        let method = "/user/selProductInfo"
//        let userId = userDefaults.value(forKey: "userId")
        let dic:[String:Any] = ["productInfoId":productInfoId]
        XL_waringBox().warningBoxModeIndeterminate(message: "加载中...", view: self.view)
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data = (res as! [String: Any])["data"] as! [String:Any]
                let productInfo = data["productInfo"] as! [String:Any]
                
                self.DianpuDic["0"] = productInfo["productName"] as? String
                self.DianpuDic["1"] = productInfo["productPrice"] as? String
                self.DianpuDic["2"] = productInfo["productNum"] as? String
                self.DianpuDic["4"] = productInfo["productTypeName"] as? String
                self.leibieId = String(format: "%d", productInfo["productType"] as! Int)
                self.DianpuDic["miaoshu"] = productInfo["productDesc"] as? String
                self.tableshangpin.reloadData()
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
    func youshangjiao()  {
        var item = UIBarButtonItem()
        
        item = UIBarButtonItem(title:"商品库",style: .plain,target:self,action:#selector(YouActio))
        
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio() {
        let xiadan: XL_SPK_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spk") as? XL_SPK_ViewController
        xiadan?.ProductBlock = {(productId :String,image:UIImage) in
            self.productId = productId
            self.imageDic["shang"] = image
            self.xiugaineirong(productInfoId: productId)
            self.xlxl = 1
        }
        self.navigationController?.pushViewController(xiadan!, animated: true)
    }


}
