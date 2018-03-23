//
//  XL_Dizhibu_ViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/3/19.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class XL_Dizhibu_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    typealias Xuanzhibody = ([String:String]) -> ()
    var dixiang: Xuanzhibody?
    override func viewDidLoad() {
        super.viewDidLoad()
        let dic = ["name":"崔海斌","phone":"15545457012","dizhi":"大河向东流"]
        
        if let block = self.dixiang {
            block(dic)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "dizhibu"
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)) as UITableViewCell
        cell.
        return cell
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
