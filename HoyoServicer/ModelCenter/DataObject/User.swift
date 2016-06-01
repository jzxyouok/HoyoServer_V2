//
//  User.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/4/5.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import Foundation
import CoreData

let UserDefaultsUserTokenKey = "usertoken"
let UserDefaultsUserIDKey = "userid"
let CurrentUserDidChangeNotificationName = "CurrentUserDidChangeNotificationName"

class User: DataObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    static var currentUser: User? = nil {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(CurrentUserDidChangeNotificationName, object: nil)
        }
    }
    
    //检查是否自动登录
    class func loginWithLocalUserInfo(success success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
        
        let UserToken = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultsUserTokenKey) as? NSString
        let UserID = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultsUserIDKey) as? NSString
        var error: NSError? = nil
        if UserToken == nil || UserID==nil  {
            let userInfo = [
                NSLocalizedDescriptionKey: "本地usertoken或UserID不存在不存在",
                NSLocalizedFailureReasonErrorKey: ""
            ]
            failure?(NSError(
                domain: NetworkManager.defaultManager!.website,
                code: NetworkManager.defaultManager!.tokenFailCode,
                userInfo: userInfo))
        } else {
            if let user = DataManager.defaultManager?.fetch("User", ID: UserID!, error: &error) as? User {
                success?(user)
            } else {
                let userInfo: NSMutableDictionary = [
                    NSLocalizedDescriptionKey: "数据库用户信息不存在",
                    NSLocalizedFailureReasonErrorKey: "",
                    NSLocalizedRecoverySuggestionErrorKey: ""
                ]
                if error != nil {
                    userInfo[NSUnderlyingErrorKey] = error
                }
                failure?(NSError(
                    domain: NetworkManager.defaultManager!.website,
                    code: 404,
                    userInfo: userInfo as [NSObject: AnyObject]))
            }
        }
    }
    //  /FamilyAccount/ResetPassword     APP忘记/修改密码
    class func ResetPassword(phone: String,code: String,password: String, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("ResetPassword",
                                            parameters: [
                                                "phone": phone,
                                                "code": code,
                                                "password": password
            ],
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //获取验证码
    class func SendPhoneCode(mobile: String,order: String, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("SendPhoneCode",
                                            parameters: [
                                                "mobile": mobile,
                                                "order": order,
                                                "scope":"engineer"
            ],
                                            success: {
                                                
                                                data in
                                                print(data)
                                                success!()
                                                
            },
                                            failure: failure)
    }
    
    //绑定银行卡时获取验证码
    class func SendPhoneCodeForBankCard(mobile: String,order: String, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("SendPhoneCode",
                                            parameters: [
                                                "mobile": mobile,
                                                "order": order,
                                                "scope":" "
            ],
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    
    
    //验证验证码
    class func AppChenkPhone(phone: String,code: String, success: ((String) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("AppChenkPhone",
                                            parameters: [
                                                "phone": phone,
                                                "code": code
            ],
                                            success: {
                                                data in
                                                success!(data["msg"].stringValue)
            },
                                            failure: failure)
    }
    // /FamilyAccount/AppRegister       APP端注册用户
    class func AppRegister(token:String, realname: String, cardid: String, password: String, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("AppRegister",
                                            parameters: [
                                                "token": token,
                                                "realname": realname,
                                                "cardid": cardid,
                                                "password": password,
                                                "scope":"engineer"
            ],
                                            success: {
                                                data in
                                                print(data)
                                                let user = User.cachedObjectWithID(data["data"].stringValue)//userId
                                                user.usertoken = data["msg"].stringValue//usertoken
                                                
                                                let defaults = NSUserDefaults.standardUserDefaults()
                                                defaults.setObject(data["msg"].stringValue, forKey: UserDefaultsUserTokenKey)
                                                defaults.setObject(data["data"].stringValue, forKey: UserDefaultsUserIDKey)
                                                defaults.synchronize()
                                                loginWithLocalUserInfo(success: success, failure: failure)
            },
                                            failure: failure)
    }
    //登录
    class func loginWithPhone(phone: String, password: String, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.clearCookies()
        NetworkManager.defaultManager!.POST("AppLogin",
                                            parameters: [
                                                "phone": phone,
                                                "password": password
            ],
                                            success: {
                                                data in
                                                
                                                let tmpUserID=data["data"].stringValue
                                                let user = User.cachedObjectWithID(tmpUserID)
                                                user.id =  tmpUserID//userId
                                                user.usertoken = data["msg"].stringValue//usertoken
                                                
                                                let defaults = NSUserDefaults.standardUserDefaults()
                                                defaults.setObject(user.usertoken, forKey: UserDefaultsUserTokenKey)
                                                defaults.setObject(tmpUserID, forKey: UserDefaultsUserIDKey)
                                                defaults.synchronize()
                                                loginWithLocalUserInfo(success: success, failure: failure)
                                                
            },
                                            failure: failure)
    }
    //获取当前用户信息
    class func GetCurrentUserInfo(success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetCurrentUserInfo",
                                            parameters: NSDictionary(),
                                            success: {
                                                data in
                                                print(data)
                                                let tmpData=data["data"]
                                                let user = User.cachedObjectWithID(tmpData["userid"].stringValue)
                                                user.city=tmpData["city"].stringValue
                                                user.country=tmpData["country"].stringValue
                                                var tmpUrl=tmpData["headimageurl"].stringValue
                                                if (tmpUrl != "")
                                                {
                                                    if (tmpUrl.containsString("http"))==false
                                                    {
                                                        tmpUrl=(NetworkManager.defaultManager?.website)!+tmpUrl
                                                    }
                                                    user.headimageurl=NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                }
                                                
                                                user.language=tmpData["language"].stringValue
                                                user.mobile=tmpData["mobile"].stringValue
                                                user.name=tmpData["nickname"].stringValue
                                                user.openid=tmpData["openid"].stringValue
                                                user.province=tmpData["province"].stringValue
                                                user.scope=tmpData["scope"].stringValue
                                                let tmpSex=tmpData["sex"].stringValue
                                                user.sex=tmpSex
                                                do{
                                                    user.groupdetails = try? tmpData["GroupDetails"].rawData()
                                                    
                                                }
                                                success!(user)
            },
                                            failure:
            failure
        )
    }
    
    
    //  /FamilyAccount/UpdateUserInfo    更新用户个人信息
    class func UpdateUserInfo(dataDic:NSDictionary, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        var constructingBlock:((AFMultipartFormData?) -> Void)?=nil
        if let tmpdata=dataDic["headImage"] {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let str = formatter.stringFromDate(NSDate())
            let fileName = NSString(format: "%@", str)
            constructingBlock={
                data in
                var _ = data!.appendPartWithFileData((tmpdata as! NSData), name: (fileName as String), fileName: "headImage", mimeType: "image/png")
            }
        }
        NetworkManager.defaultManager!.request("UpdateUserInfo", GETParameters: nil, POSTParameters: dataDic, constructingBodyWithBlock: constructingBlock, success: {
            data in
            let tmpData=data["data"]
            let user = User.cachedObjectWithID(tmpData["userid"].stringValue)
            user.city=tmpData["city"].stringValue
            user.country=tmpData["country"].stringValue
            var tmpUrl=tmpData["headimageurl"].stringValue
            if (tmpUrl != "")
            {
                if (tmpUrl.containsString("http"))==false
                {
                    tmpUrl=(NetworkManager.defaultManager?.website)!+tmpUrl
                }
                user.headimageurl=NSData(contentsOfURL: NSURL(string: tmpUrl)!)
            }
            user.language=tmpData["language"].stringValue
            user.mobile=tmpData["mobile"].stringValue
            user.name=tmpData["nickname"].stringValue
            user.openid=tmpData["openid"].stringValue
            user.province=tmpData["province"].stringValue
            user.scope=tmpData["scope"].stringValue
            user.sex=tmpData["sex"].stringValue
            do{
                user.groupdetails = try? tmpData["GroupDetails"].rawData()
            }
            User.currentUser=user
            success!()
            }, failure: failure)
        
        
    }
    //以下是未解析的借口
    //  /Command/SendMessage             APP发送消息
    class func SendMessage(recvuserid: String, message: String,messagetype: String, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("SendMessage",
                                            parameters:[
                                                "recvuserid":recvuserid,
                                                "message":message,
                                                "messagetype":messagetype
            ],
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //  /Command/BingJgNotifyId          绑定极光通知ID
    class func BingJgNotifyId(notifyid: String, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("BingJgNotifyId",
                                            parameters:[
                                                "notifyid":notifyid
            ],
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //  /Upload/Images                   上传图片接口
    class func UploadImages(frontImg:NSData,backImg:NSData, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        var constructingBlock:((AFMultipartFormData?) -> Void)?=nil
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let str = formatter.stringFromDate(NSDate())
        let fileName = NSString(format: "%@", str)
        constructingBlock={
            data in
            data!.appendPartWithFileData((frontImg), name: (fileName as String), fileName: "frontImg", mimeType: "image/png")
            data!.appendPartWithFileData((backImg), name: (fileName as String)+"1", fileName: "backImg", mimeType: "image/png")
        }
        
        NetworkManager.defaultManager!.request("UploadImages", GETParameters: nil, POSTParameters: ["order":"cardvf"], constructingBodyWithBlock: constructingBlock, success: {
            data in
            print(data)
            success!()
            }, failure: failure)
        
    }
    //  /AppInterface/GetOrderList       分页获取可抢订单列表
    class func GetOrderList(paramDic: NSDictionary, success: (([Order]) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetOrderList",
                                            parameters:paramDic,
                                            success: {
                                                data in
                                                print(data)
                                                let tmpData = data["data"].array
                                                var orders=[Order]()
                                                for item in tmpData!{
                                                    let orderId=item["OrderId"].stringValue
                                                    let order = Order.cachedObjectWithID(orderId)
                                                    var tmpUser = item["user"]
                                                    order.city = item["city"].stringValue
                                                    order.describe = item["Describe"].stringValue
                                                    order.province = item["Province"].stringValue
                                                    order.country = item["Country"].stringValue
                                                    order.id = item["OrderId"].stringValue//OrderId
                                                    var tmpUrl  = tmpUser["headimageurl"].stringValue
                                                    if (tmpUrl != "")//headimageurl
                                                    {
                                                        if (tmpUrl.containsString("http"))==false
                                                        {
                                                            tmpUrl=(NetworkManager.defaultManager?.website)!+tmpUrl
                                                        }
                                                        order.headimageurl = tmpUrl //NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                    }
                                                    else
                                                    {
                                                        order.headimageurl = ""
                                                    }
                                                    order.checkState = item["CRMCheck"].stringValue
                                                    order.productName = item["productinfo"]["ProductName"].stringValue
                                                    order.productModel = item["productinfo"]["ProductModel"].stringValue
                                                    order.createTime = item["CreateTime"].stringValue
                                                    order.address = item["Address"].stringValue
                                                    // order.describe = item["Describe"].stringValue
                                                    order.modifyTime = item["ModifyTime"].stringValue
                                                    order.distance = item["distance"].stringValue
                                                    let troubleHandle = item["ServiceType"].stringValue
                                                    order.serviceType      = NetworkManager.defaultManager?.getTroubleHandle(troubleHandle).firstObject as? String
                                                    
                                                    orders.append(order)
                                                    
                                                }
                                                
                                                success!(orders)
            },
                                            failure:
            failure)
    }
    //  /AppInterface/RobOrder           抢订单
    class func RobOrder(orderid: String, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("RobOrder",
                                            parameters:[
                                                "orderid":orderid
            ],
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //  /AppInterface/FinshOrder         提交完成订单
    class func FinshOrder(orderid: String, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("FinshOrder",
                                            parameters:[
                                                "orderid":orderid
            ],
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    
    //  /AppInterface/GetOrderDetails    获取订单详细信息
    class func GetOrderDetails(orderid: String, success: (([AnyObject]) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetOrderDetails",
                                            parameters:[
                                                "orderid":orderid
            ],
                                            success: {
                                                data in
                                                //数组
                                                print(data)
                                                var  arr = [AnyObject]()
                                                var item =   data["data"]
                                                let orderId = item["OrderId"].stringValue
                                                let ueritem = item["user"]
                                                let orderDetail  = OrderDetail.cachedObjectWithID(orderId)
                                                
                                                var  tmpUrl = ueritem["headimageurl"].stringValue
                                                if (tmpUrl != "")//headimageurl
                                                {
                                                    if (tmpUrl.containsString("http"))==false
                                                    {
                                                        tmpUrl=(NetworkManager.defaultManager?.website)!+tmpUrl
                                                    }
                                                    orderDetail.userImage = tmpUrl //NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                }
                                                else
                                                {
                                                    orderDetail.userImage = ""
                                                }
                                                var engnerImageItem = item["Engineer"]
                                                var tmpEngnerImage = engnerImageItem["headimageurl"].stringValue
                                                
                                                if (tmpEngnerImage != "")//headimageurl
                                                {
                                                    if (tmpEngnerImage.containsString("http"))==false
                                                    {
                                                        tmpEngnerImage=(NetworkManager.defaultManager?.website)!+tmpUrl
                                                    }
                                                    orderDetail.enginerImage = tmpUrl //NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                }
                                                else
                                                {
                                                    orderDetail.enginerImage = ""
                                                }
                                                
                                                var  tmpUrl2 = item["Images"]["ImageUrl"].stringValue
                                                if (tmpUrl2 != "")//headimageurl
                                                {
                                                    if (tmpUrl2.containsString("http"))==false
                                                    {
                                                        tmpUrl2=(NetworkManager.defaultManager?.website)!+tmpUrl
                                                    }
                                                    orderDetail.topImage = tmpUrl2 //NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                }
                                                else{
                                                    orderDetail.topImage = ""
                                                }
                                                
                                                let  tmpUrl3 = item["Images"].array
                                                orderDetail.imageDetail = ""
                                                for item in tmpUrl3!
                                                {
                                                    var tmp = item["ImageUrl"].stringValue
                                                    
                                                    if  tmp !=  ""
                                                    {
                                                        if (tmp.containsString("http"))==false
                                                        {
                                                            tmp = (NetworkManager.defaultManager?.website)! + tmp
                                                        }
                                                        //orderDetail.imageDetail = tmp //NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                        
                                                        
                                                    }
                                                    else {
                                                        tmp = ""
                                                        
                                                        
                                                    }
                                                    orderDetail.imageDetail = orderDetail.imageDetail! +  tmp  + "|"
                                                    
                                                }
                                                
                                                orderDetail.mobile = item["UserPhone"].stringValue
                                                orderDetail.nickname = item["UserName"].stringValue
                                                orderDetail.checkState = item["CRMCheck"].stringValue
                                                orderDetail.distance = item["distance"].stringValue
                                                orderDetail.address = item["Address"].stringValue
                                                orderDetail.addressDetail = item["Address"].stringValue
                                                
                                                orderDetail.visitTime  =  item["ServiceTime"].stringValue
                                                
                                                orderDetail.troubleDescripe = item["Describe"].stringValue
                                                orderDetail.troubleHandleType = NetworkManager.defaultManager?.getTroubleHandle(item["ServiceItem"].stringValue).firstObject as? String
                                                orderDetail.country = item["Country"].stringValue
                                                orderDetail.province = item["Province"].stringValue
                                                orderDetail.city = item["City"].stringValue
                                                
                                                
                                                orderDetail.productNameAndModel =  item["productinfo"]["ProductModel"].stringValue + item["productinfo"]["ProductName"].stringValue
                                                
                                                arr.append(orderDetail)
                                                
                                                if item["finshDetails"]["orderid"].stringValue != ""{
                                                    
                                                    let finishDetail = FinshDetail()
                                                    var   tmpFinish = item["finshDetails"]
                                                    finishDetail.arrivetime = tmpFinish["arrivetime"].stringValue
                                                    finishDetail.orderId = tmpFinish["orderid"].stringValue
                                                    finishDetail.usetime = tmpFinish["usetime"].stringValue
                                                    finishDetail.money = tmpFinish["money"].stringValue
                                                    finishDetail.troubleDetail = tmpFinish["Fault"].stringValue
                                                    finishDetail.reason = tmpFinish["Reason"].stringValue
                                                    finishDetail.remark = item["evaluate"]["Remark"].stringValue
                                                    arr.append(finishDetail)
                                                }
                                                
                                                if item["settlementinfo"]["OrderId"].stringValue != ""
                                                {
                                                    var tmpsettlementinfo = item["settlementinfo"]
                                                    let settlementinfoDetail = Settlementinfo()
                                                    
                                                    settlementinfoDetail.debitMoney = tmpsettlementinfo["DebitMoney"].stringValue
                                                    settlementinfoDetail.higherMoney = tmpsettlementinfo["HigherMoney"].stringValue
                                                    settlementinfoDetail.money = tmpsettlementinfo["Money"].stringValue
                                                    settlementinfoDetail.settleTime = tmpsettlementinfo["CreateTime"].stringValue
                                                    
                                                    arr.append(settlementinfoDetail)
                                                }
                                                
                                                
                                                success!( arr )
            },
                                            failure: failure)
    }
    
    
    //GetPost/Command/NewVersion获取版本更新
    class func NewVersion(paramDic: NSDictionary, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("NewVersion",
                                            parameters:paramDic,
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //GetPost/AppInterface/RefreshIndex   APP刷新首页获取数据
    class func RefreshIndex(success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("RefreshIndex",
                                            parameters:NSDictionary(),
                                            success: {
                                                data in
                                                
                                                print(data)
                                                let tmpData=data["data"]
                                                let tmpUser=tmpData["user"]
                                                let user = User.cachedObjectWithID(tmpUser["userid"].stringValue)
                                                user.city=tmpUser["city"].stringValue
                                                user.country=tmpUser["country"].stringValue
                                                var tmpUrl=tmpUser["headimageurl"].stringValue
                                                if (tmpUrl != "")
                                                {
                                                    if (tmpUrl.containsString("http"))==false
                                                    {
                                                        tmpUrl=(NetworkManager.defaultManager?.website)!+tmpUrl
                                                    }
                                                    user.headimageurl=NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                }
                                                user.language=tmpUser["language"].stringValue
                                                user.mobile=tmpUser["mobile"].stringValue
                                                user.name=tmpUser["nickname"].stringValue
                                                user.openid=tmpUser["openid"].stringValue
                                                user.province=tmpUser["province"].stringValue
                                                user.scope=tmpUser["scope"].stringValue
                                                user.sex=tmpUser["sex"].stringValue
                                                
                                                user.score=tmpUser["score"].stringValue
                                                user.bdimgs=tmpUser["bdimgs"].stringValue
                                                user.bannerimgs=tmpUser["bannerimgs"].stringValue
                                                
                                                do{
                                                    user.realname = try? tmpData["realname"].rawData()
                                                    user.orderabout = try? tmpData["orderabout"].rawData()
                                                    user.groupdetails = try? tmpData["GroupDetails"].rawData()
                                                }
                                                success!(user)
            },
                                            failure: failure)
    }
    
    //GetPost/AppInterface/SubmitTime提交上门时间
    class func SubmitTime(paramDic: NSDictionary, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("SubmitTime",
                                            parameters:paramDic,
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //GetPost/AppInterface/GetHomeTimeList获取历史提交的上门时间
    class func GetHomeTimeList(orderid: String, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetHomeTimeList",
                                            parameters:[
                                                "orderid":orderid
            ],
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //GetPost/AppInterface/PartnerCommand组(合伙人)成员操作
    class func PartnerCommand(params:NSDictionary, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("PartnerCommand",
                                            parameters:params,
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //GetPost/AppInterface/UpgradeAuthority升级权限
    class func UpgradeAuthority(paramDic: NSDictionary, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("UpgradeAuthority",
                                            parameters:paramDic,
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    
    //GetPost/AppInterface/GetNowAuthorityDetail获取当前权限的信息或者审核进度，获取团队成员信息---弃用
    class func GetNowAuthorityDetail
        (success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetNowAuthorityDetail",
                                            parameters:nil,
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    
    //我的团队
    class func GetNowAuthorityDetailInfo
        (success: (([TeamMembers],[MyTeamModel]) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetNowAuthorityDetail",
                                            parameters:nil,
                                            success: {
                                                data in
                                                print(data)
                                                let tmpData = data["data"]
                                                let model = MyTeamModel.cachedObjectWithID(tmpData["id"].stringValue)
                                                var teamArr = Array<MyTeamModel>()
                                                var memberArr = Array<TeamMembers>()
                                                model.headimageurl = (tmpData["user"]["headimageurl"]).stringValue ?? ""
                                                model.groupName =  (tmpData["user"]["GroupDetails"]["GroupName"]).stringValue
                                                model.userself = tmpData["userself"]["userid"].stringValue ?? ""
                                                model.userselfNickname = tmpData["userself"]["nickname"].stringValue ?? ""
                                                
                                                let memArr = tmpData["members"].array
                                                for item in memArr! {
                                                    if model.userself == item["user"]["userid"].stringValue {
                                                        model.userselfCreateTime = item["JoinTime"].stringValue ??  ""
                                                    }
                                                }
                                                
                                                
                                                if let time = model.userselfCreateTime {
                                                    if time != "" {
                                                        let date = DateTool.dateFromServiceTimeStamp(time)
                                                        model.userselfCreateTime = DateTool.stringFromDate(date!, dateFormat: "YYYY-MM-dd")
                                                    }
                                                }
                                                model.userselfMemberState = tmpData["userself"]["GroupDetails"]["MemberState"].stringValue
                                                if let modelState = model.userselfMemberState{
                                                    switch(modelState)
                                                    {
                                                    case "70001":
                                                        model.userselfMemberState = "审核成功"
                                                        break
                                                    case "70000":
                                                        model.userselfMemberState = "审核中"
                                                    case "70002":
                                                        model.userselfMemberState = "审核失败"
                                                    case "70003":
                                                        model.userselfMemberState = "被封号了"
                                                    default:
                                                        break
                                                    }
                                                }
                                                
                                                model.groupNumber = (tmpData["user"]["GroupDetails"]["GroupNumber"]).stringValue
                                                model.province = (tmpData["user"]["GroupDetails"]["ServiceAreas"][0]["Province"]).stringValue
                                                model.nickname = (tmpData["user"]["nickname"]).stringValue
                                                model.createTime = (tmpData["groupinfo"]["CreateTime"]).stringValue
                                                model.suplevel1 = (tmpData["groupinfo"]["suplevel1"]).stringValue
                                                model.suplevel2 = (tmpData["groupinfo"]["suplevel2"]).stringValue
                                                model.suplevel3 = (tmpData["groupinfo"]["suplevel3"]).stringValue
                                                if let time = model.createTime {
                                                    if time != "" {
                                                        let date = DateTool.dateFromServiceTimeStamp(time)
                                                        model.createTime = DateTool.stringFromDate(date!, dateFormat: "YYYY-MM-dd")
                                                    }
                                                }
                                                model.memberState = (tmpData["user"]["GroupDetails"]["MemberState"]).stringValue      
                                                model.groupScopeName = tmpData["attibutes"][1]["scopename"].stringValue
                                                model.groupScoupValue = tmpData["attibutes"][1]["scopevalue"].stringValue
                                                model.scopename = tmpData["attibutes"][0]["scopename"].stringValue
                                                model.scopevalue = tmpData["attibutes"][0]["scopevalue"].stringValue
                                                if let modelState = model.memberState{
                                                    switch(modelState)
                                                    {
                                                    case "70001":
                                                        model.memberState = "审核成功"
                                                        break
                                                    case "70000":
                                                        model.memberState = "审核中"
                                                    case  "70002":
                                                        model.memberState = "审核失败"
                                                    case "70003":
                                                        model.memberState = "被封号了"
                                                    default:
                                                        break
                                                    }
                                                }
                                                //团队成员信息
                                                let memberData = tmpData["members"]
                                                let count = memberData.count
                                                for  num in 0..<count  {
                                                    let memModel = TeamMembers()
                                                    memModel.headimageurl = memberData[num]["user"]["headimageurl"].stringValue
                                                    memModel.mobile = memberData[num]["user"]["mobile"].stringValue
                                                    memModel.nickname = memberData[num]["user"]["nickname"].stringValue
                                                    memModel.province = memberData[num]["user"]["province"].stringValue
                                                    memModel.city = memberData[num]["user"]["city"].stringValue
                                                    memModel.MemberState  = memberData[num]["user"]["GroupDetails"]["MemberState"].stringValue
                                                    memModel.GroupNumber = memberData[num]["GroupNumber"].stringValue
                                                    memModel.Scope = memberData[num]["Scope"].stringValue
                                                    memModel.userid = memberData[num]["user"]["userid"].stringValue
                                                    if let stateMem = memModel.Scope {
                                                        switch (stateMem)
                                                        {
                                                        case "n-partner":
                                                            memModel.Scope = "一般合伙人"
                                                            break
                                                        case "l-engineer":
                                                            memModel.Scope = "联席工程师"
                                                            break
                                                        case "partner":
                                                            memModel.Scope = "首席合伙人"
                                                            break
                                                        default:
                                                            break
                                                        }
                                                    }
                                                    memberArr.append(memModel)   
                                                }
                                                teamArr.append(model)
                                                success!(memberArr,teamArr)
            },
                                            failure:{(error) in
                                                failure!(error)
        })
        
    }
    
    
    //GetPost/AppInterface/GetMyScoreDetails获取个人的所有评价
    class func GetMyScoreDetails (success: ((Evaluation,[ScoreDetail]) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetMyScoreDetails",
                                            parameters:nil,
                                            success: {
                                                data in
                                                print(data)
                                                let evaluation = Evaluation()
                                                var tmpData = data["data"]
                                                var tempEvaluation = tmpData["score"]
                                                evaluation.userid =   tempEvaluation["Userid"].stringValue
                                                evaluation.score = tempEvaluation["Score"].stringValue == "" ? "0" : tempEvaluation["Score"].stringValue
                                                evaluation.number = tempEvaluation["Number"].stringValue == "" ? "0" : tempEvaluation["Number"].stringValue
                                                
                                                let tmpScoreLists = tmpData["scorelist"].array
                                                var scoreLists = [ScoreDetail]()
                                                
                                                for tmpScoreList in tmpScoreLists!
                                                {
                                                    let scoreList = ScoreDetail.cachedObjectWithID(tmpScoreList["Id"].stringValue)
                                                    scoreList.orderId =  tmpScoreList["Orderid"].stringValue
                                                    scoreList.userid = tmpScoreList["Userid"].stringValue
                                                    scoreList.score = tmpScoreList["Score"].stringValue
                                                    scoreList.remark = tmpScoreList["Remark"].stringValue
                                                    scoreList.createTime = tmpScoreList["CreateTime"].stringValue
                                                    // =tmpData["headimageurl"].stringValue
                                                    var tmpUrl     = tmpScoreList["user"]["headimageurl"].stringValue
                                                    if (tmpUrl != "")
                                                    {
                                                        if (tmpUrl.containsString("http"))==false
                                                        {
                                                            tmpUrl=(NetworkManager.defaultManager?.website)!+tmpUrl
                                                        }
                                                        scoreList.headimageurl = tmpUrl //NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                    }
                                                    
                                                    //                                                    scoreList.headimageurl = tmpScoreList["user"]["headimageurl"].stringValue
                                                    scoreLists.append(scoreList)
                                                    
                                                }
                                                
                                                success!(evaluation,scoreLists)
            },
                                            failure: failure)
    }
    //GetPost/Command/GetOwenBindBlankCard获取所有我的绑定银行卡列表
    class func GetOwenBindBlankCard (success: (([BankModel]) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetOwenBindBlankCard",
                                            parameters:nil,
                                            success: {
                                                data in
                                                
                                                print("bbbbbbbbbbbbank:\(data)")
                                                
                                                let tmpData = data["data"].array
                                                
                                                var tmpArr = [BankModel]()
                                                
                                                for item in tmpData!{
                                                    
                                                    let bankModel = BankModel.cachedObjectWithID(item["id"].stringValue);
                                                    bankModel.bankName = item["UserName"].stringValue ?? ""//银行名称--这是暂时没有这个字段
                                                    bankModel.cardId = item["CardId"].stringValue ?? ""
                                                    bankModel.bindTime = item["BindTime"].stringValue ?? ""
                                                    bankModel.userName = item["UserName"].stringValue ?? ""
                                                    bankModel.cardPhone = item["CardPhone"].stringValue ?? ""
                                                    bankModel.bankType = item["BlankType"].stringValue ?? ""
                                                    tmpArr.append(bankModel)
                                                }
                                                
                                                
                                                
                                                success!(tmpArr)
            },
                                            failure: failure)
    }
    
    //GetPost/Command/BindNewBlankCard绑定银行卡
    class func BindNewBlankCard(paramDic: NSDictionary, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("BindNewBlankCard",
                                            parameters:paramDic,
                                            success: {
                                                data in
                                                print(data)
                                                success!()
            },
                                            failure: failure)
    }
    //GetPost/AppInterface/GetOwenMoney获取我的账户余额
    
    class func GetOwenMoney (success: ((MyAccount) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager!.POST("GetOwenMoney",
                                            parameters:nil,
                                            success: {
                                                data in
                                                
                                                // print("88888888:\(data)")
                                                
                                                let tmpData = data["data"]
                                                
                                                let myAccount = MyAccount.cachedObjectWithID(tmpData["id"].stringValue)
                                                myAccount.balance = tmpData["money"].stringValue ?? "0.00"
                                                myAccount.income = tmpData["IncomeMoney"].stringValue ?? "0.00"
                                                myAccount.totalAssets = tmpData["ExpenditureMoney"].stringValue ?? "0.00"
                                                success!(myAccount)
            },
                                            failure:{ (error) in
                                                failure!(error)
        })
        
    }
    
    
    //工程师提现提交信息/AppInterface/WithDraw
    class func submitInfoToGetMoney(paramDic: NSDictionary, success: (() -> Void)?, failure: ((NSError) -> Void)?){
        NetworkManager.defaultManager!.POST("WithDraw",
                                            parameters:paramDic,
                                            success: { data in
                                                
                                                success!()
            },
                                            failure:{ (error) in
                                                failure!(error)
        })
        
    }
    
    
    //GetPost/AppInterface/GetOwenMoneyDetails分页获取我的账户明细
    class func GetOwenMoneyDetails (index : Int,pagesize : Int,success: (([AccountDetailModel]) -> Void)?, failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager?.POST("GetOwenMoneyDetails", parameters: ["index":index ,"pagesize" :pagesize],
                                            success: { (data) in
                                                print(data)
                                                let tmpData = data["data"].array
                                                var tmpArr = Array<AccountDetailModel>()
                                                for item in tmpData! {
                                                    let model = AccountDetailModel.cachedObjectWithID(item["id"].stringValue)
                                                    model.payId = item["PayId"].stringValue
                                                    print(model.payId)
                                                    model.money = item["Money"].stringValue
                                                    model.createTime = item["CreateTime"].stringValue
                                                    if  let time = model.createTime{
                                                        if time != "" {
                                                            let date = DateTool.dateFromServiceTimeStamp(time)
                                                            model.createTime = DateTool.stringFromDate(date!, dateFormat: "MM-dd") + DateTool.dayOfweek(date!)
                                                        }
                                                    }
                                                    
                                                    tmpArr.append(model)
                                                }
                                                success!(tmpArr)
            }, failure:{ (error) in
                failure!(error)
        })
    }
    
    
    //删除团队相关的一切（用于解散团队/团队拒绝后重新申请前的操作）
    class func DeleteTeamAll(groupNumber: Int, success:(() -> Void)?,failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager?.POST("DeleteTeamAll", parameters: ["groupNumber": groupNumber], success: { (data) in
            
            print("解散团队成功" + "\(data)")
            success!()
            
            }, failure: { (error) in
                failure!(error)
        })
        
    }
    ///用户退出当前团队
    class func RemoveTeamMember(groupNumber: Int,success:(() -> Void)?,failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager?.POST("RemoveGroupMember", parameters: ["GroupNumber":groupNumber], success: { (data) in
            print("退出当前团队成功")
            success!()
            }, failure: { (error) in
                print(error)
                failure!(error)
        })
    }
    
    //审核当前团队成员
    class func AuditGroupMember(params: NSDictionary,success:(() -> Void)?,failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager?.POST("AuditGroupMember", parameters: params, success: { (data) in
            print("审核成功")
            success!()
            }, failure: { (error) in
                print(error)
                failure!(error)
        })
    }
    
    //移除团队成员
    class func RemoveCurrentTeamMember(groupNumber: Int,useid:Int,success:(() -> Void)?,failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager?.POST("RemoveGroupMember", parameters: ["GroupNumber":groupNumber,"userid": useid], success: { (data) in
            print("移除成员成功")
            success!()
            }, failure: { (error) in
                print(error)
                failure!(error)
        })
    }
    
    //获取我的团队成员
    class func GetMyGroupMembers(pagesize: Int,index:Int,success:(([TeamMembers]) -> Void)?,failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager?.POST("GetMyGroupMembers", parameters: ["pagesize":pagesize,"index": index], success: { (data) in
            print("获取团队成员成功")
            print(data)
            let tmpData = data["data"].array
            var memArr = Array<TeamMembers>()
            for item in tmpData!{
                let member = TeamMembers()
                
                member.headimageurl = item["User"]["headimageurl"].stringValue
                member.mobile = item["User"]["mobile"].stringValue
                member.nickname = item["User"]["nickname"].stringValue
                member.province = item["User"]["province"].stringValue
                member.city =  item["User"]["city"].stringValue
                //                member.MemberState = item["User"]["GroupDetails"]["MemberState"].stringValue
                member.Scope = item["Member"]["Scope"].stringValue
                member.userid = item["Member"]["UserId"].stringValue
                //记录当前成员是否已通过审核
                member.MemberState = item["Member"]["State"].stringValue
                member.GroupNumber = item["Member"]["GroupNumber"].stringValue
                if let stateMem = member.Scope {
                    switch (stateMem)
                    {
                    case "n-partner":
                        member.Scope = "一般合伙人"
                        break
                    case "l-engineer":
                        member.Scope = "联席工程师"
                        break
                    case "partner":
                        member.Scope = "首席合伙人"
                        break
                    default:
                        break
                    }
                }
                memArr.append(member)
            }
            
            success!(memArr)
            }, failure: { (error) in
                print(error)
                failure!(error)
        })
    }
    
    //
    //
    //
    //
    //
    //
    //
    //
    //    Get
    //    Post
    //    /Command/GetPriceTable获取浩泽产品信息
    
    class func GetPriceTable (index : Int,pagesize : Int,success: (([ProductInfo]) -> Void)?, failure: ((NSError) -> Void)?) {
        
        NetworkManager.defaultManager?.POST("GetPriceTable", parameters: ["index":index ,"pagesize" :pagesize],
                                            success: { (data) in
                                                var productinfos = [ProductInfo]()
                                                let tmpData = data["data"].array
                                                for item in tmpData!{
                                                    
                                                    let productinfo =  ProductInfo.cachedObjectWithID(item["id"].stringValue);
                                                    productinfo.id = item["id"].stringValue
                                                    
                                                    var tmpUrl  = item["pic"].stringValue
                                                    if (tmpUrl != "")//headimageurl
                                                    {
                                                        if (tmpUrl.containsString("http"))==false
                                                        {
                                                            tmpUrl=(NetworkManager.defaultManager?.website)!+tmpUrl
                                                        }
                                                        productinfo.image = tmpUrl //NSData(contentsOfURL: NSURL(string: tmpUrl)!)
                                                    }
                                                    else
                                                    {
                                                        productinfo.image = ""
                                                    }
                                                    
                                                    productinfo.price = item["price"].stringValue
                                                    productinfo.name = item["name"].stringValue
                                                    productinfos.append(productinfo)
                                                }
                                                print(data)
                                                success!(productinfos)
            }, failure: failure)
    }
    
    //GetPost/AppInterface/GetCurrentRealNameInfo获取当前的实名认证信息
    
    class func GetCurrentRealNameInfo(success:((String) -> Void)?,failure: ((NSError) -> Void)?) {
        NetworkManager.defaultManager?.POST("GetCurrentRealNameInfo", parameters: nil, success: { (data) in
            print(data["data"]["checkstate"].stringValue)
            success!(data["data"]["checkstate"].stringValue)
            }, failure: { (error) in
                print(error)
                failure!(error)
        })
    }
    //  /AppInterface/UploadRealnameAuthinfo   上传实名认证信息
    class func UploadRealnameAuthinfo(name:String,cardid:String,frontImg:NSData,backImg:NSData, success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        
        var constructingBlock:((AFMultipartFormData?) -> Void)?=nil
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let str = formatter.stringFromDate(NSDate())
        let fileName = NSString(format: "%@", str)
        constructingBlock={
            data in
            data!.appendPartWithFileData((frontImg), name: "cardfront", fileName: (fileName as String), mimeType: "image/png")
            data!.appendPartWithFileData((backImg), name: "cardbehind", fileName: (fileName as String)+"1", mimeType: "image/png")
            
        }
        NetworkManager.defaultManager!.request("UploadRealnameAuthinfo", GETParameters: nil, POSTParameters: ["name":name,"cardid":cardid], constructingBodyWithBlock: constructingBlock, success: {
            data in
            print(data)
            success!()
            }, failure: failure)
        
    }
}
