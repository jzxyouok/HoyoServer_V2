//
//  GetMoneyViewController.swift
//  HoyoServicer
//
//  Created by 婉卿容若 on 16/5/5.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import IQKeyboardManager

class GetMoneyViewController: UIViewController, UITextFieldDelegate{
    
    var scrollView: UIScrollView!
    var backView: UIView!
    var cardLabel: UILabel!
    var selectCardButton: UIButton!
    var getTitleLabel: UILabel!
    var moneySignLabel: UILabel!
    var getMoneyTextField: UITextField!
    var lineView: UIView!
    var leftMoneyLabel: UILabel!
    var allGetButton: UIButton!
    var getMoneyButton: UIButton!
    
    //加约束的一些固定数据
    let horizontalSpace = 20
    let verticalSpace = 0
    let height = 60
    
    
    var dataSource = [String]()//数据源
    var dataSource02:[BankModel]? //存放银行卡的model
    var currentModel:BankModel? //选中的model
    var currentBank:String? //选择中银行,,传递到下个界面
    var myBalance:Double = 0.00{ //我的零钱余额
        
        didSet{
            
            leftMoneyLabel.text = String(format: "零钱余额￥%.2lf,",myBalance)
            let titleSize = (leftMoneyLabel.text! as NSString).sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(15)])
            leftMoneyLabel.snp_updateConstraints { (make) in
                make.width.equalTo(titleSize.width+5)
            }
        }
    }
    
    var popoverView: PopoverView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "提现"
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self, action: #selector(disMissBtn))
        
        setupUI()
        //下载银行卡列表
        downloadBankListFromServer()
        //获取账户余额
        downloadGetMoneyDetail()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardReturnKeyHandler.init().lastTextFieldReturnKeyType = UIReturnKeyType.Done
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false

    }
    
    override func viewWillLayoutSubviews() {
        
        //试图让scrollView稍微可以滑动
        let tempHeight = HEIGHT_SCREEN - HEIGHT_NavBar - getMoneyButton.frame.origin.y - getMoneyButton.frame.size.height
        getMoneyButton.snp_updateConstraints { (make) in
            make.bottom.equalTo(scrollView.snp_bottom).offset(-tempHeight-10)
        }
        
    }
    
    
}

// MARK: - 界面

extension GetMoneyViewController{
    
