//
//  XL_GuideViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_GuideViewController: UIViewController,UIScrollViewDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    fileprivate var scrolView: UIScrollView!
    fileprivate let numOfPages = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.view.frame
        scrolView = UIScrollView(frame: frame)
        scrolView.isPagingEnabled = true
        scrolView.showsHorizontalScrollIndicator = false
        scrolView.showsVerticalScrollIndicator = false
        scrolView.scrollsToTop = false
        scrolView.bounces = false
        scrolView.contentOffset = CGPoint.zero
        scrolView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages), height: frame.size.height)
        scrolView.delegate = self
        for index in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "引导\(index + 1)"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, width: frame.size.width, height: frame.size.height)
            scrolView.addSubview(imageView)
        }
        
        self.view.insertSubview(scrolView, at: 0
        )
        //给开始按钮设置圆角
        startButton.layer.cornerRadius = 15
        //隐藏开始按钮
        startButton.alpha = 0.0
        startButton.addTarget(self, action: #selector(tiaoye), for: .touchUpInside)
    }
  
    @objc func tiaoye() {
//        let NaviVC: XL_Navi_ViewController = storyboard!.instantiateViewController(withIdentifier: "Navi") as! XL_Navi_ViewController
        
        let leftVC = XL_LeftMenuViewController()
        let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        let delegate = UIApplication.shared
        delegate.keyWindow?.rootViewController = XL_DrawerViewController(mainVC: tabBarVC!, leftMenuVC: leftVC, leftWidth: 300)
//        delegate.keyWindow?.rootViewController = NaviVC
//        self.present(NaviVC, animated: false, completion: nil)
      
    }
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    /*
     *  Mark: UIScrollViewDelegate
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageControl.currentPage = Int(offset.x / view.bounds.width)
        
        // 因为currentPage是从0开始，所以numOfPages减1
        if pageControl.currentPage == numOfPages - 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.startButton.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.startButton.alpha = 0.0
            })
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
