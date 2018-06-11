//
//  PayAlert.swift
//  PayAlertView
//
//  Created by 余金 on 16/3/14.
//  Copyright © 2016年 fengzhi. All rights reserved.
//

import UIKit

class PayAlert: UIView,UITextFieldDelegate {
    
    var contentView:UIView?
    var completeBlock : (((String) -> Void)?)
    private var textField:UITextField!
    private var inputViewWidth:CGFloat!
    private var passCount:CGFloat!
    private var passheight:CGFloat!
    private var inputViewX:CGFloat!
    private var pwdCircleArr = [UILabel]()

    init(frame: CGRect, jineHide:Bool, jine: String ) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
        self.passheight = 35
        self.passCount = 6
        self.inputViewWidth = 35 * passCount
        self.inputViewX = (240 - inputViewWidth) / 2.0
        setupView(jineHide:jineHide, jine: jine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(jineHide:Bool, jine: String){
        
        contentView =  UIView(frame: CGRect(x:(Width - 240)/2, y: 100, width: 240, height: 200))
        contentView!.backgroundColor = UIColor.white
        contentView?.layer.cornerRadius = 5;
        self.addSubview(contentView!)
        
        
        let btn:UIButton = UIButton(type: .custom)
        btn.frame =  CGRect(x: 0, y: 0, width: 46, height: 46)
        btn .addTarget(self, action: #selector(close), for: .touchUpInside)
        btn .setTitle("╳", for: .normal)
        btn .setTitleColor(UIColor.black, for: .normal)
        contentView!.addSubview(btn)
        
        let titleLabel:UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: contentView!.frame.size.width, height: 46))
        titleLabel.text = "请输入支付密码"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        contentView!.addSubview(titleLabel)
        
        let linView:UIView = UIView (frame:CGRect(x: 0, y: 46, width: self.frame.size.height, height: 1))
        linView.backgroundColor = UIColor.black
        linView.alpha = 0.4
        contentView?.addSubview(linView)
        
        let moneyLabel:UILabel = UILabel(frame:CGRect(x: 0, y: 56, width: contentView!.frame.size.width, height: 26))
        moneyLabel.text = "金额:  \(jine)元"
        moneyLabel.textAlignment = .center
        moneyLabel.font = UIFont.systemFont(ofSize: 20)
        contentView?.addSubview(moneyLabel)
        if jineHide {
            moneyLabel.isHidden = true
        }
        
        textField = UITextField(frame:CGRect(x: 0, y: frame.size.height - 60, width: contentView!.frame.size.width, height: 35))
        textField.delegate = self
        textField.isHidden = true
        textField.keyboardType = UIKeyboardType.numberPad
        contentView?.addSubview(textField!)
        
        
        let inputView:UIView = UIView(frame:CGRect(x: self.inputViewX, y: contentView!.frame.size.height - 60, width: inputViewWidth, height: 35))
        
        inputView.layer.borderWidth = 1;
        inputView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor;
        contentView?.addSubview(inputView)
        
        let rect:CGRect = inputView.frame
        let x:CGFloat = rect.origin.x + (inputViewWidth / 12)
        let y:CGFloat = rect.origin.y + 35 / 2 - 5
        for i in 0..<6 {
            let circleLabel:UILabel =  UILabel(frame:CGRect(x: x + 35 * CGFloat(i), y: y, width: 10, height: 10))
            circleLabel.backgroundColor = UIColor.black
            circleLabel.layer.cornerRadius = 5
            circleLabel.layer.masksToBounds = true
            circleLabel.isHidden = true
            contentView?.addSubview(circleLabel)
            pwdCircleArr.append(circleLabel)
            
            if i == 5 {
                continue
            }
            let line:UIView = UIView(frame:CGRect(x: rect.origin.x + (inputViewWidth / 6)*CGFloat(i + 1), y: rect.origin.y, width: 1, height: 35))
            line.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            line.alpha = 0.4
            contentView?.addSubview(line)
        }
    }
    
    func show(view:UIView){
        view.addSubview(self)
        contentView!.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
        contentView!.alpha = 0;
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { () -> Void in
            self.textField.becomeFirstResponder()
            self.contentView!.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.contentView!.alpha = 1;
            
            }, completion: nil)
        
    }
    
    @objc func close(){
        self.removeFromSuperview()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if((textField.text?.count)! > 6){
         return false
        }
        
        var password : String
        if string.count <= 0 {
            let index = textField.text?.index((textField.text?.startIndex)!, offsetBy: (textField.text?.count)! - 1)//获取字符d的索引
            password = textField.text!.substring(to: index!)
        }
        else {
            password = textField.text! + string
        }
        self .setCircleShow(count: password.count)
        
        if(password.count == 6){
            completeBlock?(password)
            close()
        }
        return true;
    }
    
    func setCircleShow(count:NSInteger){
        for circle in pwdCircleArr {
            circle.isHidden = true;
        }
        for i in 0..<count {
            pwdCircleArr[i].isHidden = false
        }
    }
}
