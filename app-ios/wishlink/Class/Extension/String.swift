//
//  String.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import Foundation

extension String{

    func isNullOrEmpty()->Bool
    {
        if(self.isEmpty)
        {
            return true;
        }
        else
        {
            if(self.length>0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        
    }
    //去掉左右空格
    func trim()->String{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }

    //是否包含前缀
    func hasBegin(s:String)->Bool{
        if self.hasPrefix(s) {
            return true
        }else{
            return false
        }
    }
    //是否包含后缀
    func hasEnd(s:String)->Bool{
        if self.hasSuffix(s) {
            return true
        }else{
            return false
        }
    }
    //长度
    var length: Int {
        return count(self)
    }
    //统计长度(别名)
    func size()->Int{
        return count(self)
    }
}