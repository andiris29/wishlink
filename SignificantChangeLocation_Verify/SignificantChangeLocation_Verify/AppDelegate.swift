//
//  AppDelegate.swift
//  SignificantChangeLocation_Verify
//
//  Created by Andy Chen on 8/1/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit
import MapKit;
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    
    
    var locationManager:CLLocationManager! = nil;
    var backgroundUpdateTask:UIBackgroundTaskIdentifier!;
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //通知授权
        if UIApplication.sharedApplication().currentUserNotificationSettings().types == UIUserNotificationType.None
        {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil));
            UIApplication.sharedApplication().registerForRemoteNotifications();
        }
        

        self.getLocationAndNotifcation("Start");
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
         self.getLocationAndNotifcation("performFetch");
        
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        NSLog("applicationDidEnterBackground")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.beginBackgroundUpdateTask();
            self.getLocationAndNotifcation("Background");
        })
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
    
    //接受本地通知处理:
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        var alertView = UIAlertView(title: " 系统本地通知 " , message: notification.alertBody , delegate: nil , cancelButtonTitle: " 返回 " )
        
        alertView.show ()

    }
    
    // 注册本地通知
    func locaNotifcationSchedule(#chedulDate: NSDate ,alertBody: String ,content: NSDictionary ) {
        
        var localNotif = UILocalNotification ()
        localNotif.fireDate = chedulDate
        localNotif.timeZone = NSTimeZone . defaultTimeZone ()
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.alertBody = alertBody;
        localNotif.userInfo  = content as [NSObject : AnyObject];
        UIApplication.sharedApplication ().scheduleLocalNotification(localNotif)
        
    }
    
    //启动位置改变通知服务
    func startSignificantChangeUpdates()
    {
        if(CLLocationManager.locationServicesEnabled())
        {
            if (nil == locationManager)
            {
                locationManager = CLLocationManager()
            }
            locationManager.delegate = self;
            locationManager.requestWhenInUseAuthorization();
            locationManager.requestAlwaysAuthorization();
            
            locationManager.startMonitoringSignificantLocationChanges();
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = 1;
        }
    }


    //MARK: CoreLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
       

        var location:CLLocation = locations[locations.count-1] as! CLLocation
        println("get location:%.2f",location.horizontalAccuracy)
        if (location.horizontalAccuracy > 1) {
            self.getLocationAndNotifcation("didUpdateLocations");
        }
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
         self.getLocationAndNotifcation("didFailWithError");
        println(error)
    }

    //MARK:BackgroundTask
    func beginBackgroundUpdateTask()
    {
        self.backgroundUpdateTask =  UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            
            self.getLocationAndNotifcation("beginBackgroundUpdateTask");
            self.endBackgroundUpdateTask();
        })
        
    }
    func endBackgroundUpdateTask()
    {
        UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask);
        self.backgroundUpdateTask = UIBackgroundTaskInvalid;
    }
    

    func getLocationAndNotifcation(strFrom:String)
    {
        NSLog(strFrom);
        if(strFrom == "Start" ||  strFrom == "Background")
        {
            self.startSignificantChangeUpdates();
            self.locationManager.startUpdatingLocation();
        }
        
        if( self.locationManager.location != nil)
        {
          
            var strlocation = "latitude:" + String(self.locationManager.location.coordinate.latitude.description)
            strlocation += " longitude:" + String(self.locationManager.location.coordinate.longitude.description)
            NSLog(strlocation);
            var contentDic = [ "KEY" : "VALUE" ]
            var tipDate:NSDate = NSDate();
            NSLog(tipDate.description);
            
            
            self.locaNotifcationSchedule (chedulDate: tipDate , alertBody: "通知来源：" + strFrom + " 经纬度 :  "+strlocation , content: contentDic)
            
        }
        

        
    }
    

    
    

}

