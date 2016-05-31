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
    var titleStr: String?
    var sendUserID: String?
    var dataArr: [ScoreMessageModel] = []
        {
        didSet{
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instanceUI()
        getDatas()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GYDetailNewsVC.notice(_:)), name: messageNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden=false
        tabBarController?.tabBar.hidden=true
        title = titleStr
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(GYDetailNewsVC.dissBtnAction))
        weak var weakSelf = self
        dispatch_async(dispatch_get_main_queue()) { 
            weakSelf?.scrolliewToBootom()
        }
    }
    
    func notice(sender: AnyObject) {
        dataArr =  ScoreMessageModel.GetSourceArr(sendUserID!, entityName: "")
        scrolliewToBootom()
    }
    
    /**
     获取本地数据
     */
    func getDatas() {
        dataArr =  ScoreMessageModel.GetSourceArr(sendUserID!, entityName: "")
    }
    
    private func instanceUI() {
        
        NSUserDefaults.standardUserDefaults().setValue("0", forKey: "messageNum")
        NSNotificationCenter.defaultCenter().postNotificationName(messageNotification, object: nil, userInfo: ["messageNum": "1"])
        tableView.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 20)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        //        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        view.addSubview(tableView)
        tableView.registerClass(GYDetailNewCell.self, forCellReuseIdentifier: detailCellIndefier)
        tableView.registerNib(UINib(nibName: "OrderMessageCell",bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "OrderMessageCell")
        tableView.registerNib(UINib(nibName: "GYScoreMessageCell",bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "GYScoreMessageCell")
    }
    
    /**
     自动跳转到最后一行
     */
    func scrolliewToBootom() {
        if dataArr.count >= 1 {
            print(dataArr.count)
            tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: dataArr.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            
        }
    }
    
    func dissBtnAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(messageNotification)
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
        
        let model: ScoreMessageModel = dataArr[indexPath.row]
        switch model.messageType! {
        case "string":
            let  cell =  tableView.dequeueReusableCellWithIdentifier(detailCellIndefier) as! GYDetailNewCell
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.reloadUI(model)
            return cell
        case "score":
            let cell = tableView.dequeueReusableCellWithIdentifier("GYScoreMessageCell") as! GYScoreMessageCell
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.reloadUI(model)
            return cell
        case "ordernotify":
            let  cell =  tableView.dequeueReusableCellWithIdentifier("OrderMessageCell") as! OrderMessageCell
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.reloadUI(model)
            return cell
        default:
            break
        }
        
        //        cell.reloadUI(model)
        return UITableViewCell()
        
    }
    
    
    
}
