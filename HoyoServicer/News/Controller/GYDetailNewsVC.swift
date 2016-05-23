//
//  GYDetailNewsVC.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/18.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

let detailCellIndefier = "GYDetailNewCell"


class GYDetailNewsVC: UIViewController {
    
    var tableView: UITableView = UITableView()
    
    var dataArr: [MessageModel] = []
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
        title = "消息详情"
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(GYDetailNewsVC.dissBtnAction))
    }
    
    private func instanceUI() {
        
        NSUserDefaults.standardUserDefaults().setValue("0", forKey: "messageNum")
        NSNotificationCenter.defaultCenter().postNotificationName(messageNotification, object: nil, userInfo: ["messageNum": "1"])
        tableView.frame = view.bounds
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(tableView)
        tableView.registerClass(GYDetailNewCell.self, forCellReuseIdentifier: detailCellIndefier)
    }
    
    func dissBtnAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension GYDetailNewsVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCellWithIdentifier(detailCellIndefier) as! GYDetailNewCell
        let model: MessageModel = dataArr[indexPath.row]
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.reloadUI(model)
        return cell
        
    }
    
}
