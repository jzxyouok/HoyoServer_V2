//
//  HomeTableViewController.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/28.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//


import UIKit
import SVPullToRefresh
import MBProgressHUD

class HomeTableViewController: UITableViewController,CLLocationManagerDelegate {
    var  manager :CLLocationManager?
    var nextTitle:String!
    var action :String!
    var repeatTime = 0
    var  counttime:NSTimer!
 //  var orders=[Order]()
//    var addressDicBlock:((CLLocationCoordinate2D,CLPlacemark)->Void)? 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets=false
        tableView.registerNib(UINib(nibName: "HomeTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        //添加下拉加载数据事件
        tableView.addPullToRefreshWithActionHandler {
            [weak self] in
            if let strongSelf=self{
                strongSelf.refresh()
            }
        }
     
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CurrentUserDidChange), name: CurrentUserDidChangeNotificationName, object: nil)
        
    // initBlock()
     
    }
 
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //定位
        manager = CLLocationManager()
        manager!.delegate=self
        manager!.desiredAccuracy = kCLLocationAccuracyBest
        manager!.distanceFilter = 10.0
        manager!.requestAlwaysAuthorization()
        manager!.startUpdatingLocation()
    }
    
    var addressDic=NSMutableDictionary()
    
    var pagesize = 10
    var pageindex = 0
    

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0]
       let o2d = newLocation.coordinate
