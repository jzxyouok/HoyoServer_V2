//
//  SubmitController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 15/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ALCameraViewController
import SwiftyJSON
class SubmitController: UITableViewController,SubmitCellDelegate ,UseTimeConDelegate,OznerScanViewControllerDelegate,SelectProductViewControllerDelegate,SubmitBtnDelegate{
    
  
    
    let myKeyWindow = UIApplication.sharedApplication().keyWindow
     let  space :CGFloat = (WIDTH_SCREEN-30-79*4)/4
    
    var backControl:UIControl!
    var hour = "0"
    var minute = "0"
    
     var whichLabel:String?
    var useTime :UseTimeCon?
    var  pickerBackView :UIView?
    
    //扫描结果
    var idScanResult = ""
    var imeiScanResult = ""
    
    var imageView = UIImageView()
    
    var trouble1 = [String]()
    var trouble2 = [NSArray]()
    
    
    //订单列表的模型
    var productinfos = [Int:[String]]()
    var productInfoArr = [[String]]()
    
    var orderDetail:OrderDetail?
    lazy var troubleModelArr : [TroubleDetail] = {
        
        let path =  NSBundle.mainBundle().pathForResource("trouble", ofType: "json")
        
        //        let data    =  try! NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
        
        let data = try! NSData(contentsOfFile: path!)
        var  tmptroubleDetailArr = [TroubleDetail]()
        do {
            let json = try! JSON(data: data!)
            
            
            
            for item in json.array! {
                let tmptroubleDetail = TroubleDetail()
                tmptroubleDetail.margin = item["margin"].stringValue
                let    tmpsubresArr =  NSMutableArray()
                for item1 in item["subres"].array!
                {
                    tmpsubresArr.addObject(item1.stringValue)
                    
                }
                tmptroubleDetail.subres = tmpsubresArr
                
                tmptroubleDetailArr.append(tmptroubleDetail)
                
            }
        }
        catch{
            print(error)
        }
        
        
        return tmptroubleDetailArr
        
        
    }()
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    //dissCall不等于nil，是从注册跳过来的，否则，从个人中心过来的
    convenience  init(orderDetail:OrderDetail) {
        
        var nibNameOrNil = String?("SubmitController.swift")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        self.orderDetail=orderDetail
        
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    

    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        tableView.estimatedRowHeight = 600
        
        tableView.rowHeight = UITableViewAutomaticDimension
//        self.prefersStatusBarHidden() = false
 
        self.addBackControl()
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarHidden = false
setNavigationItem("back.png", selector: #selector(doBack), isRight: false)
         self.title  = "确认完成"

        
        for item in troubleModelArr {
            trouble1.append(item.margin! as String)
        }
        
        for item in troubleModelArr {
            trouble2.append(item.subres!)
            
        }
        
         tableView.registerNib(UINib(nibName: "SubmitCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SubmitCell")
         tableView.registerNib(UINib(nibName: "SubmitListsCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SubmitListsCell")
         tableView.registerNib(UINib(nibName: "SubmitBtn", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SubmitBtn")
        

    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func viewDidDisappear(animated: Bool) {
//           self.navigationController?.navigationBar.hidden = true
//         UIApplication.sharedApplication().statusBarHidden = true
//    }
//    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    // MARK: - Table view data source
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
    }
    
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of row
        if section == 0{
        return 1
        }
      else  if section == 1
        {
            return productinfos.keys.count
        }
        else
        {
            return 1

        
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
         cell?.selectionStyle = .None
        if indexPath.section == 0 {
        
        cell = tableView.dequeueReusableCellWithIdentifier("SubmitCell") as! SubmitCell
            let  tmpCell = cell as! SubmitCell
        tmpCell.delegate = self
       
            tmpCell.pleaseSelectTimeLabel.text = self.hour + ":" + self.minute
tmpCell.selectionStyle = .None
        tmpCell.idScanText.text = idScanResult
        tmpCell.imeiScanResult.text = imeiScanResult
        tmpCell.showText(trouble1, trouble2: trouble2,orderDetail: self.orderDetail!)
        }
      else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("SubmitListsCell", forIndexPath: indexPath) as! SubmitListsCell
            let tmpcell = cell as! SubmitListsCell
            print(productinfos)
            
//            tmpcell.showText(self.productinfos.values[indexPath.row] as [String])
            tmpcell.showText(self.productInfoArr[indexPath.row] )
           
        }
        else{
        
         cell = tableView.dequeueReusableCellWithIdentifier("SubmitBtn", forIndexPath: indexPath) as! SubmitBtn
            cell?.selectionStyle = .None
        }
        return cell!
    }
 


    func addBackControl() {
        
        
        if self.backControl == nil {
            let frame = CGRectZero
            backControl = UIControl(frame: frame)
            backControl.backgroundColor = UIColor.blackColor()
            backControl.alpha = 0.5
            
//            backControl.addTarget(self, action: #selector(SubmitController.clickBackControl), forControlEvents: .TouchUpInside);
            backControl.addTarget(self, action: #selector(SubmitController.clickBackControl), forControlEvents: .TouchUpInside)
            
            self.view.addSubview(self.backControl)
            self.view.sendSubviewToBack(self.backControl)
            
        }
    }
    
    func clickBackControl(){
        
        backControl.frame = CGRectZero
        self.pickerBackView?.frame = CGRectZero
        self.pickerBackView?.hidden  = true
//        selectTimeView.hidden = true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
                self.useTime?.view.removeFromSuperview()
                useTime?.removeFromParentViewController()
        self.view.backgroundColor=UIColor.whiteColor()
        
    }
    
//----------代理--------------
    func poptoSuperCon(label1: String)  {
        self.view.backgroundColor = UIColor.grayColor()
        var hour  = "0"
        var minute = "0"
        if label1.containsString(":") {
            hour  = label1.componentsSeparatedByString(":").first!
            minute  = label1.componentsSeparatedByString(":").last!
        }
        let useTime = UseTimeCon(hour: hour, minute: minute)
        self.useTime = useTime
        useTime.delegate = self
        self.addChildViewController(useTime)
        self.view.addSubview(useTime.view)
        self.view.sendSubviewToBack(self.backControl)
        
        
        self.pickerBackView = useTime.view
        self.view.bringSubviewToFront(useTime.view)
        
    }

    func showToSuperCon(hour: String, minute: String) {
        self.hour = hour
        self.minute = minute
        self.tableView.reloadData()
    }
 
    
    func popAboutScanToSuperCon(whichLabel: String) {
        self.whichLabel = whichLabel
        
        let  scan = OznerScanViewController()
        scan.delegate = self
        self.navigationController?.pushViewController(scan, animated: true)
    }
    
    //上传相册
    func uploadPhoto(tmpIndex: Int) {
        print(tmpIndex)
        if tmpIndex<204 {
            let alert = SCLAlertView()
            alert.addButton("相册") {
                [weak self] in
                let libraryViewController = CameraViewController.imagePickerViewController(true) { [weak self] image, asset in
                    if let strongSelf = self{
                        if image != nil{
                          
                            let imageView = self?.tableView.viewWithTag((tmpIndex)) as! UIImageView
                            imageView.image = image
                            //User.currentUser?.headimageurl=UIImageJPEGRepresentation(image!, 0.001)! as NSData
                            
                            
                            strongSelf.dismissViewControllerAnimated(true, completion: nil)
                            if tmpIndex < 203 {
                          
                            (strongSelf.tableView.viewWithTag((tmpIndex+1)) as! UIImageView).image=UIImage(named: "addmore")
                            (strongSelf.tableView.viewWithTag(260) as! UIButton).frame.origin.x+=imageView.frame.width+strongSelf.space
                            
                            }
                        }
                    }
                }
                
                self!.presentViewController(libraryViewController, animated: true, completion: nil)
            }
            alert.addButton("拍摄") {
                [weak self] in
                let cameraViewController = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { [weak self] image, asset in
                    if let strongSelf = self{
                        if image  != nil{
                            let imageView = strongSelf.tableView.viewWithTag(tmpIndex) as! UIImageView
                            imageView.image = image                    //User.currentUser?.headimageurl=UIImageJPEGRepresentation(image!, 0.001)! as NSData
                            
                            if tmpIndex < 203{
                            (strongSelf.tableView.viewWithTag((tmpIndex+1)) as! UIImageView).image=UIImage(named: "addmore")
                            (strongSelf.tableView.viewWithTag(260) as! UIButton).frame.origin.x+=(imageView.frame.width)+strongSelf.space
                          
                        }}
                        strongSelf.dismissViewControllerAnimated(true, completion: nil)
                        }
                }
                self!.presentViewController(cameraViewController, animated: true, completion: nil)
            }
            alert.addButton("取消", action: {})
            alert.showInfo("", subTitle: "请选择以下方式更新个人头像")
            
            
        }
        
    }
    func popToSelectProductMaterial() {
     let selectProductMaterial = SelectProductViewController()
        selectProductMaterial.delegate = self
        self.navigationController?.pushViewController(selectProductMaterial, animated: true)
        
    }
    
    func popToSubmitCon(result: String) {
        
        if whichLabel == "1" {
           self.idScanResult  = result
        }
        else if whichLabel == "2"
        {
           self.imeiScanResult = result
        }
        self.tableView.reloadData()
    }
    
    func selectedInfos(productInfo: [Int:[String]]) {
        
        //self.productinfos = productInfo
        for (key,value) in productInfo {
//            self.productinfos[key] = value
            self.productinfos.updateValue(value, forKey: key)
            
        
    }
        for (_,value) in self.productinfos {
          
            self.productInfoArr.append(value)
        }
        self.tableView.reloadData()
    }
    
    func submitToServer() {
        
        
        
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func initFinishParam()->NSMutableDictionary{
    var tmpParam = NSMutableDictionary()
        tmpParam.setValue(User.currentUser?.usertoken, forKey: "usertoken")
        
        var tmpListCell = tableView.viewWithTag(11) as! SubmitListsCell
        var tmpSubmitcell = tableView.viewWithTag(10) as! SubmitCell
        var finishOrderModel = FinishOrderModel()
        
        finishOrderModel.arrivetime = tmpSubmitcell.selectTimeLabel.text
        finishOrderModel.usetime = "\(Int(self.hour)!*60 + Int(self.minute)!)"
        finishOrderModel.Fault = tmpSubmitcell.troubleProblemText1.text! + tmpSubmitcell.troubleProblemText2.text!
      finishOrderModel.PayWay = tmpSubmitcell.payWay
        finishOrderModel.machinecode = tmpSubmitcell.imeiScanResult.text
        finishOrderModel.machinetype = tmpSubmitcell.idScanText.text
        finishOrderModel.Remark = tmpSubmitcell.remark.text
//        tmpParam.setValue(try NSJSONSerialization.dataWithJSONObject(finishOrderModel, options: NSJSONWritingPrettyPrinted ,error :nil), forKey: "data")
        do{
    var data = try NSJSONSerialization.dataWithJSONObject(finishOrderModel, options: .PrettyPrinted)
        }catch let error as NSError{
        
        print(error)
        
        }
    return tmpParam
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
    
}
