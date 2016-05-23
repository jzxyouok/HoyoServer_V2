//
//  SubmitBtn.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 21/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
protocol SubmitBtnDelegate {
    func submitToServer()
}
class SubmitBtn: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
