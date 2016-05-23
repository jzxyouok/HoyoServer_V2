//
//  MyCenterTableViewCell.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/29.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
protocol MyCenterTableViewCellDelegate {
    func ToDetailController(Whitch:Int)
}
class MyCenterTableViewCell: UITableViewCell {

    
    var delegate:MyCenterTableViewCellDelegate?
    @IBAction func toNextClick(sender: UIButton) {
        if delegate != nil{
            delegate?.ToDetailController(sender.tag)
        }
        
    }
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var jobNo: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
