//
//  UIhelper.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import Foundation
import UIKit


//设备枚举
enum DeviceEnum{
    case iPnone6
    case iPnone6P
    case iPnone5
    case iPnone4S
    case iElse
}

class UIHelper {
    
    let Iphone4SHeight :CGFloat = 480.0;
    let Iphone5Height:CGFloat = 568.0;
    let Iphone6Height:CGFloat = 667.0;
    let Iphone6PHeight:CGFloat = 736.0;
    
    //系统主色调{大部分字体颜色 }
     var mainColor:UIColor = UIColor(red: 124/255.0, green: 0/255.0, blue: 90.0/255.0, alpha: 1)
    
    // 列表背景色
     var listBgColor:UIColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    var mainChineseFont15:UIFont = UIFont(name: "FZLanTingHeiS-EL-GB", size: 15)!;
    /*
    获取自定义字体
    */
    func getCustomFont(isChinese:Bool,fontSsize:CGFloat)->UIFont
    {
        return isChinese ? UIFont(name: "FZLanTingHeiS-EL-GB", size: fontSsize)! : UIFont(name: "HelveticaInserat-Roman-SemiBold", size: fontSsize)!
    }
    
    /*
    将图片转换成64位编码
    */
     func imageToBase64(image:UIImage )->String {
        let imageData:NSData = UIImageJPEGRepresentation(image, 1)!
        return imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
    }
    func GetAppDelegate()->AppDelegate
    {
        return APPLICATION.delegate as! AppDelegate
    }

    /*
    获取缓存路径
    */
     func getCachedFilePath(relative:String)->String!
    {
        var strResult = "";
        let paths:NSArray=NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let root:String = paths.count>0 ? paths.objectAtIndex(0) as! String:"undefined";
        strResult = root + "/" + relative
        return strResult
        
    }
    /*
    根据图片名称在bundle中搜索该图片
    */
     func getBundledImage(name:String)->UIImage
    {
        
        let strResure =  NSBundle.mainBundle().pathForResource(name, ofType: nil)
        return UIImage(contentsOfFile:strResure!)!
        //    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    }
    
    /*给View增加圆角*/
    func buildUIViewWithRadius(target:UIView, radius:CGFloat,borderColor:UIColor,borderWidth:CGFloat)
    {
        target.layer.cornerRadius = radius;
        target.layer.masksToBounds = true
        target.layer.borderWidth = CGFloat(borderWidth);
        target.layer.borderColor = borderColor.CGColor;
    }

    
    //MARK: 设置Label的行间距
    func setLabelLineSpan(label:UILabel, lineSpacing:CGFloat)
    {
        let attributedString = NSMutableAttributedString(string: label.text!);
        let paragraphStyle = NSMutableParagraphStyle();
        paragraphStyle.lineSpacing = lineSpacing;
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, label.text!.length))
        
