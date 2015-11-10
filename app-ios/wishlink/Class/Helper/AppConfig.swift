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
let KeyWindow = APPLICATION.keyWindow!

let SERVER_BASE_URL = "http://121.41.162.102"


func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor { return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }
func RGB(r:CGFloat, g:CGFloat, b:CGFloat)->UIColor { return RGBA(r, g: g, b: b, a: 1.0) }
func RGBCA(c:CGFloat, a:CGFloat) -> UIColor { return RGBA(c, g: c, b: c, a: a)}
func RGBC(c:CGFloat) -> UIColor { return RGBA(c, g: c, b: c, a: 1.0)}
func MainColor() -> UIColor { return RGB(124, g: 0, b: 90)}

let UIHEPLER = UIHelper();
let APPCONFIG =  AppConfig.sharedAppConfig;




class AppConfig: NSObject
{
    //服务端接口前缀
    let  SERVICE_ROOT_PATH =  SERVER_BASE_URL + "/services/"
    let NotificationActionPayResult="NotificationActionPayResult"

    //微信登录相关信息
    static var  wxAppKey:String = "wx7d2407c862aeda7b";
    static var  wxAppSecret:String = "8f4bb1d0bf4d71024b9d11825e80c771"
    //微博登陆相关信息
    static var  wbAppKey:String = "3764189536"
    static var  wbAppSecret:String = "36bdb49defb6765bce3b831c7e18fa86"
    static var  wbRedirectURI:String = "https://api.weibo.com/oauth2/default.html"
    // 融云AppKey
    static var  rcAppKey: String = "pvxdm17jxrm5r"
    
    /*微信支付相关信息*/
    let WX_Pay_APP_ID          = "wx7d2407c862aeda7b"
    let WX_Pay_APP_SECRET      = "8f4bb1d0bf4d71024b9d11825e80c771"
    //商户号，填写商户对应参数
    let WX_Pay_MCH_ID          = "1273718601"
    //商户API密钥，填写相应参数
    let WX_Pay_PARTNER_ID      = "1qaz2wsx3edc4rfv1234qwerasdfzxcv"
    //支付结果回调页面
    let WX_Pay_NOTIFY_URL      = SERVER_BASE_URL + "/wishlink-payment/wechat/callback"
    //获取服务器端支付数据地址（商户自定义）
    let WX_Pay_SP_URL          = "http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"
    
    
    /*支付宝相关参数*/
    let alipay_callback_url = SERVER_BASE_URL + "/wishlink-payment/alipay/callback";
    let alipay_partner = "2088021598577909"
    let alipay_seller = "ledsed@qq.com"
    
    
    //pkcs8
    let alipay_privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMwf59KHQGYH9aL1ViXhc28IfJ4ddbMiRwmcYnu3ZW6Vyu75EuJ66k+LCpjmVogQRGso5VdYV9HCvXIWmDXvMrvvaKmRSdm5jxkGiY9Y8RBYJYTpalti4beKmf2swcngxYqimxMdDaJ43IU4Vm4KwG7uIAOiP1W6PvWK994J85ULAgMBAAECgYBa1E+phHmJbT1GN/kPfhSJcbNSADXhcf0+L5I7Ds5ZuNnGIJrgoGUm4+3hP419mg93x4jVpv/c3NTDsX4lcbyWzF9hc0R7B9K5pdDJdS9quTwB9fuCnvh+AC5BWp0RAnrS4z74Va/qX61ZR8HljNLw4NsiFOdn6wEBo7qMMN9iwQJBAOo3gfwgDytkps+jSA+FH3+jJZAb6/IOhARl03/4LW8GWaSFReqJAzBk1fBLncgQxSyELR0PMQKua/NzuHP+prECQQDfG+39XX6Hy3MI7mVuvYeIVk+rouEwXPaYX4RtqEYDxUoLvu7HPfRQz0BGl5wlC6W4Tapho7JvL6baY7g1zN57AkB5z0yG95VsF/i5XE4J5E4xb4QFor/fL7VxJBQPJd9bMo5EhhuKkp9Z99dcFbeFaVNih4t+5XuzzUrPXou7p+DBAkAfo8hWXAHrpBCGPbiowbwMu6DEyG6C+0wFQ9Z17p0vP7VGgSc/niudoiaNXEbKgiJYRrtY6WwOlIVnBylCh/EtAkEApvb2fEks0lxOEbX9ZPPjM0sZtRrt+vyD/EqMvWOUCOjNyTG3RuSPJEOElspIhAeB2tgpKIN73z9aW9bmHJDCjQ=="
    
//     var alipay_privateKey = "MIICXAIBAAKBgQDMH+fSh0BmB/Wi9VYl4XNvCHyeHXWzIkcJnGJ7t2Vulcru+RLieupPiwqY5laIEERrKOVXWFfRwr1yFpg17zK772ipkUnZuY8ZBomPWPEQWCWE6WpbYuG3ipn9rMHJ4MWKopsTHQ2ieNyFOFZuCsBu7iADoj9Vuj71ivfeCfOVCwIDAQABAoGAWtRPqYR5iW09Rjf5D34UiXGzUgA14XH9Pi+SOw7OWbjZxiCa4KBlJuPt4T+NfZoPd8eI1ab/3NzUw7F+JXG8lsxfYXNEewfSuaXQyXUvark8AfX7gp74fgAuQVqdEQJ60uM++FWv6l+tWUfB5YzS8ODbIhTnZ+sBAaO6jDDfYsECQQDqN4H8IA8rZKbPo0gPhR9/oyWQG+vyDoQEZdN/+C1vBlmkhUXqiQMwZNXwS53IEMUshC0dDzECrmvzc7hz/qaxAkEA3xvt/V1+h8tzCO5lbr2HiFZPq6LhMFz2mF+EbahGA8VKC77uxz30UM9ARpecJQuluE2qYaOyby+m2mO4NczeewJAec9MhveVbBf4uVxOCeROMW+EBaK/3y+1cSQUDyXfWzKORIYbipKfWffXXBW3hWlTYoeLfuV7s81Kz16Lu6fgwQJAH6PIVlwB66QQhj24qMG8DLugxMhugvtMBUPWde6dLz+1RoEnP54rnaImjVxGyoIiWEa7WOlsDpSFZwcpQofxLQJBAKb29nxJLNJcThG1/WTz4zNLGbUa7fr8g/xKjL1jlAjozckxt0bkjyRDhJbKSIQHgdrYKSiDe98/WlvW5hyQwo0="
    
