//
//  DetailViewCell.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 30/3/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.


import UIKit
import MBProgressHUD
protocol DetailViewCellDelegate {
    func backToSuperCon()
    func showBrowPhtotoCon(cell :BrowseCollectionViewCell,browseItemArray:NSMutableArray)
    func pushToSubmitView()
}
class DetailViewCell: UITableViewCell,UICollectionViewDataSource,UIViewControllerTransitioningDelegate,UICollectionViewDelegate {
    
   var arr = [String]()
    
   //collectionView的背景View
    @IBOutlet weak var collectionViewBlackView: UIView!
    var orderDetail : OrderDetail?
    
    var imageDetailArr  :[String]?
    @IBOutlet weak var collectView: UICollectionView!
//详情图片描述
 //   @IBOutlet weak var imageDetail: UIImageView!
    
   //头像
    @IBOutlet weak var headView: UIImageView!
    //背景
    @IBOutlet weak var topImage: UIImageView!
    //抢单
    @IBOutlet weak var robBtn: UIButton!
    //审核状态
    @IBOutlet weak var checkState: UILabel!
    //手机号
    @IBOutlet weak var mobile: UILabel!
    //问题类型
    @IBOutlet weak var troubleHandleType: UILabel!
    //产品
    @IBOutlet weak var productNameAndModel: UILabel!
    
    //上门时间
    @IBOutlet weak var visitTime: UILabel!
    //问题描述
    @IBOutlet weak var troubleDescripe: UILabel!
    
    //地点
    @IBOutlet weak var address: UILabel!
    //距离
    @IBOutlet weak var distance: UILabel!
    
 //提交时间按钮
    @IBOutlet weak var submit: UIView!
    
  //点击完成按钮
    @IBOutlet weak var finish: UIView!
    
    //包含button的view
    @IBOutlet weak var YQView: UIView!
    @IBOutlet weak var detailUserName: UILabel!
    
    var delegate :DetailViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.robBtn.enabled = true
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 35
        headView.layer.borderWidth = 3.0
        headView.layer.borderColor = UIColor.whiteColor().CGColor
        
