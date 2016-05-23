//
//  AchievementControllerViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 6/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class AchievementControllerViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
//滚动条
    @IBOutlet weak var rollStrip: UIView!
    @IBAction func back() {
        
  
        self.navigationController?.popViewControllerAnimated(true)
    }
  var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

scrollView = UIScrollView ()
 
scrollView.frame = CGRectMake(0, 135,WIDTH_SCREEN,  HEIGHT_SCREEN - 128)
        scrollView.contentSize = CGSizeMake(WIDTH_SCREEN * 3, 0)
        scrollView.pagingEnabled = true
scrollView.clipsToBounds = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
       
               scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: scrollView.frame.height + 60 , right: 0)
        
    scrollView.bounces = true
        self.view.addSubview(scrollView)
        initScrollViewItem()
    }

    
    func initScrollViewItem()
    {
        //添加日业绩
      let scrollViewItemOne = UITableView()
        
        initWithScrollViewItem(0, scrollViewItem: scrollViewItemOne)
        
        //添加周业绩
        let scrollViewItemTwo = UITableView()
        initWithScrollViewItem(WIDTH_SCREEN, scrollViewItem: scrollViewItemTwo)
        
        //添加月业绩
        let scrollViewItemThree = UITableView()
        
        initWithScrollViewItem(WIDTH_SCREEN*2, scrollViewItem: scrollViewItemThree)
    
    }
    
    
    func   initWithScrollViewItem (X : CGFloat, scrollViewItem :UITableView)
 {
// {
//   userCenterView=UserCenterView()
//    userCenterView.view.frame=leftView.bounds
//    self.leftView.addSubview(userCenterView.view)
//    
    //添加日业绩
  
    scrollViewItem.estimatedRowHeight = 80
    scrollViewItem.rowHeight = UITableViewAutomaticDimension
    scrollViewItem.delegate = self
    scrollViewItem.dataSource = self
scrollViewItem.frame = CGRectMake(X, 0, WIDTH_SCREEN, self.scrollView.frame.size.height)
   
  
    scrollViewItem.registerNib(UINib(nibName:"AchievementCell", bundle:nil), forCellReuseIdentifier:"AchievementCell")

    
    
   scrollView.addSubview(scrollViewItem)

   
  
    
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
     
       var rect = rollStrip.frame
     rect.origin.x = self.scrollView.contentOffset.x/3
        self.rollStrip.frame.origin.x = rect.origin.x
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //   let cell = tableView.dequeueReusableCellWithIdentifier("RobListViewCell") as! RobListViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AchievementCell") as! AchievementCell
        //设置点击颜色不变
        cell.selectionStyle = .None
        
        return cell
    }

    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let detail = ListsDetailViewController()
        //
        //
        //        self.navigationController?.pushViewController(detail, animated: true)
        
        
    }
    

    


}
