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
    //给btn加圆角
    func buildButtonFilletStyleWithRadius(btn:UIButton,borderColor:UIColor,titleColor:UIColor,radius:CGFloat)
    {
        btn.layer.cornerRadius = radius;
        btn.layer.masksToBounds=true
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = borderColor.CGColor;
        btn.setTitleColor(titleColor, forState: UIControlState.Normal)
        
    }
    //给Image加圆角
    func buildImageViewWithRadius(image:UIImageView,borderColor:UIColor,borderWidth:Int)
    {
        image.layer.cornerRadius = image.frame.width/2;
        image.layer.masksToBounds=true
        image.layer.borderWidth = CGFloat(borderWidth);
        image.layer.borderColor = mainColor.CGColor;
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
        print(imageData.length, terminator: "");
        var rate:CGFloat = 1
        while( imageData.length > 40 * 1000)
        {
            rate-=0.1
            imageData = UIImageJPEGRepresentation(img, rate)!
            if(rate<=0.189)
            {
                break;
            }
        }
   
        return imageData;
    }
    func showLoginPage(target:UIViewController)
    {
        let vc = U01LoginVC(nibName: "U01LoginVC", bundle: MainBundle);
        target.presentViewController(vc, animated: true, completion: nil)
        
    }
}