//
//  FillBankCardMessageController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 2/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import IQKeyboardManager

class FillBankCardMessageController: UIViewController {
    
    @IBAction func backAction(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBOutlet weak var bankTypeTextField: UITextField!
    
    @IBOutlet weak var bankPhoneTextField: UITextField!
    
    @IBOutlet weak var confirmCodeTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func sendCode(sender: UIButton) {
        
        if (bankPhoneTextField.text! as NSString).length == 11{
            
            //调用发送验证码接口
            User.SendPhoneCodeForBankCard(bankPhoneTextField.text!, order: "BindCard", success: { [weak self] in
                //启动计时器
                self!.remainingSeconds = 60
                self!.isCounting = true
                
            }) { (error) in
                
                let alertView=SCLAlertView()
                alertView.addButton("确定", action: {})
                alertView.showError("错误提示", subTitle: error.localizedDescription)
                
            }
        }else{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "手机号码格式不正确")
        }
    }
    
    @IBAction func bindingAction(sender: UIButton) {
        
        
        if (bankTypeTextField.text! as NSString).length == 0{
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "卡类型不能为空")
        }else if (bankTypeTextField.text! !=  "储蓄卡"){
            
            if (bankTypeTextField.text! != "信用卡"){
                
                let alertView=SCLAlertView()
                alertView.addButton("确定", action: {})
                alertView.showError("错误提示", subTitle:  "请填写储蓄卡或信用卡")
            }else{
                
                //立即绑定
                bingdingBankCard()
            }
        }else if (bankPhoneTextField.text! as NSString).length == 11{
            
            //立即绑定
            bingdingBankCard()
            
        }else{
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle:  "请填写储蓄卡或信用卡")
        }
        
    }
    
    //倒计时剩余的时间
    var remainingSeconds = 0{
        
        willSet{
            
            confirmButton.setTitle("(\(newValue)s)", forState: .Normal)
            
            if newValue <= 0 {
                confirmButton.setTitle("重新获取", forState: .Normal)
                isCounting = false
            }
        }
    }
    
    //计时器
    var countDownTimer:NSTimer?
    
    //用于开启和关闭定时器
    var isCounting:Bool = false{
        
        willSet{
            if  newValue {
                countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats:true)
                
                confirmButton.backgroundColor = UIColor.grayColor()
            }else
            {
                countDownTimer?.invalidate()
                countDownTimer = nil
                
                confirmButton.backgroundColor = UIColor.brownColor()
            }
            
            confirmButton.enabled = !newValue
        }
    }

    
    var realName:String?
    var bankNumber:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTextFiled()
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        // IQKeyboardReturnKeyHandler.init().lastTextFieldReturnKeyType = UIReturnKeyType.Done
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
    
    
    }

   
    
    // MARK - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        var nibNameOrNil = String?("FillBankCardMessageController")
        
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


}

// MARK: - TextFiled

extension FillBankCardMessageController:UITextFieldDelegate{
    
    //初始化TextField
    func setupTextFiled() -> Void {
        bankTypeTextField.placeholder = "储蓄卡或信用卡"
        bankTypeTextField.delegate = self
        confirmCodeTextField.keyboardType = UIKeyboardType.Default
        bankTypeTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        bankPhoneTextField.placeholder = "银行预留手机号码"
        bankPhoneTextField.delegate = self
        bankPhoneTextField.keyboardType = UIKeyboardType.NumberPad
        bankPhoneTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
    }
}

// MARK: - 点击按钮获取验证码

extension FillBankCardMessageController{
    
    //计时器事件
    func updateTime() -> Void {
        
        remainingSeconds -= 1
    }
}

// MARK: - 网络请求

extension FillBankCardMessageController{
    func bingdingBankCard() -> Void {
        //绑定验证
        User.BindNewBlankCard(["realname":realName!,"cardType":bankTypeTextField.text!,"cardid":bankNumber!,"cardphone":bankPhoneTextField.text!,"code":confirmCodeTextField.text!], success: { [weak self] in
            //验证成功跳转回navigation第二层(所有绑定的银行卡界面/提现界面)
            
            if self!.navigationController?.viewControllers.count >= 2 {
                let viewController = self!.navigationController?.viewControllers[1]
                
                //这里强制解包可能存在问题
                if (viewController!.isMemberOfClass(BoundBankCardViewController)){
                    
                    let vc = viewController as? BoundBankCardViewController
                    vc!.downloadDataFromServer()
                    self!.navigationController?.popToViewController(vc!, animated: true)
                }else if (viewController!.isMemberOfClass(GetMoneyViewController)){
                    let vc = viewController as? GetMoneyViewController
                    vc!.downloadBankListFromServer()
                    self!.navigationController?.popToViewController(vc!, animated: true)
                }
            }

//            for controller in (self!.navigationController?.viewControllers)!{
//                
//                if controller.isKindOfClass(BoundBankCardViewController){
//                    
//                    let vc = controller as? BoundBankCardViewController
//                    vc!.downloadDataFromServer()
//                    self!.navigationController?.popToViewController(vc!, animated: true)
//                }
//            }
            
            }, failure: { (error) in
                let alert = UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确认")
                alert.show()
                

            })

    }
}


