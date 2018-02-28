//
//  NetworkTools.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/2/28.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

//import UIKit
//
//enum HTRequestMethod : String {
//    case Post = "post"
//    case Get  = "get"
//}
//
//class NetworkTools: AFHTTPSessionManager {
//
//    static let shardTools : NetworkTools = {
//        let tools = NetworkTools()
//        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
//        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        return tools
//    }()
////    struct let shardTools = NetworkTools()
//
//    func request(method: HTRequestMethod , urlString : String ,parameters : AnyObject?,resultBlock : @escaping([String : Any]?, Error?) -> ()) {
////        成功闭包
//        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
//            resultBlock(responseObj as? [String : Any], nil)
//           }
////       失败闭包
//        let failureBlock = { (task: URLSessionDataTask?,error: Error)in
//            resultBlock(nil,error)
//        }
//        if method == .Post {
//            post(urlString,parameters:parameters,progress: nil,success: successBlock,failure:failureBlock)
//        }
//    }
//}

