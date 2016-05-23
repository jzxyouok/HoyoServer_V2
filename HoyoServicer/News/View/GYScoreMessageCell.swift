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
    override func awakeFromNib() {
        super.awakeFromNib()
        //        starImage_width.constant = 10.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
