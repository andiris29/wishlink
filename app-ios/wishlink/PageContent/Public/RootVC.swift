//
//  RootVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit
/*所有ViewController的父类，里面放一些全局类的变量活着方法*/
class RootVC: UIViewController {

    var userStatusChangeKey = "login-status-changed"
    var userLogOutKey = "user-login-logout"
    var httpObj:WebRequestHelper!
    var dataArr:[AnyObject]! = []

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        httpObj =  WebRequestHelper();

        
        if((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdge.None
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func userLogOut(notification:NSNotification)
    {
        NSNotificationCenter.defaultCenter().postNotificationName(self.userStatusChangeKey, object: nil)
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: reDesign Navigation
    func loadComNavTitle(strTitle:String)
    {
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 40, 30))
        titleLabel.text = strTitle
        titleLabel.textColor = UIHEPLER.mainColor;
        titleLabel.font = UIHEPLER.mainChineseFont15;
        titleLabel.textAlignment = NSTextAlignment.Center
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBarHidden = false;
    }
    
    func loadSpecNaviLeftBtn(imNormal:String,imgHighLight:String,_selecotr:Selector)
    {
        let leftBtn : UIButton = UIButton(frame: CGRectMake(0, 0, 32, 32));
        leftBtn.setImage(UIImage(named: imNormal), forState: UIControlState.Normal)
        leftBtn.setImage(UIImage(named: imgHighLight), forState: UIControlState.Highlighted)
        leftBtn.backgroundColor = UIColor.clearColor();
        leftBtn.addTarget(self, action: _selecotr, forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem : UIBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    

    
    
    
    func loadComNaviLeftBtn()
    {   
        self.loadSpecNaviLeftBtn("u02-back", imgHighLight: "u02-back-w", _selecotr: "leftNavBtnAction:");
    }
    
    func leftNavBtnAction(button: UIButton){
        
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func syncUserInfo(notification:NSNotification)
    {
        if(AppConfig.sharedAppConfig.isUserLogin())
        {
            //同步用户信息
//            AppConfig.sharedAppConfig.syncUserInfo();
        }
    }
}

