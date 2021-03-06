//
//  XL_QuanJu.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//
/*
 判断登录
 XL_TiaoDeng_ViewController().tiaodenglu { (aa) in
 
 }
 */
import UIKit
import Alamofire
let storyboard = UIStoryboard(name: "Main", bundle:nil)
let Scheme = "http://"
let AppName = "/tusousou"
let apath  =  "/api/rest/1.0"
//域名
let QianWaiWangIP = "www.tusousouxr.com"
//服务器
//let QianWaiWangIP = "39.107.255.187:8080"
//宋浩然
//let QianWaiWangIP = "192.168.1.175:8085"
//小调
//let QianWaiWangIP = "192.168.124.40:8088"
//小展http://xbxhp396.55555.io:40432
//let QianWaiWangIP = "xbxhp396.55555.io:40432"
//二号
//let QianWaiWangIP = "192.168.1.115:8080"
let url = "\(Scheme)\(QianWaiWangIP)\(AppName)\(apath)"
let sanfangUrl = "\(Scheme)\(QianWaiWangIP)\(AppName)"
let Height = UIScreen.main.bounds.height
let Width = UIScreen.main.bounds.width
let TupianUrl = "\(Scheme)\(QianWaiWangIP)"


let WeiXin_AppID = "wx678a8d37c4aec635"
let WX_APPSecret = "12331718a11c60a7bd1a298aa5307a3a"
let qqAppID = "1106864369"
let JPush_AppKey = "52e431d282ea45ce6fab0437"
let isProduction = true //true 是 生产   false 是 开发

let userDefaults = UserDefaults.standard
//是否登录: isDengLu
//订单号： dingdanhao
//版本号： appVersion
//登陆方式： loginMethod
//登录密码: passWord
//openId : openId
//用户Id :userId
//是否设置支付密码 ：isPayPassWord
//小额免密： xemmzf： true false
//用户电话： userPhone
//邀请码：invitationCode
//是否推送开启： Tuisong
//用户类型： userType 1： 个人 2 ： 企业
//企业用户是否审核通过：isFirmAdit(int) 1未认证,2认证中，3认证未通过，4认证通过
//个人实名认证：isRealAuthentication（1未认证,2认证中，3认证未通过，4认证通过）
//单点登录： accessToken
//是否有位支付订单： isNotPay， 1有 2 没有
let isDengLu = (userDefaults.value(forKey: "isDengLu") as! String == "0") ? true : false

class XL_QuanJu: NSObject {

    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    /**
     普通接口
     */
    func TokenWangluo(methodName: String, methodType: HTTPMethod,userId:String,accessToken:String, rucan: Dictionary<String, Any>, success: @escaping(_ result: Any) -> (), failed: @escaping(_ error: Error) ->()) {
        let urlString = "\(url)\(methodName)"
        print(urlString)
        let JsonString = self.getJSONStringFromDictionary(dictionary: rucan as NSDictionary)
        let params: Parameters = ["params": JsonString,"userId":userId,"accessToken":accessToken]
        
        Alamofire.request(urlString, method: methodType, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseDate) in
            guard let result = responseDate.result.value
                else {
                    failed(responseDate.error!)
                    return
            }
            success(result)
        }
    }
   /**
     普通接口
     */
    func PuTongWangluo(methodName: String, methodType: HTTPMethod, rucan: Dictionary<String, Any>, success: @escaping(_ result: Any) -> (), failed: @escaping(_ error: Error) ->()) {
        let urlString = "\(url)\(methodName)"
        print(urlString)
        let JsonString = self.getJSONStringFromDictionary(dictionary: rucan as NSDictionary)
        let params: Parameters = ["params": JsonString]
        
        Alamofire.request(urlString, method: methodType, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseDate) in
            guard let result = responseDate.result.value
                else {
                    failed(responseDate.error!)
                    return
            }
            success(result)
        }
    }
    /**
     三方接口
     */
    func SanFangWangluo(methodName: String, methodType: HTTPMethod, rucan: Dictionary<String, Any>, success: @escaping(_ result: Any) -> (), failed: @escaping(_ error: Error) ->()) {
        let urlString = "\(sanfangUrl)\(methodName)"
        print(urlString)
        let JsonString = self.getJSONStringFromDictionary(dictionary: rucan as NSDictionary)
        let params: Parameters = ["params": JsonString]
        
        Alamofire.request(urlString, method: methodType, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseDate) in
            guard let result = responseDate.result.value
                else {
                    failed(responseDate.error!)
                    return
            }
            success(result)
        }
    }
    /**
     上传图片接口
     */
    func UploadWangluo(imageArray: Array<Any>, NameArray: Array<Any>, keyArray: Array<Any>, valueArray: Array<Any>, methodName: String, success: @escaping(_ reselt: Any)->(),failed: @escaping(_ error: Error)->()) {
        let urlString = "\(url)\(methodName)"
        var DataArr: Array<Data>! = []
        
        for i in 0..<imageArray.count {
//            guard
                let JPGDate = UIImageJPEGRepresentation(imageArray[i] as! UIImage, 0.5)
//                else {
//                    return
//            }
            DataArr.append(JPGDate!)
        }
       
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                //采用post表单上传
                // 参数解释：
                //withName:和后台服务器的name要一致 ；fileName:可以充分利用写成用户的id，但是格式要写对； mimeType：规定的，要上传其他格式可以自行百度查一下
                //字典转Json
//                let JsonString = self.getJSONStringFromDictionary(dictionary: rucan as NSDictionary)
                //上传参数
//                multipartFormData.append((JsonString.data(using: String.Encoding.utf8)!), withName: "params")
                
                for x in 0..<valueArray.count{
                    multipartFormData.append(((valueArray[x] as! String).data(using: String.Encoding.utf8)!), withName: keyArray[x] as! String)
                }
                //上传图片
                let now = Date()
                let timeInterval:TimeInterval = now.timeIntervalSince1970
                let timeStamp = Int(timeInterval)
                let outRefundNo = String(format: "%d",timeStamp)
                for i in 0..<DataArr.count {
                    multipartFormData.append(DataArr[i], withName: NameArray[i] as! String, fileName: "\(outRefundNo)\(i).png", mimeType: "image/png")
                }
        },to: urlString,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                //连接服务器成功后，对json的处理
                upload.responseJSON { response in
                    //解包
                    guard let result = response.result.value else { return }
                    print("json:\(result)")
                    success(result)
                }
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                    print("图片上传进度: \(progress.fractionCompleted)")
                }
            case .failure(let encodingError):
                //打印连接失败原因
                failed(encodingError)
                print(encodingError)
            }
        })
    }
}
