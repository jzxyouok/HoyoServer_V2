//
//  RNRecruitNewMenmberViewController.swift
//  HoyoServicer
//
//  Created by 婉卿容若 on 16/5/18.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//  容若的简书地址:http://www.jianshu.com/users/274775e3d56d/latest_articles
//  容若的新浪微博:http://weibo.com/u/2946516927?refer_flag=1001030102_&is_hot=1


import UIKit
import MonkeyKing
import IQKeyboardManager

class RNRecruitNewMenmberViewController: UIViewController , UITextViewDelegate{
    
    var scrollView: UIScrollView!
    var myTeamLabel: UILabel!
    var needLabel: UILabel!
    var contactTextView: UITextView!
    var leftImageView: UIImageView!
    var rightImageView: UIImageView!
    var noteLabel: UILabel!
    var logoImageView: UIImageView!
    
    
    var isFirstInput: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "招募成员"
    

        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(disMissBtn))
        navigationItem.rightBarButtonItem = createBarButtonItem("分享", target: self, action: #selector(shareAction(_:)))
        navigationController?.navigationBarHidden = false
        
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "add_member_bg")!)
         view.backgroundColor = UIColor.whiteColor()
        
        setupUI()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        // IQKeyboardReturnKeyHandler.init().lastTextFieldReturnKeyType = UIReturnKeyType.Done
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "memberbg"), forBarPosition: UIBarPosition.Any,barMetrics: UIBarMetrics.Default)
       // navigationController?.navigationBar.setBackgroundImage(imageFromColor(COLORRGBA(60, g: 165, b: 210, a: 1)), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.translucent = false
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blackImgOfNavBg"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage =  UIImage(named: "blackImgOfNavBg")
        navigationController?.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        navigationController?.navigationBar.translucent = true
    }
    
    override func viewWillLayoutSubviews() {
        
//         let height = HEIGHT_SCREEN - HEIGHT_NavBar - contactTextView.frame.origin.y - contactTextView.frame.size.height
//         leftImageView.snp_updateConstraints { (make) in
//            make.top.equalTo(contactTextView.snp_bottom).offset(height-30-14-15-30+7+10)
//        }
//        noteLabel.snp_updateConstraints { (make) in
//             make.top.equalTo(contactTextView.snp_bottom).offset(height-30-14-15-30+10)
//        }
//        rightImageView.snp_updateConstraints { (make) in
//             make.top.equalTo(contactTextView.snp_bottom).offset(height-30-14-15-30+7+10)
//        }

        //试图让scrollView稍微可以滑动
        let tempHeight = HEIGHT_SCREEN - HEIGHT_NavBar - logoImageView.frame.origin.y - logoImageView.frame.size.height
        scrollView.snp_updateConstraints { (make) in
            make.bottom.equalTo(logoImageView.snp_bottom).offset(tempHeight+10)
        }
        
//        contactTextView.clipCornerRadiusForView(contactTextView, RoundingCorners: [UIRectCorner.TopLeft,UIRectCorner.TopRight,UIRectCorner.BottomLeft,UIRectCorner.BottomRight], Radii: CGSizeMake(10, 10))
//        
    }

    
    //创建控件
    func setupUI(){
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "memberbg")!)
        view.addSubview(scrollView)
        
        
        myTeamLabel = RNBaseUI.createLabel("我的团队", titleColor: UIColor.whiteColor(), font: 24, alignment: NSTextAlignment.Center)
        scrollView.addSubview(myTeamLabel)
        myTeamLabel.snp_makeConstraints { (make) in
            make.top.equalTo(60)
//            make.leading.equalTo(view.snp_leading).offset(50)
//            make.trailing.equalTo(view.snp_trailing).offset(-50)
            make.centerX.equalTo(view.snp_centerX)
            make.height.equalTo(45)
        }
        
        needLabel = RNBaseUI.createLabel("需要您", titleColor: UIColor.whiteColor(), font: 20, alignment: NSTextAlignment.Center)
        needLabel.hidden = true
        scrollView.addSubview(needLabel)
        needLabel.snp_makeConstraints { (make) in
            make.top.equalTo(myTeamLabel.snp_bottom).offset(10)
            make.centerX.equalTo(myTeamLabel.snp_centerX).offset(80)
            make.height.equalTo(35)
        }
        
        contactTextView = RNBaseUI.creatTextView(UIKeyboardType.Default, returnKeyType: UIReturnKeyType.Done)
        contactTextView.delegate = self
       // print("hhhhhhh:\(UIFont.familyNames())")
        contactTextView.font = UIFont(name: "Blackoak Std", size: 14)
        contactTextView.font = UIFont.systemFontOfSize(18)
        contactTextView.textColor = UIColor.whiteColor()
        contactTextView.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 0.2)
        contactTextView.tintColor = COLORRGBA(60, g: 165, b: 210, a: 1)
        contactTextView.text = "请输入招募文字(88字以内)"
        contactTextView.scrollEnabled = false
        scrollView.addSubview(contactTextView)
        contactTextView.snp_makeConstraints { (make) in
            make.top.equalTo(needLabel.snp_bottom).offset(60)
            make.leading.equalTo(view.snp_leading).offset(30)
            make.trailing.equalTo(view.snp_trailing).offset(-30)
            make.height.equalTo((MainScreenBounds.size.width-60)*10/18.0)
        }
        
        contactTextView.layer.masksToBounds = true
        contactTextView.layer.cornerRadius = 10

        
        var vSpace = MainScreenBounds.size.height - 64 - 140 - 60 - (MainScreenBounds.size.width-60)*10/18.0 - 90 - 10
        
        if vSpace < 30 {
            vSpace = 30
            
            contactTextView.snp_updateConstraints { (make) in
                make.top.equalTo(needLabel.snp_bottom).offset(30)
            }
            
        }

        
        leftImageView = RNBaseUI.createImageView(nil, backgroundColor: UIColor.whiteColor())
        scrollView.addSubview(leftImageView)
        leftImageView.snp_makeConstraints { (make) in
            make.top.equalTo(contactTextView.snp_bottom).offset(vSpace+6)
            make.leading.equalTo(view.snp_leading).offset(0)
            make.width.equalTo(70)
            make.height.equalTo(1)
        }
        
        noteLabel = RNBaseUI.createLabel("服务家售后团队火热招募中", titleColor: UIColor.whiteColor(), font: 15, alignment: NSTextAlignment.Center)
        noteLabel.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(noteLabel)
        noteLabel.snp_makeConstraints { (make) in
            make.top.equalTo(contactTextView.snp_bottom).offset(vSpace)
            make.leading.equalTo(leftImageView.snp_trailing).offset(5)
            make.height.equalTo(15)
        }
        
        rightImageView = RNBaseUI.createImageView(nil, backgroundColor: UIColor.whiteColor())
        scrollView.addSubview(rightImageView)
        rightImageView.snp_makeConstraints { (make) in
            make.top.equalTo(contactTextView.snp_bottom).offset(vSpace+6)
            make.leading.equalTo(noteLabel.snp_trailing).offset(5)
            make.trailing.equalTo(view.snp_trailing).offset(0)
            make.width.equalTo(70)
            make.height.equalTo(1)
        }
        
        logoImageView = RNBaseUI.createImageView("HoyoLogoOfHead", backgroundColor: nil)
        logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        scrollView.addSubview(logoImageView)
        logoImageView.snp_makeConstraints { (make) in
            make.top.equalTo(noteLabel.snp_bottom).offset(15)
            make.centerX.equalTo(view.snp_centerX)
            make.height.equalTo(30)
            
        }
        
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
            make.bottom.equalTo(logoImageView.snp_bottom).offset(10)
        }

    }
    
    //barItem
    func  createBarButtonItem(title:String?,target:AnyObject?,action:Selector) -> UIBarButtonItem{
        
        let btn = UIButton()
        if title != nil {
            btn.setTitle(title, forState: UIControlState.Normal)
        }
        
        
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        
        return UIBarButtonItem(customView: btn)
        
    }
    
    //纯色转图片
    func imageFromColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image
    }

}


