//
//  itemModel.swift
//  wishlink
//
//  Created by Andy Chen on 9/22/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import Foundation
class ItemModel: BaseModel {
    
    
    var _id:String = "";
    var countryRef:String!
    var brandRef:String!
    var name:String!
    var brand:String!
    var country:String!
    var spec:String!
    var price:Float!
    
    var create:String!
    var images:[String]!
    
    init(dict:NSDictionary) {
        super.init()
        self.ItemModel(dict);
    }
    
    func ItemModel(dict:NSDictionary)
    {
        self.name =  self.getStringValue("name", dic: dict);
        self._id =  self.getStringValue("_id", dic: dict);
        self.countryRef =  self.getStringValue("countryRef", dic: dict);
        self.brandRef =  self.getStringValue("brandRef", dic: dict);
        self.brand =  self.getStringValue("brand", dic: dict);
        self.country =  self.getStringValue("country", dic: dict);
        self.spec =  self.getStringValue("spec", dic: dict);
        self.create =  self.getStringValue("create", dic: dict);
        self.price =  self.getFloatValue("price", dic: dict);
        if(dict.objectForKey("images") != nil)
        {
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
}