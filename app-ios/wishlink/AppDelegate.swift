//
//  AppDelegate.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit
import MapKit;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate, WXApiDelegate,CLLocationManagerDelegate,WebRequestDelegate {

    var window: UIWindow?
    var httpObj = WebRequestHelper();
    var locationManager:CLLocationManager! = nil;
    var backgroundUpdateTask:UIBackgroundTaskIdentifier!;
    
    let NotificationCategoryIdent  = "ACTIONABLE";
    let NotificationActionOneIdent = "ACTION_ONE";
    let NotificationActionTwoIdent = "ACTION_TWO";
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        var vc = HomeVC(nibName: "HomeVC", bundle: NSBundle.mainBundle())
        self.httpObj.mydelegate = self;
        //通知授权
        //通知授权

        
        self.window!.rootViewController = TabBarVC();
        self.window!.makeKeyAndVisible()
        self.prepareJPush(launchOptions)
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(AppConfig.wbAppKey)
        WXApi.registerApp(AppConfig.wxAppKey, withDescription: "wishlink")
        RCIM.sharedRCIM().initWithAppKey(AppConfig.rcAppKey);
        
        
        if #available(iOS 8.0, *) {
            if UIApplication.sharedApplication().currentUserNotificationSettings()!.types == UIUserNotificationType.None
            {
                UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil));
                UIApplication.sharedApplication().registerForRemoteNotifications();
            }
        } else {
            // Fallback on earlier versions
        }
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        self._registerSignificantChange();

        return true
    }

    // MARK: --WeiBo delegate--
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }
    
    
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        if response is WBAuthorizeResponse {
            NSNotificationCenter.defaultCenter().postNotificationName(WBLoginSuccessNotification, object: response)
        }
    }
    // MARK: --WeiXin delegate--
    func onReq(req: BaseReq!) {
        
    }
    
    func onResp(resp: BaseResp!) {
        if resp is SendAuthResp {
            NSNotificationCenter.defaultCenter().postNotificationName(WXLoginSuccessNotification, object: resp)

        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self) || WeiboSDK.handleOpenURL(url, delegate: self)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        APService.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        APService.handleRemoteNotification(userInfo)
    }
    
    func prepareJPush(launchOptions: [NSObject: AnyObject]?) {
        
//        if IOS_VERSION >= 8 {
            //categories
            if #available(iOS 8.0, *) {
                APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue, categories:nil)
            } else {
                 if #available(iOS 8.0, *) {
                     APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue, categories:nil)
                 } else {
                     // Fallback on earlier versions
                 }
                // Fallback on earlier versions
            }
//        }else {
//            //categories nil
//            APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue, categories:nil)
//        }
        APService.setupWithOption(launchOptions)
        
    }
    
    
    
//    //MARk:接受本地通知处理:
//    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
//        
//        let alertView = UIAlertView(title: " 系统本地通知 " , message: notification.alertBody , delegate: nil , cancelButtonTitle: " 返回 " )
//        
//        alertView.show ()
//        
//    }
//    
//    // 注册本地通知
//    func locaNotifcationSchedule(chedulDate chedulDate: NSDate ,alertBody: String ,content: NSDictionary ) {
//        
//        let localNotif = UILocalNotification ()
//        localNotif.fireDate = chedulDate
//        localNotif.timeZone = NSTimeZone . defaultTimeZone ()
//        localNotif.soundName = UILocalNotificationDefaultSoundName;
//        localNotif.alertBody = alertBody;
//        localNotif.userInfo  = content as [NSObject : AnyObject];
//        UIApplication.sharedApplication ().scheduleLocalNotification(localNotif)
//        
//    }
    
    //启动位置改变通知服务
    func _registerSignificantChange() {
        if(CLLocationManager.locationServicesEnabled()) {
            if (nil == locationManager) {
                locationManager = CLLocationManager();
                locationManager.delegate = self;
                if #available(iOS 8.0, *) {
                    locationManager.requestAlwaysAuthorization()
                } else {
                    // Fallback on earlier versions
                };
            }
            
            // This is also the hardest location type to test for since you can't use the simulator either.
            // I'm not sure if they have fixed it to work with the GPX files for 6.0,
            // but the significant location change api did not work at all in the simulator prior to iOS 6.
            locationManager.startMonitoringSignificantLocationChanges();
        }
    }
    
    //MARK: CoreLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count-1] 
        if (location.horizontalAccuracy > 0) {
            self._notify(location);
        }
    }

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog(error.description)
    }
    
    
    var lastLocation:CLLocation!
    func _notify(location:CLLocation) {
        var strlocation = "latitude:" + String(location.coordinate.latitude.description)
        strlocation += " longitude:" + String(location.coordinate.longitude.description)
        NSLog("Location change:%@",location)
        
        
        lastLocation = location;
        self.performSelector(Selector("postLocation"), withObject: nil, afterDelay: 1)
        
//        //发送本地通知
//        let contentDic = [ "KEY" : "VALUE" ]
//        let tipDate:NSDate = NSDate();
//        self.locaNotifcationSchedule (chedulDate: tipDate , alertBody: "didUpdateLocations - " + strlocation, content: contentDic)
    }
    
    func postLocation()
    {
        let para = ["device":UIDevice.currentDevice().identifierForVendor!.UUIDString as String,
            "location":[
                "lat":lastLocation.coordinate.latitude,
                "lng":lastLocation.coordinate.longitude]
        ];
        
        self.httpObj.httpPostApi("geo/trace", parameters: para as! [String : AnyObject], tag: 0);

        
    }
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        
        NSLog("post geo/trace Success!")
        
    }
    func requestDataFailed(error: String) {
        NSLog("post geo/trace fail:%@",error)

    }

}















