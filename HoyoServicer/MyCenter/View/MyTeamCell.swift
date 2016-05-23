//
//  MyTeamCell.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/4/19.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import SDWebImage

class MyTeamCell: UITableViewCell {
    
    
    @IBOutlet var groupMaxNumber: UILabel!
    @IBOutlet var grapNumber: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    @IBOutlet var numLabel: UILabel!
    @IBOutlet var netWorkNameLabel: UILabel!
    @IBOutlet var creatPepleLb: UILabel!
    @IBOutlet var creatTimeLb: UILabel!
    @IBOutlet var stateLb: UILabel!
    @IBOutlet var serviceAreaLb: UILabel!
    @IBOutlet var memstate: UIView!
    
    @IBOutlet var memState: UILabel!
    @IBOutlet var memIntTime: UILabel!
    @IBOutlet var memNickname: UILabel!
    func instanceUI(teamModel:MyTeamModel){
        //图片待定
        //        iconImage.sd_setImageWithURL(NSURL(string: teamModel.headimageurl!))
        if teamModel.userself == "" {
            memstate.removeFromSuperview()
        } else {
            memState.text = teamModel.userselfMemberState
            memIntTime.text = teamModel.userselfCreateTime
            memNickname.text = teamModel.userselfNickname
        }
        
        numLabel.text = teamModel.groupNumber
        netWorkNameLabel.text = teamModel.groupName
        creatPepleLb.text = teamModel.nickname
        creatTimeLb.text = teamModel.createTime
        ///审核状态
        stateLb.text = teamModel.memberState
        serviceAreaLb.text = teamModel.province
        grapNumber.text = teamModel.scopename! + teamModel.scopevalue!
        groupMaxNumber.text = teamModel.groupScopeName!  + " " + teamModel.groupScoupValue!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
