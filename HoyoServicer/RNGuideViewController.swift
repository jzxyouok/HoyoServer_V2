//
//  RNGuideViewController.swift
//  HoyoServicer
//
//  Created by 婉卿容若 on 16/5/10.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

typealias GuideClosure = () -> Void

class RNGuideViewController: UIViewController {
    
    var collectionView: UICollectionView?
    private var imageNames = ["guide_00","guide_01","guide_02","guide_03"]
    private let cellIdentifier = "collectionCell"
    private var isHiddenNextButton = true
    private var pageControl = UIPageControl(frame: CGRectMake(0,HEIGHT_SCREEN-50,WIDTH_SCREEN,20))
    
    internal var skipClosure: GuideClosure?
    
    func initWithSkipClosure(closure: GuideClosure) -> Void{
        skipClosure = closure
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = COLORRGBA(239, g: 239, b: 239, a: 1)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)

        setupCollectionView()
        setupPageControl()
        //你在台上唱着我的创作
        
    }
    
    // MARK: About UI
    
    private func setupCollectionView() -> Void{
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = MainScreenBounds.size
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView = UICollectionView(frame: MainScreenBounds, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.registerClass(GuideCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.addSubview(collectionView!)
        
    }
    
    private func setupPageControl() -> Void{
        pageControl.numberOfPages = imageNames.count
        pageControl.currentPage = 0
        view.addSubview(pageControl)
    }

   
}


// MARK: - UICollectionViewDelegate && UICollectionViewDataSource

extension RNGuideViewController: UICollectionViewDelegate,UICollectionViewDataSource{
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! GuideCell
        cell.newImage = UIImage(named: imageNames[indexPath.row])
        if indexPath.row != imageNames.count - 1 {
            cell.setNextButtonHidden(true)
        }
        
        weak var weakSelf = self
        cell.cellClosure = {
            
            if weakSelf?.skipClosure != nil {
                weakSelf?.skipClosure!()
            }
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == WIDTH_SCREEN * CGFloat(imageNames.count - 1) {
            let cell = collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: imageNames.count - 1, inSection: 0)) as! GuideCell
            cell.setNextButtonHidden(false)
            isHiddenNextButton = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x != WIDTH_SCREEN * CGFloat(imageNames.count - 1) && !isHiddenNextButton && scrollView.contentOffset.x > WIDTH_SCREEN * CGFloat(imageNames.count - 2) {
            let cell = collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: imageNames.count - 1, inSection: 0)) as! GuideCell
            cell.setNextButtonHidden(true)
            isHiddenNextButton = true
        }
        
        pageControl.currentPage = Int(scrollView.contentOffset.x / WIDTH_SCREEN + 0.5)
    }

}
