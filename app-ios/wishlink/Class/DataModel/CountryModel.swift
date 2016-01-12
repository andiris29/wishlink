//
//  CountryModel.swift
//  wishlink
//
//  Created by Andy Chen on 11/2/15.
//  Copyright © 2015 edonesoft. All rights reserved.
//

import UIKit

class CountryModel: BaseModel {
    
    var name:String!
    var _id:String!
//    var iso3166:String!
    var icon:String!
    var words:[String]!
    
    init(dict:NSDictionary) {
        super.init()
        self.CountryModel(dict);
    }
    
    func CountryModel(dict:NSDictionary)
    {
        self.name =  self.getStringValue("name", dic: dict);
        self._id =  self.getStringValue("_id", dic: dict);
        self.icon =  self.getStringValue("icon", dic: dict);
        
    }
}