//CLLocationCoordinate2D
//        let loca = 31.4217987560
//        let logn = 116.7258979197
//        let  location = CLLocation.init(latitude: loca, longitude: logn)
        
        //let o2d = newLocation.coordinate
        manager.stopUpdatingLocation()
        let  geoC = CLGeocoder()
       
        geoC.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            if(error == nil)
            {
                
                let placemark=placemarks?.first
            
               // addressDic?.setValue(<#T##value: AnyObject?##AnyObject?#>, forKey: <#T##String#>)
                print("===========\n");
                print("成功 %@",placemark?.classForCoder);
                print("地理名称%@",placemark!.name);
                print("街道名%@",placemark!.thoroughfare);
                print("国家%@",placemark!.country);
                print("城市%@",placemark!.locality);
                
                print("区: %@",placemark!.subLocality);
 
                print("==========\n");
                
                //初始化关于地理位置的block
              //  self.initBlock()
               self.addressDic.setValue(10, forKey: "pagesize")
             //   self.addressDic.set(10, forKey: "pagesize")
                self.addressDic.setValue(1, forKey: "pageindex")
        
               
                self.addressDic.setValue((placemark!.administrativeArea! as String), forKey: "Province")
                self.addressDic.setValue((placemark!.locality! as String), forKey: "city")
          
                
                self.addressDic.setValue((o2d.latitude as NSNumber).doubleValue, forKey: "lat")
               
                self.addressDic.setValue((o2d.longitude as NSNumber).doubleValue, forKey: "lng")

//             self.addressDic.setValue(placemark?.subLocality, forKey: "Country")
              //self.addressDicBlock!(o2d,placemark!)
               
            }else
            {
                print("错误");
            }
        }
        
    }
    

 
    
    func CurrentUserDidChange() {
        self.tableView.reloadData()
    }
     func refresh() {
        let success: (User) -> Void = {
            [weak self] user in
            if let self_ = self {
                User.currentUser=user
                self_.tableView.reloadData()
                self_.tableView.pullToRefreshView.stopAnimating()
            }
        }
        let failure: (NSError) -> Void = {
            [weak self] error in
            if let self_ = self {
               self_.tableView.pullToRefreshView.stopAnimating()
            }
        }
        User.RefreshIndex(success, failure: failure)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=true
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
        return HEIGHT_SCREEN-HEIGHT_TabBar
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableViewCell", forIndexPath: indexPath) as! HomeTableViewCell
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        cell.buttonClickCallBack={ [weak self] buttonTag in
            if let strongSelf = self {
                strongSelf.buttonClick(buttonTag)
            }
            
        }
        cell.nameLabel.text = User.currentUser!.name
        if User.currentUser?.headimageurl != nil
        {
            cell.personImg.image=UIImage(data: (User.currentUser?.headimageurl)!)
        }
        cell.imageArray=[UIImage(named: "banner1"),UIImage(named: "banner2"),UIImage(named: "banner3")]
        return cell
    }
    
    /**
     点击菜单的哪个按钮
     
     - parameter Tag: 从左到右，从上到下，1、2....8
     */
    private func buttonClick(Tag:Int)
    {
        print(Tag)
        switch Tag {
        case 1:
            
     if    self.addressQconCityIsNull() == false
     {
        break
             }
              MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            counttime=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:#selector(HomeTableViewController.addressQconCityIsNull), userInfo: nil, repeats: true)
            
            break
        case 2:
            
            
            self.nextTitle = "待处理"
            
            self.action = "yqaction"
            self.pushToNextCon()

//
//              self.nextTitle = "待处理"
//       if       self.addressCityIsNill() == false
//       {
//        break
//              }
//               MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//              counttime=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:#selector(HomeTableViewController.addressCityIsNill), userInfo: nil, repeats: true)
            
             
            break
        case 3:
            let viewCon =  ViewController()
            
            self.navigationController?.pushViewController(viewCon, animated: true)
            
            break
        case 4:
            
            let viewCon =  ViewController()
            self.navigationController?.pushViewController(viewCon, animated: true)
//            self.nextTitle = "待评价"
//            self.action = "waitscoreaction"
//            self.pushToNextCon()
            break
        case 5:
            
            self.nextTitle = "待评价"
            self.action = "waitscoreaction"
            self.pushToNextCon()
            break
        case 6:
            self.nextTitle = "待结算"
            self.action = "wsettlementaction"
            self.pushToNextCon()
            
            break
        case  7:
            self.nextTitle = "已评价"
            self.action = "scoreaction"
            self.pushToNextCon()
            break
        case  8:
            
            self.nextTitle = "已结算"
            self.action = "hsettlementaction"
            pushToNextCon()
//            let  myteam = MyTeamTableViewController()
//           // myteam.hidesBottomBarWhenPushed = true
//             self.navigationController?.pushViewController(myteam, animated: true)
            
            break
            
        default:
            break
            
        }

    }
    
    func pushToNextCon( ){
        
        //        self.nextTitle = "待处理"
        //
        //        self.action = "kqaction"
        if       self.addressCityIsNill() == false
        {
            return
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        counttime=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:#selector(HomeTableViewController.addressCityIsNill), userInfo: nil, repeats: true)
    }
    
    
    //除了抢单，其他各种单页面都一样
    func addressCityIsNill()->Bool{
        repeatTime += 1
        
        if repeatTime > 3 {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            counttime.invalidate()
            self.noticeError("网络不给力呀兄弟.", autoClear: true, autoClearTime: 2)
            repeatTime = 0
        }
        if self.addressDic.objectForKey("city") != nil{
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            let pendingDoing = RobListOneController(title: nextTitle, orderBytime: self.addressDic,action: self.action)
            pendingDoing.hidesBottomBarWhenPushed = true
            
            
            self.navigationController?.pushViewController(pendingDoing, animated: true)
            
            if self.counttime != nil {
                self.counttime.invalidate()
            }
            repeatTime = 0
            return false
        }
        return true
        
    }

    //抢单判断传入的地理信息是否成功
    func addressQconCityIsNull() ->Bool{
        repeatTime += 1
        if repeatTime > 3 {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            counttime.invalidate()
            
            self.noticeError("网络不给力呀兄弟....", autoClear: true, autoClearTime: 2)
            repeatTime = 0
        }
        
        if self.addressDic.objectForKey("city") != nil{
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.addressDic.setValue("kqaction", forKey: "action")
            let robOneCon = RobListMianViewController(addressDic: self.addressDic)
            
            robOneCon.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(robOneCon, animated: true)
            if self.counttime != nil {
                self.counttime.invalidate()
            }
            repeatTime = 0
            return false
            
        }
        
        return true
    }
}
