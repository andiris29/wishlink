//
//  BaseModel.swift
//  cancan
//
//  Created by Andy Chen on 15/8/26.
//  Copyright (c) 2015年 FinderEasy. All rights reserved.
//

import UIKit


class BaseModel: NSObject {
    
    
    func getIntValue(strKey:String,dic:NSDictionary)->Int!
    {
        var result:Int!
        if(dic.objectForKey(strKey) != nil && dic.objectForKey(strKey)?.description != "<null>")
        {
            result = dic.objectForKey(strKey)  as! Int
        }
        else
        {
            result = 0
        }
        return result;
    }
    
    
    
    func getStringValue(strKey:String,dic:NSDictionary)->String!
    {
        var result:String!
        if(dic.objectForKey(strKey) != nil && dic.objectForKey(strKey)?.description != "<null>")
        {
            result = dic.objectForKey(strKey)  as! String
        }
        else
        {
            result = ""
        }
        
        return result;
    }
    
    func getBoolValue(strKey:String,dic:NSDictionary)->Bool!
    {
        var result:Bool!
        if(dic.objectForKey(strKey) != nil && dic.objectForKey(strKey)?.description != "<null>")
        {
            result = dic.objectForKey(strKey)  as! Bool
        }
        else
        {
            result = false
        }
        
        return result;
    }
    
    func getFloatValue(strKey:String,dic:NSDictionary)->Float!
    {
        var result:Float!
        if(dic.objectForKey(strKey) != nil && dic.objectForKey(strKey)?.description != "<null>")
        {
            result = dic.objectForKey(strKey)  as! Float
        }
        else
        {
            result = 0
        }
        return result;
    }
    
    
    
    func getDateValue(strKey:String,dic:NSDictionary)->NSDate!
    {
        var result:NSDate!
        if(dic.objectForKey(strKey) != nil)
        {
            result = NSDate(timeIntervalSince1970: (dic.objectForKey(strKey)  as! Double))
        }
        return result;
    }
    
    
}

