//
//  RNUITextField+Expand.swift
//  HoyoServicer
//
//  Created by 婉卿容若 on 16/5/13.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//  容若的简书地址:http://www.jianshu.com/users/274775e3d56d/latest_articles
//  容若的新浪微博:http://weibo.com/u/2946516927?refer_flag=1001030102_&is_hot=1


import Foundation
import UIKit

extension UITextField{
    

    
    /**
     校验数字的数字(例如钱金额),保留小数点几位----方法放在func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool 这个代理方法里
     
     - parameter text:              需要处理的字符串
     - parameter range:             正在输入为的范围
     - parameter replacementString: 正在输入的字符
     - parameter remian:            保留小数点后几位
     
     - returns: 输入符合要求true,反之false
     */
    func moneyFormatCheck(text: String, range: NSRange, replacementString: String, remian: Int) -> Bool {
        
        //限制输入框只能输入数字(最多两位小数)
        let newString = (text as NSString).stringByReplacingCharactersInRange(range, withString: replacementString)
        let expression = "^[0-9]*((\\.|,)[0-9]{0,\(remian)})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatchesInString(newString, options:NSMatchingOptions.ReportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0

    }
}