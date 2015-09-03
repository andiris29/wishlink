//
//  AppConfig.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//



import Foundation
import UIKit
enum LanguageVersion:Int
{
    case EN_US = 0,
    ZH_CN=1,
    SPANISH=2
}




let CURR_DEVICE = UIDevice.currentDevice()
//常用系统函数简写


//常用系统函数简写
let IOS_VERSION = (UIDevice.currentDevice().systemVersion as NSString).intValue;
let NotificationCenter = NSNotificationCenter.defaultCenter()
let UserDefaults = NSUserDefaults.standardUserDefaults();
let APPLICATION = UIApplication.sharedApplication()
let MainBundle = NSBundle.mainBundle();
let ScreenWidth = UIScreen.mainScreen().bounds.width
let ScreenHeight = UIScreen.mainScreen().bounds.height


func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor { return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }
func RGB(r:CGFloat, g:CGFloat, b:CGFloat)->UIColor { return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1) }

let UIHEPLER = UIHelper();
let APPCONFIG =  AppConfig.sharedAppConfig;




class AppConfig: NSObject
{
    static var  mapAPIKey:String = "64cb7cd4d44935d006e8d30d5684021a";
    static var  wxAppKey:String = "64cb7cd4d44935d006e8d30d5684021a";
    
    var AccessToken:String!;
    var CurrentUID:Int = 0;
    var CurrentLoginName:String = ""
    
    var profileDetailDictionary:NSDictionary!;
    
    var Latitude:CGFloat = 0.0
    var Longitude:CGFloat = 0.0
    var languageVer = LanguageVersion.ZH_CN
    
    class var sharedAppConfig : AppConfig {
        struct Static {
            static var instance : AppConfig?
            static var token : dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = AppConfig()
        }
        return Static.instance!
    }
    
    override init()
    {
        super.init();
        self.load()
    }
    func load()
    {
        var ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("Configuration_Token") != nil)
        {
            self.AccessToken = ud.objectForKey("Configuration_Token") as! String;
        }
        else
        {
            self.AccessToken = "";
        }
        if(ud.objectForKey("Configuration_CurrentUID") != nil)
        {
            self.CurrentUID = ud.objectForKey("Configuration_CurrentUID") as! Int;
        }
        else
        {
            self.CurrentUID = 0;
        }
        if(ud.objectForKey("Configuration_CurrentLoginName") != nil)
        {
            self.CurrentLoginName = ud.objectForKey("Configuration_CurrentLoginName") as! String;
        }
        else
        {
            self.CurrentLoginName = "";
        }
    }
    func save()->Bool
    {
        var ud = NSUserDefaults.standardUserDefaults()
        if(!self.AccessToken.isNullOrEmpty())
        {
            ud.setObject(self.AccessToken, forKey: "Configuration_Token")
        }
        else
        {
            ud.removeObjectForKey("Configuration_Token")
        }
        
        if (self.CurrentUID > 0) {
            ud.setObject(self.CurrentUID, forKey: "Configuration_CurrentUID")
            // [ud setObject:[NSNumber numberWithInteger:self.CurrentUID] forKey:@"Configuration_CurrentUID"];
        }else {
            ud.removeObjectForKey("Configuration_CurrentUID")
        }
        
        if(!self.CurrentLoginName.isNullOrEmpty())
        {
            ud.setObject(self.CurrentLoginName, forKey: "Configuration_CurrentLoginName")
        }
        else
        {
            ud.removeObjectForKey("Configuration_CurrentLoginName")
        }
        return true;
    }
    
    func isUserLogin()->Bool
    {
        return (!self.AccessToken.isNullOrEmpty());
    }
    
    func userLogout()
    {
        self.AccessToken = "";
        self.CurrentUID  = 0;
        self.save();
        
        NSNotificationCenter.defaultCenter().postNotificationName("user-login-logout", object: nil, userInfo: nil)
    }
    
    func getAuthorizationString()->String
    {
        var strFullToken = String(format: "iPhone<>%@<>%f<>%f<>%d",AppConfig.sharedAppConfig.AccessToken,AppConfig.sharedAppConfig.Latitude,AppConfig.sharedAppConfig.Longitude,AppConfig.sharedAppConfig.languageVer.rawValue)
        return strFullToken
    }
    
    //给btn假圆角
    func buildButtonFilletStyleWithRadius(btn:UIButton,borderColor:UIColor,titleColor:UIColor,radius:CGFloat)
    {
        btn.layer.cornerRadius = radius;
        btn.layer.masksToBounds=true
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = borderColor.CGColor;
        btn.setTitleColor(titleColor, forState: UIControlState.Normal)
        
    }

    
    
}
