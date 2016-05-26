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
        print(model.messageCon)
        if model.messageCon == "有新的订单可以抢~" {
            nickName.text = "系统通知"
            iconImage.image = UIImage(named: "sys_msg")
            stateLabel.text = model.messageCon
            return
        }
        
        nickName.text = model.sendNickName
        if model.sendImageUrl != "" {
            iconImage.sd_setImageWithURL(NSURL(string: model.sendImageUrl!))
        }
        
        if model.messageType == "score" {
            let tmp =  model.messageCon
            if let data = tmp!.dataUsingEncoding(NSUTF8StringEncoding) {
                let dic = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
                if dic != nil {
                    stateLabel.text = dic!!["Remark"] as? String
                }
            }
        } else {
            stateLabel.text = model.messageCon
        }
        //        let numStr:String = (NSUserDefaults.standardUserDefaults().valueForKey("messageNum") ?? "0") as! String
        
        //        if numStr == "0" {
        //            stateLabel.text = "暂无未读消息"
        //            stateLabel.textColor = UIColor.lightGrayColor()
        //        } else {
        //            stateLabel.text = "您有\(numStr)条消息未读，请及时打开。"
        //            stateLabel.textColor = UIColor.redColor()
        //        }
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
