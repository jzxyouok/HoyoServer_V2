//
//  String+Expand.swift
//  OznerServer
//
//  Created by 赵兵 on 16/2/26.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import Foundation
// string 扩展，一些常用字符串处理等等
extension String{
    //md5加密
    //判断字符串是否全是数字
    var isAllNumber:Bool{
        let pred = NSPredicate(format: "SELF MATCHES %@", "^[0-9]*$")
        if pred.evaluateWithObject(self) {
            return true
        }
        return false
    }
    
}