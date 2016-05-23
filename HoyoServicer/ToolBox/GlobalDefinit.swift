//
//  commonAttribute.swift
//  OznerServer
//
//  Created by 赵兵 on 16/2/26.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
//状态栏高度
let HEIGHT_StatusBar:CGFloat=20
//导航栏高度
let HEIGHT_NavBar:CGFloat=64
//导航栏高度
let HEIGHT_TabBar:CGFloat=49
//当前屏幕bounds
let MainScreenBounds = UIScreen.mainScreen().bounds
//获取当前屏幕 宽度、高度
let WIDTH_SCREEN:CGFloat = UIScreen.mainScreen().bounds.size.width
let HEIGHT_SCREEN:CGFloat = UIScreen.mainScreen().bounds.size.height
//参考的设计图纸尺寸
let WidthOfDesign:CGFloat=375.0
let HeightOfDesign:CGFloat=667.0
//消息通知
let messageNotification = "MessageNotification"
let scoreNotification = "ScoreNotification"

//宽比例尺寸换算
func WidthFromTranslat(width:CGFloat)->CGFloat
{
    return width*WIDTH_SCREEN/WidthOfDesign
}
//高比例尺寸换算
func HeightFromTranslat(height:CGFloat)->CGFloat
{
    return height*HEIGHT_SCREEN/HeightOfDesign
}
//系统版本号
let IOS_VERSION:Float = Float((UIDevice.currentDevice().systemVersion as NSString).substringToIndex(1))!
