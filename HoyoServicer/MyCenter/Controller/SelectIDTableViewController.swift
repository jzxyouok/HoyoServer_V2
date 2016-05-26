//
//  SelectIDTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/4/10.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManager

protocol SelectIDTableViewControllerDelegate {
    func selectButtonChange(index:Int)
    func ToSelectAdressController()
    func SelectAdressFinished(adress:String)
}
class SelectIDTableViewController: UITableViewController,SelectIDTableViewControllerDelegate,UITextFieldDelegate {
    
    //1 首席合伙人,2一般合伙人,3联系工程师
    private var whitchCell = 1{
        didSet{
            if whitchCell==oldValue {
                return
            }
            self.tableView.reloadData()
        }
    }
    var chiefOfSelectIDCell:ChiefOfSelectIDCell?
    var generalOfSelectIDCell:GeneralOfSelectIDCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="选择身份"
        self.automaticallyAdjustsScrollViewInsets=false
        tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        chiefOfSelectIDCell=NSBundle.mainBundle().loadNibNamed("ChiefOfSelectIDCell", owner: self, options: nil).last as? ChiefOfSelectIDCell
        chiefOfSelectIDCell?.delegate=self
        generalOfSelectIDCell=NSBundle.mainBundle().loadNibNamed("GeneralOfSelectIDCell", owner: self, options: nil).last as? GeneralOfSelectIDCell
        chiefOfSelectIDCell?.webSiteNameTextField.delegate=self
        chiefOfSelectIDCell?.detailAdressTextField.delegate=self
        generalOfSelectIDCell?.delegate=self
        generalOfSelectIDCell?.inputNumberTextField.delegate=self
        generalOfSelectIDCell?.commitbutton.addTarget(self, action: #selector(commitClick), forControlEvents: .TouchUpInside)
        chiefOfSelectIDCell?.commitbutton.addTarget(self, action: #selector(commitClick), forControlEvents: .TouchUpInside)
        chiefOfSelectIDCell?.selectionStyle=UITableViewCellSelectionStyle.None
        generalOfSelectIDCell?.selectionStyle=UITableViewCellSelectionStyle.None
    }
    func commitClick(button:UIButton) {
        
        let tmpStr:String?
        if button.tag==1 {
            tmpStr="partner"
        }
        else
        {
            tmpStr=generalOfSelectIDCell?.selectIndex==22 ? "n-partner" : "engineer"
        }
        if let str = tmpStr {
            //            weak var weakSelf = self
            switch (str) {
            case "partner":
                //创建团队
                createTeam()
                break
            case "n-partner":
                //加入团队 一般合伙人
                //PartnerCommand
                joinEngineerTeam()
                break
            case "engineer":
                //联席工程师
                joinHoldTeam()
                break
            default:
                break
            }
        }
        
    }
    /**
     SelectIDTableViewControllerDelegate回掉方法
     */
    func selectButtonChange(index: Int) {
        whitchCell=index==21 ?1:index
    }
    //选择地址
    func ToSelectAdressController(){
        let jsonPath = NSBundle.mainBundle().pathForResource("china_citys", ofType: "json")
        let jsonData = NSData(contentsOfFile: jsonPath!)! as NSData
        let tmpObject: AnyObject?
        do{
            tmpObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
        }
        let adressDic = tmpObject as! NSMutableArray
        let adressControll = SelectAdressTableViewController(adressData: adressDic, firstSelectRow: -1)
        adressControll.delegate=self
        self.navigationController?.pushViewController(adressControll, animated: true)
        
    }
    func SelectAdressFinished(adress:String)
    {
        chiefOfSelectIDCell?.cityLabel.text=adress
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        self.tabBarController?.tabBar.hidden=true
        //重写返回按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("back", target: self , action:#selector(SelectIDTableViewController.backBtnAction) )
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardReturnKeyHandler.init().lastTextFieldReturnKeyType = UIReturnKeyType.Done
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
    }
    func backBtnAction(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tmpHeight:CGFloat = whitchCell==1 ? 650:560
        
        return max(tmpHeight, (HEIGHT_SCREEN-HEIGHT_NavBar))
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if whitchCell != 1 {
            generalOfSelectIDCell?.selectIndex=whitchCell==2 ? 22:23
        }
        
        return whitchCell==1 ? chiefOfSelectIDCell!:generalOfSelectIDCell!
    }
    
    //MARK: - 团队操作
    /**创建团队(首席合伙人)*/
    private func createTeam() {
        //创建网点：已成功
        weak var weakSelf = self
        if chiefOfSelectIDCell?.webSiteNameTextField.text == "" {
            let alert = UIAlertView(title: "温馨提示", message: "请输入网点名称", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        if chiefOfSelectIDCell?.cityLabel.text == "省         市" {
            let alert = UIAlertView(title: "温馨提示", message: "请选择所在省市", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        if chiefOfSelectIDCell?.detailAdressTextField.text == "" {
            let alert = UIAlertView(title: "温馨提示", message: "请输入详细信息", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let str = (chiefOfSelectIDCell?.cityLabel.text)! as NSString
        let strNer = str.componentsSeparatedByString(" ")
        let province = strNer.first
        let city = strNer.last
        print("\(province)" + "\(city)")
        let dict = ["scope":"partner","name":(chiefOfSelectIDCell?.webSiteNameTextField.text)!,"province":province!,"city":city!,"country":"  ","address":(chiefOfSelectIDCell?.detailAdressTextField.text)!]
        MBProgressHUD.showHUDAddedTo(view.superview, animated: true)
        User.UpgradeAuthority(dict, success: {
            MBProgressHUD.hideHUDForView(weakSelf!.view.superview, animated: true)
            let alertView=SCLAlertView()
            alertView.addButton("ok", action: {})
            alertView.showError("温馨提示", subTitle: "申请成功!")
            weakSelf?.navigationController?.popViewControllerAnimated(true)
            }, failure: { (error:NSError) in
                MBProgressHUD.hideHUDForView(weakSelf!.view.superview, animated: true)
                let alert = UIAlertView(title: "温馨提示", message: "提交申请失败请重试", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
        })
        
    }
    /**加入团队(一般合伙人)*/
    private func joinEngineerTeam(){
        weak var weakSelf = self
        if generalOfSelectIDCell?.inputNumberTextField.text == "" {
            let alert = UIAlertView(title: "温馨提示", message: "请输入团队号", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let params: NSDictionary = ["groupnumber":Int((generalOfSelectIDCell?.inputNumberTextField.text)!)!,"commandaction":"join","scope":"n-partner"]
        MBProgressHUD.showHUDAddedTo(view.superview, animated: true)
        User.PartnerCommand(params, success: {
            let alertView=SCLAlertView()
            alertView.addButton("ok", action: {})
            alertView.showError("温馨提示", subTitle: "申请成功!")
            weakSelf?.navigationController?.popViewControllerAnimated(true)
            }, failure: { (error:NSError) in
                MBProgressHUD.hideHUDForView(weakSelf!.view.superview, animated: true)
                if error.code == -10033 {
                    let alert = UIAlertView(title: "温馨提示", message: "当前组不存在请重试", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                } else {
                    let alert = UIAlertView(title: "温馨提示", message: "提交申请失败请重试", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }
        })
        
    }
    /**加入团队(联席工程师)*/
    private func joinHoldTeam() {
        
        weak var weakSelf = self
        if generalOfSelectIDCell?.inputNumberTextField.text == "" {
            let alert = UIAlertView(title: "温馨提示", message: "请输入团队号", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        let params: NSDictionary = ["groupnumber":Int((generalOfSelectIDCell?.inputNumberTextField.text)!)!,"commandaction":"join","scope":"l-engineer"]
        MBProgressHUD.showHUDAddedTo(view.superview, animated: true)
        User.PartnerCommand(params, success: {
            MBProgressHUD.hideHUDForView(weakSelf!.view.superview, animated: true)
            let alertView=SCLAlertView()
            alertView.addButton("ok", action: {})
            alertView.showError("温馨提示", subTitle: "申请成功!")
            weakSelf?.navigationController?.popViewControllerAnimated(true)
            }, failure: { (error:NSError) in
                MBProgressHUD.hideHUDForView(weakSelf!.view.superview, animated: true)
                if error.code == -10033 {
                    let alert = UIAlertView(title: "温馨提示", message: "当前组不存在请重试", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                } else {
                    let alert = UIAlertView(title: "温馨提示", message: "提交申请失败请重试", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }
        })
    }
    
}
