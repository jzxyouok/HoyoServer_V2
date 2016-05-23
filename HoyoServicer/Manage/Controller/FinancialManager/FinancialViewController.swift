//
//  FinancialViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 3/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class FinancialViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
//返回
    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var tableView :UITableView?
    lazy var seg : UISegmentedControl = {

        let segCon = UISegmentedControl (frame: CGRectMake(20, 10, WIDTH_SCREEN-20*2, 35))
        segCon.insertSegmentWithTitle("明细", atIndex: 0, animated: true)
        segCon.insertSegmentWithTitle("收入", atIndex: 1, animated: true)
        segCon.insertSegmentWithTitle("支出", atIndex: 2, animated: true)
        return segCon
    }()
    
    var backControl :UIControl!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selectTimeView: UIDatePicker!
//    lazy  var selectTimeView :UIDatePicker = {
//    
//        let  picker = UIDatePicker()
//      picker.datePickerMode = UIDatePickerMode.Date
//   
//        
//      
//        return  picker
//    
//    }()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectTimeView.hidden = true
    }
    //选择时间
    @IBOutlet weak var selectTimeBtn: UIButton!
    //选择查看时间
    @IBAction func selectTime() {
        
     


        self.selectTimeView.backgroundColor = UIColor.whiteColor()
        
        
        self.backControl.frame = self.view.bounds
      self.view.bringSubviewToFront(backControl)
        self.view.bringSubviewToFront(backView)
     self.view.bringSubviewToFront(selectTimeView)
    selectTimeView.hidden = false
        selectTimeView.addTarget(self, action: #selector(FinancialViewController.select as (FinancialViewController) -> () -> ()), forControlEvents: .ValueChanged)

        
    }
   

    func select(){
        
             let select = selectTimeView.date
        let dataFormatter = NSDateFormatter()
        self.selectTimeView.datePickerMode = .Date
        dataFormatter.dateFormat="yyyy-MM-dd"
        let mon = dataFormatter.stringFromDate(select)
       var arr = NSArray()
        arr = mon.componentsSeparatedByString("-")
        print(arr[1])
            selectTimeBtn.titleLabel?.text = (arr[1] as! String)+"月"
        
    }
    
    
 
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
          addBackControl()
        initTableView()
              seg.tintColor = COLORRGBA(58, g: 58, b: 58, a: 1)
        seg.addTarget(self, action: #selector(FinancialViewController.segChange(_:)), forControlEvents: .ValueChanged)

        seg.selectedSegmentIndex = 0
        
      
        
  
          self.segChange(seg)


        
    }
    func  initTableView(){
    
        tableView = UITableView(frame: CGRectMake(0, 128, WIDTH_SCREEN, HEIGHT_SCREEN-HEIGHT_NavBar))
        
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.estimatedRowHeight = 400
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        tableView!.registerNib(UINib(nibName: "DetailfFinancialViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "DetailfFinancialViewCell")
        self.view.addSubview(tableView!)
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailfFinancialViewCell") as! DetailfFinancialViewCell
 
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let view = UIView(frame: CGRectMake(0, 0, WIDTH_SCREEN, 60))
view.addSubview(seg)
        tableView.addSubview(view)
        view.backgroundColor = UIColor.whiteColor()
        return view
    
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    
    }
    
    //添加选择时间的时候的背景效果
    func addBackControl() {
        
        if backControl == nil {
            let frame = CGRectZero
            backControl = UIControl(frame: frame)
            backControl.backgroundColor = UIColor.blackColor()
            backControl.alpha = 0.5
         
            backControl.addTarget(self, action: #selector(FinancialViewController.clickBackControl), forControlEvents: .TouchUpInside);
            
            
            self.view.addSubview(self.backControl)
            self.view.sendSubviewToBack(self.backControl)
            
        }
    }
 
    func clickBackControl(){
    
backControl.frame = CGRectZero

        selectTimeView.hidden = true
    }
    
    override func  awakeFromNib() {
       
    }
    func segChange(segCon : UISegmentedControl)
    {

        self.tableView?.reloadData()
    
        
        
//        if (segCon.selectedSegmentIndex == 0) {
//            //[self.view addSubview:self.one.tableView];
//            self.seg_Detail.tableView.hidden = false
//
//            self.seg_Detail.tableView.snp_makeConstraints(closure: { [weak self] make in
//              if let  strongSelf = self{
//                make.edges.equalTo((strongSelf.view)!).inset(UIEdgeInsetsMake(180, 0, 0, 0))
//                }
//                //make.edges.equalTo(srtrongself.view).inset(UIEdgeInsetsMake(60, 0, 0, 0))
//            })
//            
//                    self.seg_Income.tableView.hidden = true
//            self.seg_Expend.tableView.hidden = true
//            
//          
//        }
//        else if (segCon.selectedSegmentIndex == 1){
//            
//            //        [self.view addSubview:self.two.tableView];
//                      self.seg_Income.tableView.hidden = false
//            self.seg_Income.tableView.frame = CGRectMake(0, 180, WIDTH_SCREEN, HEIGHT_SCREEN - 180)
//            self.seg_Detail.tableView.hidden = true
//            self.seg_Expend.tableView.hidden = true
//            
//        }
//        else if (segCon.selectedSegmentIndex == 2){
//            //        [self.view addSubview:self.three.tableView];
//       
//            self.seg_Expend.tableView.hidden = false
//            self.seg_Expend.tableView.frame = CGRectMake(0, 180, WIDTH_SCREEN  , HEIGHT_SCREEN - 180)
//            self.seg_Detail.tableView.hidden = true
//            self.seg_Income.tableView.hidden = true
//            
//        }

        
    }
    func disappear() {
        
        backControl.frame = CGRectZero
        self.selectTimeView.removeFromSuperview()
    }
}
