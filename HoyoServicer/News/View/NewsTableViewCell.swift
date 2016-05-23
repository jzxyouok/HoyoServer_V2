//
//  NewsTableViewCell.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/29.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var nickName: UILabel!
    @IBOutlet var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reloadUI(model:MessageModel) {
        timeLabel.text = model.createTime
        nickName.text = model.sendNickName
        if model.sendImageUrl != "" {
            iconImage.sd_setImageWithURL(NSURL(string: model.sendImageUrl!))
        }
        
        let numStr:String = (NSUserDefaults.standardUserDefaults().valueForKey("messageNum") ?? "0") as! String
        
        if numStr == "0" {
            stateLabel.text = "暂无未读消息"
            stateLabel.textColor = UIColor.lightGrayColor()
        } else {
            stateLabel.text = "您有\(numStr)条消息未读，请及时打开。"
            stateLabel.textColor = UIColor.redColor()
        }
    }
    func reloadScoreUI(model:ScoreMessageModel) {
        timeLabel.text = model.createTime
        nickName.text = model.sendNickName
        if model.sendImageUrl != "" {
            iconImage.sd_setImageWithURL(NSURL(string: model.sendImageUrl!))
        }
        
        let numStr:String = (NSUserDefaults.standardUserDefaults().valueForKey("scoreNum") ?? "0") as! String
        
        if numStr == "0" {
            stateLabel.text = "暂无未读消息"
            stateLabel.textColor = UIColor.lightGrayColor()
        } else {
            stateLabel.text = "您有\(numStr)条消息未读，请及时打开。"
            stateLabel.textColor = UIColor.redColor()
        }
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
