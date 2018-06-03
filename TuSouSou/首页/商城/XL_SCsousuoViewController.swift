//
//  XL_SCsousuoViewController.swift
//  
//
//  Created by 斌小狼 on 2018/5/7.
//

import UIKit

class XL_SCsousuoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //数组
    let DIC = [
        ["dian":["image":"广告页","Name":"我是店名","Jieshao":"如果我不说你知道我是店名吗？"],
         "wu":[
            ["image":"启动页","Name":"哇哈哈","Jieshao":"¥46.5"],["image":"启动页","Name":"哇哈哈","Jieshao":"¥46.5"]
            ]
        ],
               [
                "dian":["image":"广告页","Name":"我是店名","Jieshao":"如果我不说你知道我是店名吗？"],
                "wu":[
                    ["image":"启动页","Name":"哇哈哈","Jieshao":"¥46.5"]
                ]
        ],
    [
        "dian":["image":"广告页","Name":"我是店名","Jieshao":"如果我不说你知道我是店名吗？"],
        "wu":[]
        ]
    ]
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "搜索结果"
//        segment.frame = CGRect(x: 0, y: 8, width: Width, height: 44)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SCsousuo")
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DIC.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for i in 0..<DIC.count {
            if i == section {
                return (DIC[i]["wu"] as! Array<Any>).count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 5))
        vv.backgroundColor = UIColor(hexString: "f0eff5")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 72))
        let xiaxian = UIView(frame: CGRect(x: 24, y: 71, width: Width, height: 1))
        xiaxian.backgroundColor = UIColor(hexString: "f0f0f0")
        let shangxian = UIView(frame: CGRect(x: 24, y: 5, width: Width, height: 1))
        shangxian.backgroundColor = UIColor(hexString: "f0f0f0")
        let imageView = UIImageView(frame: CGRect(x: 8, y: 15, width: 48, height: 48))
        let image: String = (DIC[section]["dian"] as! Dictionary)["image"]!
        imageView.image = UIImage(named: "\(image)")
        let name = UILabel(frame: CGRect(x: 72, y: 21, width: Width - 142, height: 24))
        name.textColor = UIColor(hexString: "8e8e8e")
        name.text = (DIC[section]["dian"] as! Dictionary)["Name"]
        let jieshao = UILabel(frame: CGRect(x: 72, y: 37, width: Width - 142, height: 32))
        jieshao.font = UIFont.systemFont(ofSize: 13)
        jieshao.textColor = UIColor(hexString: "6e6e6e")
        jieshao.numberOfLines = 2
        jieshao.text = (DIC[section]["dian"] as! Dictionary)["Jieshao"]
        view.addSubview(imageView)
        view.addSubview(jieshao)
        view.addSubview(name)
        view.addSubview(shangxian)
        view.addSubview(xiaxian)
        view.addSubview(vv)
        view.backgroundColor = UIColor.white
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "SCsousuo"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.selectionStyle = .none
        for v: UIView in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 64, height: 64))
        
        let image: String = ((DIC[indexPath.section]["wu"] as! Array<Any>)[indexPath.row] as! Dictionary)["image"]!
        imageView.image = UIImage(named: "\(image)")
        let name = UILabel(frame: CGRect(x: 82, y: 16, width: Width - 142, height: 24))
        name.font = UIFont.systemFont(ofSize: 15)
        name.textColor = UIColor(hexString: "8e8e8e")
        name.text = ((DIC[indexPath.section]["wu"] as! Array<Any>)[indexPath.row] as! Dictionary)["Name"]
        let jieshao = UILabel(frame: CGRect(x: 88, y: 36, width: Width - 142, height: 40))
        jieshao.font = UIFont.systemFont(ofSize: 18)
        jieshao.textColor = UIColor.orange
        jieshao.numberOfLines = 2
        jieshao.text = ((DIC[indexPath.section]["wu"] as! Array<Any>)[indexPath.row] as! Dictionary)["Jieshao"]
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(jieshao)
        cell.contentView.addSubview(name)
        
        return cell
    }
    
    @IBAction func Andong(_ sender: Any) {
        if segment.isEnabledForSegment(at: 0) {
            
        }else if segment.isEnabledForSegment(at: 1) {
            
        }
    }

}
