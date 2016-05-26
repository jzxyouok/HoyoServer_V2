//
//  GYDetailNewCell.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/18.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import SDWebImage
class GYDetailNewCell: UITableViewCell {
    
    var messageLabel: UILabel = UILabel()
    var iconImageView: UIImageView = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        iconImageView.frame = CGRectMake(10, 20, 50, 50)
        iconImageView.image = UIImage(named: "sys_msg")
        contentView.addSubview(iconImageView)
        let imageView = UIImageView(image: UIImage(named:"chat_normal_pic"))
        imageView.frame = contentView.bounds
        contentView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(25)
            make.left.equalTo(contentView).offset(65)
            make.height.greaterThanOrEqualTo(20)
            make.rightMargin.lessThanOrEqualTo(-80)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.sizeToFit()
        messageLabel.textAlignment = NSTextAlignment.Left
        messageLabel.numberOfLines = 0
        imageView.addSubview(messageLabel)
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView).offset(8)
            make.left.equalTo(imageView).offset(15)
            make.height.greaterThanOrEqualTo(20)
            make.rightMargin.lessThanOrEqualTo(-20)
            make.bottom.equalTo(imageView).offset(-8)
        }
        
    }
    
    func reloadUI(model: ScoreMessageModel) {
        messageLabel.text = model.messageCon
        if model.sendImageUrl != "" {
            let url = model.sendImageUrl!
            print(model.sendImageUrl)
            iconImageView.layer.cornerRadius = 25
            iconImageView.layer.masksToBounds = true
            //TODO:头像不显示
            iconImageView.sd_setImageWithURL(NSURL(string: url))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
