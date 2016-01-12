//
//  UserModel.swift
//  wishlink
//
//  Created by Yue Huang on 9/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class UserModel: BaseModel, RCIMUserInfoDataSource {
    
    var userDic: [String : AnyObject]! {
        didSet {
            self.fillData()
        }
    }
    var _id: String = ""
    var role:Int!;
    var isLogin: Bool = false
    var nickname: String = ""
    var mobile :String = "";
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
    var rcToken: String = "" {
        didSet {
            if rcToken != oldValue {
                self.loginRongCloud()
            }
        }
    }
    
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
    
    override init()
    {
        super.init();
        self.prepareData()
    }
    
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        let user = RCUserInfo()
        user.userId = self._id
        user.portraitUri = self.portrait
        user.name = self.nickname
        return completion(user)
    }
    
    func fillData() {
        if self.userDic.count == 0 {
            return  
        }
        print(self.userDic)
        self._id = getStringValue("_id", dic: self.userDic)
        
        if let _role = self.userDic["role"] as? Int
        {
            
            self.role =  _role
        }
//        else
//        {
//            self.role = 1
//        }
        
        if(self.role != nil && self.role == 1)
        {
            self.isLogin = true
        }
        else
        {
            
            self.isLogin = false;
        }
        self.nickname = getStringValue("nickname", dic: self.userDic)
        self.mobile = getStringValue("mobile", dic: self.userDic)
        self.update = getStringValue("update", dic: self.userDic)
        self.create = getStringValue("create", dic: self.userDic)
        self.portrait = getStringValue("portrait", dic: self.userDic)
        self.background = getStringValue("background", dic: self.userDic)
        self.countryRef = getStringValue("countryRef", dic: self.userDic)
        if let alipay = self.userDic["alipay"] as? NSDictionary {
            self.alipayId = alipay["id"] as! String
        }
        if let rongcloud = self.userDic["rongcloud"] as? NSDictionary {
            self.rcToken = rongcloud["token"] as! String
        }
        
        if let receivers = self.userDic["receivers"] as? NSArray {
            if receivers.count > 0 {
                self.receiversArray = []
                for receiverDic in receivers {
                    let receiverModel = ReceiverModel(dic: receiverDic as! NSDictionary)
                    self.receiversArray.append(receiverModel)
                }
            }
        }
        
        var unreadDic = self.userDic["unread"] as! [String: AnyObject]
        let itemRecommendationRefs = unreadDic["itemRecommendationRefs"] as! [ItemModel]
        if itemRecommendationRefs.count != 0 {
//            for item in itemRecommendationRefs {
//                
//            }
        }
        
        if let receivers = self.userDic["searchHistory"] as? NSDictionary {
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
        
        // TODO
        let tradeRefs = unreadDic["tradeRefs"] as! [AnyObject]
        if tradeRefs.count != 0 {
            for trande in tradeRefs {
                
            }
        }
        self.save()
    }
    
    func save() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject("true", forKey: "isLogin")
        ud.synchronize()
    }
    
    func logout() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey("isLogin")
        ud.synchronize()
        self.isLogin = false
        if self.rcToken.length != 0 {
            RCIM.sharedRCIM().logout()
        }
    }
    
    func loginRongCloud() {
        if self.rcToken.length == 0 {
            return
        }
        RCIM.sharedRCIM().connectWithToken(self.rcToken, success: { (userId) -> Void in
            RCIM.sharedRCIM().userInfoDataSource = self
            }, error: { (errorCode) -> Void in
                print(errorCode)
            }) { () -> Void in
                print("token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致")
        }
    }
    
    func prepareData() {
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("isLogin") != nil {
            self.isLogin = true
        }else
        {
            self.isLogin = false
        }
    }
    
}





