//
//  UserModel.swift
//  wishlink
//
//  Created by Yue Huang on 9/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class UserModel: BaseModel {
    
    var userDic: [String : AnyObject]! {
        didSet {
            self.fillData()
        }
    }
    var isLogin: Bool = false
    var userId: String = ""
    var nickname: String = ""
    var password: String = ""
    var update: String = ""
    var create: String = ""
    var portrait: String = ""
    var backgroud: String = ""
    var itemRecommendationRefs: NSMutableArray!
    var tradeRefs: NSMutableArray!
    var receiversArray: [ReceiverModel]!
    var alipayId: String = ""
    
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
    
    
    
    func fillData() {
        if self.userDic.count == 0 {
            return  
        }
        self.isLogin = true
        self.userId = getStringValue("_id", dic: self.userDic)
        self.nickname = getStringValue("nickname", dic: self.userDic)
        self.update = getStringValue("update", dic: self.userDic)
        self.create = getStringValue("create", dic: self.userDic)
        self.portrait = getStringValue("portrait", dic: self.userDic)

        if let alipay = self.userDic["alipay"] as? NSDictionary {
            self.alipayId = alipay["id"] as! String
        }

        
        if let receivers = self.userDic["receivers"] as? NSArray {
            if receivers.count > 0 {
                self.receiversArray = []
                for receiverDic in receivers {
                    var receiverModel = ReceiverModel(dic: receiverDic as! NSDictionary)
                    self.receiversArray.append(receiverModel)
                }
            }
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





