//
//  RobListViewCellTableViewCell.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 28/3/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
protocol RobListViewCellDelegate {
    func refreshFromRobList()
}


class RobListViewCell : UITableViewCell {
    
    var delegate:RobListViewCellDelegate?
    var  tableView : RobListOneController?
    //右边显示的抢的图片
    @IBOutlet weak var qiangImage: UIImageView!
    
    @IBOutlet weak var checkState: UILabel!
    //用户地址
    @IBOutlet weak var address: UILabel!
    //用户反馈信息
    @IBOutlet weak var message: UILabel!
    //头像
    @IBOutlet weak var headImage: UIImageView!
    //背景
    @IBOutlet weak var backView: UIView!
    
    //距离抢单结束还有多少时间
    @IBOutlet weak var modifyTime: UILabel!
    
    //显示距离
    @IBOutlet weak var distance: UILabel!
    //故障处理
    @IBOutlet weak var troubleHandle: UILabel!
    
    //产品类型信息等
    @IBOutlet weak var productName: UILabel!
    
    //定时器
    var nstimer:NSTimer?
    //还有多少时间，系统规定最长是30分钟
    var timeInval = NSTimeInterval()
    
    var IsShow = true{
        didSet{
            message.hidden = !IsShow
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true
//
    }


    func  showCellText(order:Order,title:String)
    {
        
       
        if title == "抢单" {
            self.checkState.hidden = true
            self.modifyTime.hidden = false
            self.qiangImage.hidden = false
        }
        else{
            
                self.checkState.hidden = false
                self.modifyTime.hidden = true
                self.qiangImage.hidden = true
            }
    //    self.checkState.text =
//        self.headImage.sd_setImageWithURL(NSURL(string: order.headimageurl! as String), placeholderImage:
//        UIImage(named: "order_repair.png"))//
        self.headImage.image=UIImage(named:  (NetworkManager.defaultManager?.getTroubleHandle(order.checkState!).lastObject as? String)!)
        self.message.text = order.describe! as String
        
        self.address.text = order.province! + order.city! + order.country! + order.address!
        let tmp = (order.distance! as NSString).doubleValue
        self.distance.text = String(format: "%.2lf",tmp) + " " + "km"
        
        
      
        self.productName.text = order.productName!
        self.checkState.text = NetworkManager.defaultManager?.getTroubleHandle(order.checkState!).firstObject as? String
        self.troubleHandle.text = order.serviceType
        let  timeStamp  =  DateTool.dateFromServiceTimeStamp(order.modifyTime! )!
        
        //cell.remark.text   =  DateTool.stringFromDate(timeStamp, dateFormat: "yyyy-MM-dd")+" "+self.scorelists[indexPath.row-1].remark!
       // self.modifyTime.text =  DateTool.stringFromDate(timeStamp, dateFormat: "mm:ss")
        if(title == "抢单" && order.id != ""){
            nstimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:#selector(RobListViewCell.getLastTime), userInfo: nil, repeats: true)
        getTime(timeStamp)
        }
        
    }
    func getTime(date:NSDate){
        let  nowDate = NSDate()
      
       
     let dateInterVal  =  nowDate.timeIntervalSinceDate(date)
        let lastTimeInterVal = 1800 - dateInterVal
      showLastRobTime(lastTimeInterVal)
        
      
    }

    
    
    func showLastRobTime(lastTimeInterVal:NSTimeInterval)
    {
    
      
        print(lastTimeInterVal)
        if lastTimeInterVal/60>1 {
            self.timeInval = lastTimeInterVal
            let time = String(format: "%02.0lf",lastTimeInterVal/60) + ":" + String(format: "%02.0lf",lastTimeInterVal%60)
            self.modifyTime.text = time
        }
        else {
            
            let time = "00" + ":" + String(format: "%02.0lf",lastTimeInterVal)
            self.modifyTime.text = time
        }
       // print(self.modifyTime.text)
    }
    
    
    
    func getLastTime(){
    
  var intTimeInval =  NSString(format: "%.0lf", self.timeInval).longLongValue
        if intTimeInval==0{
        delegate!.refreshFromRobList()
        self.nstimer?.invalidate()
            return
        }
        intTimeInval-=1
        print(intTimeInval)
  showLastRobTime(Double(intTimeInval))
       
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

            }
    
}
