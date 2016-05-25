//
//  ForGetPassowViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 19/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForGetPassowViewController: UIViewController {
    
    //倒计时时间
    var shuttime=60
    var counttime:NSTimer!
    
//手机号
    @IBOutlet weak var iphoneNumber: UITextField!
    
    //验证码
    @IBOutlet weak var code: UITextField!
    //获取验证码Label
    @IBOutlet weak var getCodeLab: UILabel!
    
    //新密码
    @IBOutlet weak var newPassword: UITextField!
    //确认新密码
    @IBOutlet weak var confirmNewPassword: UITextField!

    //获取验证码Label

    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var navgaBackView: UIView!
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //UIApplication.sharedApplication().statusBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//获取验证码
    @IBAction func getCode(sender:UIButton) {
        
//       sender.enabled = false
    
    print("点击啦")
        let istrue = checkTel(iphoneNumber.text!)
        
        if istrue
        {
           
            sender.enabled=false
        
            shuttime=60
            counttime=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ForGetPassowViewController.rushtime), userInfo: nil, repeats: true)
            yanzhengfunc()
        }
        else
        {
            let alert = UIAlertView()
            alert.title = "请输入正确的手机号"
            
            alert.addButtonWithTitle("确定")
            alert.show()
        
        }
      
    }
    func yanzhengfunc(){
    
        User.SendPhoneCode(iphoneNumber.text!, order: "ResetPassword", success: {
            
            print("获取成功")
        }) { (error) in
            
            let alert = UIAlertView(title: "", message:error.localizedDescription, delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确认")
            alert.show()
            
        }
    }
    
    func  rushtime()
    {
        if shuttime==0
        {
            
            self.getCodeLab.text = "获取验证码"
            self.getCodeBtn.enabled = true
            counttime.invalidate()
        }else
        {
            
            self.getCodeLab.text = "倒计时\(shuttime)秒"
        }
        
        shuttime -= 1
        
    }
 
    //提交新密码
    @IBAction func submitBtn() {
        print("进去了")

       
        
      MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      

        User.ResetPassword(iphoneNumber.text!, code: self.code.text!, password: self.newPassword.text!, success: { 
            [weak self] in
            let strongSelf = self
            
            
                        strongSelf!.dismissViewControllerAnimated(true) {
            }
            })
            {[weak self] (error) in
                let strongSelf = self
                 MBProgressHUD.hideHUDForView(strongSelf!.view, animated: true)
                let alertView=SCLAlertView()
                alertView.addButton("ok", action: {})
                alertView.showError("错误提示", subTitle: error.localizedDescription)
                
                
        }
        
    }
    
   

}
