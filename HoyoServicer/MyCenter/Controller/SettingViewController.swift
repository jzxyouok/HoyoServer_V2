//
//  SettingViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/4/8.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBAction func loginOut(sender: UIButton) {
        appDelegate.LoginOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("你好")
        print("你好")
        self.title="设置"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        self.tabBarController?.tabBar.hidden=true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience  init() {
        
        var nibNameOrNil = String?("SettingViewController")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
