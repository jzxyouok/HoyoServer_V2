//
//  RobListOneController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 30/3/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVPullToRefresh
class RobListOneController: UITableViewController,UIGestureRecognizerDelegate ,RobListViewCellDelegate{
    var textTitle:String?
    var orders=[Order]()
    var oderbyTime = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden=false

        tableView.estimatedRowHeight = 400
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
         tableView.registerNib(UINib(nibName: "RobListViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "RobListViewCell")
        self.tableView.backgroundColor = COLORRGBA(239, g: 239, b: 244, a: 1)
        
        setNavigationItem("back.png", selector: #selector(doBack), isRight: false)

        setNavigationItem(oderbyTime.objectForKey("city") as! String, selector: #selector(doRight), isRight: true)
tableView.separatorStyle = .None
     MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
         self.loadData()
     self.addPullView()
         self.title = textTitle
        

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    //dissCall不等于nil，是从注册跳过来的，否则，从个人中心过来的
    convenience  init(title :String,orderBytime:NSMutableDictionary ,action:String) {
        
        var nibNameOrNil = String?("RobListOneController.swift")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        
        self.textTitle = title
        
        self.oderbyTime = orderBytime.mutableCopy() as! NSMutableDictionary
        self.oderbyTime.setValue("time", forKey: "orderby")
        self.oderbyTime.setValue(action, forKey: "action")
        
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
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
        return orders.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     //   let cell = tableView.dequeueReusableCellWithIdentifier("RobListViewCell") as! RobListViewCell

        let cell = tableView.dequeueReusableCellWithIdentifier("RobListViewCell") as! RobListViewCell
      
        //设置点击颜色不变
        cell.selectionStyle = .None
       
        
        cell.showCellText(orders[indexPath.row],title: self.title!)
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     // self.navigationController?.navigationBarHidden=false
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
//        if (self.navigationController.respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        {
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//        }
     
            self.navigationController!.interactivePopGestureRecognizer!.enabled = true
                     self.navigationController!.interactivePopGestureRecognizer!.delegate = nil
            
      
        //orderId: orders[indexPath.row].id!
   
        let detail = ListsDetailViewController(orderId: orders[indexPath.row].id!, title: self.title!)
        detail.hidesBottomBarWhenPushed = true
      
         self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    
   
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.interactivePopGestureRecognizer!.enabled = false
        
        print("hjkhdkjhkjh")
    }
    
    func loadData(){
        
        User.GetOrderList(self.oderbyTime, success: {[weak self] orders in
            if let strongSelf = self{
           MBProgressHUD.hideHUDForView(strongSelf.tableView, animated: true)
       strongSelf.orders = orders
            print("成功.....-------")
            print(orders)
            strongSelf.tableView.reloadData()
            } }) { (error) in
            
          MBProgressHUD.hideHUDForView(self.tableView, animated: true)
            print(error.localizedDescription)
        }
        
        
    }
    
    //添加下拉刷新
    func addPullView(){
        
        tableView.addPullToRefreshWithActionHandler {
            [weak self] in
            if let strongSelf = self{
                strongSelf.tableView.userInteractionEnabled = false
                strongSelf.loadDataByPull((strongSelf.oderbyTime))
            }
        }
        
    }
    
    func loadDataByPull(param :NSDictionary){
        
        User.GetOrderList(param, success: { [weak self]orders in
            if let strongSelf = self{
                
                
                strongSelf.orders = orders
                
                strongSelf.tableView.pullToRefreshView.stopAnimating()
                strongSelf.tableView.userInteractionEnabled = true
                print("成功.....-------")
                print(orders)
                strongSelf.tableView.reloadData()
            }}) { [weak self] (error) in
                
                
    
                self!.tableView.pullToRefreshView.stopAnimating()
                self?.tableView.userInteractionEnabled = true
                print(error.localizedDescription)
                
        }
        
        
    }
    func refreshFromRobList() {
        //待处理不需要
    }
    
}
