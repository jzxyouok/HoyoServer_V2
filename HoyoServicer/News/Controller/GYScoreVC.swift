//
//  GYScoreVC.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/20.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

let scoreMessageCellID = "scoreMessageCellID"

class  GYScoreVC: UIViewController {
    
    var tableView: UITableView = UITableView()
    
    var dataArr: [ScoreMessageModel] = []
        {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instanceUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden=false
        tabBarController?.tabBar.hidden=true
        view.backgroundColor = UIColor.redColor()
        title = "评价详情"
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(GYScoreVC.dissBtnAction))
    }
    
    private func instanceUI() {
        
        NSUserDefaults.standardUserDefaults().setValue("0", forKey: "scoreNum")
        NSNotificationCenter.defaultCenter().postNotificationName(messageNotification, object: nil, userInfo: ["messageNum": "1"])
        tableView.frame = view.bounds
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        //        tableView.rowHeight = 300
        
        view.addSubview(tableView)
        tableView.registerClass(ScoreMessageCell.self, forCellReuseIdentifier: scoreMessageCellID)
        
    }
    
    func dissBtnAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension  GYScoreVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCellWithIdentifier(scoreMessageCellID) as! ScoreMessageCell
        
        let model: ScoreMessageModel = dataArr[indexPath.row]
        cell.selectionStyle = .None
        cell.reloadUI(model)
        return cell
        
    }
    
}

