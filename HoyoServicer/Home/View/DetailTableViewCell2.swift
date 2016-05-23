//
//  DetailTableViewCell2.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 11/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class DetailTableViewCell2: UITableViewCell {
//到达时间
    @IBOutlet weak var arrivetime: UILabel!
    //用时
    @IBOutlet weak var usertime: UILabel!
    
    //服务费
    @IBOutlet weak var money: UILabel!
    
    //机器型号
    @IBOutlet weak var machineType: UILabel!
    
    //机器编号
    @IBOutlet weak var machineCode: UILabel!
    
    //支付方式
    @IBOutlet weak var payWay: UILabel!
    
    //故障
    @IBOutlet weak var troubleDetail: UILabel!
    
    //原因
    
    @IBOutlet weak var reason: UILabel!
    
    //评价
    @IBOutlet weak var remark: UILabel!
    
    //评论视图
    @IBOutlet weak var remarkView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showDetail2Text(finishDetail : FinshDetail)
    {
        if finishDetail.remark == "" {
            self.remarkView.removeFromSuperview()
        }
        
        let  timeStamp  =  DateTool.dateFromServiceTimeStamp(finishDetail.arrivetime! )!
     self.arrivetime.text =  DateTool.stringFromDate(timeStamp, dateFormat: "yyyy年MM月dd日")
      self.money.text = finishDetail.money
        if finishDetail.payWay == "Money" {
              self.payWay.text = "现金"
        }
        else{
        self.payWay.text = "其他"
        
        }
        self.machineType.text = finishDetail.machineType
        self.machineCode.text = finishDetail.machineCode
        self.troubleDetail.text = finishDetail.troubleDetail
        self.reason.text = finishDetail.reason
        self.remark.text = finishDetail.remark
      self.usertime.text = finishDetail.usetime! + "分钟"
    
    }
    
}
