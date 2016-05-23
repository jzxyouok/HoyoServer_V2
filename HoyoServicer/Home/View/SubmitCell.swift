//
//  SubmitCell.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 15/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

protocol SubmitCellDelegate {
    func poptoSuperCon(label1:String)
    func popAboutScanToSuperCon(whichLabel:String)
    func uploadPhoto(tmpIndex:Int)
    func popToSelectProductMaterial()
    func reloadTableView()
}
class SubmitCell: UITableViewCell{
var tmpIndex = 199
    var tmpTrouble2 = [String]()
    var trouble1:[String]?
    var trouble2 = NSArray()
    
    @IBOutlet weak var troubleProblemText1: UILabel!
    @IBOutlet weak var troubleProblemBtn1: UIButton!
    
    @IBOutlet weak var troubleProblemText2: UILabel!
    @IBOutlet weak var troubleProblemBtn2: UIButton!
    var delegate : SubmitCellDelegate?
    //选择日期
    @IBOutlet weak var selectDate: UIButton!
    //选择时间
    @IBOutlet weak var selectTime: UIButton!
    //请选择用时
    @IBOutlet weak var pleaseSelectTime: UIButton!
    
    //选择日期label
    @IBOutlet weak var selectDateLabel: UILabel!
    //选择时间label
    
    //id扫描结果
    
      //imei扫描结果
    @IBOutlet weak var idScanText: UITextView!
    @IBOutlet weak var imeiScanResult: UITextView!
    
    @IBOutlet weak var selectTimeLabel: UILabel!
    //用时
    @IBOutlet weak var pleaseSelectTimeLabel: UILabel!
    
    
    @IBOutlet weak var serverView: UIView!
  //默认现金支付
    var payWay = "现金支付"
    
    //reason
    @IBOutlet weak var remark: UITextView!
    //头像
    @IBOutlet weak var headImage: UIImageView!
    //问题类型
    @IBOutlet weak var troubleType: UILabel!
    //产品信息
    @IBOutlet weak var productInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        troubleProblemBtn1.imageEdgeInsets = UIEdgeInsetsMake( (self.troubleProblemBtn1.frame.height-32)/2, self.troubleProblemBtn1.frame.size.width-40, (self.troubleProblemBtn1.frame.height-32)/2,8 )
         troubleProblemBtn2.imageEdgeInsets = UIEdgeInsetsMake( (self.troubleProblemBtn1.frame.height-32)/2, self.troubleProblemBtn1.frame.size.width-40, (self.troubleProblemBtn1.frame.height-32)/2,8 )
       
         serverHeight.constant = 0
//        [self.view setNeedsLayout]; //更新视图
//        [self.view layoutIfNeeded];
        self.setNeedsLayout()
        self.layoutIfNeeded()
      
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //点击事件
    func showText(trouble1:[String],trouble2:NSArray,orderDetail:OrderDetail)
    {
        
        self.trouble1 = trouble1
        self.trouble2 = trouble2
          //self.headImage.sd_setImageWithURL(NSURL(string: orderDetail.headImage! as String))
        self.headImage.sd_setImageWithURL(NSURL(string: orderDetail.userImage! as String), placeholderImage: UIImage(named: "order_repair.png"))
        self.troubleType.text = orderDetail.troubleHandleType
        self.productInfo.text = orderDetail.productNameAndModel
    
    }
    
    
    
    
    @IBOutlet weak var serverHeight: NSLayoutConstraint!
    @IBAction func selectBtn(sender: AnyObject) {
        switch sender.tag {
        case 0:
            DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date,formate : "YYYY-MM-DD") {
                (date) -> Void in
                self.selectDateLabel.text = "\(date)"
            print("选择日期")
            }
            break
        case 1:
                DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time,formate : "HH:mm:ss") {
                    (date) -> Void in
                    self.selectTimeLabel.text = "\(date)"
            print("选择时间")
                }
            break
        case 2:

            delegate?.poptoSuperCon(self.pleaseSelectTimeLabel.text!)
            break
        case 3:
            print("扫描机器ID")
            delegate?.popAboutScanToSuperCon("1")
            break
        case 4:
            print("IMEI")
            delegate?.popAboutScanToSuperCon("2")
            break
        case 5:
            print("故障按钮1")
            let popoverView = PopoverView()
            popoverView.menuTitles = self.trouble1
            
            popoverView.showFromView(troubleProblemText1, selected: {[weak self] (index: Int) in
                if let strongSelf = self{
                    
                    //                strongSelf.troubleProblemBtn1.setTitle(popoverView.menuTitles[index] as? String, forState: UIControlState.Normal)
                    strongSelf.tmpTrouble2 = strongSelf.trouble2[index] as! [String]
                    
                    strongSelf.troubleProblemText1.text =  strongSelf.trouble1![index]
                    //                weakSelf?.currentModel = weakSelf?.dataSource02![index]
                    //                weakSelf?.currentBank = popoverView.menuTitles[index] as? String
                }})
            break
        case 6:
            let popoverView = PopoverView()
            popoverView.menuTitles = self.tmpTrouble2
            
            popoverView.showFromView(troubleProblemText2, selected: {[weak self] (index: Int) in
                if let strongSelf = self {
                
                    
                    strongSelf.troubleProblemText2.text = strongSelf.tmpTrouble2[index]
                   
                    
                }   })
            
            print("故障按钮2")
            break
        case 7:
            delegate?.popToSelectProductMaterial()
            break
        case 8:
            print("现金支付")
             serverHeight.constant = 0

     setBtnLayer(8,otherOneTage: 9,otherTwoTage: 13)
            payWay = "现金支付"
            delegate?.reloadTableView()
            break
        case 9 :
            setBtnLayer(9,otherOneTage: 8,otherTwoTage: 13)
            
             serverHeight.constant = 45
            payWay = "微信支付"
            print("微信支付")
                  
            delegate?.reloadTableView()
            break
        case 13:
            setBtnLayer(13,otherOneTage: 8,otherTwoTage: 9)
        serverHeight.constant = 0
            payWay = "无需支付"
            print("无需支付")
       delegate?.reloadTableView()
            break
            
        case 260:
     
                tmpIndex += 1
                delegate?.uploadPhoto(tmpIndex)
                print("点击上传图片")
      
            break
        default:
            break
        }
        
    }
    
    func setBtnLayer(clicktag:Int,otherOneTage:Int,otherTwoTage:Int){
        
        let tmpBtn = self.viewWithTag(clicktag) as!UIButton
       tmpBtn.layer.borderColorWithUIColor = COLORRGBA(248, g: 90, b: 30, a: 1)
        tmpBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
       tmpBtn.layer.cornerRadius=6
        tmpBtn.backgroundColor=COLORRGBA(251, g: 133, b: 38, a: 1)
        tmpBtn.layer.masksToBounds=true
       tmpBtn.layer.borderWidth=1
    
         let tmpBtn2 = self.viewWithTag(otherOneTage) as!UIButton
        tmpBtn2.backgroundColor = UIColor.whiteColor()
        tmpBtn2.setTitleColor(UIColor.blackColor(), forState: .Normal)
        let tmpBtn3 = self.viewWithTag(otherTwoTage) as!UIButton
        tmpBtn3.backgroundColor = UIColor.whiteColor()
        tmpBtn3.setTitleColor(UIColor.blackColor(), forState: .Normal)
    
    }
  
}