    var AccessToken:String!;
    var Uid = "";
    var cookieStr:String = "" {
        didSet {
            AccessToken = cookieStr
            save()
        }
    }
    var CurrentLoginName:String = ""
    
    var profileDetailDictionary:NSDictionary!;
    
    //验证码发送时间间隔
    var defaultWaitSecond = 60;
    //经纬度信息
    var Latitude:CGFloat = 0.0
    var Longitude:CGFloat = 0.0
    
    //默认语言
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
        let ud = NSUserDefaults.standardUserDefaults()
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
            self.Uid = ud.objectForKey("Configuration_CurrentUID") as! String;
        }
        else
        {
            self.Uid = "";
        }
        
        // add by yeo 2015.10.13 23:22
        if ud.objectForKey("Configuration_Cookie") != nil {
            self.cookieStr = ud.objectForKey("Configuration_Cookie") as! String
            UserModel.shared.isLogin = true
        }else {
            self.cookieStr = ""
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
        let ud = NSUserDefaults.standardUserDefaults()
        if(!self.AccessToken.isNullOrEmpty())
        {
            ud.setObject(self.AccessToken, forKey: "Configuration_Token")
        }
        else
        {
            ud.removeObjectForKey("Configuration_Token")
        }
        
        if (self.Uid != "" ) {
            ud.setObject(self.Uid, forKey: "Configuration_CurrentUID")
            // [ud setObject:[NSNumber numberWithInteger:self.CurrentUID] forKey:@"Configuration_CurrentUID"];
        }else {
            ud.removeObjectForKey("Configuration_CurrentUID")
        }
        
        // add by yeo 2015.10.13 23:19
        if self.cookieStr != "" {
            ud.setObject(self.cookieStr, forKey: "Configuration_Cookie")
        }else {
            ud.removeObjectForKey("Configuration_Cookie")
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
        self.Uid  = "";
        self.cookieStr = ""
        self.save();
        
        NSNotificationCenter.defaultCenter().postNotificationName("user-login-logout", object: nil, userInfo: nil)
    }
    
    func getAuthorizationString()->String
    {
        let strFullToken = String(format: "iPhone<>%@<>%f<>%f<>%d",AppConfig.sharedAppConfig.AccessToken,AppConfig.sharedAppConfig.Latitude,AppConfig.sharedAppConfig.Longitude,AppConfig.sharedAppConfig.languageVer.rawValue)
        return strFullToken
    }
    
    ///从缓存目录中读取图片信息
    func readImgFromCachePath(url:String)->UIImage!
    {
        var img:UIImage!
        
        if(url != "" && url.trim().length>0)
        {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//                
//                autoreleasepool({ () -> () in
//                    
            
                    let  encodeName = url.stringByReplacingOccurrencesOfString("/", withString: "_", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
                    //判断文件路径是否存在，不存在则创建
                    var imagepath:String = UIHEPLER.getCachedFilePath("cachedimages");
                    
                    let fm:NSFileManager = NSFileManager.defaultManager();
                    if(!fm.fileExistsAtPath(imagepath))
                    {
                        do {
                            try fm.createDirectoryAtPath(imagepath, withIntermediateDirectories: true, attributes: nil)
                        } catch _ {
                        }
                    }
                    //检测本读是否有该图片缓存
                    imagepath = imagepath+"/"+encodeName
                    if(fm.fileExistsAtPath(imagepath))
                    {
                        
                        let imageData:NSData!
                        do {
                            try imageData = NSData(contentsOfURL: NSURL(fileURLWithPath: imagepath), options: NSDataReadingOptions.DataReadingUncached)
                            let  image = UIImage(data: imageData!);
                            if (image != nil) {
//                                img = image;
                                return image;
                            }
                            
                        } catch {
                            // deal with error
                        }
                    }
                   
//                })
//            })
        }
        return img
//        return result;
    
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