        label.attributedText = attributedString;
    }
    
    //给btn加圆角
    func buildButtonFilletStyleWithRadius(btn:UIButton,borderColor:UIColor,titleColor:UIColor,radius:CGFloat)
    {
//        btn.layer.cornerRadius = radius;
//        btn.layer.masksToBounds=true
//        btn.layer.borderWidth = 1;
//        btn.layer.borderColor = borderColor.CGColor;
        
        
        self.buildUIViewWithRadius(btn , radius: radius, borderColor: borderColor, borderWidth: 1)
        
        btn.setTitleColor(titleColor, forState: UIControlState.Normal)
        
    }
    //给Image加圆角
    func buildImageViewWithRadius(image:UIImageView,borderColor:UIColor,borderWidth:CGFloat)
    {
//        image.layer.cornerRadius = image.frame.width/2;
//        image.layer.masksToBounds=true
//        image.layer.borderWidth = CGFloat(borderWidth);
//        image.layer.borderColor = mainColor.CGColor;
        
        self.buildUIViewWithRadius(image , radius: image.frame.width/2, borderColor: borderColor, borderWidth: borderWidth)
    }
    func GetDeviceModel()->DeviceEnum
    {
        var result = DeviceEnum.iElse;
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone)
        {
            let maxLenght = max(ScreenWidth,ScreenHeight)
            if(maxLenght == 568.0)
            {
                result = DeviceEnum.iPnone5;
            }
            else  if(maxLenght == 667.0)
            {
                result = DeviceEnum.iPnone6;
            }
            else  if(maxLenght == 736.0)
            {
                result = DeviceEnum.iPnone6P;
            }
        }
        
        return result;
    }
    
    //等比缩放高度:以6尺寸为基本尺寸
    func resizeHeight(orginHeightInIphone6:CGFloat)->CGFloat
    {
        let deviceType = GetDeviceModel()
        var height = orginHeightInIphone6
        if(deviceType == DeviceEnum.iPnone5)
        {
            height = height/self.Iphone6Height * self.Iphone5Height;
        }
        else if(deviceType == DeviceEnum.iPnone6P)
        {
            height = height/self.Iphone6Height * self.Iphone6PHeight;
        }
        else if(deviceType == DeviceEnum.iPnone4S)
        {
            height = height/self.Iphone6Height * self.Iphone4SHeight;
        }
        let newHeigt:Int = Int(height)
        return CGFloat(newHeigt);
    }
    
    //读取本地图片
    func readImageFromLocalByName(imgName:String)->(img:UIImage,path:String)
    {
        var strName = "tempEdit.png"
        if(imgName.length>0)
        {
            strName = imgName
        }
        
        strName = "/" + strName;
        var docs=NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let filePath:String =  docs[0].stringByAppendingString(strName)//.stringByAppendingPathComponent(strName);
        let img:UIImage = UIImage(contentsOfFile: filePath)!;
        
        return (img,filePath);
    }
    //保存图片到本地
    func saveImageToLocal(img:UIImage,strName:String)
    {
        var imgName = strName
        if(strName == "")
        {
            imgName = "tempEdit.png"
        }
        imgName = "/" + imgName;
        //var paths:NSArray =
        var docs=NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let filePath:String =   docs[0].stringByAppendingString(imgName)//docs[0].stringByAppendingPathComponent(imgName);
        
        print("save editImg to path:" + filePath, terminator: "");
                let result:Bool = UIImagePNGRepresentation(img)!.writeToFile(filePath, atomically: true);
        print(result)
    }
    
    func alertErrMsg(strMsg:String)
    {
        UIAlertView(title: "", message: strMsg, delegate: nil, cancelButtonTitle: "确定").show();
    }
    
    func compressionImageToDate(img:UIImage)->NSData
    {
        var imageData:NSData = UIImageJPEGRepresentation(img, 1)!
//        print(imageData.length, terminator: "");
        NSLog("orgin img file size:%d", imageData.length)
        var rate:CGFloat = 1
        while( imageData.length > 40 * 1000)
        {
            rate-=0.1
            imageData = UIImageJPEGRepresentation(img, rate)!
            if(rate<=0.19)
            {
                break;
            }
        }
        NSLog("after compression-> img file size:%d", imageData.length)
        return imageData;
    }
    var loginVC:U01LoginVC!
    
    func showLoginPage(target:UIViewController,isToHomePage:Bool)
    {
        if(self.loginVC == nil)
        {
            loginVC = U01LoginVC(nibName: "U01LoginVC", bundle: MainBundle);
        }
        
     
        
        
        target.presentViewController(loginVC, animated: true, completion: { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

            if(isToHomePage)
            {
                let tababarController =  self.GetAppDelegate().window!.rootViewController as! UITabBarController
                tababarController.selectedIndex = 0;
                tababarController.childViewControllers[0].navigationController?.navigationBarHidden = true;
           
            }
          
            
            })
        })
        
    }
    //跳转到U02选项卡
    func gotoU02Page(isBuyer:Bool)
    {
        if( UIHEPLER.GetAppDelegate().window!.rootViewController as? UITabBarController != nil) {
            let tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
            
            tababarController.selectedIndex = 4;
            
            
            let vc: U02UserVC! =   (tababarController.childViewControllers[4] as! NavigationPageVC).viewControllers[0] as? U02UserVC
            if(vc != nil)
            {
                if(isBuyer)
                {
                    vc.orderListDefaultModel = BuyerSellerType.Buyer
                }
                else
                {
                    vc.orderListDefaultModel = BuyerSellerType.Seller
                    
                }
            }
            

          
        }
    }
    func getTabbar()->TabBarVC!
    {
        var result:TabBarVC!
        if( UIHEPLER.GetAppDelegate().window!.rootViewController as? TabBarVC != nil) {
            result =  UIHEPLER.GetAppDelegate().window!.rootViewController as! TabBarVC
        }
        return result;
    }
    func showTabBar(isShow:Bool)
    {
        if( UIHEPLER.GetAppDelegate().window!.rootViewController as? TabBarVC != nil) {
            let tabbar =  UIHEPLER.GetAppDelegate().window!.rootViewController as! TabBarVC
//            var isNeedReload = false
//            if(tabbar.centerButton.hidden)
//            {
//                isNeedReload = true;
//            }
//            if(isShow)
//            {
//                
//                tabbar.view!.bringSubviewToFront(tabbar.centerButton);
//                
//                if(isNeedReload)
//                {
//                    tabbar.createCenterBtn();
//                }
//            }
//            
//            tabbar.centerButton.hidden = !isShow;
             tabbar.tabBar.hidden = !isShow;
        }
    }
    //MARK:格式化时间
    func formartTime(dateString:String)->String!
    {
          var result  = dateString
        if(dateString.containsString("T"))
        {
          var stringArr =   dateString.componentsSeparatedByString("T")
            result = stringArr[0];
        }
        if(result.containsString("-"))
        {
            result = (result as NSString).stringByReplacingOccurrencesOfString("-", withString: ".")
        }
    
        return result;
        
    }
    
    // MARK: - 检测是否是手机号
    func checkPhone(string: String) -> Bool{
        
        let regex = "^1\\d{10}$"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluateWithObject(string)
    }
    
}