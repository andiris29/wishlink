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

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        httpObj =  WebRequestHelper();
        self.navigationController?.navigationBar.hidden = true;
        
        if((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdge.None
            self.automaticallyAdjustsScrollViewInsets = false;
        }
    }
    
    
    
    func userLogOut(notification:NSNotification)
    {
        NSNotificationCenter.defaultCenter().postNotificationName(self.userStatusChangeKey, object: nil)
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

