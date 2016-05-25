//
//  AchievementCell.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 8/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class AchievementCell: UITableViewCell {

    @IBOutlet weak var rankingLabel: UILabel! //排名
    @IBOutlet weak var headImageView: UIImageView! //头像
    @IBOutlet weak var nameLabel: UILabel! //名字
    @IBOutlet weak var star01: UIImageView! //等级
    @IBOutlet weak var star02: UIImageView!
    @IBOutlet weak var star03: UIImageView!
    @IBOutlet weak var star04: UIImageView!
    @IBOutlet weak var star05: UIImageView!
    @IBOutlet weak var scoresLabel: UILabel! //分数
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //显示cell
    func configCell(model: String, index: Int) {
        
        if index > 2 {
            rankingLabel.textColor = UIColor.blackColor()
        }else{
            rankingLabel.textColor = UIColor.redColor()
        }
    }
    
}
