//
//  RobListMianViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 11/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVPullToRefresh

class RobListMianViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,RobListViewCellDelegate {
    var tableView  :UITableView! = nil
    //var currentData:NSMutableDictionary?
    
    @IBOutlet weak var toptitle: UILabel!
    var orderBylocationDic = NSMutableDictionary()
    
    var orderByTimeDic = NSMutableDictionary()
    
    
    var  orders=[Order]()
    
    var segSelectedIndex = 0
    
 
    
    //let segCon : UISegmentedControl = UISegmentedControl()
    lazy var segCon : UISegmentedControl = {
        let segCon = UISegmentedControl (frame: CGRectMake(60, 10, WIDTH_SCREEN-60*2, 35))
        segCon.tintColor = COLORRGBA(58, g: 58, b: 58, a: 1)
        segCon.insertSegmentWithTitle("按时间排序", atIndex: 0, animated: true)
        segCon.insertSegmentWithTitle("按距离排序", atIndex: 1, animated: true)
        return segCon
    }()
    @IBAction func back() {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    var   IsSelectLeft  = true
        {
        
        didSet{
            if IsSelectLeft == true
            {
                loadData(self.orderByTimeDic)
                
              self.addPullView(self.orderByTimeDic)
            }
            else{
                loadData(self.orderBylocationDic)
             self.addPullView(self.orderBylocationDic)
            }
            
            
        }
    
    }
    
    
   
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    //dissCall不等于nil，是从注册跳过来的，否则，从个人中心过来的
    convenience  init(addressDic : NSMutableDictionary) {
        
        var nibNameOrNil = String?("RobListMianViewController.swift")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
      
        self.orderBylocationDic = addressDic.mutableCopy() as! NSMutableDictionary
        self.orderByTimeDic = addressDic.mutableCopy() as! NSMutableDictionary
        self.orderBylocationDic.setValue("location", forKey: "orderby")
        self.orderByTimeDic.setValue("time", forKey: "orderby")
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segCon.frame = CGRectMake(60, 10, WIDTH_SCREEN-60*2, 35)
        self.automaticallyAdjustsScrollViewInsets = true
        
        tableView = UITableView(frame: CGRectMake(0, 64, WIDTH_SCREEN, HEIGHT_SCREEN-HEIGHT_NavBar))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 400
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RobListViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "RobListViewCell")
        self.view.addSubview(tableView)
        segCon.selectedSegmentIndex = 0
        tableView.separatorStyle = .None
      
        
      
      self.addPullView(self.orderByTimeDic)
     self.loadData(self.orderByTimeDic)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (orders.count)
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RobListViewCell") as! RobListViewCell
//        if (IsSelectLeft ) {
//            cell.distance.hidden = false
//      
//        }
//        else
//        {
//            cell.distance.hidden = true
//          
//        }
          cell.showCellText(self.orders[indexPath.row],title: self.toptitle.text!)
        // Configure the cell...
        cell.selectionStyle = .None
        cell.delegate = self
        return cell
    }
    
 
    //添加下拉刷新
    func addPullView(address:NSMutableDictionary){
       
        tableView.addPullToRefreshWithActionHandler {
            [weak self] in
            if let strongSelf = self{
                strongSelf.tableView.userInteractionEnabled = false
                strongSelf.loadDataByPull((address))
            }
        }
    
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print("进来了")
        
        let view = UIView(frame: CGRectMake(0, 0, WIDTH_SCREEN, 60))
        
        
        
        
        
        view.addSubview(segCon)
        segCon.addTarget(self, action: #selector(RobListMianViewController.controlPressed(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(view)
        view.backgroundColor = UIColor.whiteColor()
        return view
    }
    
    
    func loadDataByPull(param :NSDictionary){
        
        User.GetOrderList(param, success: { [weak self]orders in
            if let strongSelf = self{
                
                
                strongSelf.orders = orders
                
                strongSelf.tableView.pullToRefreshView.stopAnimating()
                strongSelf.tableView.userInteractionEnabled = true
                print("成功.....-------")
                print(orders)
                self?.tableView.reloadData()
            }}) { [weak self] (error) in
                
                if let strongSelf = self{
               strongSelf.orders = [Order]()
                self!.tableView.pullToRefreshView.stopAnimating()
            strongSelf.tableView.userInteractionEnabled = true
                    strongSelf.tableView.reloadData()
                print(error.localizedDescription)
                }
        }
        
        
    }
    
    
    
    func loadData(param :NSDictionary){
        MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
        User.GetOrderList(param, success: { [weak self]orders in
            if let strongSelf = self{
              MBProgressHUD.hideHUDForView(strongSelf.tableView, animated: true)
             strongSelf.tableView.userInteractionEnabled = true
            strongSelf.orders = orders
                
                          print("成功.....-------")
            print(orders)
            strongSelf.tableView.reloadData()
            }}) { [weak self] (error) in
                if let strongSelf = self{
                    strongSelf.orders = [Order]()
                
            //strongSelf.tableView.pullToRefreshView.stopAnimating()
                self?.tableView.userInteractionEnabled = true
              MBProgressHUD.hideHUDForView(strongSelf.tableView, animated: true)
                strongSelf.tableView.reloadData()
            print(error.localizedDescription)
                }
        }
    
        
    }
    
    func controlPressed(segCon :UISegmentedControl){
        if segCon.selectedSegmentIndex != segSelectedIndex{
            
          //MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
            self.tableView.userInteractionEnabled = false
            IsSelectLeft = (segCon.selectedSegmentIndex==0)
            
            print(IsSelectLeft)
            
            //isShow = true
            
            segSelectedIndex = segCon.selectedSegmentIndex
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = ListsDetailViewController(orderId:  orders[indexPath.row].id!, title: self.toptitle.text!)
        detail.popToSuperConBlock = {
            
            print(self.orderByTimeDic)
             self.loadData(self.orderByTimeDic)
           
        }
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    //当抢单时间所剩为0的时候刷新
    func refreshFromRobList() {
        if (IsSelectLeft == true)
        {
            loadData(self.orderByTimeDic)
        
        }
        else{
        
        loadData(self.orderBylocationDic)
        }
        
        
    }
}
