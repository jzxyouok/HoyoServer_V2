//
//  HomeTableViewCell.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/28.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit
@objc protocol CirCleViewDelegate {
    /**
     *  点击banner图片的代理方法
     *  @para  currentIndxe 当前点击图片的下标
     */
    optional func clickCurrentImage(currentIndxe: Int)
}
class HomeTableViewCell: UITableViewCell,UIScrollViewDelegate {

    var buttonClickCallBack:((whichButton:Int)->Void)?
    @IBAction func buttonClick(sender: UIButton) {
        if buttonClickCallBack==nil{
            return
        }
        buttonClickCallBack!(whichButton: sender.tag)
    }
    @IBOutlet weak var personImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //banner
    @IBOutlet weak var footerScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        personImg.layer.cornerRadius=personImg.frame.width/2
                // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        self.setUpCircleView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    //footer banner视图
    
    let TimeInterval = 2.5          //全局的时间间隔
    var imageArray: [UIImage!]!=[UIImage(named: "banner1"),UIImage(named: "banner2"),UIImage(named: "banner3")] {
        //监听图片数组的变化，如果有变化立即刷新轮转图中显示的图片
        willSet(newValue) {
            self.imageArray = newValue
        }
        didSet {
            self.setScrollViewOfImage()
        
        }
    }
    var urlImageArray: [String]? {
        willSet(newValue) {
            self.urlImageArray = newValue
        }
        
        didSet {
            //这里用了强制拆包，所以不要把urlImageArray设为nil
            for urlStr in self.urlImageArray! {
                let urlImage = NSURL(string: urlStr)
                if urlImage == nil { break }
                let dataImage = NSData(contentsOfURL: urlImage!)
                if dataImage == nil { break }
                let tempImage = UIImage(data: dataImage!)
                if tempImage == nil { break }
                imageArray.append(tempImage)
            }
        }
    }
    
    var delegate: CirCleViewDelegate?
    
    var indexOfCurrentImage: Int!  {                // 当前显示的第几张图片
        //监听显示的第几张图片，来更新分页指示器
        didSet {
            pageControll.currentPage = indexOfCurrentImage
        }
    }
    
    private var currentImageView:   UIImageView!
    private var lastImageView:      UIImageView!
    private var nextImageView:      UIImageView!
    
   
    
    private var timer:              NSTimer?                //计时器
    
    
    /********************************** Privite Methods ***************************************/
    //MARK:- Privite Methods
    private func setUpCircleView() {
        
        footerScrollView.contentSize = CGSizeMake(WIDTH_SCREEN * 3, 0)
        footerScrollView.delegate = self
  

        self.currentImageView = UIImageView()
        currentImageView.frame = CGRectMake(WIDTH_SCREEN, 0, WIDTH_SCREEN, footerScrollView.frame.height)
        currentImageView.userInteractionEnabled = true
        currentImageView.contentMode = UIViewContentMode.ScaleAspectFill
        currentImageView.clipsToBounds = true
        footerScrollView.addSubview(currentImageView)
        
        //添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapAction))
        currentImageView.addGestureRecognizer(imageTap)
        
        self.lastImageView = UIImageView()
        lastImageView.frame = CGRectMake(0, 0, WIDTH_SCREEN, footerScrollView.frame.height)
        lastImageView.contentMode = UIViewContentMode.ScaleAspectFill
        lastImageView.clipsToBounds = true
        footerScrollView.addSubview(lastImageView)
        
        self.nextImageView = UIImageView()
        nextImageView.frame = CGRectMake(WIDTH_SCREEN * 2, 0, WIDTH_SCREEN, footerScrollView.frame.height)
        nextImageView.contentMode = UIViewContentMode.ScaleAspectFill
        nextImageView.clipsToBounds = true
        footerScrollView.addSubview(nextImageView)
        
        self.setScrollViewOfImage()
        footerScrollView.setContentOffset(CGPointMake(WIDTH_SCREEN, 0), animated: false)
        
        //设置计时器
        self.timer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    //MARK: 设置图片
    private func setScrollViewOfImage(){
        self.currentImageView.image = self.imageArray[self.indexOfCurrentImage]
        self.nextImageView.image = self.imageArray[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
        self.lastImageView.image = self.imageArray[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
    }
    
    // 得到上一张图片的下标
    private func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            return self.imageArray.count - 1
        }else{
            return tempIndex
        }
    }
    
    // 得到下一张图片的下标
    private func getNextImageIndex(indexOfCurrentImage index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < self.imageArray.count ? tempIndex : 0
    }
    
    //事件触发方法
    func timerAction() {
 
        footerScrollView.setContentOffset(CGPointMake(WIDTH_SCREEN*2, 0), animated: true)
    }
    
    
    /********************************** Public Methods  ***************************************/
    //MARK:- Public Methods
    func imageTapAction(tap: UITapGestureRecognizer){
        self.delegate?.clickCurrentImage!(indexOfCurrentImage)
    }
    
    
    /********************************** Delegate Methods ***************************************/
    //MARK:- Delegate Methods
    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果用户手动拖动到了一个整数页的位置就不会发生滑动了 所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }else if offset == WIDTH_SCREEN * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPointMake(WIDTH_SCREEN, 0), animated: false)
        
        //重置计时器
        if timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    //时间触发器 设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(footerScrollView)
    }


}
