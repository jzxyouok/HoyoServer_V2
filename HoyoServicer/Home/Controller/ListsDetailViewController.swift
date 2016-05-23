//
//  ListsDetailViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 11/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

import MBProgressHUD

class ListsDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DetailViewCellDelegate {
    var orderID :String!
    var  detailArr  = [AnyObject]()
    var popToSuperConBlock : (()->Void)?
    var orderDetail :OrderDetail?
    var textTitle:String?
    @IBOutlet weak var toptitle: UILabel!
  
    @IBAction func back() {
        
        self.navigationController?.navigationBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    var tableView :UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
                    hideNavBarAndStatus()
        
       initView()
        tableView.estimatedRowHeight = 667
        
        tableView.rowHeight = UITableViewAutomaticDimension
        navBar.alpha = 0.6
      self.loadData()
        self.toptitle.text! = textTitle!
   self.tableView.separatorStyle = .None
    
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    UIApplication.sharedApplication().statusBarHidden = true
    }
    
    //设置navBar
    @IBOutlet weak var navBar: UIView!
    
    
    func initView(){
        // 初始化tableView的数据
        self.tableView=UITableView(frame:CGRectMake(0, 0, WIDTH_SCREEN,HEIGHT_SCREEN),style:UITableViewStyle.Plain)
        // 设置tableView的数据源
        self.tableView!.dataSource=self
        // 设置tableView的委托
        self.tableView!.delegate = self
        //
        self.tableView.registerNib(UINib(nibName:"DetailViewCell", bundle:nil), forCellReuseIdentifier:"DetailViewCell")
           self.tableView.registerNib(UINib(nibName:"DetailTableViewCell2", bundle:nil), forCellReuseIdentifier:"DetailTableViewCell2")
           self.tableView.registerNib(UINib(nibName:"DetailTableViewCell3", bundle:nil), forCellReuseIdentifier:"DetailTableViewCell3")
        self.view.addSubview(self.tableView!)
       // self.tableView.bounds =  CGRectMake(0, 6, WIDTH_SCREEN, HEIGHT_SCREEN)
       // self.tableView.bounds = CGRectMake(0, -64, WIDTH_SCREEN, HEIGHT_SCREEN)

       
        self.navBar.alpha  = 0.26
        self.view.bringSubviewToFront(navBar)
    }
  func   hideNavBarAndStatus(){
    
    UIApplication.sharedApplication().statusBarHidden = true
    self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    //dissCall不等于nil，是从注册跳过来的，否则，从个人中心过来的
    convenience  init(orderId : String,title :String) {
        
        var nibNameOrNil = String?("ListsDetailViewController.swift")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        
        self.orderID = orderId
        textTitle = title
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK:  Table view data source
    
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 1
    }
    
 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // warning Incomplete implementation, return the number of rows
    
        return (detailArr.count)
    }
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    
//    if orderDetail == nil {
//        
//    }
//    else{
//    cell.showCellText(orderDetail!,title: self.toptitle.text!)
//    }
    switch (detailArr.count) as Int {
    case 1 :
        if indexPath.row == 0  {
            
       
         let   cell  = tableView.dequeueReusableCellWithIdentifier("DetailViewCell") as! DetailViewCell
        cell.showCellText(detailArr[0] as! OrderDetail, title: self.toptitle.text!)
            cell.delegate = self
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.grayColor()
            cell.frame = CGRectMake(0, -64, WIDTH_SCREEN, cell.frame
                .size.height)
        return cell
        }
        break
    case 2:
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailViewCell") as! DetailViewCell
            cell.showCellText(detailArr[indexPath.row] as! OrderDetail, title: self.toptitle.text!)
      cell.delegate = self
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.grayColor()
            cell.frame = CGRectMake(0, -64, WIDTH_SCREEN, cell.frame
                .size.height)
        return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell2") as! DetailTableViewCell2
         cell.showDetail2Text(detailArr[indexPath.row] as! FinshDetail)
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.grayColor()
            cell.frame = CGRectMake(0, -64, WIDTH_SCREEN, cell.frame
                .size.height)
            return cell
        }
        
        break
    case 3:
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailViewCell") as! DetailViewCell
            cell.showCellText(detailArr[indexPath.row] as! OrderDetail, title: self.toptitle.text!)
            cell.delegate = self
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.grayColor()
            cell.frame = CGRectMake(0, -64, WIDTH_SCREEN, cell.frame
                .size.height)
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell2") as! DetailTableViewCell2
            cell.showDetail2Text(detailArr[indexPath.row] as! FinshDetail)
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.grayColor()
            cell.frame = CGRectMake(0, -64, WIDTH_SCREEN, cell.frame
                .size.height)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell3") as! DetailTableViewCell3
            cell.showDetail3Text(detailArr[indexPath.row] as! Settlementinfo)
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.grayColor()
            cell.frame = CGRectMake(0, -64, WIDTH_SCREEN, cell.frame
                .size.height)
            return cell
        }
        break
    default:
        break
     
    }
//    if (detailArr?.count)! as Int != 0 {
//        if detailArr[indexPath.row] != nil {
//            <#code#>
//        }
//    }
    
    //
    let cell = UITableViewCell()
    return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    let y = self.tableView.bounds.origin.y
        
    
        if  y <= 0{
            self.navBar.alpha = 0.58
             print("\(self.navBar.alpha)" + "--------")
        }
        else{
      self.navBar.alpha = (self.tableView.bounds.origin.y+80)/230
        
        print(self.navBar.alpha)
        }
    }

    func loadData(){
         
        MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
        
        User.GetOrderDetails(self.orderID, success: {[weak self] arr in
            if let strongSelf = self{
                MBProgressHUD.hideHUDForView(strongSelf.tableView, animated: true)
                print(arr)
                self?.detailArr = arr
                print("成功.....-------")
                print(arr)
                strongSelf.tableView.reloadData()
            } }) { (error) in
                
                MBProgressHUD.hideHUDForView(self.tableView, animated: true)
                print(error.localizedDescription)
        }
        
        
    }
    
    //实现详情页头的代理
    func backToSuperCon() {
        
        self.back()
         popToSuperConBlock!()
       
        
    }
    
    func showBrowPhtotoCon(cell :BrowseCollectionViewCell,browseItemArray:NSMutableArray) {
    
        let bvc = MSSBrowseNetworkViewController.init(browseItemArray: browseItemArray as [AnyObject], currentIndex: cell.imageView.tag - 100)
      self.presentViewController(bvc, animated: false, completion: nil)
    }
    
    
    func pushToSubmitView()
        {
        
            
       let submit  =  SubmitController(orderDetail: self.detailArr.first as! OrderDetail!)
         self.navigationController?.pushViewController(submit, animated: true)
            
        }
    
  
}
