//
//  AppDelegate.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate, WXApiDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        var vc = HomeVC(nibName: "HomeVC", bundle: NSBundle.mainBundle())

        self.window!.rootViewController = TabBarVC();
        self.window!.makeKeyAndVisible()
        self.prepareJPush(launchOptions)
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(AppConfig.wbAppKey)
        WXApi.registerApp(AppConfig.wxAppKey, withDescription: "wishlink")
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
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
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
        
        if IOS_VERSION >= 8 {
            //categories
            APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue, categories:nil)
        }else {
            //categories nil
            APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue, categories:nil)
        }
        APService.setupWithOption(launchOptions)
        
    }
}















