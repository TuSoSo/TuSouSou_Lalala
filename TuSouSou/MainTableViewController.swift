//
//  MainTableViewController.swift
//  TuSouSou
//
//  Created by 斌小狼 on 2018/2/28.
//  Copyright © 2018年 爱普易峰. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var classArray : [String] = {
        
        let array  : [String] = ["GET","SHU","POST","other","download"];
        
        return array
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DEMO_Swfit"
        
        //remove boom line
        self.tableView.tableFooterView = UIView()
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.classArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = "maincell"
        var cell  = tableView.dequeueReusableCell(withIdentifier: identifer)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifer)
        }
        
        
        cell?.textLabel?.text = "\(self.classArray[indexPath.row])"
        
        return cell!
    }
  

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc = UIViewController()
        switch indexPath.row {
        case 0:
            UserDefaults().set(0, forKey: "index")
            vc = secViewController()
        case 1:
            UserDefaults().set(1, forKey: "index")
            vc = secViewController()
        case 2:
            UserDefaults().set(2, forKey: "index")
            vc = secViewController()
        case 3:
            UserDefaults().set(3, forKey: "index")
            vc = secViewController()
        case 4:
            UserDefaults().set(4, forKey: "index")
            vc = secViewController()
            
        default:
            break
        }
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc,animated: true, completion: nil )
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
