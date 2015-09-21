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
        var imageData:NSData = UIImageJPEGRepresentation(image, 1)
        return imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
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
        var paths:NSArray=NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        var root:String = paths.count>0 ? paths.objectAtIndex(0) as! String:"undefined";
        strResult = root + "/" + relative
        return strResult
        
    }
    /*
    根据图片名称在bundle中搜索该图片
    */
     func getBundledImage(name:String)->UIImage
    {
        
        var strResure =  NSBundle.mainBundle().pathForResource(name, ofType: nil)
        return UIImage(contentsOfFile:strResure!)!
        //    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
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
    func GetDeviceModel()->DeviceEnum
    {
        var result = DeviceEnum.iElse;
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone)
        {
            var maxLenght = max(ScreenWidth,ScreenHeight)
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
        var deviceType = GetDeviceModel()
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
        var newHeigt:Int = Int(height)
        return CGFloat(newHeigt);
    }
    
    func alertErrMsg(strMsg:String)
    {
        UIAlertView(title: "", message: strMsg, delegate: nil, cancelButtonTitle: "确定").show();
    }
}