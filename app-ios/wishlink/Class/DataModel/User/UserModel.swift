//
//  UserModel.swift
//  wishlink
//
//  Created by Yue Huang on 9/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class UserModel: BaseModel {
    class var shared: UserModel {
        dispatch_once(&Inner.token) {
            Inner.instance = UserModel()
        }
        return Inner.instance!
    }
    struct Inner {
        static var instance: UserModel?
        static var token: dispatch_once_t = 0
    }
    
    var userDic: [String : AnyObject]! {
        didSet {
            self.fillData()
        }
    }
    var userId: String = ""
    var nickname: String = ""
    var password: String = ""
    var update: String = ""
    var create: String = ""
    var itemRecommendationRefs: NSMutableArray!
    var tradeRefs: NSMutableArray!
    var receiversArray: NSMutableArray!
    
    func fillData() {
        self.userId = self.userDic["_id"] as! String
        self.nickname = self.userDic["nickname"] as! String
        self.update = self.userDic["update"] as! String
        self.create = self.userDic["create"] as! String
        
//        var re
        for receiver in self.userDic["receivers"] as! [ReceiverModel] {
            
        }
        
        var unreadDic = self.userDic["unread"] as! [String: AnyObject]
        var itemRecommendationRefs = unreadDic["itemRecommendationRefs"] as! [itemModel]
        if itemRecommendationRefs.count != 0 {
            for item in itemRecommendationRefs {
                
            }
        }
        
        // TODO
        var tradeRefs = unreadDic["tradeRefs"] as! [AnyObject]
        if tradeRefs.count != 0 {
            for trande in tradeRefs {
                
            }
        }
        
    }
}





