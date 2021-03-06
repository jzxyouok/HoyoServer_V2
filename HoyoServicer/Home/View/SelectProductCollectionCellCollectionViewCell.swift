//
//  SelectProductCollectionCellCollectionViewCell.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 19/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class SelectProductCollectionCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var productInfo: UILabel!
    
    var isSign: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isSign = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isSign = false
    }
    

    func showCellText(productinfo:ProductInfo)
    {
        self.image.sd_setImageWithURL(NSURL(string: productinfo.image! as String))//
        self.productInfo.text = productinfo.name

    }


}
