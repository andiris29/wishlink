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
    var _countryRef:CountryModel!
    var brandRef:String!
    var name:String!
    var brand:String!
    var country:String!
    var spec:String!
    var price:Float!
    var notes:String!
    var create:String!
    var numTrades:Int!
    var images:[String]!
    var unit:String!//单位
    var isFavorite: Bool = false
    
    init(dict:NSDictionary) {
        super.init()
        self.ItemModel(dict);
    }
    
    func ItemModel(dict:NSDictionary)
    {
        self.name =  self.getStringValue("name", dic: dict);
        self._id =  self.getStringValue("_id", dic: dict);
        
        
     

        
        if let countryDic = dict.objectForKey("countryRef") as? NSDictionary
        {
            self._countryRef = CountryModel(dict: countryDic);
            self.countryRef = self._countryRef.name;
        }
        
        
        if let countryStr = dict.objectForKey("countryRef") as? String
        {
             self.countryRef = countryStr
        }
 
        
        self.brandRef =  self.getStringValue("brandRef", dic: dict);
        self.brand =  self.getStringValue("brand", dic: dict);
        self.country =  self.getStringValue("country", dic: dict);
        self.spec =  self.getStringValue("spec", dic: dict);
        self.create =  self.getStringValue("create", dic: dict);
        self.unit =  self.getStringValue("unit", dic: dict);
        self.notes =  self.getStringValue("notes", dic: dict);
//        self.price =  self.getFloatValue("price", dic: dict);
        
        if let priceStr = dict.objectForKey("price") as? String
        {
            if let pricePic = priceStr as? Float
            {   
                self.price = pricePic
            }
        }
        if let priceFloat = dict.objectForKey("price") as? Float
        {
            self.price = priceFloat
        }
        if let priceFloat = dict.objectForKey("price") as? Int
        {
            self.price = Float(priceFloat)
        }
        
        if let tempDic = dict["__context"] as? NSDictionary {
            
            self.numTrades = self.getIntValue("numTrades", dic: tempDic)
            self.isFavorite = self.getBoolValue("favoritedByCurrentUser", dic: tempDic)
        }
//        if(dict.objectForKey("images") != nil)
//        {
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
//        }
    }
}