    func setupUI() -> Void {
        scrollView = UIScrollView()
        scrollView.backgroundColor = COLORRGBA(239, g: 239, b: 239, a: 1)
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        backView = UIView()
        backView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(backView)
        backView.snp_makeConstraints { (make) in
            make.top.equalTo(horizontalSpace)
            make.leading.equalTo(view.snp_leading).offset(horizontalSpace)
            make.trailing.equalTo(view.snp_trailing).offset(-horizontalSpace)
            make.height.equalTo(4*height+1)
        }
        
        cardLabel = UILabel()
        cardLabel.text = "到账银行卡"
        cardLabel.textColor = UIColor.blackColor()
        cardLabel.textAlignment = NSTextAlignment.Left
        cardLabel.font = UIFont.systemFontOfSize(17)
        backView.addSubview(cardLabel)
        cardLabel.snp_makeConstraints { (make) in
            make.top.equalTo(verticalSpace)
            make.leading.equalTo(horizontalSpace)
            make.width.equalTo(85)
            make.height.equalTo(height)
        }
        
        selectCardButton = UIButton()
        selectCardButton.setTitle("添加银行卡", forState: UIControlState.Normal)
        selectCardButton.setTitleColor(COLORRGBA(0, g: 122, b: 255, a: 1), forState: UIControlState.Normal)
        selectCardButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        selectCardButton.titleLabel?.textAlignment = NSTextAlignment.Center
        selectCardButton.addTarget(self, action: #selector(selectBankCard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        backView.addSubview(selectCardButton)
        selectCardButton.snp_makeConstraints { (make) in
            make.leading.equalTo(cardLabel.snp_trailing).offset(0)
            make.centerY.equalTo(cardLabel.snp_centerY)
            make.height.equalTo(cardLabel.snp_height)
            make.trailing.equalTo(0)
        }
        
        getTitleLabel = UILabel()
        getTitleLabel.text = "提现金额:"
        getTitleLabel.textColor = UIColor.blackColor()
        getTitleLabel.textAlignment = NSTextAlignment.Left
        getTitleLabel.font = UIFont.systemFontOfSize(17)
        backView.addSubview(getTitleLabel)
        getTitleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(cardLabel.snp_bottom).offset(0)
            make.leading.equalTo(horizontalSpace)
            make.trailing.equalTo(0)
            make.height.equalTo(height)
        }
        
        moneySignLabel = UILabel()
        moneySignLabel.text = "￥"
        moneySignLabel.textColor = UIColor.blackColor()
        moneySignLabel.textAlignment = NSTextAlignment.Left
        moneySignLabel.font = UIFont.systemFontOfSize(20)
        backView.addSubview(moneySignLabel)
        moneySignLabel.snp_makeConstraints { (make) in
            make.top.equalTo(getTitleLabel.snp_bottom).offset(0)
            make.leading.equalTo(horizontalSpace)
            make.width.equalTo(40)
            make.height.equalTo(height)
        }
        
        getMoneyTextField = UITextField()
        getMoneyTextField.delegate = self
        getMoneyTextField.placeholder = "请输入提现金额(元)"
        getMoneyTextField.keyboardType = UIKeyboardType.DecimalPad
        getMoneyTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        getMoneyTextField.returnKeyType = UIReturnKeyType.Done
        backView.addSubview(getMoneyTextField)
        getMoneyTextField.snp_makeConstraints { (make) in
            make.leading.equalTo(moneySignLabel.snp_trailing).offset(0)
            make.centerY.equalTo(moneySignLabel.snp_centerY)
            make.height.equalTo(moneySignLabel.snp_height)
            make.trailing.equalTo(-20)
        }
        
        lineView = UIView()
        lineView.backgroundColor = COLORRGBA(239, g: 239, b: 239, a: 1)
        backView.addSubview(lineView)
        lineView.snp_makeConstraints { (make) in
            make.top.equalTo(moneySignLabel.snp_bottom).offset(0)
            make.leading.equalTo(horizontalSpace+20)
            make.height.equalTo(1)
            make.trailing.equalTo(-horizontalSpace-20)
        }
        
        leftMoneyLabel = UILabel()
        leftMoneyLabel.text = "零钱余额￥0.00,"
        leftMoneyLabel.textColor = UIColor.blackColor()
        leftMoneyLabel.textAlignment = NSTextAlignment.Left
        leftMoneyLabel.font = UIFont.systemFontOfSize(15)
        backView.addSubview(leftMoneyLabel)
        leftMoneyLabel.snp_makeConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom).offset(0)
            make.leading.equalTo(20)
            make.height.equalTo(height)
        }
        
        allGetButton = UIButton()
        allGetButton.setTitle("全部提现", forState: UIControlState.Normal)
        allGetButton.setTitleColor(COLORRGBA(0, g: 122, b: 255, a: 1), forState: UIControlState.Normal)
        allGetButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        allGetButton.titleLabel?.textAlignment = NSTextAlignment.Left
        allGetButton.addTarget(self, action: #selector(allGetAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        backView.addSubview(allGetButton)
        allGetButton.snp_makeConstraints { (make) in
            make.leading.equalTo(leftMoneyLabel.snp_trailing).offset(0)
            make.centerY.equalTo(leftMoneyLabel.snp_centerY)
            make.height.equalTo(leftMoneyLabel.snp_height)
            make.width.equalTo(80)
        }
        
        
        getMoneyButton = UIButton()
        getMoneyButton.setTitle("提现", forState: UIControlState.Normal)
        getMoneyButton.setTitleColor(COLORRGBA(255, g: 255, b: 255, a: 1), forState: UIControlState.Normal)
        getMoneyButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        getMoneyButton.backgroundColor = UIColor.orangeColor()
        getMoneyButton.titleLabel?.textAlignment = NSTextAlignment.Center
        getMoneyButton.addTarget(self, action: #selector(getMoneyAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(getMoneyButton)
        getMoneyButton.snp_makeConstraints { (make) in
            make.top.equalTo(backView.snp_bottom).offset(40)
            make.leading.equalTo(view.snp_leading).offset(horizontalSpace)
            make.height.equalTo(40)
            make.trailing.equalTo(view.snp_trailing).offset(-horizontalSpace)
            
        }
        getMoneyButton.layer.cornerRadius = 5

       
        
    }
}

