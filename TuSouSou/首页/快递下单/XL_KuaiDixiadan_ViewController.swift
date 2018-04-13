//
//  XL_KuaiDixiadan_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/4/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_KuaiDixiadan_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var HeJijine: UILabel!
    let _tableview: UITableView! = UITableView()
    let body: [String: String] = [:]
    let uiswitch0 = UISwitch()
    let uiswitch1 = UISwitch()
    var zhifuButton0 = UIButton()
    var zhifuButton1 = UIButton()
    var xiaofeiTF = UITextField()
    var yangjiao = UILabel()
    var beizhuTF = UITextView()
    var placeholderLabel = UILabel()
    var bounds: CGRect! = CGRect(x: 0, y: 0, width: 0, height: 40)
    var sousoubiView: XL_PaoMaView?
    var yueView: XL_PaoMaView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewDelegate()
        self.TableviewCellUI()
//        self.gundongDonghua()
    }
    func gundongDonghua(string: String) {
        sousoubiView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 80, height: 32), title: string)
        yueView = XL_PaoMaView(frame: CGRect(x: 16, y: 8, width: 80, height: 32), title: string)
    }
    func tableviewDelegate() {
        _tableview.delegate = self
        _tableview.dataSource = self
        _tableview?.register(UITableViewCell.self, forCellReuseIdentifier: "dingdan")
        _tableview.frame = CGRect(x: 0, y: 0, width: Width, height: Height - 120)
        _tableview.tableFooterView = UIView()
        _tableview.rowHeight = UITableViewAutomaticDimension;
        
        _tableview.estimatedRowHeight = 100;
        self.view.addSubview(_tableview)
    }
    func TableviewCellUI() {
        uiswitch0.center = CGPoint(x: Width - 45, y: 24)
        uiswitch0.isOn = false
        uiswitch0.addTarget(self, action: #selector(switchDidChange0), for: .valueChanged)
        
        uiswitch1.center = CGPoint(x: Width - 45, y: 24)
        uiswitch1.isOn = false
        uiswitch1.addTarget(self, action: #selector(switchDidChange1), for: .valueChanged)
        
        zhifuButton0 = UIButton(frame: CGRect(x: Width - 32, y: 16, width: 16, height: 16))
        zhifuButton0.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        zhifuButton0.setImage(UIImage(named: "圆圈选中"), for: .selected)
        zhifuButton0.isSelected = false
        zhifuButton0.addTarget(self, action:                #selector(DidzhifuButton0), for: .touchUpInside)
        
        zhifuButton1 = UIButton(frame: CGRect(x: Width - 32, y: 16, width: 16, height: 16))
        zhifuButton1.setImage(UIImage(named: "圆圈未选中"), for: .normal)
        zhifuButton1.setImage(UIImage(named: "圆圈选中"), for: .selected)
        zhifuButton1.isSelected = false
        zhifuButton1.addTarget(self, action: #selector(DidzhifuButton1), for: .touchUpInside)
        
        xiaofeiTF = UITextField(frame: CGRect(x: 102, y: 8, width: 100, height: 32))
        xiaofeiTF.delegate = self
        xiaofeiTF.layer.borderWidth = 1
        xiaofeiTF.layer.borderColor = UIColor(hexString: "f7ead3").cgColor
        
        yangjiao = UILabel(frame: CGRect(x: 210, y: 8, width: 10, height: 32))
        
        beizhuTF = UITextView(frame: CGRect(x: 92, y: 8, width: Width - 130, height: 32))
        beizhuTF.isScrollEnabled = false
        beizhuTF.delegate = self
        beizhuTF.font = UIFont.systemFont(ofSize: 14)
        
        //手动提示
        self.placeholderLabel.frame = CGRect(x: 0 , y: 5, width: 100, height: 20)
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        self.placeholderLabel.text = "200字以内"
        beizhuTF.addSubview(self.placeholderLabel)
        self.placeholderLabel.textColor = UIColor(red:72/256 , green: 82/256, blue: 93/256, alpha: 1)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                return bounds.height + 16
            }
        }
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "dingdan"
        
        let cell = (_tableview.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        let ZuoLabel = UILabel(frame: CGRect(x: 16, y: 8, width: 80, height: 32))
        ZuoLabel.font = UIFont.systemFont(ofSize: 14)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                ZuoLabel.text = "立即送出"
                cell.accessoryType = .disclosureIndicator//右箭头
            case 1:
                ZuoLabel.text = "直拿直送"
                cell.addSubview(uiswitch0)
            case 2:
                ZuoLabel.text = "加小费"
                if uiswitch1.isOn == false {
                    yangjiao.isHidden = false
                    xiaofeiTF.placeholder = "1~500元"
                }else{
                    yangjiao.isHidden = true
                    xiaofeiTF.placeholder = ""
                }
                cell.addSubview(xiaofeiTF)
                cell.addSubview(yangjiao)
                cell.addSubview(uiswitch1)
            case 3:
                ZuoLabel.text = "备注:"
                
                cell.addSubview(beizhuTF)
            default:
                break
            }
            cell.addSubview(ZuoLabel)
        }else{
            let ZFImage = UIImageView(frame: CGRect(x: 16, y: 12, width: 24, height: 24))
            let zuolabel = UILabel(frame: CGRect(x: 48, y: 9, width: 100, height: 32))
            zuolabel.font = UIFont.systemFont(ofSize: 14)
            switch indexPath.row {
            case 0:
                self.gundongDonghua(string: "飕飕币剩余(0.00)") //"剩余(¥\(body["qian"]))支付"
                cell.addSubview(sousoubiView!)
            case 1:
                self.gundongDonghua(string: "余额(¥0.00)支付")//"剩余(¥\(body["qian"]))支付"
                cell.addSubview(yueView!)
            case 2:
                ZFImage.image = UIImage(named: "支付-支付宝")
                zuolabel.text = "支付宝支付"//"剩余(¥\(body["qian"]))支付"
                cell.addSubview(zhifuButton0)
                cell.addSubview(ZFImage)
                cell.addSubview(zuolabel)
            case 3:
                ZFImage.image = UIImage(named: "支付-微信")
                zuolabel.text = "微信支付"
                cell.addSubview(zhifuButton1)
                cell.addSubview(ZFImage)
                cell.addSubview(zuolabel)
            default:
                break
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                if zhifuButton0.isSelected == false {
                    zhifuButton0.isSelected = true
                }else{
                    zhifuButton0.isSelected = false
                }
                zhifuButton1.isSelected = false
            }
            if indexPath.row == 3 {
                if zhifuButton1.isSelected == false {
                    zhifuButton1.isSelected = true
                }else{
                    zhifuButton1.isSelected = false
                }
                zhifuButton0.isSelected = false
            }
        }
        _tableview.reloadData()
    }
    //MARK：tableviewHeader
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 50
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 50))
        view.backgroundColor = UIColor(hexString: "f2f2f2")
        let label = UILabel(frame: CGRect(x: 16, y: 8, width: 100, height: 40))
        label.text = "付款方式:"
        view.addSubview(label)
        if section == 1 {
            return view
        }
        return nil
    }
    //MARK: textviewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.placeholderLabel.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = false
        }else{
            self.placeholderLabel.isHidden = true
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        if textView.text.count >= 200 {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        bounds = textView.bounds
        let maxSize = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        
        let newSize = textView.sizeThatFits(maxSize)
        bounds.size.height = newSize.height
        beizhuTF.frame = CGRect(x: 92, y: 8, width: bounds.width, height: bounds.height)
        _tableview.beginUpdates()
        _tableview.endUpdates()
    }
    //MARK：两个开关按钮
    @objc func switchDidChange0() {
        if uiswitch0.isOn == true {
            uiswitch1.isOn = false
        }
        
        _tableview.reloadData()
    }
    @objc func switchDidChange1() {
        if uiswitch1.isOn == true {
            uiswitch0.isOn = false
        }
        _tableview.reloadData()
    }
    @objc func DidzhifuButton0()  {
        if zhifuButton0.isSelected == false {
            zhifuButton0.isSelected = true
        }else{
            zhifuButton0.isSelected = false
        }
        zhifuButton1.isSelected = false
    }
    @objc func DidzhifuButton1()  {
        if zhifuButton1.isSelected == false {
            zhifuButton1.isSelected = true
        }else{
            zhifuButton1.isSelected = false
        }
        zhifuButton0.isSelected = false
    }
    @IBAction func querenzhifu(_ sender: Any) {
    }
}
//MARK：扩展UIColor
extension UIColor{
    convenience init(hexString:String){
        //处理数值
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
}
