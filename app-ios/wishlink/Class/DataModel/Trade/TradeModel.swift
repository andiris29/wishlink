//
//  tradeModel.swift
//  wishlink
//
//  Created by Andy Chen on 10/7/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit
enum TradeStatusOrder {
    case a0, b0, c0, d0
}
class TradeModel: BaseModel {
    
    var _id: String = ""
    
    var status:Int!
    var itemRef:String!
    var item: ItemModel!
    var ownerRef:String!
    var owner:NSDictionary?
    var create:String!
    var update:String!
    var statusOrder: TradeStatusOrder = .a0
    
    var quantity:Int!
    
    
    init(dict:NSDictionary) {
        super.init()
        self.TradeModel(dict);
    }
    
    func TradeModel(dict:NSDictionary)
    {
        self._id =  self.getStringValue("_id", dic: dict);
        
        self.statusOrder =   self.statusOrderFromString(self.getStringValue("statusOrder", dic: dict))
        self.status =  self.getIntValue("status", dic: dict);
//        self.itemRef =  self.getStringValue("itemRef", dic: dict);
        if let itemDic = dict["itemRef"] as? NSDictionary {
            self.item = ItemModel(dict: itemDic)
        }else {
            self.item = ItemModel(dict: NSDictionary())
        }
        if let ownerDic = dict["ownerRef"] as? NSDictionary {
            self.owner = ownerDic
        }
        
        if let ownerID = dict["ownerRef"] as? String {
            self.ownerRef = ownerID
        }
//        self.ownerRef =  self.getStringValue("ownerRef", dic: dict);
        self.create =  self.getStringValue("create", dic: dict);
        self.update =  self.getStringValue("update", dic: dict);
        self.quantity =  self.getIntValue("quantity", dic: dict);
        
    }
    
    private func statusOrderFromString(order: String) -> TradeStatusOrder {
        if order == "a0" {
            return .a0
        }else if order == "b0" {
            return .b0
        }else if order == "c0" {
            return .c0
        }else {
            return .d0
        }
    }
}
