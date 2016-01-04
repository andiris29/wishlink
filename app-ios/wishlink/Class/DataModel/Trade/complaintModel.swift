//
//  complaintModel.swift
//  wishlink
//
//  Created by Andy Chen on 1/3/16.
//  Copyright © 2016 edonesoft. All rights reserved.
//


import Foundation
class complaintModel: BaseModel {
    
    
    var _id:String = "";
    var problem:String!
    var create:String!
    
    var images:[String]!
    var resolution:NSDictionary!
    
    init(dict:NSDictionary) {
        super.init()
        self.complaintModel(dict);
    }
    
    func complaintModel(dict:NSDictionary)
    {
        self._id =  self.getStringValue("_id", dic: dict);
        self.problem =  self.getStringValue("problem", dic: dict);
        self.create =  self.getStringValue("create", dic: dict);
        
        if let resoDic = dict.objectForKey("resolution") as? NSDictionary
        {
            if(resoDic.count>0)
            {
                self.resolution = resoDic
               
            }
        }
        
        if let imgArr = dict.objectForKey("images") as? NSArray
        {
            if(imgArr.count>0)
            {
                images = [];
                for imgUrl in imgArr
                {
                    self.images.append(imgUrl as! String);
                }
            }
        }
    }
}