// MARK: - event response

extension RNRecruitNewMenmberViewController{
    
    //左边按钮
    func disMissBtn(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    //分享
    func shareAction(sender: UIButton) {
        
        MonkeyKing.registerAccount(.WeChat(appID:ShareIDAndKey.Wechat.appID, appKey: ShareIDAndKey.Wechat.appKey))
        
        //跳转的url
        let shareURL = NSURL(string: "http://www.ozner.net")
        
        var desc: String = "浩优期待您的加入"
        
        if !contactTextView.text.isEmpty && !(contactTextView.text as NSString).isEqualToString("请输入招募文字(88字以内)"){
            desc = contactTextView.text
        }
        
        let info = MonkeyKing.Info(
            title: "浩泽服务家",
            description: desc,
            thumbnail: UIImage(named: "manage_member"),
            media: MonkeyKing.Media.URL(shareURL!)
        )
        
        
        //微信好友
        let sessionMessage = MonkeyKing.Message.WeChat(.Session(info: info))
        let weChatSessionActivity = AnyActivity(
            type: "com.ozner.WeChat.Session",
            title: NSLocalizedString("微信好友", comment: ""),
            image: UIImage(named: "wechat_session")!,
            message: sessionMessage,
            completionHandler: { (result) in
                print("Session success: \(result)")
        })
        //朋友圈
        let timelineMessage = MonkeyKing.Message.WeChat(.Timeline(info: info))
        let weChatTimelineActivity = AnyActivity(
            type: "com.ozner.WeChat.Timeline",
            title: NSLocalizedString("朋友圈", comment: ""),
            image: UIImage(named: "wechat_timeline")!,
            message: timelineMessage,
            completionHandler: { (result) in
                print("Timeline success: \(result)")
        })
        
        let activityViewController = UIActivityViewController(activityItems: [shareURL!], applicationActivities: [weChatSessionActivity,weChatTimelineActivity])
        activityViewController.excludedActivityTypes = [UIActivityTypeMail,UIActivityTypeMessage,UIActivityTypeAddToReadingList,UIActivityTypePostToTwitter,UIActivityTypePostToFacebook,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypePostToTwitter,UIActivityTypeAirDrop,UIActivityTypePostToWeibo]
        presentViewController(activityViewController, animated: true, completion: nil)
        
    }


}

// MARK: - UITextViewDelegate

extension RNRecruitNewMenmberViewController{
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).isEqualToString("\n") {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if isFirstInput {
            contactTextView.text = nil
            isFirstInput = false
        }
       
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            contactTextView.text = "请输入招募文字(88字以内)"
            isFirstInput = true
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if (textView.text as NSString).length > 88 {
            textView.text = (textView.text as NSString).substringToIndex(88)
            textView.resignFirstResponder()
            let alertView=SCLAlertView()
            alertView.addButton("ok", action: {})
            alertView.showError("错误提示", subTitle: "输入不能超过88个字")
        }
    }
}

