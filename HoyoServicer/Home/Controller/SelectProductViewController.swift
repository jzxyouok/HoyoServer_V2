//
//  SelectProductViewController.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 19/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import UIKit

import MBProgressHUD
import SVPullToRefresh
protocol SelectProductViewControllerDelegate {
    func selectedInfos(productInfo:[Int:[String]])
}
class SelectProductViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
var productInfos = [ProductInfo]()
    var productInfo = [ProductInfo]()
    var productInfo2 = [Int:[String]]()
    var delegate:SelectProductViewControllerDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem("back.png", selector: #selector(SelectProductViewController.doBack), isRight: false)
        self.setNavigationItem("确认", selector: #selector(SelectProductViewController.sure), isRight: true)
        self.title = "选择材料"
         self.collectionView!.registerNib(UINib(nibName:"SelectProductCollectionCellCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:"SelectProductCollectionCellCollectionViewCell")
            
     collectionView.dataSource = self
        collectionView.delegate = self
        
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarHidden = false
        
        self.addPullView()
        self.loadData()

        
        
       
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
    }
//确认并且返回
    func sure(){
    
    delegate?.selectedInfos(self.productInfo2)
    self.navigationController?.popViewControllerAnimated(true)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productInfos.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell =   collectionView.dequeueReusableCellWithReuseIdentifier("SelectProductCollectionCellCollectionViewCell", forIndexPath: indexPath) as! SelectProductCollectionCellCollectionViewCell
         cell.showCellText(productInfos[indexPath.row])
        cell.selectImage.image = UIImage(named: "")
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
                    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectProductCollectionCellCollectionViewCell
        
        if !cell.isSign {
               cell.selectImage.image = UIImage(named: "selected")
            cell.isSign = true
//            productInfo.append(productInfos[indexPath.row])
            productInfo2[indexPath.row] = ["\(productInfos[indexPath.row].name!)","\(productInfos[indexPath.row].price!)","\(productInfos[indexPath.row].id)","\(productInfos[indexPath.row].productCode)","\(productInfos[indexPath.row].productType)","\(productInfos[indexPath.row].company)"]
        }else{
               cell.selectImage.image = UIImage(named: "")
            cell.isSign = false
//              productInfo.removeAtIndex(indexPath.row)
            productInfo2.removeValueForKey(indexPath.row)
        }
//             if selectedTime != indexPath.row
//                    
//               {
//            cell.selectImage.image = UIImage(named: "selected")
//                
//                productInfo.append(productInfos[indexPath.row].name!)
//                
//               // print(productInfo.count)
//                print(indexPath.row)
//                    }
//            else{
//                
//                cell.selectImage.image = UIImage(named: "")
////                productInfo.removeAtIndex(indexPath.row-1)
////                print(productInfo.count)
//                print(indexPath.row)
//                    }
//                    
//                    
  //                  selectedTime = indexPath.row
    }
                
    
    //添加下拉刷新
    func addPullView(){
        
        collectionView.addPullToRefreshWithActionHandler {
            [weak self] in
            if let strongSelf = self{
                strongSelf.collectionView.userInteractionEnabled = false
                strongSelf.loadDataByPull()
            }
        }
        
    }

    
    func loadData(){
        MBProgressHUD.showHUDAddedTo(self.collectionView, animated: true)
        User.GetPriceTable(1, pagesize: 10, success: { [weak self]productinfos in
            if let strongSelf = self{
                 print(productinfos)
                MBProgressHUD.hideHUDForView(strongSelf.collectionView, animated: true)
                strongSelf.collectionView.userInteractionEnabled = true
//                strongSelf.orders = orders
                strongSelf.productInfos = productinfos
                print("成功.....-------")
               
                strongSelf.collectionView.reloadData()
            }}) { [weak self] (error) in
                if let strongSelf = self{
//                    strongSelf.orders = [Order]()
                    
                    //strongSelf.tableView.pullToRefreshView.stopAnimating()
                    self?.collectionView.userInteractionEnabled = true
                    MBProgressHUD.hideHUDForView(strongSelf.collectionView, animated: true)
                    strongSelf.collectionView.reloadData()
                    print(error.localizedDescription)
                }
        }
        
        
    }
    
    
    func loadDataByPull(){
        
        User.GetPriceTable(1, pagesize: 10, success: { [weak self]productinfos in
            if let strongSelf = self{
                
                
             
                
                strongSelf.collectionView.pullToRefreshView.stopAnimating()
                strongSelf.collectionView.userInteractionEnabled = true
                print("成功.....-------")
                strongSelf.productInfos = productinfos
                print(productinfos)
                self?.collectionView.reloadData()
            }}) { [weak self] (error) in
                
                if let strongSelf = self{
                 
                    self!.collectionView.pullToRefreshView.stopAnimating()
                    strongSelf.collectionView.userInteractionEnabled = true
                    strongSelf.collectionView.reloadData()
                    print(error.localizedDescription)
                }
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
