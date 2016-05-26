//
//  FinancialManagerVC.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/6.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit


class FinancialManagerVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var index: Int = 1
    let pageSize = 5
    
    
    var dataArr: [AccountDetailModel] = []
        {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(FinancialManagerVC.backAction))
        title = "财务管理"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instanceUI()
        getDatas()
        weak var weakSelf = self
        //下拉刷新
        tableView.addPullToRefreshWithActionHandler { 
            weakSelf!.index = 1
            weakSelf!.getDatas()
        }
        
        //上拉加载
        tableView.addInfiniteScrollingWithActionHandler { 
            weakSelf?.index = weakSelf!.index + 1
            weakSelf!.getDatas()
        }
        
    }
    
    
    func getDatas() {
        weak var weakSelf = self
        User.GetOwenMoneyDetails(index, pagesize: pageSize, success: { (accountArr: [AccountDetailModel]) in
            if weakSelf!.index == 1 {
                weakSelf?.dataArr.removeAll()
                weakSelf?.dataArr.appendContentsOf(accountArr)
                weakSelf?.tableView.pullToRefreshView.stopAnimating()
                weakSelf?.tableView.infiniteScrollingView.stopAnimating()
                return
            }
            weakSelf!.dataArr.appendContentsOf(accountArr)
            weakSelf?.tableView.pullToRefreshView.stopAnimating()
            weakSelf?.tableView.infiniteScrollingView.stopAnimating()
        }) { (error:NSError) in
            
            print("gggggggg:\(error.code)")
            weakSelf?.tableView.pullToRefreshView.stopAnimating()
            weakSelf?.tableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    func instanceUI(){
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(topView)
        topView.addSubview(payLabel)
        topView.addSubview(incomeLabel)
        topView.addSubview(payNumLabel)
        topView.addSubview(incomeNumLabel)
        let segementArr = ["明细","收入","支出"]
        let segement = UISegmentedControl(items: segementArr)
        segement.frame = CGRect(x: 12, y: CGRectGetMaxY(topView.frame) + 12, width: WIDTH_SCREEN - 24, height: 35)
        segement.tintColor = UIColor(red: 35/255.0, green: 39/255.0, blue: 44/255.0, alpha: 1.0)
        segement.selectedSegmentIndex = 0
        view.addSubview(segement)
        tableView.frame = CGRect(x: 0, y: CGRectGetMaxY(segement.frame) + 12, width: WIDTH_SCREEN, height: HEIGHT_SCREEN - CGRectGetMaxY(segement.frame) - 76)
        tableView.backgroundColor = UIColor.lightGrayColor()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80
        tableView.registerClass(FinacialManagerCell.self, forCellReuseIdentifier: "FinacialManagerCell")
    }
    
    func backAction(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: -界面所需控件
    private lazy var tableView: UITableView = {
        let tab = UITableView()
        return tab
    }()
    private lazy var topView: UIView = {
        let vi = UIView()
        vi.frame = CGRect(x: 0, y: 0, width: WIDTH_SCREEN, height: 60)
        //设置背景图片颜色
        vi.layer.contents = UIImage(named:"blackImgOfNavBg")?.CGImage
        return vi
    }()
    
    private lazy var payLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 0, y: 0, width: WIDTH_SCREEN/2, height: 30)
        //        lb.backgroundColor = UIColor.redColor()
        lb.text = "支出(元)"
        lb.textColor = UIColor.grayColor()
        lb.textAlignment = NSTextAlignment.Center
        return lb
    }()
    
    private lazy var incomeLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: WIDTH_SCREEN/2, y: 0, width: WIDTH_SCREEN/2, height: 30)
        //        lb.backgroundColor = UIColor.purpleColor()
        lb.text = "收入(元)"
        lb.textColor = UIColor.grayColor()
        lb.textAlignment = NSTextAlignment.Center
        return lb
    }()
    
    private lazy var payNumLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 0, y: 30, width: WIDTH_SCREEN/2, height: 30)
        //        lb.backgroundColor = UIColor.redColor()
        lb.text = "0.0"
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = NSTextAlignment.Center
        return lb
    }()
    
    private lazy var incomeNumLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: WIDTH_SCREEN/2, y: 30, width: WIDTH_SCREEN/2, height: 30)
        //        lb.backgroundColor = UIColor.purpleColor()
        lb.text = "0.0"
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = NSTextAlignment.Center
        return lb
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: - tableView代理方法 数据源
extension FinancialManagerVC
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FinacialManagerCell") as! FinacialManagerCell
        cell.selectionStyle = .None
        let model =  dataArr[indexPath.row]
        cell.reloadUI(model)
        return cell
        
    }
    
}

