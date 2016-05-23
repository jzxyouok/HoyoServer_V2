//
//  categoryzb.swift
//  OZner
//
//  Created by 赵兵 on 16/3/11.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import Foundation

extension CALayer
{
    var borderColorWithUIColor:UIColor{
        set{
            self.borderColor = newValue.CGColor
        }
        get{
            return UIColor(CGColor: self.borderColor!)
        }
    }
}