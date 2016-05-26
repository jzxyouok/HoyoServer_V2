//
//  MyTeamTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/4/19.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import MBProgressHUD
class MyTeamTableViewController: UITableViewController {
    
    var rightBtnState: Bool  = false
    var bootomViewState: Bool = true
    var myTeamCell:MyTeamCell?
    var teamMembers:[TeamMembers]?
    ///保存我的团队相关信息
    var myTeamData :[MyTeamModel]?
        {
        didSet{
            let modelTeam = myTeamData![0]
            if modelTeam.userself != "" {
                switch modelTeam.userselfMemberState! {
                case "审核失败","被封号了","审核中":
                    rightBtnState = false
                    bootomBtn.setTitle("取消申请", forState: UIControlState.Normal)
                    break
                case "审核成功":
                    rightBtnState = true
                    bootomBtn.setTitle("退出团队", forState: UIControlState.Normal)
                    break
                default:
                    break
                }
            } else {
                switch modelTeam.memberState! {
                case "审核失败","被封号了","审核中":
                    rightBtnState = false
                    bootomBtn.setTitle("取消申请", forState: UIControlState.Normal)
                    break
                case "审核成功":
                    rightBtnState = true
                    bootomViewState = false
                    //                    bootomBtn.setTitle("解散团队", forState: UIControlState.Normal)
                    break
                default:
                    break
                }
                
            }
            if rightBtnState  {
                let rightBarButton = UIBarButtonItem(title: "成员列表", style: .Plain, target: self, action: #selector(ToMemberList))
                navigationItem.rightBarButtonItem=rightBarButton
                navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**
         获取数据
         */
        instanceData()
        instanceUI()
        
    }
    private func instanceData(){
        
        weak var weakSelf = self
        
        User.GetNowAuthorityDetailInfo({ (memberArr: [TeamMembers], teamArr: [MyTeamModel]) in
            weakSelf?.myTeamData = teamArr
            weakSelf?.teamMembers = memberArr
            // ---
            weakSelf?.addUI()
        }) { (error:NSError) in
            weakSelf?.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    private func instanceUI(){
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.title="我的团队"
        UITableViewStyle.Grouped
        self.automaticallyAdjustsScrollViewInsets=false
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(WareHouseViewController.disMissBtn))
        tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        myTeamCell=NSBundle.mainBundle().loadNibNamed("MyTeamCell", owner: self, options: nil).last as? MyTeamCell
        myTeamCell?.selectionStyle=UITableViewCellSelectionStyle.None
    }
    
    func  addUI() {
        if bootomViewState {
            let booview = UIView()
            booview.frame = CGRect(x: 0, y: 0, width: WIDTH_SCREEN, height: 60)
            booview.backgroundColor = UIColor.groupTableViewBackgroundColor()
            booview.addSubview(bootomBtn)
            bootomBtn.addTarget(self, action: #selector(MyTeamTableViewController.teamAction), forControlEvents: UIControlEvents.TouchUpInside)
            tableView.tableFooterView = booview
        }
    }
    
    func teamAction() {
        let modelTeam = myTeamData![0]
        if modelTeam.userself != "" {
            switch modelTeam.userselfMemberState! {
            case "审核失败","被封号了","审核中":
                let alert = UIAlertView(title: "温馨提示", message: "确定取消团队申请?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alert.show()
                break
            case "审核成功":
                //退出当前团队，已成功
                let alert = UIAlertView(title: "温馨提示", message: "确认退出团队?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alert.show()
            default:
                break
            }
        } else {
            switch modelTeam.memberState! {
            case "审核失败","被封号了","审核中":
                //取消创建团队申请.已成功
                let alert = UIAlertView(title: "温馨提示", message: "确定取消创建团队申请?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alert.show()
                break
            case "审核成功":
                //解散团队.已成功
                let alert = UIAlertView(title: "温馨提示", message: "确定解散团队?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alert.show()
                break
            default:
                break
            }
        }
        
    }
    
    func disMissBtn() {
        navigationController?.popViewControllerAnimated(true)
    }
    /**
     跳转到成员列表
     */
    func ToMemberList() {
        let modelTeam = myTeamData![0]
        let teamList  = TeamListTableViewController()
        //        teamList.memberList = teamMembers
        teamList.memScope = modelTeam.userself
        self.navigationController?.pushViewController(teamList, animated: true)
    }
    
    /// 底部按钮
    private lazy var bootomBtn: UIButton = {
        let lb = UIButton()
        lb.backgroundColor = UIColor.orangeColor()
        lb.frame = CGRect(x: 5, y: 10, width: WIDTH_SCREEN - 10, height: 40)
        return lb
    }()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        //self.tabBarController?.tabBar.hidden=true
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myTeamData?.count ?? 0
    }
    
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return max(HEIGHT_SCREEN-64, 780)
    //    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        myTeamCell?.instanceUI(myTeamData![indexPath.row])
        return myTeamCell!
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        var nibNameOrNil = String?("MyTeamTableViewController")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
            
        {
            nibNameOrNil = nil
            
        }
        
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
}



//MARK: - alertView 响应事件
extension MyTeamTableViewController: UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            let modelTeam = myTeamData![0]
            weak var weakSelf = self
            if modelTeam.userself != "" {
                switch modelTeam.userselfMemberState! {
                case "审核失败","被封号了","审核中":
                    //取消进入当前团队，已成功
                    MBProgressHUD.showHUDAddedTo(view, animated: true)
                    User.RemoveTeamMember(Int(modelTeam.groupNumber!)!, success: {
                        print("取消成功")
                        MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                        weakSelf?.navigationController?.popViewControllerAnimated(true)
                        }, failure: { (NSError) in
                            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                            let alert = UIAlertView(title: "温馨提示", message: "取消失败请重试", delegate: nil, cancelButtonTitle: "确定")
                            alert.show()
                    })
                    break
                case "审核成功":
                    //退出当前团队，已成功
                    //                    let alert = UIAlertView(title: "温馨提示", message: "确认退出团队?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                    //                    alert.show()
                    MBProgressHUD.showHUDAddedTo(view, animated: true)
                    User.RemoveTeamMember(Int(modelTeam.groupNumber!)!, success: {
                        print("退出成功")
                        MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                        weakSelf?.navigationController?.popViewControllerAnimated(true)
                        }, failure: { (NSError) in
                            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                            let alert = UIAlertView(title: "温馨提示", message: "退出失败请重试", delegate: nil, cancelButtonTitle: "确定")
                            alert.show()
                    })
                default:
                    break
                }
            } else {
                switch modelTeam.memberState! {
                case "审核失败","被封号了","审核中":
                    //取消创建团队申请.已成功
                    MBProgressHUD.showHUDAddedTo(view, animated: true)
                    User.DeleteTeamAll((Int(modelTeam.groupNumber!))!, success: {
                        MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                        weakSelf?.navigationController?.popViewControllerAnimated(true)
                        }, failure: { (NSError) in
                            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                            let alert = UIAlertView(title: "温馨提示", message: "取消申请失败请重试", delegate: nil, cancelButtonTitle: "确定")
                            alert.show()
                    })
                    break
                case "审核成功":
                    //解散团队.已成功
                    MBProgressHUD.showHUDAddedTo(view, animated: true)
                    User.DeleteTeamAll(Int(modelTeam.groupNumber!)!, success: {
                        MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                        weakSelf?.navigationController?.popViewControllerAnimated(true)
                        }, failure: { (NSError) in
                            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                            let alert = UIAlertView(title: "温馨提示", message: "解散失败请重试", delegate: nil, cancelButtonTitle: "确定")
                            alert.show()
                    })
                    break
                default:
                    break
                }
            }
            break
        default:
            break
        }
    }
    
}


