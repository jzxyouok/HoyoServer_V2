//
//  AuthenticationController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/30.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import ALCameraViewController
import MBProgressHUD


class AuthenticationController: UIViewController,UITextFieldDelegate {

    var dissCallBack:(()->Void)?//对注册进来用的
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var centerViewContainer: UIView!
    @IBOutlet weak var firstViewContainer: UIView!
    @IBOutlet weak var verifierStateLabel: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBAction func verifyClick(sender: AnyObject) {
        
        
        if ((secondViewContainer?.hidden)!)==false {//第二个页面的点击事件处理
         
            if secondViewContainer?.nameTextField.text==""||secondViewContainer?.IDTextField.text=="" {
                let alert=SCLAlertView()
                alert.showTitle("", subTitle: "姓名和身份证号不能为空！", duration: 2, completeText: "", style: SCLAlertViewStyle.Notice, colorStyle: nil, colorTextButton: nil, circleIconImage: nil)
                return
            }
            
            let frontData=UIImageJPEGRepresentation((secondViewContainer?.imageButton1.imageView?.image)!, 0.001)! as NSData
            let backData=UIImageJPEGRepresentation((secondViewContainer?.imageButton2.imageView?.image)!, 0.001)! as NSData
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            User.UploadRealnameAuthinfo((secondViewContainer?.nameTextField.text)!, cardid: (secondViewContainer?.IDTextField.text)!, frontImg: frontData, backImg: backData, success: {
                [weak self] in
                MBProgressHUD.hideHUDForView(self!.view, animated: true)
                self!.verifierStateLabel.text="正在审核中。。。"
                self!.secondViewContainer?.hidden=true
                self!.verifyButton.setTitle("身份验证", forState: .Normal)
                self!.verifyButton.backgroundColor=UIColor.grayColor()
                self!.verifyButton.enabled=false
                if self!.dissCallBack != nil {
                    self!.leftButton.hidden = true
                }
                }, failure: { [weak self](error) in
                    MBProgressHUD.hideHUDForView(self!.view, animated: true)
                    let alert=SCLAlertView()
                    alert.addButton("确定", action: { })
                    alert.showNotice("", subTitle: "上传失败，请检查网络后重试")
                    self!.verifyButton.backgroundColor=UIColor(red: 252/255, green: 134/255, blue: 62/255, alpha: 1)
                    self!.verifyButton.enabled=false
            })
            
        }else//第一个页面的点击事件处理
        {
            secondViewContainer?.hidden=false
            verifyButton.setTitle("提交", forState: .Normal)
            verifyButton.backgroundColor=UIColor.grayColor()
            verifyButton.enabled=false
            leftButton.hidden=false
            
        }
        
    }
    var secondViewContainer:AuthDetailView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondViewContainer=NSBundle.mainBundle().loadNibNamed("AuthDetailView", owner: nil, options: nil).last as? AuthDetailView
        centerViewContainer.addSubview(secondViewContainer!)
        secondViewContainer?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(centerViewContainer).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        })
        secondViewContainer?.hidden=true
        leftButton.addTarget(self, action: #selector(barButtonClick), forControlEvents: .TouchUpInside)
        rightButton.addTarget(self, action: #selector(barButtonClick), forControlEvents: .TouchUpInside)
        secondViewContainer?.imageButton1.addTarget(self, action: #selector(cameraClick), forControlEvents: .TouchUpInside)
        secondViewContainer?.imageButton2.addTarget(self, action: #selector(cameraClick), forControlEvents: .TouchUpInside)
        secondViewContainer?.nameTextField.delegate=self
        secondViewContainer?.IDTextField.delegate=self
        
        
        leftButton.hidden = !(dissCallBack == nil)
        rightButton.hidden = (dissCallBack == nil)
        initFrontData=UIImageJPEGRepresentation((secondViewContainer?.imageButton1.imageView?.image)!, 0.001)! as NSData
        initBackData=UIImageJPEGRepresentation((secondViewContainer?.imageButton2.imageView?.image)!, 0.001)! as NSData
        //获取认证信息
        verifyButton.enabled=false
        verifyButton.backgroundColor=UIColor.grayColor()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        User.GetCurrentRealNameInfo({
            
            [weak self] checkState in
            MBProgressHUD.hideHUDForView(self!.view, animated: true)
            switch checkState
            {
            case "0" :
                self!.verifierStateLabel.text="请上传身份证进行审核。。。"
                self!.verifyButton.enabled=true
                self!.verifyButton.backgroundColor=UIColor(red: 252/255, green: 134/255, blue: 62/255, alpha: 1)
                break
            case "1" :
                self!.verifierStateLabel.text="您的信息正在等待审核。。。"
            case "2" :
                self!.verifierStateLabel.text="您的信息已经审核通过。"
            case "3" :
                self!.verifierStateLabel.text="您的身份信息已被拒绝。"
                self!.verifyButton.enabled=true
                self!.verifyButton.backgroundColor=UIColor(red: 252/255, green: 134/255, blue: 62/255, alpha: 1)
            default :
                self!.verifierStateLabel.text="获取数据失败，请检查网络后重试！"
                break
            }
        }) { [weak self](error) in
            print(error)
            self!.verifierStateLabel.text="获取数据失败，请检查网络后重试！"
            MBProgressHUD.hideHUDForView(self!.view, animated: true)
        }
        // Do any additional setup after loading the view.
    }
    func barButtonClick(button:UIButton)
    {
        if secondViewContainer?.hidden==false&&button.tag==1 {
            secondViewContainer?.hidden = !(secondViewContainer?.hidden)!
            verifyButton.setTitle("身份验证", forState: .Normal)
            if dissCallBack != nil {
                leftButton.hidden = ((secondViewContainer?.hidden)!)
            }
        }
        else{
            self.dismissViewControllerAnimated(dissCallBack==nil, completion: dissCallBack)
        }
        
        
    }
    func cameraClick(button:UIButton) {
        let alert = SCLAlertView()
        alert.addButton("相册") {
            [weak self] in
            let libraryViewController = CameraViewController.imagePickerViewController(true) { [weak self] image, asset in
                if image != nil
                {
                    button.setImage(image, forState: .Normal)
                    self!.checkCommitButtonIsEnable()
                }
                
                self!.dismissViewControllerAnimated(true, completion: nil)
            }
            
            self!.presentViewController(libraryViewController, animated: true, completion: nil)
        }
        alert.addButton("拍摄") {
            [weak self] in
            let cameraViewController = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { [weak self] image, asset in
                if image != nil
                {
                    button.setImage(image, forState: .Normal)
                    self!.checkCommitButtonIsEnable()
                }
                
                self!.dismissViewControllerAnimated(true, completion: nil)
            }
            self!.presentViewController(cameraViewController, animated: true, completion: nil)
        }
        alert.addButton("取消", action: {})
        alert.showInfo("", subTitle: "请选择")
   
    }
    var initFrontData:NSData?
    var initBackData:NSData?
    
    private func checkCommitButtonIsEnable()
    {
        let frontData=UIImageJPEGRepresentation((secondViewContainer?.imageButton1.imageView?.image)!, 0.001)! as NSData
        let backData=UIImageJPEGRepresentation((secondViewContainer?.imageButton2.imageView?.image)!, 0.001)! as NSData
        if !(initFrontData==frontData||initBackData==backData) {
            verifyButton.enabled=true
            verifyButton.backgroundColor=UIColor(red: 252/255, green: 134/255, blue: 62/255, alpha: 1)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    //dissCall不等于nil，是从注册跳过来的，否则，从个人中心过来的
    convenience  init(dissCall:(()->Void)?) {
        
        var nibNameOrNil = String?("AuthenticationController")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        dissCallBack=dissCall
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
