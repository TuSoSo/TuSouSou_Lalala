//
//  XL_QuanJu.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
import Alamofire
let storyboard = UIStoryboard(name: "Main", bundle:nil)
let Scheme = "http://"
let AppName = "/tusousou"
let apath  =  "/api/rest/1.0"
let QianWaiWangIP = "192.168.1.186:8080"
let url = "\(Scheme)\(QianWaiWangIP)\(AppName)\(apath)"
let Height = UIScreen.main.bounds.height
let Width = UIScreen.main.bounds.width

let WeiXin_AppID = "wx678a8d37c4aec635"
let WX_APPSecret = "12331718a11c60a7bd1a298aa5307a3a"
let qqAppID = "1106864369"
let JPush_AppKey = "52e431d282ea45ce6fab0437"


let userDefaults = UserDefaults.standard
//微信 openId : WXopenid
//qq openId : QQopenid

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
    
    func PuTongWangluo(methodName: String, methodType: HTTPMethod, rucan: Dictionary<String, Any>, success: @escaping(_ result: Any) -> (), failed: @escaping(_ error: Error) ->()) {
        let urlString = "\(url)\(methodName)"
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
    func UploadWangluo(imageArray: Array<Any>, NameArray: Array<Any>, methodName: String, rucan: Dictionary<String, Any>, success: @escaping(_ reselt: Any)->(),failed: @escaping(_ error: Error)->()) {
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
                let JsonString = self.getJSONStringFromDictionary(dictionary: rucan as NSDictionary)
                //上传参数
                multipartFormData.append((JsonString.data(using: String.Encoding.utf8)!), withName: "params")
                //上传图片
                for i in 0..<DataArr.count {
                    multipartFormData.append(DataArr[i], withName: NameArray[i] as! String, fileName: "这是第\(i)张.png", mimeType: "image/png")
                }

                
        },to: urlString,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                //连接服务器成功后，对json的处理
                upload.responseJSON { response in
                    //解包
                    guard let result = response.result.value else { return }
                    print("json:\(result)")
                }
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("图片上传进度: \(progress.fractionCompleted)")
                }
            case .failure(let encodingError):
                //打印连接失败原因
                print(encodingError)
            }
        })
    }
}
