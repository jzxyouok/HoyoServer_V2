


//
//  UIViewController+extense.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 30/3/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import Foundation

extension UIViewController
{

    func setNavigationItem(title:String,selector:Selector,isRight:Bool)
    {
        var item:UIBarButtonItem!
        
        if title.hasSuffix("png") {
            item = UIBarButtonItem(image: UIImage(named: title), style: .Plain, target: self, action: selector)
        }
        else {
            item = UIBarButtonItem(title: title, style: .Plain, target: self, action: selector)
            
        }
        
item.tintColor = UIColor.whiteColor()
        
        if isRight {
            self.navigationItem.rightBarButtonItem = item
        }
        else {
            self.navigationItem.leftBarButtonItem = item
        }
        
        
    }
    func doRight(){
        
    }
    
    func doBack(){
        print("doBack")
        if(self.navigationController?.viewControllers.count>1)
        {
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        }
        else{
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }


}