//
//  secViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/2/28.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit
import Alamofire
let host_url = "http://v.juhe.cn/toutiao/index?"    //请求地址
let host_img_url = "https://httpbin.org/image/png"   //图片 url

let appkey = "ad2908cae6020addf38ffdb5e2255c06"

let top = "top"
let shehui = "shehui"
let yule = "yule"

let main_url = "https://httpbin.prg.get"

class secViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Alamofire detail"
        let tap =  UITapGestureRecognizer(target: self, action: #selector(tapClick));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor.yellow
        let xxx = Int (UserDefaults().string(forKey: "index")!)
        print("\(String(describing: xxx))")
        switch xxx {
        case 0?:
            self.GET_Request()
        case 1?:
            self.SHURLRequest()
        case 2?:
            self.POST_Request()
        case 3?:
            self.otherMethod()
        case 4?:
            self.downloadAnduploadMethod()
        default:
            break
        }
        
    }
    @objc func tapClick(){
        
          print("按钮被点击")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func GET_Request() {
        let parameters : [String :Any] = ["foo":"bar"]
        
        Alamofire.request(main_url, method: .get, parameters: parameters).responseJSON { (returnResult) in
            print("GET_Request --> GET请求 --> returnResult = \(returnResult)")
            if let json = returnResult.result.value{
                print("firsMethod --> responseJSON --> \(json)")
                /*  返回请求地址、数据、和状态结果等信息
                 print("firstMethod --> responseJSON() --> \(returnResult.request!)")
                 print("firstMethod --> responseJSON() --> \(returnResult.data!)")
                 print("firstMethod --> responseJSON() --> \(returnResult.result)")
                 */
            }
        }
        
        //2,response()
//                Alamofire.request(main_url, method:.get, parameters: parameters).response { (response) in
//                    print("response = \(response.response)")
//                    print("data = \(response.data)")
//                    print("error = \(response.error)")
//
//
//                    if let data = response.data , let utf8string = String(data: data , encoding:.utf8) {
//                        print("utf8string = \(utf8string)")
//                    }
//        
//                }
        
        
        
        
        //3,responseData()
        //        Alamofire.request(main_url, method: .get, parameters: parameters).responseData { (responseData) in
        //            debugPrint("responseData : \(responseData)")
        //
        //            if let data = responseData.data, let utf8string = String(data: data, encoding: .utf8) {
        //                print("utf8string = \(utf8string)")
        //            }
        //
        //        }
        
        
        
        //        //4,responseString
        //        Alamofire.request(main_url, method: .get, parameters: parameters).responseString { (responseString) in
        //            debugPrint("responseString() --> Sucess = \(responseString.result.isSuccess)")
        //             debugPrint("responseString : \(responseString)")
        //
        //            if let data = responseString.data , let utf8string = String(data: data, encoding: .utf8) {
        //               print("utf8string = \(utf8string)")
        //            }
        //        }
        
        
        
        // 5. responsePropertyList()  下面解释
        
        
        
        //6.在response方法中还有一个方法  参数：queue：请求队列 --> 就是默认在主线程中执行~但是我们可以自定义调度队列。
        //        let customQueue = DispatchQueue.global(qos: .utility)
        //        Alamofire.request(main_url, method: .get, parameters: parameters).responseJSON(queue: customQueue) { (returnResult) in
        //            print("请求队列 --> \(returnResult)")
        //        }
        
        
        
    }
    
    func otherMethod() {
        
        /*
         public enum HTTPMethod: String {
         case options = "OPTIONS"
         case get     = "GET"
         case head    = "HEAD"
         case post    = "POST"
         case put     = "PUT"
         case patch   = "PATCH"
         case delete  = "DELETE"
         case trace   = "TRACE"
         case connect = "CONNECT"
         }
         */
        
        // 请求头
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(main_url, headers: headers).responseJSON { (returnResult) in
            print(" 请求头 --> returnResult = \(returnResult)")
        }
        
        //参数编码
        //Alamofire.request(SERVICE_URL, method: .post, parameters: param, encoding: URLEncoding.default)
        //Alamofire.request(SERVICE_URL, method: .post, parameters: param, encoding: URLEncoding(destination: .methodDependent))
        
        
    }
    
    //MARK: URLRequest
    func SHURLRequest() {
        
        let url = URL(string: main_url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseData { (returnResult) in
            debugPrint(returnResult)
            if let data = returnResult.data, let utf8Text =  String(data: data, encoding: .utf8) {
                print(" 请求方式 --> utf8Text = \(utf8Text)")
            }
        }
    }
    
    //下载 上传
    
    func downloadAnduploadMethod() {
        //下载文件
        Alamofire.download(host_img_url).responseJSON { (returnResult) in
            if let data = returnResult.result.value {
                let image = UIImage(data : data as! Data)
                print("\(String(describing: image))")
            }else {
                print("download is fail")
            }
        }
        
        //还可以看下载进度
        Alamofire.download(host_img_url).downloadProgress { (progress) in
            print("download progress = \(progress.fractionCompleted)")
            }.responseJSON { (returnResult) in
                if let data = returnResult.result.value {
                    let image = UIImage(data : data as! Data)
                    print("\(String(describing: image))")
                }else {
                    print("download is fail")
                }
        }
        
    }
    
    
    // post
    func POST_Request(){
        
        
        //request(host_url, method:.post, parameters : parameters)
        
        let urlstring = "\(host_url)type=\(top)&key=\(appkey)"
        
        Alamofire.request(urlstring, method:.post).responseJSON { (returnResult) in
            print("POST_Request --> post 请求 --> returnResult = \(returnResult)")
            //            switch returnResult.result.isSuccess {
            //            case true:
            //                print("数据获取成功!")
            //            case false:
            //                print(returnResult.result.error ?? Error.self)
            //            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
