//
//  UserModel.swift
//  wishlink
//
//  Created by Yue Huang on 9/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class UserModel: BaseModel {
    var nickname: String = ""
    var password: String = ""
    var itemRecommendationRefs: NSMutableArray!
    var tradeRefs: NSMutableArray!
}
