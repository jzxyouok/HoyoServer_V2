//
//  SelectAdressTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/4/12.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class SelectAdressTableViewController: UITableViewController {
    var delegate:SelectIDTableViewControllerDelegate?
    private var adressData:NSMutableArray?
    private var firstSelectRow:Int?//一级页面选择的行号
    //firstSelectRow 小于0一级选择页面 大于0二级选择页面
    init(adressData:NSMutableArray,firstSelectRow:Int) {
        super.init(nibName: nil, bundle: nil)
        self.firstSelectRow=firstSelectRow
        self.adressData = adressData
        self.title = firstSelectRow<0 ? "选择省市":"选择市区"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets=false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return firstSelectRow!<0 ?(adressData?.count)!:(adressData?.objectAtIndex(firstSelectRow!).objectForKey("cities")?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = firstSelectRow!<0 ?(adressData?.objectAtIndex(indexPath.row).objectForKey("name") as? String):(adressData?.objectAtIndex(firstSelectRow!).objectForKey("cities")?.objectAtIndex(indexPath.row) as! String)
        // Configure the cell...

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  firstSelectRow<0 {
            //一级页面的选择事件
            let secondControll = SelectAdressTableViewController(adressData: adressData!, firstSelectRow: indexPath.row)
            secondControll.delegate=delegate
            self.navigationController?.pushViewController(secondControll, animated: true)
        }
        else{
            //二级页面的选择事件
            var tmpStr=adressData?.objectAtIndex(firstSelectRow!).objectForKey("name") as! String
            
            tmpStr+="    "+((adressData?.objectAtIndex(firstSelectRow!).objectForKey("cities")?.objectAtIndex(indexPath.row))! as! String)
            
            
            delegate?.SelectAdressFinished(tmpStr)
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3])!, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
