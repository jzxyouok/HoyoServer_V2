//
//  RNAchievementViewController.swift
//  HoyoServicer
//
//  Created by 婉卿容若 on 16/5/24.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//  容若的简书地址:http://www.jianshu.com/users/274775e3d56d/latest_articles
//  容若的新浪微博:http://weibo.com/u/2946516927?refer_flag=1001030102_&is_hot=1


import UIKit

class RNAchievementViewController: YZDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "绩效排行榜"
        //navigationController?.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(disMissBtn))
        
        
        setupAllControllers()
        settingTitleEffects()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.translucent = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
         self.navigationController?.navigationBarHidden = true
    }
    
   
    //创建此控制器下的多个控制器
    func setupAllControllers() {
        
        //今天
        let todayVC = RNTodayViewController()
        todayVC.title = "今天"
        self.addChildViewController(todayVC)
        
        //本周
        let weekVC = RNWeekViewController()
        weekVC.title = "本周"
        self.addChildViewController(weekVC)
        
        //本月
        let monthVC = RNMonthViewController()
        monthVC.title = "本月"
        self.addChildViewController(monthVC)
        
    }
    
    //设置标题效果
    func settingTitleEffects(){
        
        let width = UIScreen.mainScreen().bounds.width/3.0
        
        self.titleScrollViewColor = UIColor(patternImage: UIImage(named: "blackImgOfNavBg")!)
        self.isShowUnderLine = true // 是否显示下滑线
        self.norColor = UIColor.whiteColor() // 正常情况标题颜色
        self.selColor = UIColor.whiteColor() // 选中情况标题颜色
        self.underLineColor = COLORRGBA(59, g: 166, b: 169, a: 1) // 下滑线颜色
        self.titleFont = UIFont.systemFontOfSize(20)
        self.titleWidths.addObjectsFromArray([width,width,width])
        self.isfullScreen = false
        
    }

}

// MARK: - event response

extension RNAchievementViewController{
    
    //左边按钮
    func disMissBtn(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}

