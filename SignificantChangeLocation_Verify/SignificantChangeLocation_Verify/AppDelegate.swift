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
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        self._registerSignificantChange();
        
        // Override point for customization after application launch.
        return true
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
    func _registerSignificantChange() {
        if(CLLocationManager.locationServicesEnabled()) {
            if (nil == locationManager) {
                locationManager = CLLocationManager();
                locationManager.delegate = self;
                locationManager.requestAlwaysAuthorization();
            }
            
            // This is also the hardest location type to test for since you can't use the simulator either.
            // I'm not sure if they have fixed it to work with the GPX files for 6.0,
            // but the significant location change api did not work at all in the simulator prior to iOS 6.
            locationManager.startMonitoringSignificantLocationChanges();
        }
    }
    
    //MARK: CoreLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        if (location.horizontalAccuracy > 0) {
            self._notify(location);
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    
    func _notify(location:CLLocation) {
        var strlocation = "latitude:" + String(location.coordinate.latitude.description)
        strlocation += " longitude:" + String(location.coordinate.longitude.description)

        var contentDic = [ "KEY" : "VALUE" ]
        var tipDate:NSDate = NSDate();
        
        self.locaNotifcationSchedule (chedulDate: tipDate , alertBody: "didUpdateLocations - " + strlocation, content: contentDic)
    }
}

