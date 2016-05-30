//
//  NewsTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/28.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var dataArr: [MessageModel] = []
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
        var modelArr: [MessageModel] = (MessageModel.allCachedObjects() as? [MessageModel])!
        modelArr.sortInPlace { (s1:MessageModel, s2: MessageModel) -> Bool in
            return Int(s1.msgId!)! > Int(s2.msgId!)!
        }
        dataArr = modelArr
        messageList = dataArr.count
    }
    
    //数组对象排序
    func onSort(s1: MessageModel,s2: MessageModel) -> Bool {
        return Int(s1.msgId!)! > Int(s2.msgId!)!
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageList ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
        if dataArr.count != 0 {
            let model:MessageModel = dataArr[indexPath.row]
            cell.selectionStyle=UITableViewCellSelectionStyle.Blue
            cell.reloadUI(model)
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detail = GYDetailNewsVC()
        let model = dataArr[indexPath.row]
        detail.dataArr =  ScoreMessageModel.GetSourceArr(model.sendUserid!, entityName: "")
        detail.sendUserID = model.sendUserid
        detail.titleStr = model.sendNickName
        navigationController?.pushViewController(detail, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let model = dataArr[indexPath.row]
            ScoreMessageModel.deleteSource(model.sendUserid!, entityName: "")
            MessageModel.deleteSource(model.sendUserid!, entityName: "")
            getDatas()
        }
    }
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return  "删除"
    }
    
}

