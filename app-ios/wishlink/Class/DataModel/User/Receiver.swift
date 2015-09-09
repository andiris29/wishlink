//
//  Receiver.swift
//  wishlink
//
//  Created by Yue Huang on 9/9/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class Receiver: NSObject {
    var name: String = ""
    var phone: String = ""
    var province: String = ""
    var address: String = ""
    var isDefault: Bool = false
    convenience override init() {
        self.init(dic: ["": ""])
    }
    init(dic: [String: AnyObject]) {
        super.init()
        self.setValuesForKeysWithDictionary(dic)
//        self.name = dic["name"]
//        self.phone = dic["phone"]
//        self.province = dic[""]
    }
}
