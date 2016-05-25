//
//  AppDelegate.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/28.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import CoreData
import Reachability
import SwiftyJSON

var appDelegate: AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = { 
        let v = UIWindow(frame: UIScreen.mainScreen().bounds)
        return v
    }()
    
    
    lazy var loginViewController: LoginAndRegisterViewController = {
        return LoginAndRegisterViewController()
    }()
    /// 网络状态
    var reachOfNetwork:Reachability?
    //主视图控制器
    var mainViewController: MainViewController!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //检查网络状况，无网络，wifi，普通网络三种情况实时变化通知
        reachOfNetwork = Reachability(hostName: "www.baidu.com")
        reachOfNetwork!.startNotifier()
        
        //网络变化通知，在需要知道的地方加上此通知即可
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityChanged), name: kReachabilityChangedNotification, object: nil)
        
        
        
        //提醒用户给app打分
        //        Appirater.setAppId("955305764")
        //        Appirater.setDaysUntilPrompt(1)
        //        Appirater.setUsesUntilPrompt(1)
        //        Appirater.setSignificantEventsUntilPrompt(-1)
        //        Appirater.setTimeBeforeReminding(2)
        //        Appirater.setDebug(true)
        //        Appirater.appLaunched(true)
        
        //设置状态栏字体为白色
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        
        //标记是否第一次登陆
        let isFristOpen = NSUserDefaults.standardUserDefaults().objectForKey("isFristOpenApp")
        
        if isFristOpen == nil {
            let guideVC = RNGuideViewController()
            
            guideVC.skipClosure = { [weak self]() -> Void in
                
                UIView.animateWithDuration(1.2, animations: {
                    
                    let newTransform = CGAffineTransformMakeScale(1.1, 1.1)
                    guideVC.view.transform = newTransform
                    
                    }, completion: { (finished) in
                        self!.window!.rootViewController = self!.loginViewController
                        
                })
                
            }
            window?.rootViewController = guideVC
            NSUserDefaults.standardUserDefaults().setObject("isFristOpenApp", forKey: "isFristOpenApp")
        } else {
            window!.rootViewController = loginViewController
        }
        
        
        window!.makeKeyAndVisible()
        
        
        //Required 判断当前设备版本
        if Float(UIDevice.currentDevice().systemVersion) >= 8.0 {
            
            let type:UInt = UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Badge.rawValue
            
            JPUSHService.registerForRemoteNotificationTypes(type, categories: nil)
            
        } else {
            let type:UInt = UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue
            
            JPUSHService.registerForRemoteNotificationTypes(type, categories: nil)
        }
        //注册极光
        JPUSHService.setupWithOption(launchOptions, appKey: "78f40fd899d1598548afa084", channel: nil, apsForProduction: false)
        
        if (launchOptions != nil) {
            let remoteNotification = launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey];
            //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
            if (remoteNotification != nil) {
                NSUserDefaults.standardUserDefaults().setObject("push", forKey: "push")
                //                window?.rootViewController?.presentViewController(ZGYViewController(), animated: true, completion: nil)
                
            }
        }
        
        //关闭连接
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.JPushDidClose(_:)), name: kJPFNetworkDidCloseNotification, object: nil)
        
        //注册成功
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.JPushDidRegister(_:)), name: kJPFNetworkDidRegisterNotification, object: nil)
        
        //登陆成功
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.JPushDidLogin(_:)), name: kJPFNetworkDidLoginNotification, object: nil)
        
        //收到自定义消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.JPushDidReceiveMessage(_:)), name: kJPFNetworkDidReceiveMessageNotification, object: nil)
        
        
        return true
    }
    
    /**
     登出处理
     */
    func LoginOut()
    {
        //清理用户文件
        appDelegate.clearCaches()
        appDelegate.mainViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    //接收到网络变化后处理事件
    func reachabilityChanged(notification:NSNotification){
        let reach = notification.object
        print(reachOfNetwork?.currentReachabilityString())
        if ((reach?.isKindOfClass(Reachability.classForCoder())) != false){
            
            let status:NetworkStatus = (reach?.currentReachabilityStatus())! //currentReachabilityStatus];
            
            switch status
            {
            case .NotReachable:
                print("网络不可用")
                break
            case .ReachableViaWiFi:
                print("WIFI已连接")
                break
            case .ReachableViaWWAN:
                print("普通网络已连接")
                break
                
            }
            
            
        }
        
    }
    
    func clearCaches() {
        NetworkManager.clearCookies()
        //NSFileManager.defaultManager().removeItemAtURL(cacheFileURL, error: nil)
        DataManager.defaultManager = nil
        //DataManager.temporaryManager = nil
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIScreen.mainScreen()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ozner.HoyoServicer" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("HoyoServicer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    //MARK: - 极光通知方法
    //注册推送消息
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("deviceToken:\(deviceToken)")
        //        let registraID = JPUSHService.registrationID()
        JPUSHService.registerDeviceToken(deviceToken)
        print("注册设备成功")
    }
    
    //推送消息成功后调用
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("程序在前台zhu" + "\(userInfo)")
        JPUSHService.handleRemoteNotification(userInfo)
        
    }
    
    //iOS 7.0方法
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //        public enum UIApplicationState : Int {
        //
        //        case Active
        //        case Inactive
        //        case Background
        //    }
        if application.applicationState == UIApplicationState.Active {
            print("程序在前台" + "\(userInfo)")
            AudioServicesDisposeSystemSoundID(1007);
            completionHandler(UIBackgroundFetchResult.NewData)
        } else {
            JPUSHService.handleRemoteNotification(userInfo)
            completionHandler(UIBackgroundFetchResult.NewData)
            print("程序在后台ZHU" + "\(userInfo)")
            print(userInfo["aps"]!["alert"])
        }
    }
    //注册推送失败
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Errorwd:\(error)")
    }
    
    //MARK: - 极光推送监听
    
    func JPushDidSetup(noti:NSNotification)
    {
        print("建立连接")
    }
    
    func JPushDidClose(noti:NSNotification)  {
        print("关闭连接")
    }
    
    func JPushDidRegister(noti:NSNotification)  {
        print("注册成功")
    }
    func JPushDidLogin(noti:NSNotification)  {
        print("登录成功")
        print("🐷" + "registraID:\(JPUSHService.registrationID())")
        print(User.currentUser?.usertoken)
        User.BingJgNotifyId(JPUSHService.registrationID(), success: {
            print("绑定极光通知成功")
        }) { (error:NSError) in
            print(error)
        }
    }
    
    //MARK: - 接受自定义消息和通知消息
    func JPushDidReceiveMessage(noti:NSNotification)  {
        
        let tmp = noti.userInfo!["content"] as! String
        print(tmp)
        if  let data = tmp.dataUsingEncoding(NSUTF8StringEncoding) {
            let dic = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
            let typeStr = dic!!["MessageType"] as! String
            
            switch  typeStr {
            case "score":
                let model = ScoreMessageModel.cachedObjectWithID(dic!!["MsgId"] as! String)
                model.msgId = dic!!["MsgId"] as? String ?? ""
                model.sendUserid = dic!!["SendUserid"] as? String ?? ""
                model.recvUserid = dic!!["RecvUserid"] as? String ?? ""
                model.sendNickName = dic!!["SendNickName"] as? String ?? ""
                model.sendImageUrl = dic!!["SendImageUrl"] as? String ?? ""
                if model.sendImageUrl != "" {
                    model.sendImageUrl = "http://wechat.hoyofuwu.com" +  model.sendImageUrl!
                }
                model.messageCon = dic!!["MessageCon"] as? String ?? ""
                model.messageType = dic!!["MessageType"] as? String ?? ""
                model.createTime = dic!!["CreateTime"] as? String ?? ""
                print("zhu\(model.createTime)")
                let  numStr:String =  (NSUserDefaults.standardUserDefaults().valueForKey("scoreNum") ?? "0") as! String
                let str = String(Int(numStr)! + 1)
                NSUserDefaults.standardUserDefaults().setValue(str, forKey: "scoreNum")
                NSUserDefaults.standardUserDefaults().setValue(true, forKey: "StateMessage")
                DataManager.defaultManager!.saveChanges()
                break
            case "string","ordernotify":
                let model = MessageModel.cachedObjectWithID(dic!!["MsgId"] as! String)
                model.msgId = dic!!["MsgId"] as? String ?? ""
                model.sendUserid = dic!!["SendUserid"] as? String ?? ""
                model.recvUserid = dic!!["RecvUserid"] as? String ?? ""
                model.sendNickName = dic!!["SendNickName"] as? String ?? ""
                model.sendImageUrl = dic!!["SendImageUrl"] as? String ?? ""
                if model.sendImageUrl != "" {
                    model.sendImageUrl = "http://wechat.hoyofuwu.com" +  model.sendImageUrl!
                }
                model.messageCon = dic!!["MessageCon"] as? String ?? ""
                model.messageType = dic!!["MessageType"] as? String ?? ""
                model.createTime = dic!!["CreateTime"] as? String ?? ""
                print("zhu\(model.createTime)")
                let  numStr:String =  (NSUserDefaults.standardUserDefaults().valueForKey("messageNum") ?? "0") as! String
                let str = String(Int(numStr)! + 1)
                NSUserDefaults.standardUserDefaults().setValue(str, forKey: "messageNum")
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "StateMessage")
                 DataManager.defaultManager!.saveChanges()
                break
            default:
                break
            }
           
            print("进入了")
            AudioServicesPlaySystemSound(1007)
            
            NSNotificationCenter.defaultCenter().postNotificationName(messageNotification, object: nil, userInfo: ["messageNum": "1"])
            
        }
        
    }
    
    //回调函数
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("回调了")
    }
    
    
}

