//
//  getMoneyDetailCell.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 12/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

typealias successClosure = () -> Void

class getMoneyDetailCell: UITableViewCell {

    @IBOutlet weak var bankInfoLabel: UILabel!
    @IBOutlet weak var getAmountLabel: UILabel!
    
    //选择银行卡回调
    var sucClosure:successClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func successAction(sender: UIButton) {
        
        if sucClosure != nil {
            sucClosure!()
        }
    }
}
