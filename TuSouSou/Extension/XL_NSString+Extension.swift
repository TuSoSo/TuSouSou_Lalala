//
//  XL_NSString+Extension.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/7/23.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

extension NSString {
//    /*!
//     验证手机号是否合法
//
//     - returns: true/false
//     */
//    func isValidateTelNumber() -> Bool {
//        return validate("^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$")
//    }
    /*!
     验证身份证
     
     - returns: true/false
     */
    func chk18PaperId() -> Bool {
        //判断位数
        if self.length != 15 && self.length != 18 {
            return false
        }
        var carid = self
        
        var lSumQT = 0
        
        //加权因子
        let R = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        
        //校验码
        let sChecker: [Int8] = [49,48,88, 57, 56, 55, 54, 53, 52, 51, 50]
        
        //将15位身份证号转换成18位
        let mString = NSMutableString.init(string: self)
        
        if self.length == 15 {
            mString.insert("19", at: 6)
            var p = 0
            let pid = mString.utf8String
            for i in 0...16 {
                p += (Int(pid![i]) - 48) * R[i]
            }
            let o = p % 11
            let stringContent = NSString(format: "%c", sChecker[o])
            mString.insert(stringContent as String, at: mString.length)
            carid = mString
        }
        
        //判断地区码
        let sProvince = carid.substring(to: 2)
        if (!areaCodeAt(code: sProvince)) {
            return false
        }
        
        //判断年月日是否有效
        //年份
        let strYear = Int(carid.substring(with: NSMakeRange(6, 4)))
        //月份
        let strMonth = Int(carid.substring(with: NSMakeRange(10, 2)))
        //日
        let strDay = Int(carid.substring(with: NSMakeRange(12, 2)))
        
        let localZone = NSTimeZone.local
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = localZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: "\(String(format: "%02d",strYear!))-\(String(format: "%02d",strMonth!))-\(String(format: "%02d",strDay!)) 12:01:01")
        
        if date == nil {
            return false
        }
        
        let paperId = carid.utf8String
        //检验长度
        if 18 != carid.length {
            return false
        }
        //校验数字
        func isDigit(c: Int8) -> Bool {
            return 0 <= c && c <= 9
        }
        for i in 0...18 {
            if isDigit(c: paperId![i]) && !(88 == paperId![i] || 120 == paperId![i]) && 17 == i {
                return false
            }
        }
        
        //验证最末的校验码
        for i in 0...16 {
            lSumQT += (Int(paperId![i]) - 48) * R[i]
        }
        if sChecker[lSumQT%11] != paperId![17] {
            return false
        }
        return true
    }
    func areaCodeAt(code: String) -> Bool {
        var dic: [String: String] = [:]
        dic["11"] = "北京"
        dic["12"] = "天津"
        dic["13"] = "河北"
        dic["14"] = "山西"
        dic["15"] = "内蒙古"
        dic["21"] = "辽宁"
        dic["22"] = "吉林"
        dic["23"] = "黑龙江"
        dic["31"] = "上海"
        dic["32"] = "江苏"
        dic["33"] = "浙江"
        dic["34"] = "安徽"
        dic["35"] = "福建"
        dic["36"] = "江西"
        dic["37"] = "山东"
        dic["41"] = "河南"
        dic["42"] = "湖北"
        dic["43"] = "湖南"
        dic["44"] = "广东"
        dic["45"] = "广西"
        dic["46"] = "海南"
        dic["50"] = "重庆"
        dic["51"] = "四川"
        dic["52"] = "贵州"
        dic["53"] = "云南"
        dic["54"] = "西藏"
        dic["61"] = "陕西"
        dic["62"] = "甘肃"
        dic["63"] = "青海"
        dic["64"] = "宁夏"
        dic["65"] = "新疆"
        dic["71"] = "台湾"
        dic["81"] = "香港"
        dic["82"] = "澳门"
        dic["91"] = "国外"
        if (dic[code] == nil) {
            return false;
        }
        return true;
    }
}
