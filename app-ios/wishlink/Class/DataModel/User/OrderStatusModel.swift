//
//  OrderStatusModel.swift
//  wishlink
//
//  Created by whj on 15/11/3.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class OrderStatusModel: BaseModel {

    var _id: String         = ""
    var create: String      = ""
    var status: Int         = 0
    var userRef: String     = ""
    var comment: String     = ""
    
    convenience override init() {
        self.init(dic: NSDictionary())
    }
    
    init(dic: NSDictionary) {
        super.init()
        
        self._id        = self.getStringValue("_id", dic: dic)
        self.create     = self.getStringValue("create", dic: dic)
        self.status     = self.getIntValue("status", dic: dic)
        self.userRef    = self.getStringValue("userRef", dic: dic)
        self.comment    = self.getStringValue("comment", dic: dic)
    }
    
}
