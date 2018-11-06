//
//  XL_YQHY_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/6/2.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_YQHY_ViewController: UIViewController,UIActionSheetDelegate{

    @IBOutlet weak var wodeerweima: UILabel!
    @IBOutlet weak var youhuizhengce: UILabel!
    @IBOutlet weak var erweima: UIImageView!
    var lujing = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邀请好友"
        let youhuizheng=userDefaults.value(forKey: "yaoqingyouhui") as! String
        youhuizhengce.text = youhuizheng
        let invitingCode = userDefaults.value(forKey: "invitationCode") as! String
        wodeerweima.text = "我的邀请码为: \(invitingCode)"
        lujing = "http://wx.tusousouxr.com/index.php/index/user/register/userType/1.html?invitationCode=" + invitingCode
        erweima.isUserInteractionEnabled = true
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        erweima.addGestureRecognizer(longpressGesutre)
        youAnniu()
        erweimaShengcheng()
        // Do any additional setup after loading the view.
    }
    func youAnniu() {
        let item = UIBarButtonItem(title:"已邀请",style: .plain,target:self,action:#selector(YouAction))
        self.navigationItem.rightBarButtonItem = item
    }
    @objc func YouAction() {
        let WDXX: XL_YiYaohaoyou_ViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "yiyaoqing") as? XL_YiYaohaoyou_ViewController
        self.navigationController?.pushViewController(WDXX!, animated: true)
    }
    func erweimaShengcheng() {
        view.endEditing(true)
        
        
        let str:String = lujing
        
        
        // 1. 创建二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 1.1 恢复滤镜默认设置
        filter?.setDefaults()
        
        // 2. 设置滤镜输入数据
        // KVC
        let data = str.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        
        // 2.2 设置二维码的纠错率
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        
        
        // 3. 从二维码滤镜里面, 获取结果图片
        var image = filter?.outputImage
        
        
        // 借助这个方法, 处理成为一个高清图片
        let transform = CGAffineTransform(scaleX: 20, y: 20)
        image = image?.transformed(by: transform)

        // 3.1 图片处理
        // (23.0, 23.0)
        let resultImage = UIImage(ciImage: image!)
        print(resultImage.size)
        
        // 前景图片
//        let center = UIImage(named: "erha.png")
//        resultImage = getNewImage(resultImage, center: center!)
        
        
        // 4. 显示图片
        erweima.image = resultImage
        
    }
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        let alertController = UIAlertController(title: "提示", message: "您可以对图片进行一下操作",
                                                preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let paizhaoAction = UIAlertAction(title: "保存到相册", style: .default) { (ss) in
            print("拍照")
            UIImageWriteToSavedPhotosAlbum(self.erweima.image!, nil, nil, nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(paizhaoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func shareWX(_ sender: Any) {
        sendWXFX(inScene: WXSceneSession)
    }
    @IBAction func PYQ(_ sender: Any) {
        sendWXFX(inScene: WXSceneTimeline)
    }
    
    //分享文本
    //inScene可选的值有三个：WXSceneTimeline（朋友圈）、WXSceneSession（聊天界面） 、WXSceneFavorite（收藏）
    func sendWXFX(inScene: WXScene){
        let webpage = WXWebpageObject()
        webpage.webpageUrl = lujing
        let msg = WXMediaMessage()
        msg.mediaObject = webpage
        msg.title = "欢迎注册使用飕飕网递"
        msg.description = "飕飕网递应用分享"
        msg.setThumbImage(UIImage(named: "80"))
        //      msg.setThumbImage(UIImage(named: "引导1")) msg.setThumbImage(Data.sharedManager.searchArticle.imagedic[content.contentImg])
        let req = SendMessageToWXReq()
        req.message = msg
        req.scene = Int32(inScene.rawValue)
        WXApi.send(req)
        
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
