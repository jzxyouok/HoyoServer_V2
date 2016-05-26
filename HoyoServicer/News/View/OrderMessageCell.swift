//
//  OrderMessageCell.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/25.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class OrderMessageCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reloadUI(model: ScoreMessageModel) {
        timeLable.text = model.createTime
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}