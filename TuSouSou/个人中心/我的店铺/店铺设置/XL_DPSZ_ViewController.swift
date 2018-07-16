//
//  XL_DPSZ_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_DPSZ_ViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var DianpuDic:[String:String] = [:]
    var FenleiArr:[[String:Any]] = []
    var HuodongArr:[[String:Any]] = []
    var shi = 0
    var fenleiId = ""
    var huodongId = ""
    
    var NwDatePicker = UIDatePicker()
    var banView = UIView()
    var chunView = UIView()
    let zuoArr:[String] = ["商户名称:","联系电话:","店铺地址:","开始时间:","结束时间:","分类类别:","活动类别:"]
    let youArr:[String] = ["请填写商户名称","请填写联系电话","请选择店铺地址","请选择开始营业时间","请选择结束营业时间","请选择分类类别","请选择活动类别"]
    
    var imageDic:[String : Any] = [:]
    var isSHX = 0
    var Lat:String = ""
    var Lon:String = ""
    
    var cishu = 0
    
    @IBOutlet weak var tableDianpu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDelegate()
        self.title = "店铺信息"
        shijianxuanze()
        youshangjiao()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        jinrujiekou()
    }
    
    //MARK:tableviewDelegate
    func tableDelegate() {
        tableDianpu.delegate = self
        tableDianpu.dataSource = self
        tableDianpu.tableFooterView = UIView()
        tableDianpu.register(UITableViewCell.self, forCellReuseIdentifier: "dianpu")
        tableDianpu.backgroundColor = UIColor(hexString: "f0eff5")
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
            let youTF: UITextField = UITextField(frame: CGRect(x: 88, y: 12, width: Width - 104, height: 32))
            youTF.textColor = UIColor.darkGray
            youTF.tag = indexPath.row + 330
            youTF.font = UIFont.systemFont(ofSize: 14)
            youTF.delegate = self
            if nil != DianpuDic["\(indexPath.row)"]{
                youTF.text = DianpuDic["\(indexPath.row)"]!
            }
            if indexPath.row == 1 {
                youTF.keyboardType = .numberPad
            }
            youTF.placeholder = youArr[indexPath.row]
            let label = UILabel(frame:CGRect(x: 88, y: 12, width: Width - 104, height: 32))
            label.text = youArr[indexPath.row]
            label.textColor = UIColor(hexString: "c7c7cd")
            if nil != DianpuDic["\(indexPath.row)"]{
                label.text = DianpuDic["\(indexPath.row)"]!
                label.textColor = UIColor.black
            }
            label.font = UIFont.systemFont(ofSize: 14)
//            if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 {
//                youTF.frame = CGRect(x: 88, y: 12, width: 150, height: 32)
//            }
            view.addSubview(zuoLable)
            if indexPath.row == 0 || indexPath.row == 1 {
                 view.addSubview(youTF)
            }else{
                view.addSubview(label)
                cell.accessoryType = .disclosureIndicator
            }
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
                xiazi.text = "上传LOGO"
                if nil != imageDic["shang"] {
                    imageView.image = imageDic["shang"] as? UIImage
                }
            }else if indexPath.row == 1{
                xiazi.text = "上传店铺环境1"
                if nil != imageDic["xia"] {
                    imageView.image = imageDic["xia"] as? UIImage
                }
            }else {
                xiazi.text = "上传店铺环境2"
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
            button.setBackgroundImage(UIImage(named: "立即签到背景"), for: .normal)
            button.setTitle("确认提交", for: .normal)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                let baiduditu: XL_baiduditu_ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baiduditu") as! XL_baiduditu_ViewController
                baiduditu.baidudizhi = {(baidudizhi: [String:String]) in
                    self.DianpuDic["2"] = baidudizhi["dizhi"]
                    self.Lon = baidudizhi["lon"]!
                    self.Lat = baidudizhi["lat"]!
                    self.tableDianpu.reloadData()
                }
                self.navigationController?.pushViewController(baiduditu, animated: true)
            }else if indexPath.row == 3 {
                shi = 1
                shijian()
            }else if indexPath.row == 4 {
                shi = 2
                shijian()
            }else if indexPath.row == 5 {
                //弹出分类类别
                tantantan(index: 1)
            }else if indexPath.row == 6 {
                //弹出活动类别
                tantantan(index: 2)
            }
        }
    }
    func tantantan(index: Int) {
        self.view.endEditing(true)
        let alertController = UIAlertController(title: "类型", message: "你可以选择以下类型",
                                                preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        var paizhaoAction = UIAlertAction()
        if index == 1 {
            for i in 0..<FenleiArr.count {
                let title = FenleiArr[i]["name"] as! String
                
                paizhaoAction = UIAlertAction(title: title, style: .default) { (ss) in
                    self.fenleiId = self.FenleiArr[i]["id"] as! String
                    self.DianpuDic["5"] = self.FenleiArr[i]["name"] as? String
                    self.tableDianpu.reloadData()
                }
                alertController.addAction(paizhaoAction)
            }
        }else if index == 2 {
            for i in 0..<HuodongArr.count {
                let title = HuodongArr[i]["name"] as! String
                
                paizhaoAction = UIAlertAction(title: title, style: .default) { (ss) in
                    self.huodongId = self.HuodongArr[i]["id"] as! String
                    self.DianpuDic["6"] = self.HuodongArr[i]["name"] as? String
                    self.tableDianpu.reloadData()
                }
                alertController.addAction(paizhaoAction)
            }
        }
        
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func shijian() {
        NwDatePicker.isHidden = false
        banView.isHidden = false
        chunView.isHidden = false
    }
    @objc func yincang() {
        chunView.isHidden = true
        NwDatePicker.isHidden = true
        banView.isHidden = true
        tableDianpu.reloadData()
    }
    func shijianxuanze() {
        chunView = UIView(frame: CGRect(x: 0, y:0, width: Width, height: Height))
        chunView.backgroundColor = UIColor.black
        chunView.alpha = 0.8
        chunView.isHidden = true
        self.view.addSubview(chunView)
        banView = UIView(frame: CGRect(x: 0, y: Height - 300, width: Width, height: 300))
        banView.backgroundColor = UIColor.white
        self.view.addSubview(banView)
        banView.isHidden = true
        banView.isUserInteractionEnabled = true
        let tapOne = UITapGestureRecognizer(target: self, action: #selector(yincang))
        chunView.addGestureRecognizer(tapOne)
        NwDatePicker = UIDatePicker(frame: CGRect(x: 0, y: Height - 300, width: Width, height: 300))
        NwDatePicker.layer.borderWidth = 1
        NwDatePicker.layer.borderColor = UIColor.gray.cgColor
        NwDatePicker.datePickerMode = .time
        NwDatePicker.locale = Locale.init(identifier: "zh_CN")
        NwDatePicker.addTarget(self, action: #selector(chooseDate( _:)), for:UIControlEvents.valueChanged)
        self.view.addSubview(NwDatePicker)
        NwDatePicker.isHidden = true
    }
    @objc func chooseDate(_ datePicker:UIDatePicker) {
        let  chooseDate = datePicker.date
        let  dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "HH:mm"
        if shi == 1 {
            DianpuDic["3"] = dateFormater.string(from: chooseDate)
        }else if shi == 2 {
            DianpuDic["4"] = dateFormater.string(from: chooseDate)
        }
        print(dateFormater.string(from: chooseDate))
    }
    //MARK: textfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        DianpuDic["\(textField.tag - 330)"] = newString
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        DianpuDic["\(textField.tag - 330)"] = textField.text!
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 332 || textField.tag == 333 || textField.tag == 334 {
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag != 330 + 4 {
            let index = IndexPath(row: textField.tag - 330 + 1, section: 0)
            let cell = tableDianpu.cellForRow(at: index)
            (cell?.viewWithTag(textField.tag + 1) as! UITextField).becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
        return true
    }
    
    @objc func queding() {
        print("调接口")
        Dianpujiekou()
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
        if let photo = info[UIImagePickerControllerOriginalImage] as! UIImage?{
            if self.isSHX == 1 {
                self.imageDic["shang"] = photo
            }else if self.isSHX == 2 {
                self.imageDic["xia"] = photo
            }else if self.isSHX == 3 {
                self.imageDic["fa"] = photo
            }
            tableDianpu.reloadData()
        }
    }
    func Dianpujiekou() {
        let method = "/merchant/saveApp"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        XL_waringBox().warningBoxModeIndeterminate(message: "信息提交中...", view: self.view)
        
        let imagearr:[Any] = [imageDic["shang"]!,imageDic["xia"]!,imageDic["fa"]!]
        let namearr:[Any] = ["logoUrl","picture1","picture2"]
        
        let keyArr = ["userId","name","phone","address","longitude","latitude","shopHours","firstType","secondType","cityName","logoUrl","picture1","picture2"]
        var valueArr = [userId]
        valueArr.append(DianpuDic["0"]!)
        valueArr.append(DianpuDic["1"]!)
        valueArr.append(DianpuDic["2"]!)
        valueArr.append(Lon)
        valueArr.append(Lat)
        valueArr.append(String(format: "%@", DianpuDic["3"]! + "-" + DianpuDic["4"]!))
        valueArr.append(fenleiId)
        valueArr.append(huodongId)
        let cityName:String = userDefaults.value(forKey: "cityName") as! String
        valueArr.append(cityName)
        valueArr.append("")
        valueArr.append("")
        valueArr.append("")
//        for i in 0..<5 {
//            if nil != DianpuDic["\(i)"]{
//                valueArr.append(DianpuDic["\(i)"]!)
//            }else{
//                valueArr.append("")
//            }
//        }
        XL_QuanJu().UploadWangluo(imageArray: imagearr, NameArray: namearr, keyArray: keyArr, valueArray: valueArr, methodName: method, success: { (res) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                XL_waringBox().warningBoxModeText(message: "提交成功", view: (self.navigationController?.view)!)
//                userDefaults.set(2, forKey: "isFirmAdit")
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            XL_waringBox().warningBoxModeText(message: "网络连接失败", view: self.view)
            print(error)
        }
    }
    func jinrujiekou() {
        cishu += 1
        let method = "/merchant/merMessage"
        let userId:String = userDefaults.value(forKey: "userId") as! String
        let dic = ["userId":userId]
        XL_QuanJu().PuTongWangluo(methodName: method, methodType: .post, rucan: dic, success: { (res) in
            print(res)
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            if (res as! [String: Any])["code"] as! String == "0000" {
                let data:[String:Any] = (res as! [String: Any])["data"] as! [String:Any]
                
                
                let arrr = (data["shopTime"] as! String).components(separatedBy: "-")
                
                self.HuodongArr = data["secondTypeList"] as! [[String:Any]]
                self.FenleiArr = data["firstTypeList"] as! [[String:Any]]
                if nil == data["name"] || (data["name"] as! String).count == 0{
                    
                }else{
                    self.DianpuDic["0"] = data["name"] as? String
                    self.DianpuDic["1"] = data["phone"] as? String
                    self.DianpuDic["2"] = data["address"] as? String
                    self.DianpuDic["3"] = arrr[0]
                    self.DianpuDic["4"] = arrr[1]
                    self.fenleiId = (data["firstType"] as? String)!
                    self.huodongId = (data["secondType"] as? String)!
                    let xx:String = (data["firstType"] as? String)!
                    for aa in 0..<self.FenleiArr.count{
                        if self.FenleiArr[aa]["id"] as! String == xx {
                            self.DianpuDic["5"] = self.FenleiArr[aa]["name"] as? String
                            break
                        }
                    }
                    let yy:String = (data["secondType"] as? String)!
                    for aa in 0..<self.HuodongArr.count{
                        if self.HuodongArr[aa]["id"] as! String == yy {
                            self.DianpuDic["6"] = self.HuodongArr[aa]["name"] as? String
                            break
                        }
                    }
                    
//                    self.DianpuDic["6"] = data["secondType"] as? String
                    self.Lon = (data["lng"] as? String)!
                    self.Lat = (data["lat"] as? String)!
                    let logoUrl = data["logoUrl"] as! String
                    let newstring = TupianUrl + logoUrl
                    let uul = URL(string: String(format: "%@",newstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
                    let shangImageView = UIImageView()
                    shangImageView.sd_setImage(with: uul, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: { (image:UIImage?, error:Error?, cacheType:SDImageCacheType, url:URL?) in
                        if let img = image {
                            self.imageDic["shang"] = img
                            self.tableDianpu.reloadData()
                        }

                    })
                    let picString:String = data["picture"] as! String
                    let PicArr = picString.components(separatedBy: ";")
                    
                    let newstring1 = TupianUrl + PicArr[0]
                    let uul1 = URL(string: String(format: "%@",newstring1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
                    let xiaImageView = UIImageView()
                    xiaImageView.sd_setImage(with: uul1, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: { (image:UIImage?, error:Error?, cacheType:SDImageCacheType, url:URL?) in
                        if let img = image {
                            self.imageDic["xia"] = img
                            self.tableDianpu.reloadData()
                        }
                        
                    })
                    let newstring2 = TupianUrl + PicArr[1]
                    let uul2 = URL(string: String(format: "%@",newstring2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ))
                    let faImageView = UIImageView()
                    faImageView.sd_setImage(with: uul2, placeholderImage: UIImage(named: "加载失败"), options: SDWebImageOptions.progressiveDownload, completed: { (image:UIImage?, error:Error?, cacheType:SDImageCacheType, url:URL?) in
                        if let img = image {
                            self.imageDic["fa"] = img
                            self.tableDianpu.reloadData()
                        }
                    })
                    self.tableDianpu.reloadData()
                    if self.cishu == 1 {
                        self.jinrujiekou()
                    }
                }
            }
        }) { (error) in
            XL_waringBox().warningBoxModeHide(isHide: true, view: self.view)
            
        }
    }
    func youshangjiao()  {
        var item = UIBarButtonItem()
        
        item = UIBarButtonItem(title:"查看",style: .plain,target:self,action:#selector(YouActio))

        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouActio() {
        let xiadan: XL_DPCK_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dpck") as? XL_DPCK_ViewController
       
        //        xiada
        self.navigationController?.pushViewController(xiadan!, animated: true)
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
