//
//  NewsTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/28.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import SVPullToRefresh

class NewsTableViewController: UITableViewController {
    
    var dataArr: [MessageModel] = []
    var scoreArr: [ScoreMessageModel] = []
    var modelLast: MessageModel?
    var isBool: Bool = false
    
    var messageList: Int = 0
        {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instanceUI()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsTableViewController.notice(_:)), name: messageNotification, object: nil)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        self.tabBarController?.tabBar.hidden=false
        getDatas()
    }
    private func instanceUI() {
        self.title="消息"
        tableView.registerNib(UINib(nibName: "NewsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "NewsTableViewCell")
        tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        
    }
    
    func getDatas() {
        dataArr.removeAll()
        scoreArr.removeAll()
        let modelArr: [MessageModel] = (MessageModel.allCachedObjects() as? [MessageModel])!
        dataArr = modelArr
        let scoreArrT:[ScoreMessageModel] = (ScoreMessageModel.allCachedObjects() as? [ScoreMessageModel])!
        scoreArr = scoreArrT
        
        let dataInt = dataArr.count == 0 ? 0 : 1
        let scoreInt = scoreArr.count == 0 ? 0 : 1
        messageList = dataInt + scoreInt
        if let boolis = NSUserDefaults.standardUserDefaults().valueForKey("StateMessage") as? Bool {
            isBool = boolis
        }
        
    }
    
    func notice(sender: AnyObject) {
        getDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return messageList
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
        cell.selectionStyle=UITableViewCellSelectionStyle.Blue
        if indexPath.section == 0 {
            
            if isBool {
                let model: ScoreMessageModel = scoreArr.last!
                cell.reloadScoreUI(model)
            } else {
                let mode: MessageModel = dataArr.last!
                cell.reloadUI(mode)
            }
            
        } else {
            if isBool {
                let mode: MessageModel = dataArr.last!
                cell.reloadUI(mode)
                
            } else {
                let model: ScoreMessageModel = scoreArr.last!
                cell.reloadScoreUI(model)
            }
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if isBool {
                let detailController = GYScoreVC()
                detailController.dataArr = scoreArr
                self.navigationController?.pushViewController(detailController, animated: true)
            } else {
                let detailController = GYDetailNewsVC()
                detailController.dataArr = dataArr
                self.navigationController?.pushViewController(detailController, animated: true)
            }
            
        } else {
            if isBool {
                let detailController = GYDetailNewsVC()
                detailController.dataArr = dataArr
                self.navigationController?.pushViewController(detailController, animated: true)
            } else {
                let detailController = GYScoreVC()
                detailController.dataArr = scoreArr
                self.navigationController?.pushViewController(detailController, animated: true)
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if indexPath.section == 0 {
                if isBool {
                    scoreArr.removeAll()
                    DataManager.defaultManager.deleteAllObjectsWithEntityName("ScoreMessageModel")
                    NSUserDefaults.standardUserDefaults().setValue(!isBool, forKey: "StateMessage")
                    NSUserDefaults.standardUserDefaults().setValue("0", forKey: "scoreNum")
                    NSNotificationCenter.defaultCenter().postNotificationName(messageNotification, object: nil, userInfo: ["messageNum": "1"])
                    getDatas()
                } else {
                    dataArr.removeAll()
                    DataManager.defaultManager.deleteAllObjectsWithEntityName("MessageModel")
                    NSUserDefaults.standardUserDefaults().setValue(!isBool, forKey: "StateMessage")
                    NSUserDefaults.standardUserDefaults().setValue("0", forKey: "messageNum")
                    NSNotificationCenter.defaultCenter().postNotificationName(messageNotification, object: nil, userInfo: ["messageNum": "1"])
                    getDatas()
                }
            } else {
                if isBool {
                    dataArr.removeAll()
                    DataManager.defaultManager.deleteAllObjectsWithEntityName("MessageModel")
                    NSUserDefaults.standardUserDefaults().setValue("0", forKey: "messageNum")
                    NSNotificationCenter.defaultCenter().postNotificationName(messageNotification, object: nil, userInfo: ["messageNum": "1"])
                    getDatas()
                } else {
                    scoreArr.removeAll()
                    DataManager.defaultManager.deleteAllObjectsWithEntityName("ScoreMessageModel")
                    NSUserDefaults.standardUserDefaults().setValue("0", forKey: "scoreNum")
                    NSNotificationCenter.defaultCenter().postNotificationName(messageNotification, object: nil, userInfo: ["messageNum": "1"])
                    getDatas()
                }
            }
            tableView.reloadData()
        } else if editingStyle == .Insert {
            
        }    
    }
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return  "删除"
    }
    
    
}
