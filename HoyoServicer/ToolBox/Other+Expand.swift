//
//  Other+Expand.swift
//  OznerServer
//
//  Created by 赵兵 on 16/3/5.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import Foundation
/**
 判断是不是空或null
 */
func MSRIsNilOrNull(object: AnyObject?) -> Bool {
    return object == nil || object is NSNull
    
}
//-------------------检查手机号格式-------------------------
func checkTel(str:NSString)->Bool
{
    if (str.length != 11) {
        
        return false
    }
    let regex = "^\\d{11}$"
    let pred = NSPredicate(format: "SELF MATCHES %@",regex)
    
    let isMatch = pred.evaluateWithObject(str)
    if (!isMatch) {
        return false
    }
    return true
}
extension UINavigationBar{
    //黑底白字
    func loadBlackBgBar() {
        self.setBackgroundImage(UIImage(named: "blackImgOfNavBg"), forBarMetrics: UIBarMetrics.Default)
        self.shadowImage =  UIImage(named: "blackImgOfNavBg")
        self.titleTextAttributes=[NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    // 按钮和标题
//    func addBackAndTitle()
//    {
//        
//    }
    //
}