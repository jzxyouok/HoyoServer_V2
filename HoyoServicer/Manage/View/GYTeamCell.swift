//
//  GYTeamCell.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/26.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class GYTeamCell: UITableViewCell {
    
    /// 本地数据
    var  fixedName: UILabel?
    /// 网络数据
    var  netWorkLb: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fixedName = RNBaseUI.createLabel("", titleColor: UIColor.blackColor(), font: 17, alignment: NSTextAlignment.Left)
        
        netWorkLb = RNBaseUI.createLabel("", titleColor: UIColor.blackColor(), font: 17, alignment: NSTextAlignment.Left)
        addSubview(fixedName!)
        addSubview(netWorkLb!)
        
        fixedName?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(10)
//            make.height.equalTo(21)
            make.width.equalTo(102)
            make.bottom.equalTo(contentView).offset(-7.5)
        })
      
        netWorkLb?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(fixedName!.snp_top)
            make.left.equalTo(fixedName!.snp_right).offset(15)
//            make.height.equalTo(21)
            make.rightMargin.lessThanOrEqualTo(-10)
             make.bottom.equalTo(contentView).offset(-7.5)
        })
        
    }
    
    
    func reloadUI(str:String,str2: String) {
        fixedName?.text = str
        if str2 == "" {
            netWorkLb?.text = "暂无"
        } else {
        netWorkLb?.text = str2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
