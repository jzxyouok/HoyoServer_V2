//
//  ManageTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/28.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class ManageTableViewController: UITableViewController,ManageTableViewCellDelegate {
    
    let header = MJRefreshNormalHeader() // 下拉刷新
    
    var  accountModel: MyAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.resignFirstResponder()
        self.automaticallyAdjustsScrollViewInsets=false
        tableView.registerNib(UINib(nibName: "ManageTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ManageTableViewCell")
        
        // 获取资产详情
        downloadGetMoneyDetail()
        
        // 创建刷新
        setUpRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=true
        
    }
    
    func setUpRefresh() {
        
        //下拉刷新
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headRefresh))
        tableView.mj_header = header
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_SCREEN-HEIGHT_TabBar
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ManageTableViewCell", forIndexPath: indexPath) as!  ManageTableViewCell
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        cell.delegate=self
        // Configure the cell...
        if let model = accountModel {
            cell.configCell(model)
        }
        
        
        return cell
    }
    /**
     ManageTableViewCellDelegate代理方法，从左到右，从上到下,button的tag分别为，1...8
     
     - parameter Tag: button的tag
     */
    func ButtonOfManageCell(Tag: Int) {
        switch Tag {
        case 1:
            let  financialManager = FinancialManagerVC()
            financialManager.expenditure = accountModel?.totalAssets ?? "0"
            financialManager.income = accountModel?.income ?? "0"
            financialManager.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(financialManager, animated: true)
            break
        case 2:
            let getMoney = GetMoneyViewController()
            getMoney.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(getMoney, animated: true)
            break
        case 3:
            let boundBank = BoundBankCardViewController()
            boundBank.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(boundBank, animated: true)
            
            break
        case 4:
            
            let achievement = RNAchievementViewController()
            achievement.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(achievement, animated: true)
            break
        case 5:
            let financialManager = FinancialManagerVC()
            financialManager.expenditure = accountModel?.totalAssets ?? "0"
            financialManager.income = accountModel?.income ?? "0"
            financialManager.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(financialManager, animated: true)
            
            break
        case 6:
            let newMember = RNRecruitNewMenmberViewController()
            newMember.hidesBottomBarWhenPushed  = true
            self.navigationController?.pushViewController(newMember, animated: true)
            break
            
        case 8://我的仓库
            let wareHouse = WareHouseViewController()
            wareHouse.hidesBottomBarWhenPushed  = true
            self.navigationController?.pushViewController(wareHouse, animated: true)
            break
            
        case 7://我的团队
            chooseTeam()
            break
        default:
            break
            
        }
        
    }
    
    private func chooseTeam() {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        weak var weakSelf = self
        User.GetNowAuthorityDetailInfo({ (memberArr: [TeamMembers], teamArr: [MyTeamModel]) in
            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            let myTeamController = MyTeamTableViewController()
            myTeamController.hidesBottomBarWhenPushed  = true
            self.navigationController?.pushViewController(myTeamController, animated: true)
        }) { (error:NSError) in
            print(error)
            if error.code == -10039 {
                MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                let select = SelectIDTableViewController()
                select.hidesBottomBarWhenPushed = true
                weakSelf!.navigationController?.pushViewController(select ,animated: true)
                return
            }
            
            if error.code == -10015 {
                MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                let alert = UIAlertView(title: "温馨提示", message: "账号已在其它地方登陆，请重新登录!", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            
            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            let alert = UIAlertView(title: "温馨提示", message: "请检查网络", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            
        }
        
    }
    
}

// MARK: - download data

extension ManageTableViewController{
    //获取账户余额
    func downloadGetMoneyDetail() -> Void {
        
        weak var weakSelf = self
        User.GetOwenMoney({ (model) in
            
            weakSelf?.accountModel = model
            
            weakSelf?.tableView.reloadData()
            
            weakSelf?.header.endRefreshing()
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}

// MARK: - event response

extension ManageTableViewController{
    
    // 下拉刷新事件
    
    func headRefresh() {
        
        downloadGetMoneyDetail()
    }
    
}


// MARK: - UI

