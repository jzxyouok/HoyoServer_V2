//
//  BoundCarViewCell.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 2/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class BoundCarViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankTypelabel: UILabel!
    @IBOutlet weak var bankNumberLabel: UILabel!
    
//    var model:BankModel? = nil{
//        
//        willSet{
//            
//            bankNameLabel.text = model?.bankName
//            bankTypelabel.text = model?.bankType
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        backView.layoutIfNeeded()
        
        let maskPath = UIBezierPath(roundedRect: backView.bounds, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight] , cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = backView.bounds
        maskLayer.path = maskPath.CGPath
        backView.layer.mask = maskLayer
        
    }
    
    func configureForCell(model:BankModel) -> Void {
        
        bankNameLabel.text = model.bankName!
        bankTypelabel.text = model.bankType!
        
        var cardNum: String = "**** **** **** "
        
        if let card = model.cardId {
            
            var count = 0
            for item in card.characters {
                
//                if count % 4 == 0 && count != 0{
//                    cardNum += " "
//                }
                
                count += 1

                if count > ((card as NSString).length - 4) {
                    cardNum.append(item)
                }
//                else{
//                    cardNum += "*"
//                }
            }
            
            bankNumberLabel.text = cardNum
        }
        
    }
    
}