// MARK: - event reponse

extension GetMoneyViewController{
    
    //左边按钮
    func disMissBtn(){
        
        getMoneyTextField.resignFirstResponder()
        
        if let pop = popoverView {
            pop.hide()
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     选择银行卡--按钮事件
     
     - parameter sender: 按钮
     */
    func selectBankCard(sender: UIButton) -> Void {
        
        getMoneyTextField.resignFirstResponder()
        
        if dataSource.isEmpty {
            
            //跳转添加银行卡页面
            let addCar = AddCarViewController()
            self.navigationController?.pushViewController(addCar, animated: true)
            
        }else{
            
            popoverView = PopoverView()
            popoverView!.menuTitles = dataSource
            weak var weakSelf = self
            popoverView!.showFromView(selectCardButton, selected: { (index: Int) in
                weakSelf?.selectCardButton.setTitle(weakSelf?.popoverView!.menuTitles[index] as? String, forState: UIControlState.Normal)
                weakSelf?.currentModel = weakSelf?.dataSource02![index]
                weakSelf?.currentBank = weakSelf?.popoverView!.menuTitles[index] as? String
            })
        }

    }
    
    /**
     全部提现--按钮事件
     
     - parameter sender: 按钮
     */
    func allGetAction(sender: UIButton) -> Void {
        //将所有余额全部提现
        getMoneyTextField.text = String(format: "%.2lf",myBalance)
    }
    
    /**
     提现--按钮事件
     
     - parameter sender: 按钮
     */
    func getMoneyAction(sender: UIButton) -> Void {
        
        /*校验
         1.校验是否已小数点开头,例如.99,,则体现是自动补0->0.99
         2.校验提现金额是否超过余额
         3.判断是否为空
         */
        
        if getMoneyTextField.text!.isEmpty {
            let alertView=SCLAlertView()
            alertView.addButton("ok", action: {})
            alertView.showError("错误提示", subTitle: "提现金额不能为空")
            
        }else{
            if getMoneyTextField.text!.hasPrefix(".") {//是否已"."开头
                
                let tmp = (("0" + getMoneyTextField.text!) as NSString).doubleValue
                getMoneyTextField.text = String(format: "%.2f",tmp)
                if (getMoneyTextField.text! as NSString).doubleValue > myBalance {
                    let alertView=SCLAlertView()
                    alertView.addButton("ok", action: {})
                    alertView.showError("错误提示", subTitle: "余额不足")
                }
                else if (getMoneyTextField.text! as NSString).doubleValue <= 0{
                    
                    let alertView=SCLAlertView()
                    alertView.addButton("ok", action: {})
                    alertView.showError("错误提示", subTitle: "提现金额不能为0")
                    
                }
                else{
                    
                    //调用接口提现
                    weak var weakSelf = self
                    User.submitInfoToGetMoney(["blankid":(currentModel?.bankId)!,"WDMoney":getMoneyTextField.text!], success: {
                        //跳转到下个界面
                        
                       // print("yyyyyyyyyyyyyyyyyy")
                        
                        let getMoneyDetailVC = GetMoneyDetailTableViewController()
                        getMoneyDetailVC.bankInfo = weakSelf?.currentBank
                        getMoneyDetailVC.getAmount = weakSelf?.getMoneyTextField.text
                        self.navigationController?.pushViewController(getMoneyDetailVC, animated: true)
                        
                        }, failure: { (error) in
                            print(error.localizedDescription)
                    })
                }
                
            }else if getMoneyTextField.text!.hasSuffix("."){
                let alertView=SCLAlertView()
                alertView.addButton("ok", action: {})
                alertView.showError("错误提示", subTitle: "提现金额不能以小数点结尾")
                
            }
            else if (getMoneyTextField.text! as NSString).doubleValue <= 0{
                
                let alertView=SCLAlertView()
                alertView.addButton("ok", action: {})
                alertView.showError("错误提示", subTitle: "提现金额不能为0")
                
            }
            else if (getMoneyTextField.text! as NSString).doubleValue > myBalance{
                let alertView=SCLAlertView()
                alertView.addButton("ok", action: {})
                alertView.showError("错误提示", subTitle: "余额不足")
            }else{
                //调用接口提现
                weak var weakSelf = self
                User.submitInfoToGetMoney(["blankid":(currentModel?.bankId)!,"WDMoney":getMoneyTextField.text!], success: {
                    //跳转到下个界面
                   // print("yyyyyyyyyyyyyyyyyy")
                    
                    let getMoneyDetailVC = GetMoneyDetailTableViewController()
                    getMoneyDetailVC.bankInfo = weakSelf?.currentBank
                    getMoneyDetailVC.getAmount = weakSelf?.getMoneyTextField.text
                    self.navigationController?.pushViewController(getMoneyDetailVC, animated: true)
                    
                    }, failure: { (error) in
                        print(error.localizedDescription)
                })
            }

        }
    }
    
}


// MARK: - download data

extension GetMoneyViewController{
    
    //获取银行卡列表
    func downloadBankListFromServer() -> Void {
        
        weak var weakSelf = self
        User.GetOwenBindBlankCard({ (tmpArr) in
            
            weakSelf?.dataSource02 = tmpArr //存放起来 -- 选择银行卡体现是需要银行卡id
           
            for model in tmpArr{
                
                weakSelf?.dataSource.append(weakSelf!.linkBankInfo(model))
            }
            
            //显示数据
            weakSelf!.showData()
            
            
        }){ (errror) in
            
            print(errror.localizedDescription)
        }
        
    }
    
    
    //获取账户余额
    func downloadGetMoneyDetail() -> Void {
        
        weak var weakSelf = self
        User.GetOwenMoney({ (model) in
            //显示余额
            if let tmp = Double(model.balance!){
                weakSelf?.myBalance = tmp
            }else{
                 weakSelf?.myBalance = 0.00
            }
            
           
            
            }) { (error) in
                print(error.localizedDescription)
        }
    }
}

// MARK: - 显示数据

extension GetMoneyViewController{
    
    /**
     显示控件上的数据
     */
    func showData() -> Void {
        
        
        if dataSource.isEmpty {
            selectCardButton.setTitle("添加银行卡", forState: UIControlState.Normal)
            getMoneyButton.backgroundColor = UIColor.grayColor()
            getMoneyButton.enabled = false
        }else{
            selectCardButton.setTitle(dataSource[0], forState: UIControlState.Normal)
            currentModel = dataSource02![0]
            currentBank = dataSource[0]
        }

    }
}


// MARK: - 拼接银行卡信息

extension GetMoneyViewController{
    
    func linkBankInfo(model:BankModel) -> String {
        var resultString:String = ""
        resultString += model.bankName!
        resultString += "   "
        
        var tempStr:String = "尾号("
        var count = 0
        for item in (model.cardId?.characters)! {
            count += 1
            if count > ((model.cardId?.characters.count)! - 4) {
                tempStr.append(item)
            }
        }
        tempStr += ")"
        
        resultString += tempStr
        
        return resultString
    }
}

// MARK: - UITextFieldDelegate

extension GetMoneyViewController{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        //限制输入框只能输入数字(最多两位小数)
        return  textField.moneyFormatCheck(textField.text!, range: range, replacementString: string, remian: 2)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        getMoneyTextField.resignFirstResponder()
        return true
    }
    
}


