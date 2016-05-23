//
//  RecruitNewMemberViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 1/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import MonkeyKing
import IQKeyboardManagerSwift

class RecruitNewMemberViewController: UIViewController {
    //分享内容
    
    @IBOutlet weak var contanct: UITextView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var navBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(navBarView)
        contanct.layer.cornerRadius = 10
        contanct.layer.masksToBounds = true
        contanct.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        var nibNameOrNil = String?("RecruitNewMemberViewController")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
            
        {
            nibNameOrNil = nil
            
        }
        
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(navBarView)
        self.view.sendSubviewToBack(backImageView)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        // IQKeyboardReturnKeyHandler.init().lastTextFieldReturnKeyType = UIReturnKeyType.Done

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        
        self.navigationController?.navigationBarHidden = true
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
    }

    
    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.contanct.resignFirstResponder()
    }
    
    //分享
    @IBAction func shareAction(sender: UIButton) {
        
        MonkeyKing.registerAccount(.WeChat(appID:ShareIDAndKey.Wechat.appID, appKey: ShareIDAndKey.Wechat.appKey))
        
        //跳转的url
        let shareURL = NSURL(string: "http://www.jianshu.com/users/274775e3d56d/latest_articles")
        
        let info = MonkeyKing.Info(
            title: "浩泽服务家",
            description: "我的appKey还木有拿到辣",
            thumbnail: UIImage(named: "auth_wait"),
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

extension RecruitNewMemberViewController: UITextViewDelegate{
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).isEqualToString("\n") {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}

