//
//  UIhelper.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import Foundation
class UIHelper {
    
    
    //系统主色调{大部分字体颜色 }
    static var mainColor:UIColor = UIColor(red: 88.0/255.0, green: 140.0/255.0, blue: 236.0/255.0, alpha: 1)
    
    
    static func imageToBase64(image:UIImage )->String {
        var imageData:NSData = UIImageJPEGRepresentation(image, 1)
        return imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
    }

    static func getCachedFilePath(relative:String)->String!
    {
        var strResult = "";
        var paths:NSArray=NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        var root:String = paths.count>0 ? paths.objectAtIndex(0) as! String:"undefined";
        strResult = root + "/" + relative
        return strResult
        
    }
    static func getBundledImage(name:String)->UIImage
    {
        
        var strResure =  NSBundle.mainBundle().pathForResource(name, ofType: nil)
        return UIImage(contentsOfFile:strResure!)!
        //    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    }
}