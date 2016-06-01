//
//  BoundBankCardViewController.swift
//  HoyoServicer
//
//  Created by 婉卿容若 on 16/5/30.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//  容若的简书地址:http://www.jianshu.com/users/274775e3d56d/latest_articles
//  容若的新浪微博:http://weibo.com/u/2946516927?refer_flag=1001030102_&is_hot=1


import UIKit
import IQKeyboardManager

class BoundBankCardViewController: UIViewController {
    var tableView: UITableView!
    var dataSource:Array<BankModel> = []{
        didSet{
            
            guard dataSource.isEmpty else{
                tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
                
                //刷新数据
                tableView.reloadData()
                
                return
            }
        }
        
    }
    
    // MARK: - lift cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的银行卡"
        
        view.backgroundColor = UIColor(red: 40/255.0, green: 56/255.0, blue: 82/255.0, alpha: 1.0)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(disMissBtn))
       // navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("add_normal", target: self, action: #selector(addCards))
        
        navigationItem.rightBarButtonItem = createBarButtonItem(nil, imageName: "add_normal", target: self, action: #selector(addCards))

        
        initView()
        
        downloadDataFromServer()
        //新分支--主分支
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
        navigationController?.navigationBarHidden = true
    }
    
    // MARK: - custom methods 
    
    func initView(){
        
        
        // 初始化tableView的数据
        self.tableView=UITableView(frame:CGRectMake(0, 0, WIDTH_SCREEN,HEIGHT_SCREEN-HEIGHT_NavBar),style:UITableViewStyle.Grouped)
        tableView.backgroundColor = UIColor(red: 40/255.0, green: 56/255.0, blue: 82/255.0, alpha: 1.0)
        // 设置tableView的数据源
        self.tableView!.dataSource=self
        // 设置tableView的委托
        self.tableView!.delegate = self
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.tableFooterView = UIView(frame: CGRectZero )
        self.tableView.rowHeight = 120
        //
        self.tableView.registerNib(UINib(nibName:"BoundCarViewCell", bundle:nil), forCellReuseIdentifier:"BoundCarViewCell")
        self.view.addSubview(self.tableView!)
        
    }
    
    //barItem
    func  createBarButtonItem(title:String?,imageName: String?, target:AnyObject?,action:Selector) -> UIBarButtonItem{
        
        let btn = UIButton()
        if title != nil {
            btn.setTitle(title, forState: UIControlState.Normal)
        }
        
        if imageName != nil {
            btn.setImage(UIImage(named: imageName!), forState: UIControlState.Normal)
        }

        
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        //btn.sizeToFit()
        btn.frame = CGRectMake(0, 0, 25, 25)
        
        return UIBarButtonItem(customView: btn)
        
    }

    
}


// MARK: - download data

extension BoundBankCardViewController{
    
    func downloadDataFromServer() -> Void {
        
        weak var weakSelf = self
        User.GetOwenBindBlankCard({ (tmpArr) in
            weakSelf!.dataSource = tmpArr
        }){ (error) in
            print("错误原因:\(error.localizedDescription)")
        }
        
    }
}


// MARK: - UITableViewDelegate && UITableViewDataSoure

extension BoundBankCardViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        tableViewDisplayWithMsg("没有银行卡,点击左上角添加银行卡吧", ifNecessagryForRowCount: dataSource.count)
        return dataSource.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BoundCarViewCell") as! BoundCarViewCell
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        /*
         使用这个方法的目的: 让UITableView 滑动更流畅
         这个代理方法是在现实cell之前被调用 -- 这里cell已经现实,此时执行数据绑定会更好
         当然这对cell定高的UITableView来说没有作用,但对动态高度的cell来说,很容易地让滑动更流畅
         */
        let  cell = cell as! BoundCarViewCell
        cell.contentView.backgroundColor = UIColor(red: 40/255.0, green: 56/255.0, blue: 82/255.0, alpha: 1.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if dataSource.count > indexPath.section {
            
            cell.configureForCell(dataSource[indexPath.section])
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //删除一行
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
        
    }
    //选择一行
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //        let alert = UIAlertView()
        //        alert.title = "提示"
        //
        //        alert.addButtonWithTitle("Ok")
        //        alert.show()
    }
    
}


// MARK: - 没有数据时的用户提示

extension BoundBankCardViewController{
    
    func tableViewDisplayWithMsg(message: String, ifNecessagryForRowCount: Int ) -> Void {
        if  ifNecessagryForRowCount == 0{
            //没有数据时显示
            
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = UIFont.systemFontOfSize(15)
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            
        }else{
            tableView.backgroundView = nil
        }
    }
}

// MARK: - event response

extension BoundBankCardViewController{
    
    //左边按钮
    func disMissBtn(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    // 添加银行卡
    func addCards() {
        let addCar = AddCarViewController()
        self.navigationController?.pushViewController(addCar, animated: true)
    }
    
}