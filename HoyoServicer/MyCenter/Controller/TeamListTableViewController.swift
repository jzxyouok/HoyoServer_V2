//
//  TeamListTableViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 20/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class TeamListTableViewController: UITableViewController {
    
    var index:Int = 1
    let pageSize = 10
    
    var memScope:String?
    var memberList: [TeamMembers] = []
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
        tableView.triggerPullToRefresh()
    }
    
    private func instanceData() {
        weak var weakSelf = self
        User.GetMyGroupMembers(pageSize, index: index, success: { (tmpArr:[TeamMembers]) in
            if weakSelf?.index == 1 && weakSelf != nil{
                weakSelf?.memberList.removeAll()
                weakSelf?.memberList.appendContentsOf(tmpArr)
                weakSelf?.tableView.pullToRefreshView.stopAnimating()
                weakSelf?.tableView.infiniteScrollingView.stopAnimating()
                return
            }
            
            weakSelf?.memberList.appendContentsOf(tmpArr)
            weakSelf?.tableView.pullToRefreshView.stopAnimating()
            weakSelf?.tableView.infiniteScrollingView.stopAnimating()
            
        }) { (error:NSError) in
            
            weakSelf?.tableView.pullToRefreshView.stopAnimating()
            weakSelf?.tableView.infiniteScrollingView.stopAnimating()
        }
        
    }
    
    
    private func instanceUI(){
        self.title = "我的团队"
        tableView.estimatedRowHeight = 60
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets=false
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(WareHouseViewController.disMissBtn))
        tableView.tableFooterView = UIView()
        //tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        
        //        teamListCell?.selectionStyle=UITableViewCellSelectionStyle.None
        tableView.registerNib(UINib(nibName: "GYTeamListCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "GYTeamListCell")
        weak var weakSelf = self
        //下拉刷新
        tableView.addPullToRefreshWithActionHandler {
            print("已添加")
            weakSelf?.index = 1
            weakSelf?.instanceData()
        }
        
        //上拉加载
        tableView.addInfiniteScrollingWithActionHandler {
            weakSelf?.index = weakSelf!.index + 1
            weakSelf!.instanceData()
        }
        
        
    }
    
    
    func disMissBtn(){
        navigationController?.popViewControllerAnimated(true)
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
        return memberList.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GYTeamListCell") as! GYTeamListCell
        cell.reloadUIWithModel(memberList[indexPath.row],memScope: memScope!)
        //设置点击颜色不变
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let teamMemberInfo = TeamMemberInfoVC()
        teamMemberInfo.memberInfo = memberList[indexPath.row]
        teamMemberInfo.memScope = memScope
        navigationController?.pushViewController(teamMemberInfo, animated: true)
        
    }
    
}
