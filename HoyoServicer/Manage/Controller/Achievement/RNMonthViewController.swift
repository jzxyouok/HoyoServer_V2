//
//  RNMonthViewController.swift
//  HoyoServicer
//
//  Created by 婉卿容若 on 16/5/24.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//  容若的简书地址:http://www.jianshu.com/users/274775e3d56d/latest_articles
//  容若的新浪微博:http://weibo.com/u/2946516927?refer_flag=1001030102_&is_hot=1


import UIKit
import MJRefresh

class RNMonthViewController: UIViewController {
    
    // MARK: - 声明变量
    
    var dataSource: [String] = []
    
    var tableView: UITableView!
    
    let cellIndentifier: String = "cellIdentifier"
    
    var currentPage: Int = 0 //获取数据-- 当前页码
    
    let header = MJRefreshNormalHeader() // 下拉刷新
    let footer = MJRefreshAutoNormalFooter() //上拉刷新
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        setUpTableView()
        
        setUpRefresh()
        
        header.beginRefreshing() // 进入页面自动刷新
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - custom mothods
    
    func setUpTableView() {
        
        
        tableView = UITableView(frame: CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - HEIGHT_NavBar - HEIGHT_TabBar), style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.dataSource = self
        tableView.delegate = self
        // tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.rowHeight = 95
        
        tableView.registerNib(UINib(nibName: "AchievementCell",bundle: nil), forCellReuseIdentifier: cellIndentifier)
        
        view.addSubview(tableView)
    }
    
    func downFirstData() {
        
        dataSource = []
        dataSource = ["jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk"]
        tableView.reloadData()
        header.endRefreshing()
        
    }
    func downloadNextData() {
        
        // 先判断页码是否大于总页数 - 如果大于 - 显示没有更多数据
        
        if currentPage > 2 {
            footer.endRefreshingWithNoMoreData()
            return
        }
        
        dataSource.appendContentsOf(["jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk","jkjjk"])
        
        //下载成功刷新
        tableView.reloadData()
        footer.endRefreshing()
    }
    
    func setUpRefresh() {
        
        //下拉刷新
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headRefresh))
        tableView.mj_header = header
        
        //上拉刷新
        
        footer.setRefreshingTarget(self, refreshingAction:  #selector(footerRefresh))
        tableView.mj_footer = footer
        
    }

}

// MARK: - event response

extension RNMonthViewController{
    
    // 下拉刷新事件
    
    func headRefresh() {
        
        if !dataSource.isEmpty {
            dataSource.removeAll() // 移除所有数据
        }
        
        currentPage = 0 //返回第一页
        footer.resetNoMoreData() // 重启
        downFirstData()
    }
    
    // 上拉刷新事件
    
    func footerRefresh() {
        
        currentPage += 1 //页码增加
        downloadNextData()
        
    }
}


// MARK: - UITableViewDelegate && UITableViewDataSoure

extension RNMonthViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableViewDisplayWithMsg("暂时没有绩效排行数据", ifNecessagryForRowCount: dataSource.count)
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier) as! AchievementCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.configCell("dsddd", index: indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true) //取消选中效果
    }
    
    // 没有数据时的用户提示
    
    func tableViewDisplayWithMsg(message: String, ifNecessagryForRowCount: Int ) -> Void {
        if  ifNecessagryForRowCount == 0{
            //没有数据时显示
            
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = UIFont.systemFontOfSize(15)
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            
            footer.hidden = true //没有数据是隐藏footer
            
        }else{
            tableView.backgroundView = nil
            footer.hidden = false
        }
    }
    
}

