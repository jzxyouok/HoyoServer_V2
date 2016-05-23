//
//  ScoreMessageCell.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/20.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class ScoreMessageCell: UITableViewCell {
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        creatUI()
        
    }
    
    func creatUI() {
        contentView.addSubview(orderLabel)
        contentView.addSubview(orderLb)
        contentView.addSubview(userLabel)
        contentView.addSubview(userLb)
        contentView.addSubview(gadeLabel)
        
        contentView.addSubview(gadeImage)
        contentView.addSubview(starImage)
        
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentLb)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeLb)
        contentLb.numberOfLines = 0
        
        orderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        orderLb.adjustsFontSizeToFitWidth = true
        orderLb.snp_makeConstraints { (make) in
            make.left.equalTo(orderLabel.snp_right).offset(10)
            make.top.equalTo(orderLabel.snp_top)
            make.height.equalTo(orderLabel.snp_height)
            //  make.rightMargin.lessThanOrEqualTo(-10)
            make.trailing.equalTo(contentView.snp_trailing).offset(-10)
        }
        
        
        userLabel.snp_makeConstraints { (make) in
            make.top.equalTo(orderLabel.snp_bottom).offset(10)
            make.left.equalTo(self).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        userLb.snp_makeConstraints { (make) in
            make.left.equalTo(userLabel.snp_right).offset(10)
            make.top.equalTo(userLabel.snp_top)
            make.height.equalTo(userLabel.snp_height)
            make.rightMargin.lessThanOrEqualTo(-10)
            
        }
        
        gadeLabel.snp_makeConstraints { (make) in
            make.top.equalTo(userLabel.snp_bottom).offset(10)
            make.left.equalTo(self).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        
        starImage.snp_makeConstraints { (make) in
            make.top.equalTo(gadeLabel.snp_top).offset(9)
            make.left.equalTo(gadeLabel.snp_right).offset(10)
            make.width.equalTo(65)
            
        }
        
        gadeImage.snp_makeConstraints { (make) in
            make.top.equalTo(gadeLabel.snp_top).offset(9)
            make.left.equalTo(gadeLabel.snp_right).offset(10)
            make.width.equalTo(65)
            
        }
        
        
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(gadeLabel.snp_bottom).offset(10)
            make.left.equalTo(self).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        contentLb.preferredMaxLayoutWidth = MainScreenBounds.width - 80-15-10-10
        contentLb.snp_makeConstraints { (make) in
            make.left.equalTo(contentLabel.snp_right).offset(10)
            make.top.equalTo(contentLabel.snp_top).offset(6)
            make.right.equalTo(contentView.snp_right).offset(-10)
            //make.rightMargin.lessThanOrEqualTo(-10)
            //            make.height.greaterThanOrEqualTo(30)
            
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.top.equalTo(contentLb.snp_bottom).offset(10)
            make.left.equalTo(contentView.snp_left).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.bottom.equalTo(contentView.snp_bottom).offset(-10)
        }
        
        timeLb.snp_makeConstraints { (make) in
            make.top.equalTo(contentLb.snp_bottom).offset(10)
            make.height.equalTo(30)
            make.left.equalTo(timeLabel.snp_right).offset(10)
            make.rightMargin.lessThanOrEqualTo(-10)
        }
        
    }
    
    func reloadUI(model: ScoreMessageModel) {
        
        let tmp =  model.messageCon
        if let data = tmp!.dataUsingEncoding(NSUTF8StringEncoding) {
            let dic = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
            if dic != nil {
                orderLb.text = dic!!["Orderid"] as? String ?? ""
                userLb.text =  dic!!["Userid"] as? String ?? ""
                contentLb.text = dic!!["Remark"] as? String ?? ""
                if let time:String = dic!!["CreateTime"] as? String ?? "" {
                    if time != "" {
                        let date = DateTool.dateFromServiceTimeStamp(time)
                        timeLb.text = DateTool.stringFromDate(date!, dateFormat: "YYYY-MM-dd HH:mm:ss")
                    }
                }
                let score: CGFloat  =   dic!!["Score"] as? CGFloat ?? 0
                starImage.snp_updateConstraints(closure: { (make) in
                    let width = (score / 5.0) * 65
                    make.width.equalTo(width)
                })
            }
        }
        
    }
    
    
    
    
    //    private lazy var bootomView: ScoreBootomView = ScoreBootomView.init(frame: CGRectZero)
    
    //MARK: - 控件
    //订单
    private lazy var orderLabel: UILabel = RNBaseUI.createLabel("订       单:", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Center)
    private lazy var orderLb: UILabel = RNBaseUI.createLabel("12324121512712614T16416gtfrdr214172417", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Left)
    //用户ID
    private lazy var userLabel: UILabel = RNBaseUI.createLabel("用       户:", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Center)
    private lazy var userLb: UILabel = RNBaseUI.createLabel("", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Left)
    //评分 星级
    private lazy var gadeLabel: UILabel = RNBaseUI.createLabel("评       分:", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Center)
    private lazy var gadeImage: UIImageView = {
        let image = UIImageView(image: UIImage(named:"StarsBackground"))
        return image
    }()
    private lazy var starImage: UIImageView = {
        let image = UIImageView(image: UIImage(named:"StarsForeground"))
        image.clipsToBounds = true
        image.contentMode = UIViewContentMode.Left
        return image
    }()
    //评论内容
    private lazy var contentLabel: UILabel = RNBaseUI.createLabel("评论内容:", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Center)
    private lazy var contentLb: UILabel = RNBaseUI.createLabel("的愿望电压为抵押给抵押给一点我gay的gay的尕娃有温度高亚安慰", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Left)
    //评论时间
    private lazy var timeLabel: UILabel = RNBaseUI.createLabel("评论时间:", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Center)
    private lazy var timeLb: UILabel = RNBaseUI.createLabel("", titleColor: UIColor.blackColor(), font: 15, alignment: NSTextAlignment.Left)
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
