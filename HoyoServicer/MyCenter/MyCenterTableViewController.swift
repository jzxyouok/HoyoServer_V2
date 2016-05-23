//
//  MyCenterTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/28.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyCenterTableViewController: UITableViewController,MyCenterTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="我的"
        self.automaticallyAdjustsScrollViewInsets=false
        tableView.registerNib(UINib(nibName: "MyCenterTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MyCenterTableViewCell")
        tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CurrentUserDidChange), name: CurrentUserDidChangeNotificationName, object: nil)
        
    }
    
    func CurrentUserDidChange() {
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        self.tabBarController?.tabBar.hidden=false
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
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return HEIGHT_SCREEN-HEIGHT_NavBar-HEIGHT_TabBar
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCenterTableViewCell", forIndexPath: indexPath) as! MyCenterTableViewCell
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        cell.delegate=self
        
        if User.currentUser?.headimageurl != nil
        {
            
            cell.headImg.image=UIImage(data: (User.currentUser?.headimageurl)!)
            
        }
        
        cell.phone.text=User.currentUser?.mobile
        cell.jobNo.text="(工号:"+(User.currentUser?.id)!+")"
        cell.name.text=User.currentUser?.name
        return cell
    }
    /**
     MyCenterTableViewCellDelegate 方法
     
     - parameter Whitch: 1...6,从上到下
     */
    func ToDetailController(Whitch: Int) {
        switch Whitch {
        case 1:
            self.navigationController?.pushViewController(UserInfoViewController(), animated: true)
            print("查看资料")
        case 2:
            presentViewController(AuthenticationController(dissCall: nil), animated: true, completion: nil)
        case 3:
            self.navigationController?.pushViewController(MyExamViewController(), animated: true)
            print("我的考试")
        case 4:
            //            MBProgressHUD.showHUDAddedTo(view, animated: true)
            //            weak var weakSelf = self
            //            User.GetNowAuthorityDetailInfo({ (memberArr: [TeamMembers], teamArr: [MyTeamModel]) in
            //                MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            //                let myTeamController = MyTeamTableViewController()
            //                myTeamController.hidesBottomBarWhenPushed  = true
            //                self.navigationController?.pushViewController(myTeamController, animated: true)
            //            }) { (error:NSError) in
            //                MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            //                weakSelf!.navigationController?.pushViewController(SelectIDTableViewController(), animated: true)
            //            }
            chooseTeam()
            
            print("我的网点")
        case 5:
            
            self.navigationController?.pushViewController(MyEvaluatTableViewController(), animated: true)
            print("我的评价")
        case 6:
            self.navigationController?.pushViewController(SettingViewController(), animated: true)
            print("设置")
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
            
            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            let alert = UIAlertView(title: "温馨提示", message: "请检查网络", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            
        }
        
    }
    
    
}
