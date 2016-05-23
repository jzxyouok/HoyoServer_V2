//
//  MyEvaluatTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/4/8.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
class MyEvaluatTableViewController: UITableViewController {
    //var tableView:UITableView?
    var evaluateTop :Evaluation = Evaluation()
    var scorelists : [ScoreDetail] = [ScoreDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="我的评价"
        tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        tableView!.registerNib(UINib(nibName: "MyEvaluatCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MyEvaluatCell")
        tableView!.registerNib(UINib(nibName: "MyEvaluatHeadCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MyEvaluatHeadCell")
        tableView!.separatorStyle=UITableViewCellSeparatorStyle.None
           MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        User.GetMyScoreDetails({[weak self]  (evaluation,scorelists) in
               MBProgressHUD.hideHUDForView(self!.view, animated: true)
            if let strongSelf = self{
             
               strongSelf.evaluateTop = evaluation
              strongSelf.scorelists = scorelists

             //ll
       self?.tableView.reloadData()
            }
            }) { (error) in
                
               MBProgressHUD.hideHUDForView(self.view, animated: true) 
                
        }
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience  init() {
        
        var nibNameOrNil = String?("MyEvaluatTableViewController")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden=false
        self.tabBarController?.tabBar.hidden=true
    }
    // MARK: - Table view data source

     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ScoreDetail.allCachedObjects().count+1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row==0 ? 164:135
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(indexPath.row==0 ? "MyEvaluatHeadCell":"MyEvaluatCell", forIndexPath: indexPath)
        cell.selectionStyle=UITableViewCellSelectionStyle.None
      
        if indexPath.row == 0{
            let cell = (cell as!  MyEvaluatHeadCell )
            cell.headImageView.image = UIImage(data: (User.currentUser?.headimageurl)!)
            cell.alreadyDidCount.text = (self.evaluateTop.number) == nil ? "0" :(self.evaluateTop.number)
            cell.alreadyGetLists.text = (self.evaluateTop.score) == nil ? "0" : (self.evaluateTop.score)
            let sumCount = (cell.alreadyGetLists.text! as NSString).doubleValue
       
            let count = (cell.alreadyDidCount.text! as NSString).doubleValue
            var score :Double =  0.0
            if count != 0 {
                
            
            print()
                 score = ceil(sumCount/(count))
           print(score)
            }
            self.commentStars(cell.score1, score2: cell.score2, score3: cell.score3, score4: cell.score4, score5: cell.score5,score: count == 0 ?  0 : score)
            
            cell.evaluateTitle.text = "当前累计综合评分为"+"\(score)"+"星"
        
        }else
        {
            if scorelists.count != 0{
        let cell = cell as! MyEvaluatCell
          // cell.remark.text = self.scorelists[indexPath.row-1 ].remark
                cell.orderid.text = self.scorelists[indexPath.row-1].orderId
                
                cell.headImage.sd_setImageWithURL(NSURL(string: self.scorelists[indexPath.row-1].headimageurl! as String), placeholderImage: UIImage(named: "DefaultHeadImg"))// 
                
                cell.orderid.text = self.scorelists[indexPath.row-1].orderId
                let  timeStamp  =  DateTool.dateFromServiceTimeStamp(self.scorelists[indexPath.row-1].createTime! )!
               
                cell.remark.text   =  DateTool.stringFromDate(timeStamp, dateFormat: "yyyy-MM-dd")+" "+self.scorelists[indexPath.row-1].remark!
                

                self.commentStars(cell.score1, score2: cell.score2, score3: cell.score3, score4: cell.score4, score5: cell.score5, score:  (self.scorelists[indexPath.row-1].score! as NSString).doubleValue)
            }
        }

        return cell
    }
    
    func  commentStars(score1 :UIImageView,score2 :UIImageView,score3 :UIImageView,score4 :UIImageView,score5 :UIImageView,score :Double)
    {
             let tmpImage = UIImage(named: "starsedOfHome")
        switch score {
        case 1.0:
            score1.image = tmpImage
            
        case 2.0:
          score1.image = tmpImage
            score2.image = tmpImage
            
        case 3.0:
            
        score1.image = tmpImage
            score2.image = tmpImage
            score3.image = tmpImage
            
        case 4.0:
           score1.image = tmpImage
            score2.image = tmpImage
           score3.image = tmpImage
           score4.image = tmpImage
            
        case 5.0:
         score1.image = tmpImage
            score2.image = tmpImage
            score3.image = tmpImage
            score4.image = tmpImage
           score5.image = tmpImage
            
        default:
            break
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
