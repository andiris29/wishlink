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
    static var mainColor:UIColor = UIColor(red: 124/255.0, green: 0/255.0, blue: 90.0/255.0, alpha: 1)
    
    // 列表背景色
    static var listBgColor:UIColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    /*
    将图片转换成64位编码
    */
    static func imageToBase64(image:UIImage )->String {
        var imageData:NSData = UIImageJPEGRepresentation(image, 1)
        return imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
    }

    /*
    获取缓存路径
    */
    static func getCachedFilePath(relative:String)->String!
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
    static func getBundledImage(name:String)->UIImage
    {
        
        var strResure =  NSBundle.mainBundle().pathForResource(name, ofType: nil)
        return UIImage(contentsOfFile:strResure!)!
        //    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    }
    
   static func loadLeftItem(navi:UINavigationController, imgNormal:String,imgHightLight:String,btnAction:Selector)
    {
    
        
        
        
        
        
    }

}