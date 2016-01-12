//
//  keywordModel.swift
//  wishlink
//
//  Created by Andy Chen on 10/10/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import Foundation

class keywordModel: BaseModel {
    
    var keyword:String!
    var _id:String!
    var create:String!
    
    init(dict:NSDictionary) {
        super.init()
        self.keywordModel(dict);
    }
    
    func keywordModel(dict:NSDictionary)
    {
        self.keyword =  self.getStringValue("keyword", dic: dict);
        self._id =  self.getStringValue("_id", dic: dict);
        self.create =  self.getStringValue("create", dic: dict);
    }
}
