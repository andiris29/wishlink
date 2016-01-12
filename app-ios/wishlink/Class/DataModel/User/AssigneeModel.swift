//
//  AssigneeModel.swift
//  wishlink
//
//  Created by whj on 15/11/3.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class AssigneeModel: BaseModel {

    var _id: String = ""
    var isLogin: Bool = false
    var nickname: String = ""
    var password: String = ""
    var update: String = ""
    var create: String = ""
    var portrait: String = ""
    var background: String = ""
    var countryRef: String = ""
    var itemRecommendationRefs: NSMutableArray!
    var tradeRefs: NSMutableArray!
    var receiversArray: [ReceiverModel]!
    var searchHistory: [keywordModel]!
    var alipayId: String = ""
    var rcToken: String = ""
    
    convenience override init() {
        self.init(dic: NSDictionary())
    }
    
    init(dic: NSDictionary) {
        super.init()
        
        self._id        = getStringValue("_id", dic: dic)
        self.update     = getStringValue("update", dic: dic)
        self.create     = getStringValue("create", dic: dic)
        self.nickname   = getStringValue("nickname", dic: dic)
        self.portrait   = getStringValue("portrait", dic: dic)
        self.background = getStringValue("background", dic: dic)
        self.countryRef = getStringValue("countryRef", dic: dic)
        
        if let alipay = dic["alipay"] as? NSDictionary {
            self.alipayId = alipay["id"] as! String
        }
        if let rongcloud = dic["rongcloud"] as? NSDictionary {
            self.rcToken = rongcloud["token"] as! String
        }
        
        if let receivers = dic["receivers"] as? NSArray {
            if receivers.count > 0 {
                self.receiversArray = []
                for receiverDic in receivers {
                    let receiverModel = ReceiverModel(dic: receiverDic as! NSDictionary)
                    self.receiversArray.append(receiverModel)
                }
            }
        }
        
        var unreadDic = dic["unread"] as! [String: AnyObject]
        let itemRecommendationRefs = unreadDic["itemRecommendationRefs"] as! [ItemModel]
        if itemRecommendationRefs.count != 0 {
//            for item in itemRecommendationRefs {
//                
//            }
        }
        
        if let receivers = dic["searchHistory"] as? NSDictionary {
            if let  itemArr = receivers.objectForKey("entry") as? NSArray
            {
                if itemArr.count > 0 {
                    self.searchHistory = []
                    for itemDic in itemArr {
                        let item = keywordModel(dict: itemDic as! NSDictionary)
                        self.searchHistory.append(item)
                    }
                }
            }
        }
    }
}
