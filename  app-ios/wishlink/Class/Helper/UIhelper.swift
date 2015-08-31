//
//  UIhelper.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import Foundation
import UIKit
class UIHelper {
    
    
    //系统主色调{大部分字体颜色 }
     var mainColor:UIColor = UIColor(red: 124/255.0, green: 0/255.0, blue: 90.0/255.0, alpha: 1)
    
    // 列表背景色
     var listBgColor:UIColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
    
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

}