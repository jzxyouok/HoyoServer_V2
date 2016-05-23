//
//  SubmitListsCell.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 21/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class SubmitListsCell: UITableViewCell {
//产品名字
    @IBOutlet weak var productName: UILabel!
    //购买数量
    @IBOutlet weak var shopNumber: UILabel!
    
    //操作购买数额
    @IBOutlet weak var reduceOrAdd: UIStepper!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func  showText(productInfo:[String])
    {
        self.productName.text = productInfo.first
      //  self.shopNumber.text = productInfo.last
       
    }
    
    @IBAction func reduceOrAdd(sender: AnyObject) {
   
        print(sender.stepValue)
        
        print(shopNumber.text)
   self.shopNumber.text = "\( Double(self.shopNumber.text!)!  + (sender as! UIStepper).stepValue)"
        
        
    
    }
}
