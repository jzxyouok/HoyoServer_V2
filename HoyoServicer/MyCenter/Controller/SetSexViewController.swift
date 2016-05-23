//
//  SetSexViewController.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
//typealias InputClosureType = (String) -> Void   //定义闭包类型（特定的函数类型函数类型）
class SetSexViewController: UIViewController,UIAlertViewDelegate {



    @IBOutlet weak var womenImg: UIImageView!
    @IBOutlet weak var manImg: UIImageView!
     @IBOutlet weak var secretImage: UIImageView!
    @IBAction func womenClick(sender: AnyObject) {
        sex="女"
      callBack!(sex)
        
      self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func manClick(sender: AnyObject) {
        sex="男"
       callBack!(sex)
    

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func secretClick(sender: AnyObject) {
        sex="保密"
     callBack!(sex)
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    var tmpSex:String?//初始化时外部传入的值
    private var sex="女" {
        didSet{
            print(sex)
            womenImg.hidden = sex=="男"
            manImg.hidden = sex=="女"
            secretImage.hidden = sex == "保密"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "性别"
        print(tmpSex)
        sex=tmpSex ?? "女"

        
    
    setNavigationItem("back.png", selector: #selector(UIViewController.doBack), isRight: false)

    }


    //返回
   override func doBack()
  {
////        if tmpSex != sex
////        {
////            let alert=UIAlertView(title: "", message: "是否保存？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "保存")
////            alert.show()
////        }
////        else
////        {
////            self.navigationController?.popViewControllerAnimated(true)
////        }
    
    self.navigationController?.popViewControllerAnimated(true)
    
    }
//    func SaveClick()
//    {
//        if backClosure != nil
//        {
//            print(sex)
//            backClosure!(sex)
//        }
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//    //alert 点击事件
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        if alertView.message=="是否保存？"
//        {
//            if buttonIndex==0
//            {
//                self.navigationController?.popViewControllerAnimated(true)
//            }
//            else
//            {
//                SaveClick()
//            }
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden=false
        
        
    }
    
        var callBack:((String)->Void)?
    
//    convenience  init(callback:((String)->Void)) {
//        
//        var nibNameOrNil = String?("SetSexViewController")
//        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
//        {
//            nibNameOrNil = nil
//        }
//        self.init(nibName: nibNameOrNil, bundle: nil)
//        callBack=callback
//    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(callback:((String)->Void))
    {
        var nibNameOrNil = String?("EditNameViewController")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        callBack=callback
    
    }

    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }


}