        robBtn.layer.masksToBounds = true
        robBtn.layer.cornerRadius = 6
     collectView.delegate = self
        collectView.dataSource = self
        let flowLayout  =  UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
       
     
        collectView.collectionViewLayout = flowLayout
        
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
  
    }
    
    @IBAction func click(sender: AnyObject) {
        let  tag = (sender as! UIButton).tag
        switch tag {
        case 0:
            print("抢单")

        MBProgressHUD.showHUDAddedTo(self, animated: true)
            User.RobOrder(self.orderDetail!.id!, success: {
                
                MBProgressHUD.hideHUDForView(self, animated: true)
                self.robBtn.enabled = false
                let alertView=SCLAlertView()
                //                alertView.showSuccess("", subTitle: "抢单", closeButtonTitle:"")
                alertView.showSuccess("抢单成功", subTitle: "抢单", closeButtonTitle: "", duration: 0.5)
                let  durationTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(DetailViewCell.backToRobLists), userInfo: nil, repeats: false)
                NSRunLoop.mainRunLoop().addTimer(durationTimer, forMode: NSRunLoopCommonModes)
            
                }, failure: { (error) in
                    
                
                    let alertView=SCLAlertView()
                    alertView.addButton("ok", action: {})
                    alertView.showError("错误提示", subTitle: error.localizedDescription)

                    
            })
            
            break
        case 1:
            print("上门时间")
            
            break
        case 2:
            print("完成")
            
            delegate?.pushToSubmitView()
            
            
            break
        default:
            break
        }
        
        
        
        
    }
    //返回到上个容器
    func backToRobLists()
    {
    delegate?.backToSuperCon()
        
    
    }
    func showCellText(orderDetail:OrderDetail,title :String)

    {
        self.orderDetail = orderDetail
        
        for item in (self.orderDetail?.imageDetail?.componentsSeparatedByString("|"))! as [String] {
            if (item as String).hasSuffix("|") {
                
                arr.append(item.componentsSeparatedByString("|").first!)
            }
            else if  item != ""{
                arr.append(item)
            }
            
        }
    
       if title == "抢单"
       {
        YQView.removeFromSuperview()
        }
    
      else if (title == "待处理") {
        robBtn.removeFromSuperview()
        }
      else
        {
        YQView.removeFromSuperview()
            robBtn.removeFromSuperview()
            
        }
       // self.headView.sd_setImageWithURL(NSURL(string: orderDetail.headImage! as String))//
        if(title == "抢单"){
         self.headView.sd_setImageWithURL(NSURL(string: orderDetail.userImage! as String), placeholderImage: UIImage(named: "defaultImage.png"))
        }else{
        self.headView.sd_setImageWithURL(NSURL(string: orderDetail.enginerImage! as String), placeholderImage: UIImage(named: "defaultImage.png"))
        }
        //        self.topImage.sd_setImageWithURL(NSURL(string: orderDetail.topImage! as String))
        self.checkState.text  =  NetworkManager.defaultManager?.getTroubleHandle(orderDetail.checkState! as String!).firstObject as! String

        self.mobile.text = orderDetail.mobile
        self.troubleHandleType.text = orderDetail.troubleHandleType
        self.productNameAndModel.text = orderDetail.productNameAndModel
        self.troubleDescripe.text = orderDetail.troubleDescripe
        self.address.text = orderDetail.province! + orderDetail.city! + orderDetail.country! + orderDetail.address!
        let  timeStamp  =  DateTool.dateFromServiceTimeStamp(orderDetail.visitTime! )!
        
        //cell.remark.text   =  DateTool.stringFromDate(timeStamp, dateFormat: "yyyy-MM-dd")+" "+self.scorelists[indexPath.row-1].remark!
        self.visitTime.text =  DateTool.stringFromDate(timeStamp, dateFormat: "yyyy年MM月dd日")
        let tmp = (orderDetail.distance! as NSString).doubleValue
        self.distance.text = "距离" + String(format: "%.2lf",tmp) + "km"
        self.detailUserName.text = orderDetail.nickname
//  self.imageDetail.sd_setImageWithURL(NSURL(string: orderDetail.imageDetail!.componentsSeparatedByString("|").first! as String))//
        self.collectView!.registerNib(UINib(nibName:"BrowseCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:"BrowseCollectionViewCell")
        
        if arr.count == 0{
        
            self.collectionViewBlackView.removeFromSuperview()
        
        }
        
    self.collectView.reloadData()
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
    let cell =   collectionView.dequeueReusableCellWithReuseIdentifier("BrowseCollectionViewCell", forIndexPath: indexPath) as! BrowseCollectionViewCell
        cell.imageView.sd_setImageWithURL(NSURL(string: arr[indexPath.row] as String))
        cell.imageView.tag = indexPath.row + 100
        cell.imageView.clipsToBounds = true
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        NSArray *bigUrlArray = @[@"http://7xjtvh.com1.z0.glb.clouddn.com/browse01.jpg",
//        @"http://7xjtvh.com1.z0.glb.clouddn.com/browse02.jpg",
//        @"http://7xjtvh.com1.z0.glb.clouddn.com/browse03.jpg",
//        @"http://7xjtvh.com1.z0.glb.clouddn.com/browse04.jpg",
//        @"http://7xjtvh.com1.z0.glb.clouddn.com/browse05.jpg",
//        @"http://7xjtvh.com1.z0.glb.clouddn.com/browse06.jpg",
//        @"http://7xjtvh.com1.z0.glb.clouddn.com/browse07.jpg",
//        @"http://7xjtvh.com1.z0.glb.clouddn.com/browse08.jpg",
//        @"http://7xjtvh.com1.z0.glb.clouddn.com/browse09.jpg"];
//        // 加载网络图片
//        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
//        int i = 0;
//        for(i = 0;i < [_smallUrlArray count];i++)
//        {
//            UIImageView *imageView = [self.view viewWithTag:i + 100];
//            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
//            browseItem.bigImageUrl = bigUrlArray[i];// 加载网络图片大图地址
//            browseItem.smallImageView = imageView;// 小图
//            [browseItemArray addObject:browseItem];
//        }
//        MSSCollectionViewCell *cell = (MSSCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
//        MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.imageView.tag - 100];
//        [bvc showBrowseViewController];
        
        
//        let province =  adressDetail.componentsSeparatedByString(" ").first! as String
//        
//        let city =  adressDetail.componentsSeparatedByString(" ").last! as String

      
//        for item in (self.orderDetail?.imageDetail?.componentsSeparatedByString("|"))! as [String] {
//            if (item as String).hasSuffix("|") {
//
//                 arr.append(item.componentsSeparatedByString("|").first!)
//            }
//            else{
//            arr.append(item)
//            }
//        }
   
        let browseItemArray = NSMutableArray()
        var  i = 0
        for( i = 0 ; i < arr.count; i += 1){
            
        let imageView = UIApplication.sharedApplication().keyWindow?.viewWithTag(i+100)
          let    browseItem = MSSBrowseModel()
            browseItem.bigImageUrl = arr[i]
            browseItem.smallImageView = imageView as! UIImageView
            browseItemArray.addObject(browseItem)
      
            }
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BrowseCollectionViewCell
              delegate?.showBrowPhtotoCon(cell ,browseItemArray: browseItemArray)
    }

   
}
