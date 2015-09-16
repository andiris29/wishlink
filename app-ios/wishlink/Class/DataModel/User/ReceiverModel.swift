//
//  Receiver.swift
//  wishlink
//
//  Created by Yue Huang on 9/9/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class ReceiverModel: BaseModel {
    var name: String = ""
    var phone: String = ""
    var province: String = ""
    var address: String = ""
    var isDefault: Bool = false
    convenience override init() {
        self.init(dic: NSDictionary())
    }
    init(dic: NSDictionary) {
        super.init()
        self.name = self.getStringValue("name", dic: dic)
        self.phone = self.getStringValue("phone", dic: dic)
        self.province = self.getStringValue("province", dic: dic)
        self.address = self.getStringValue("address", dic: dic)
        self.isDefault = self.getBoolValue("isDefault", dic: dic)
    }
}
