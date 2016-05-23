//
//  WeiXinURLViewController.swift
//  OZner
//
//  Created by test on 16/1/1.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
import MBProgressHUD

class WeiXinURLViewController: UIViewController,UIWebViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    private var URLString:String?
    private var tmpTitle:String?
    convenience  init(Url:String,Title:String) {
        
        var nibNameOrNil = String?("WeiXinURLViewController")
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
        {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        self.URLString=Url
        self.tmpTitle=Title
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    @IBAction func BackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet var titleOfURL: UILabel!
    @IBOutlet var webView: UIWebView!
    
    var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleOfURL.text=tmpTitle!
        
        //重新加载按钮
        button=UIButton(frame: CGRect(x: 0, y: HEIGHT_SCREEN/2-40, width: WIDTH_SCREEN, height: 40))
        button.addTarget(self, action: #selector(loadAgain), forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.setTitle("加载失败,点击继续加载！", forState: .Normal)
        button.hidden=true
        webView.addSubview(button)
        
        webView.delegate=self
        webView.scalesPageToFit = true
        webView.loadRequest(NSURLRequest(URL: NSURL(string: URLString!)!))
        
        // Do any additional setup after loading the view.
    }

    
    //继续加载
    func loadAgain(button:UIButton)
    {
        webView.loadRequest(NSURLRequest(URL: NSURL(string: URLString!)!))
        
    }
    func webViewDidStartLoad(webView: UIWebView) {
        button.hidden=true
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.performSelector(#selector(hideMbProgressHUD), withObject: nil, afterDelay: 3);
    }
    func hideMbProgressHUD()
    {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        button.hidden=true
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        button.hidden=false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
