//
//  AddCarViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 2/4/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import IQKeyboardManager

class AddCarViewController: UIViewController,UITextFieldDelegate {

//持卡人
    @IBOutlet weak var cardOwner: UITextField!
    
    //持卡人卡号
    @IBOutlet weak var cardNumber: UITextField!
    
    //下一步

    

    @IBAction func next(sender: AnyObject) {
        
        if (cardOwner.text! as NSString).length == 0{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle: "持卡人姓名不能空")

            
        }else if cardNumber.text!.isAllNumber && ((cardNumber.text! as NSString).length == 19 || (cardNumber.text! as NSString).length == 16 || (cardNumber.text! as NSString).length == 17){
            
            let fillBankCardCV = FillBankCardMessageController()
            fillBankCardCV.bankNumber = cardNumber.text!
            fillBankCardCV.realName = cardOwner.text!
            navigationController?.pushViewController(fillBankCardCV, animated: true)
            
        }else{
            
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle: "您输入的银行卡号数字个数不正确，请重新输入")
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "添加银行卡"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(disMissBtn))

        
        cardOwner.placeholder = "持卡人姓名"
        cardOwner.delegate = self
        cardOwner.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        cardNumber.placeholder  = "持卡人银行卡号"
        cardNumber.delegate = self
        cardNumber.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        cardNumber.keyboardType = UIKeyboardType.NumberPad
        //cardOwner.text = "郑文祥"
        //cardNumber.text = "6217001210048102717"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
        navigationController?.navigationBarHidden = true
    }

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        var nibNameOrNil = String?("AddCarViewController")
        
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
        
    }
    
      
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
// 
//        if (textField.tag == 10 && string.isAllNumber && (string as NSString).length != 19 ){
//            let alertView=UNAlertView(title: "", message: "您输入的银行卡号数字个数不正确，请重新输入")
//            alertView.addButton("确定", action: {
//            })
//            alertView.show()
//           
//        }
//        return true
//    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
        if [10].contains(textField.tag) && !string.isAllNumber {
            return false
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if !( (textField.text! as NSString).length == 19 ){
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle: "您输入的银行卡号数字个数不正确，请重新输入")
        }
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if cardNumber.text != nil {
            
        
        if (  (cardNumber.text! as NSString).length != 19 ){
            let alertView=SCLAlertView()
            alertView.addButton("确定", action: {})
            alertView.showError("错误提示", subTitle: "您输入的银行卡号数字个数不正确，请重新输入")
            
        }
        cardNumber.resignFirstResponder()
        }}

}

// MARK: - 银行卡号码校验

extension AddCarViewController{
    
    //剔除卡号里的非法字符
    func getDigitsOnly(text: String) -> String {
        var digitsOnly = ""
        
        for c in text.characters {
            switch c {
            case "0","1","2","3","4","5","6","7","8","9":
                digitsOnly.append(c)
            default:
                continue
                
            }
        }
        return digitsOnly
    }
    
    //检查银行卡是否合法(Luhn算法)
    func isValidCardNumber(bankNumber: String) -> Bool {
        let numbers = getDigitsOnly(bankNumber)
        
        var sum:Int = 0
        var digit:Int = 0
        var addend:Int = 0
        var timesTwo = false
        
        var numArr = [Character]()
        for cha in numbers.characters {
            numArr.append(cha)
        }
        for cha in numArr.reverse() {
        
            let char = String(cha)
            digit = Int((char.unicodeScalars.first?.value)!)
            
            if timesTwo {
                addend = digit * 2
                if addend > 9 {
                    addend -= 9
                }
            }else{
                addend = digit
            }
            
            sum += addend
            timesTwo = true
        }
        
        let modulus = sum % 10
        return modulus == 0
    }
}

// MARK: - event response

extension AddCarViewController{
    
    //左边按钮
    func disMissBtn(){
        navigationController?.popViewControllerAnimated(true)
    }
    
}
