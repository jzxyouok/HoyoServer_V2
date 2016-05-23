//
//  GYDetailNewCell.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/18.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class GYDetailNewCell: UITableViewCell {
    
    var messageLabel: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(image: UIImage(named: "chat_normal_pic"))
        imageView.frame = contentView.bounds
        contentView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(15)
            make.height.greaterThanOrEqualTo(20)
            make.rightMargin.lessThanOrEqualTo(-100)
            make.bottom.equalTo(contentView).offset(-10)
        }
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.sizeToFit()
        messageLabel.textAlignment = NSTextAlignment.Left
        messageLabel.numberOfLines = 0
        imageView.addSubview(messageLabel)
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView).offset(10)
            make.left.equalTo(imageView).offset(15)
            make.height.greaterThanOrEqualTo(20)
            make.rightMargin.lessThanOrEqualTo(-20)
            make.bottom.equalTo(imageView).offset(-10)
        }
        
    }
    
    func reloadUI(model: MessageModel) {
        messageLabel.text = model.messageCon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
