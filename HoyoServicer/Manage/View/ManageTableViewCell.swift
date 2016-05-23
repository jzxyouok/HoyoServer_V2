//
//  ManageTableViewCell.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/29.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
protocol ManageTableViewCellDelegate {
    func ButtonOfManageCell(Tag:Int)
}
class ManageTableViewCell: UITableViewCell {

    @IBOutlet weak var totalAssetLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    //从左到右，从上到下,button的tag分别为，1...8
    var delegate:ManageTableViewCellDelegate?
    @IBAction func ButtonClick(sender: UIButton) {
        if delegate != nil {
            delegate?.ButtonOfManageCell(sender.tag)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //显示
    func configCell(model: MyAccount?){
        
        if let asset = Double(model!.totalAssets!) {
            totalAssetLabel.text = String(format: "%.2lf",asset)
        }else{
            totalAssetLabel.text = "0.00"
        }
        
        if let income = Double(model!.income!) {
            incomeLabel.text = String(format: "累计收益 %.2lf",income)
        }else{
            incomeLabel.text = "累计收益 0.00"
        }
    }

    
}
