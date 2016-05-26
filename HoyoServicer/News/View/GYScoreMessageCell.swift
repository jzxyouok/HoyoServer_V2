//
//  GYScoreMessageCell.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/20.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class GYScoreMessageCell: UITableViewCell {
    
    
    
    @IBOutlet weak var starImage_width: NSLayoutConstraint!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var payWay: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        starImage.clipsToBounds = true
        starImage.contentMode = UIViewContentMode.Left
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func reloadUI(model: ScoreMessageModel) {
        
        let tmp =  model.messageCon
        if let data = tmp!.dataUsingEncoding(NSUTF8StringEncoding) {
            let dic = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
            if dic != nil {
                orderNum.text = dic!!["Orderid"] as? String ?? ""
                contentLabel.text = dic!!["Remark"] as? String ?? ""
                payWay.text = dic!!["Way"] as? String ?? ""
                ipLabel.text = dic!!["Ip"] as? String ?? ""
                if let time:String = dic!!["CreateTime"] as? String ?? "" {
                    if time != "" {
                        let date = DateTool.dateFromServiceTimeStamp(time)
                        timeLabel.text = DateTool.stringFromDate(date!, dateFormat: "YYYY-MM-dd HH:mm:ss")
                    }
                }
                let score: CGFloat  =   dic!!["Score"] as? CGFloat ?? 0
                starImage_width.constant =  (score/5.0) * 65
            }
        }
    }
}
