//
//  GetMoneyDetailTableViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 12/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class GetMoneyDetailTableViewController: UITableViewController {
    
    var bankInfo: String?//银行信息
    var getAmount:String? //提现金额
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "getMoneyDetailCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "getMoneyDetailCell")
        tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        // setNavigationItem("back.png", selector: #selector(doBack), isRight: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(disMissBtn))
        self.title = "提现详情"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden=false
    }
    
    // MARK: - Table view data sougrce
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("getMoneyDetailCell") as! getMoneyDetailCell
        
        cell.selectionStyle = .None
        
        cell.bankInfoLabel.text = bankInfo
        let tmp = (getAmount! as NSString).doubleValue
        cell.getAmountLabel.text = String(format: "￥%2.f",tmp)
        
        weak var weakSelf = self
        cell.sucClosure = { () -> Void in
            
            weakSelf?.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return HEIGHT_SCREEN-HEIGHT_NavBar
    }
       
}

// MARK: - event response

extension GetMoneyDetailTableViewController{
    
    func disMissBtn() -> Void{
        navigationController?.popViewControllerAnimated(true)
    }
}

