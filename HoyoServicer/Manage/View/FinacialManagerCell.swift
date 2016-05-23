//
//  FinacialManagerCell.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/6.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class FinacialManagerCell: UITableViewCell {
    
    var typeLable: UILabel = UILabel()
    var moneyLable: UILabel = UILabel()
    var timeLable: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func reloadUI(model:AccountDetailModel) {
        typeLable.text = model.payId
        moneyLable.text = model.money
        timeLable.text = model.createTime
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        typeLable.text = "安装收益"
        typeLable.font = UIFont.systemFontOfSize(20)
        typeLable.textAlignment = NSTextAlignment.Center
        
        //        moneyLable.text = "123.8"
        moneyLable.font = UIFont.systemFontOfSize(18)
        moneyLable.textAlignment = NSTextAlignment.Center
        
        //        timeLable.text = "星期五"
        timeLable.font = UIFont.systemFontOfSize(18)
        timeLable.textColor = UIColor.lightGrayColor()
        timeLable.textAlignment = NSTextAlignment.Center
        contentView.addSubview(typeLable)
        contentView.addSubview(moneyLable)
        contentView.addSubview(timeLable)
        typeLable.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(WIDTH_SCREEN/2)
            //            make.right.lessThanOrEqualTo(-200)
        }
        moneyLable.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.height.equalTo(30)
            make.left.equalTo(typeLable.snp_right).offset(0)
            make.width.equalTo(WIDTH_SCREEN/2)
        }
        timeLable.snp_makeConstraints { (make) in
            make.top.equalTo(typeLable.snp_bottom).offset(10)
            make.left.equalTo(contentView).offset(0)
            make.width.equalTo(WIDTH_SCREEN/2)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
