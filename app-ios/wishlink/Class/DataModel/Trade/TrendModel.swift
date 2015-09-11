//
//  TrendModel.swift
//  wishlink
//
//  Created by Andy Chen on 9/11/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class TrendModel: BaseModel {
    
    var name:String!
    var icon:String!
    var weight:Int!
    
    init(dict:NSDictionary) {
        super.init()
        self.TrendModel(dict);
    }
    
    func TrendModel(dict:NSDictionary)
    {
        self.name =  self.getStringValue("name", dic: dict);
        self.icon =  self.getStringValue("icon", dic: dict);
        self.weight =  self.getIntValue("weight", dic: dict);
    }
}
