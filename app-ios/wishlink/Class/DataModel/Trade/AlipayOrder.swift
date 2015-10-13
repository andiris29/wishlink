//
//  AlipayOrder.swift
//  wishlink
//
//  Created by Andy Chen on 10/14/15.
//  Copyright © 2015 edonesoft. All rights reserved.
//

import Foundation

class AlipayOrder: BaseModel {
    
    
    var  partner  = "";
    var  seller  = "";
    var  tradeNO  = "";
    var  productName  = "";
    var  productDescription  = "";
    var  amount  = "";
    var  notifyURL  = "";
    
    var  service  = "";
    var  paymentType  = "";
    var  inputCharset  = "";
    var  itBPay  = "";
    var  showUrl  = "";
    
    
    var  rsaDate  = "";//可选
    var  appID  = "";//可选
}