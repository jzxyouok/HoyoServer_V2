//
//  RNGuideViewController.swift
//  HoyoServicer
//
//  Created by 婉卿容若 on 16/5/10.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

typealias GuideCellClosure = () -> Void

class GuideCell: UICollectionViewCell {
    
    private let newImageView = UIImageView(frame: MainScreenBounds)
    private let nextButton = UIButton(frame: CGRectMake((WIDTH_SCREEN - 100) * 0.5, HEIGHT_SCREEN - 110, 100, 33))
    
    internal var cellClosure: GuideCellClosure?
    
    var newImage: UIImage? {
        didSet {
            newImageView.image = newImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        newImageView.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(newImageView)
        
        nextButton.setBackgroundImage(UIImage(named: "icon_next"), forState: UIControlState.Normal)
        nextButton.addTarget(self, action: #selector(GuideCell.nextButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.hidden = true
        contentView.addSubview(nextButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNextButtonHidden(hidden: Bool) {
        nextButton.hidden = hidden
    }
    
    func nextButtonClick() {
       // NSNotificationCenter.defaultCenter().postNotificationName(GuideViewControllerDidFinish, object: nil)
        
        if cellClosure != nil  {
            cellClosure!()
        }
    }
}
