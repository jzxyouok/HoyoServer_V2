//
//  UseTimeCon.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 16/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
import SnapKit
var HOUR:String?
var MINUTE :String?
protocol UseTimeConDelegate {
    func showToSuperCon(hour:String,minute:String)
}
class UseTimeCon: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  
    var delegate : UseTimeConDelegate?
    
    let Done  = UIButton()
    let Cancel  = UIButton()
    let label = UILabel()
    let pickerView = UIPickerView()
    let back = UIView()
    var hour  = "1"
    var minute  = "1"
    var backView = UIView()
    let hoursArr = NSMutableArray()
    let minutesArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       for index in 1...24
    {
           hoursArr.addObject("\(index)")
    
        }
    
        for index in 1...60{
            
            minutesArr.addObject("\(index)")
        
        }

        self.view.frame = CGRectMake(40 , (HEIGHT_SCREEN - 300)/2, WIDTH_SCREEN-80,300)
    
     addToSubView()
//     addControl()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    //dissCall不等于nil，是从注册跳过来的，否则，从个人中心过来的
    convenience  init(hour :String,minute:String   ) {
        
        var nibNameOrNil = String?("UseTimeCon.swift")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        
        self.hour = hour
        
        self.minute = minute
    
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

    
    
    func addToSubView(){
        
        
        
        
        Done.setTitle("Done", forState: .Normal)
        Cancel.setTitle("Cancel", forState: .Normal)
        label.text = "请选择用时"
        
        Done.setTitleColor(UIColor.blackColor(), forState: .Normal)
        Cancel.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        pickerView.addSubview(Done)
        pickerView.addSubview(Cancel)
        
        backView.frame = self.view.bounds
        self.backView.backgroundColor = COLORRGBA(233, g: 233, b: 244, a: 1)
        pickerView.frame = CGRectMake(self.backView.frame.origin.x+1, self.backView.frame.origin.y+40, self.backView.frame.width-2, self.backView.frame.height-90)
        self.backView.addSubview(pickerView)
        self.view.addSubview(backView)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.backgroundColor = COLORRGBA(233, g: 233, b: 244, a: 1)
        self.pickerView.selectRow(Int((self.hour as NSString).stringByReplacingOccurrencesOfString(" ", withString: "") as String)!-1, inComponent: 0, animated: true)
        self.pickerView.selectRow(Int((self.minute as NSString).stringByReplacingOccurrencesOfString(" ", withString: "") as String)!-1, inComponent: 1, animated: true)
        
        //        self.view.sendSubviewToBack(backControl)
        self.view.sendSubviewToBack(backView)
        self.backView.addSubview(Done)
        self.backView.addSubview(Cancel)
        Done.snp_makeConstraints(closure: { [weak self ](make) in
            if let strongSelf = self{
                make.edges.equalTo((strongSelf.backView)).inset(UIEdgeInsetsMake(strongSelf.backView.frame.height-50, 20, 10  , strongSelf.backView.frame.width-60-30))
            }
            })
        
        Cancel.snp_makeConstraints(closure: { [weak self ](make) in
            if let strongSelf = self{
                make.edges.equalTo((strongSelf.backView)).inset(UIEdgeInsetsMake(strongSelf.backView.frame.height-50, strongSelf.backView.frame.width-60-30, 10, 20))
            }
            })
        
        
        Done.addTarget(self, action: #selector(UseTimeCon.done), forControlEvents: .TouchUpInside)
        Cancel.addTarget(self, action: #selector(UseTimeCon.cancel), forControlEvents: .TouchUpInside)
        
        view.addSubview(label)
        // label.frame.size.height = 40
        label.textAlignment = .Center
        label.snp_makeConstraints { (make) -> Void in
            //解释：box对象相对于父视图上边距为20像素
            make.top.equalTo(2)
            make.leading.equalTo(20)
            
            make.trailing.equalTo(-20)
            make.height.equalTo(40)
        }

    }

    func done(){
    
        
       HOUR = self.hour
        MINUTE = self.minute
        delegate?.showToSuperCon(self.hour, minute: minute)
    self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    func cancel(){
    
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //有几列
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    //各个列分别多少行
    func   pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
        return hoursArr.count
        }else{
        return minutesArr.count
        }
       
    }
    
    //显示的数据
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
        return hoursArr[row] as? String
        }
        else{
        return minutesArr[row] as? String
        }
    }
    
    //监听选中的某一列的某一行
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        if (component == 0) {
//            pickerView.reloadComponent(1)
//        
//            pickerView.selectRow(0, inComponent: 1, animated: true)
//        }
//        else
//        {
//            pickerView.reloadComponent(1)
//            
//            pickerView.selectRow(1, inComponent: 1, animated: true)
//        }
      let hourIndex  = pickerView.selectedRowInComponent(0)
        let hour = self.hoursArr[hourIndex]
        let minuteIndex = pickerView.selectedRowInComponent(1)
        let minute = minutesArr[minuteIndex]
       self.hour = hour as! String
        self.minute=minute as! String
        
        print(minute)
        print(hour)
    
    }
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.removeFromSuperview()
    }
}
