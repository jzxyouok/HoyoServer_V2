//
//  TeamMemberInfoVC.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/3.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class TeamMemberInfoVC: UIViewController {
    
    var memScope:String?
    var memberInfo: TeamMembers?
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var leaveLable: UILabel!
    @IBOutlet var nickName: UILabel!
    @IBOutlet var areaLable: UILabel!
    @IBOutlet var phoneNumLb: UILabel!
    @IBOutlet var detailAreaLb: UILabel!
    
    @IBOutlet var agreeBtn: UIButton!
    @IBOutlet var refuseBtn: UIButton!
    @IBOutlet var removeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instanceUI()
        instaceView()
    }
    
    private func instanceUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(TeamMemberInfoVC.dismissAction))
        title = "成员信息"
    }
    
    private func instaceView(){
        let urlStr = "http://wechat.hoyofuwu.com" + (memberInfo?.headimageurl!)!
        print("\(urlStr)")
        iconImage.sd_setImageWithURL(NSURL(string:urlStr))
        leaveLable.text = memberInfo?.Scope
        nickName.text = memberInfo?.nickname
        areaLable.text = memberInfo?.province
        detailAreaLb.text = (memberInfo?.province)! + "  " + (memberInfo?.city)!
        phoneNumLb.text = memberInfo?.mobile
        
        if memScope == "" {
            if memberInfo!.MemberState == "70000" {
                agreeBtn.hidden = false
                refuseBtn.hidden = false
            } else if memberInfo!.MemberState == "70002" || memberInfo!.MemberState == "70003"{
                // removeBtn.hidden = false
            } else {
                removeBtn.hidden = false
            }
        }
        
    }
    
    /**
     同意
     */
    @IBAction func agreeGetMem(sender: AnyObject) {
        let params:NSDictionary = ["GroupNumber":Int((memberInfo?.GroupNumber)!)!,"userid":Int((memberInfo?.userid)!)!,"result":70001]
        weak var weakSelf = self
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        User.AuditGroupMember(params, success: {
            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            weakSelf?.navigationController?.popViewControllerAnimated(true)
        }) { (error:NSError) in
            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            let alert = UIAlertView(title: "温馨提示", message: "审核失败请重试", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    /**
     拒绝
     */
    @IBAction func refuseBtn(sender: AnyObject) {
        
        let params:NSDictionary = ["GroupNumber":Int((memberInfo?.GroupNumber)!)!,"userid":Int((memberInfo?.userid)!)!,"result":70002]
        weak var weakSelf = self
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        User.AuditGroupMember(params, success: {
            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            weakSelf?.navigationController?.popViewControllerAnimated(true)
        }) { (error:NSError) in
            MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
            let alert = UIAlertView(title: "温馨提示", message: "审核失败请重试", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        
        
    }
    /**
     移除
     */
    @IBAction func removeBtn(sender: AnyObject) {
        
        let alert = UIAlertView(title: "温馨提示", message: "确定移除该成员?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
        
    }
    func dismissAction() {
        navigationController?.popViewControllerAnimated(true)
        //
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension TeamMemberInfoVC: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            weak var weakSelf = self
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            User.RemoveCurrentTeamMember(Int((memberInfo?.GroupNumber)!)!, useid: Int((memberInfo?.userid)!)!, success: {
                MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                weakSelf?.navigationController?.popViewControllerAnimated(true)
            }) { (error:NSError) in
                MBProgressHUD.hideHUDForView(weakSelf!.view, animated: true)
                let alert = UIAlertView(title: "温馨提示", message: "移除失败请重试", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            break
        default:
            break
        }
    }
}
