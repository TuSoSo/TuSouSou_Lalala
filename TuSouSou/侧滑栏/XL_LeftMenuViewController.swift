//
//  XL_LeftMenuViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/6.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_LeftMenuViewController: UIViewController {
    fileprivate let cellIdentifier = "WLCellIdentifier"
    //    weak var delegate: XL_LeftMenuViewControllerDelegate?
    let headerViewH: CGFloat = 200
    
    var dataArray = [["我的商城","引导1"],["QQ钱包","引导1"],["个性装扮","引导1"],["我的收藏","引导1"],["我的相册","引导1"],["我的文件","引导1"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        
    }
    
    private lazy var tableView: UITableView = {
        
        let tab = UITableView(frame: CGRect(x: 0, y: self.headerViewH, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.headerViewH), style: .plain)

        tab.backgroundColor = UIColor(red: 13.0 / 255.0, green: 184.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
        tab.separatorStyle = UITableViewCellSeparatorStyle.none
        tab.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tab.delegate = self
        tab.dataSource = self
        tab.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        return tab
    }()
    
    
    private lazy var headerView: UIView = {
        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.headerViewH))
        let bgImageView = UIImageView(frame: view.frame)
        bgImageView.image = UIImage(named: "引导3")
        bgImageView.contentMode = UIViewContentMode.scaleAspectFill
        bgImageView.clipsToBounds = true
        view.addSubview(bgImageView)
        return view
        
    }()
    
}

extension XL_LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = dataArray[indexPath.row][0]
        cell.imageView?.image = UIImage(named: dataArray[indexPath.row][1])
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        vc.title = dataArray[indexPath.row][0]
        XL_DrawerViewController.shareDrawer?.LeftViewController(didSelectController: vc)
        
    }
}
