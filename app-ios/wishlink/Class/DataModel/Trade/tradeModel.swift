//
//  tradeModel.swift
//  wishlink
//
//  Created by Andy Chen on 10/7/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class tradeModel: BaseModel {
    
    var _id:String!
    
    var statusOrder:String!
    var status:Int!
    var itemRef:String!
    var ownerRef:String!
    var create:String!
    var update:String!
    
    var quantity:Int!

    
    init(dict:NSDictionary) {
        super.init()
        self.tradeModel(dict);
    }
    
    func tradeModel(dict:NSDictionary)
    {
        self._id =  self.getStringValue("_id", dic: dict);
        self.statusOrder =  self.getStringValue("statusOrder", dic: dict);
        self.status =  self.getIntValue("status", dic: dict);
        self.itemRef =  self.getStringValue("itemRef", dic: dict);
        self.ownerRef =  self.getStringValue("ownerRef", dic: dict);
        self.create =  self.getStringValue("create", dic: dict);
        self.update =  self.getStringValue("update", dic: dict);
        self.quantity =  self.getIntValue("quantity", dic: dict);

    }
}
