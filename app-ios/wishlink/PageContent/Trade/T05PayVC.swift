//
//  T05PayVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

enum PayModel{
    case Weixin
    case Alipay
}


class T05PayVC: RootVC,WebRequestDelegate,WXApiDelegate {
    
    let selectedButtonWXTag: Int = 1000
    let selectedButtonZFBTag: Int = 1001
    
    let increingButtonTag: Int = 2001
    let declineButtonTag: Int = 2000
    
    var goodsNumbers: Int = 0
    var isNewOrder: Bool = true
    var currPayModel:PayModel = .Alipay
    var item:ItemModel!
    var trade:TradeModel!
    var u03VC:U03AddressManagerVC!
    
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    @IBOutlet weak var lbReceverName: UILabel!
    @IBOutlet weak var lbReceverMobile: UILabel!
    @IBOutlet weak var lbRecevierAddress: UILabel!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbSpec: UILabel!
    @IBOutlet weak var numbersTextField: UITextField!
   
    @IBOutlet weak var lbTotalFree: UILabel!
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    private var new_trade_id:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self;
        self.loadData();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("receiveWeXinPayResultNotification:"), name: APPCONFIG.NotificationActionPayResult, object: nil)
        
    }
    func receiveWeXinPayResultNotification(obj:NSNotification)
    {
        var result = obj.object as! PayResp
        if(result.errCode == 0)
        {
            
            SVProgressHUD.showWithStatusWithBlack("请稍等...")
            self.httpObj.httpPostApi("trade/postpay", parameters: ["_id":self.new_trade_id], tag: 99);
        }
        else if(result.errCode  == -1)//错误
        {
            
        }
        else if(result.errCode  == -2)//用户取消
        {
        }
    }
    deinit
    {
        NSLog("T05PayVC --> deinit");
        self.imageRollView.removeFromSuperview();
        self.imageRollView = nil;
        self.item = nil;
        self.trade = nil;
    }
    
    func initImageRollView(images:[UIImage]) {
        
        imageRollView.initWithImages(images)
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
    }
    
    func loadData() {
        
        self.lbName.text = "";
        self.lbCountry.text = "";
        self.lbSpec.text = "";
        self.lbPrice.text = "";
        self.numbersTextField.text = "0";
        if(self.item != nil)
        {
            self.lbName.text = self.item.name;
            self.lbCountry.text = self.item.country;
            self.lbSpec.text = self.item.spec;
            self.lbPrice.text = self.item.price.format(".2");
            if(goodsNumbers>0)
            {
                self.lbTotalFree.text = "¥" + (self.item.price * Float(goodsNumbers)).format(".2");
            }
            else
            {
                 self.lbTotalFree.text = "¥" + self.item.price.format(".2");
            }
        }
        if(self.trade != nil && self.trade._id != "")
        {
            self.numbersTextField.text = String(self.trade.quantity)
            goodsNumbers = self.trade.quantity
        }
        
         self.decreaseButton.enabled = goodsNumbers > 1
        self.lbReceverName.text = "";
        self.lbReceverMobile.text = "";
        self.lbRecevierAddress.text = "";
        if( UserModel.shared.isLogin && UserModel.shared.receiversArray != nil && UserModel.shared.receiversArray.count>0)
        {
            let result = UserModel.shared.receiversArray.filter{itemObj -> Bool in
                return (itemObj as ReceiverModel).isDefault == true;
            }
            if(result.count>0)
            {
                let defaultAddress = result[0] as ReceiverModel
                
                self.lbReceverName.text = defaultAddress.name
                self.lbReceverMobile.text = defaultAddress.phone;
                self.lbRecevierAddress.text = defaultAddress.address;
                
                if (item == nil ||  item.images == nil) {return}
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    
                    var images: [UIImage] = [UIImage]()
                    for imageUrl in self.item.images {
                        let url: NSURL = NSURL(string: imageUrl)!
                        let image: UIImage = UIImage(data: NSData(contentsOfURL: url)!)!
                        images.append(image)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.initImageRollView(images)
                    })
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        if(self.u03VC != nil)
        {
            if(self.u03VC.selectedReciver != nil)//更换支付地址
            {
                
                self.lbReceverName.text = self.u03VC.selectedReciver.name
                self.lbReceverMobile.text = self.u03VC.selectedReciver.phone;
                self.lbRecevierAddress.text = self.u03VC.selectedReciver.address;
                
                let para = ["_id":self.trade._id,
                    "receiver":[
                        "name":self.u03VC.selectedReciver.name,
                        "phone":self.u03VC.selectedReciver.phone,
                        "province":self.u03VC.selectedReciver.province,
                        "address":self.u03VC.selectedReciver.address
                    ]
                ]
                
                //TODU:更换支付地址
                self.httpObj.httpPostApi("trade/updateReceiver", parameters: para as? [String : AnyObject], tag: 51)
            }
            self.u03VC.view.removeFromSuperview();
            self.u03VC.view  = nil;
            self.u03VC = nil;
        }
        
        self.navigationController?.navigationBarHidden = false;
        
        self.increaseButton.enabled = !self.isNewOrder
        
        if self.isNewOrder {
            
            self.decreaseButton.enabled = false
        } else {
            
            self.decreaseButton.enabled = goodsNumbers > 1
        }
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle(self.isNewOrder ? "发布" : "我要跟单")
    }
    
    var currentButton: UIButton = UIButton()
    @IBAction func selectedButtonPay(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        if sender.tag == selectedButtonWXTag {
            
            self.currPayModel = .Weixin
        } else if sender.tag == selectedButtonZFBTag {
            
            self.currPayModel = .Alipay
        }
        // single select
        if currentButton != sender { currentButton.selected = false }
        currentButton = sender
    }
    @IBAction func btnPayTapped(sender: UIButton) {
        
      
        
        let tag = sender.tag;
        if(tag == 11)//确认支付
        {
            if !(currentButton.tag == selectedButtonWXTag || currentButton.tag == selectedButtonZFBTag) {
                
                UIAlertView(title: "提示" , message: "请选择一种支付方式" , delegate: nil , cancelButtonTitle: " 完成 " ).show()
                return
            }
            var para = ["_id":self.trade._id,
                "pay": [
                    "alipay":NSDictionary()
                ]];
            if(self.currPayModel == .Weixin)
            {
                para = ["_id":self.trade._id,
                    "pay": [
                        "weixin":NSDictionary()
                    ]];
            }
            SVProgressHUD.showWithStatusWithBlack("请稍等...")
            self.httpObj.httpPostApi("trade/prepay", parameters: para as? [String : AnyObject], tag: 88)
        }
        else
        {
            if(self.u03VC == nil)
            {
                self.u03VC = U03AddressManagerVC(nibName: "U03AddressManagerVC", bundle: NSBundle.mainBundle())
            }
            self.navigationController?.pushViewController(self.u03VC, animated: true);
            
        }
    }
    
    @IBAction func incrlineOrDecreingButtonPay(sender: UIButton) {
        
        if sender.tag == increingButtonTag {
            goodsNumbers++
            
        } else if sender.tag == declineButtonTag {
            goodsNumbers > 1 ? goodsNumbers-- : goodsNumbers
        }
        self.decreaseButton.enabled = goodsNumbers > 1
        
        numbersTextField.text = "\(goodsNumbers)"
        let totalfree = (self.item.price * Float(goodsNumbers)).format(".2")
        self.lbTotalFree.text =  "¥\(totalfree)";
    }
    
    //WebRequesrDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if(tag == 10)
        {
            SVProgressHUD.dismiss();
        }
            
        else if(tag == 51)//发送prepay后服务端返回的结果
        {
            SVProgressHUD.dismiss();
            
        }
        else if(tag == 88)//发送prepay后服务端返回的结果
        {
            SVProgressHUD.dismiss();
            
            if (self.currPayModel == .Alipay) {
                
                
                var _tradeDic:NSDictionary! = response as? NSDictionary
                var _trade:TradeModel!
                var _prepayid:String!;
                if(_tradeDic != nil && _tradeDic.objectForKey("trade") != nil)
                {
                    var tradeDic:NSDictionary! = _tradeDic.objectForKey("trade") as! NSDictionary
                    _trade = TradeModel(dict: tradeDic)

                }
                new_trade_id = _trade._id;
                
                let order = Order()
                order.partner = APPCONFIG.alipay_partner;
                order.seller = APPCONFIG.alipay_seller;
                order.tradeNO = new_trade_id
                order.productName = self.item.name
                order.productDescription = "wishLink-" +  self.item.name + " " + self.item.spec
                order.amount = "0.02"// (self.lbTotalFree.text as! NSString).stringByReplacingOccurrencesOfString("¥", withString:"")
                order.notifyURL = APPCONFIG.alipay_callback_url//回调URL
                
                order.service = "mobile.securitypay.pay";
                order.paymentType = "1";
                order.inputCharset = "utf-8";
                order.itBPay = "30m";
                order.showUrl = "m.alipay.com";
                
                
                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                let appScheme = "alisdk";
                let orderSpec = order.description
                //将商品信息拼接成字符串
                NSLog("orderSpec = %@",orderSpec);
                let signer = CreateRSADataSigner(APPCONFIG.alipay_privateKey)
                let signedString = signer.signString(orderSpec)
                let orderString = "\(order.description)&sign=\"\(signedString)\"&sign_type=\"RSA\""
                
                NSLog("orderString = %@",orderString);
                AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { (resultDic) -> Void in
                    
                    NSLog(" alipay reslut = \(resultDic)")
                    SVProgressHUD.showWithStatusWithBlack("请稍等...")
                    self.httpObj.httpPostApi("trade/postpay", parameters: ["_id":self.trade._id], tag: 99);
                })
            } else if (self.currPayModel == .Weixin) {
                
                
                
                var _tradeDic:NSDictionary! = response as? NSDictionary
                var _trade:TradeModel!
                var _prepayid:String!;
                if(_tradeDic != nil && _tradeDic.objectForKey("trade") != nil)
                {
                    ////-------------------方式一 begin-------------------／
                    var tradeDic:NSDictionary! = _tradeDic.objectForKey("trade") as! NSDictionary
                    _trade = TradeModel(dict: tradeDic)
                    var payDic:NSDictionary! = tradeDic.objectForKey("pay")  as! NSDictionary
                    if(payDic != nil && payDic.objectForKey("weixin") != nil)
                    {
                        var   prepayDic:NSDictionary!  = payDic.objectForKey("weixin") as! NSDictionary
                        _prepayid = prepayDic.objectForKey("prepayid") as? String
                        prepayDic = nil;
                    }
                    if(_prepayid == nil || _prepayid == "" ||  _prepayid.length<1)
                    {
                        UIHEPLER.alertErrMsg("微信预支付出现问题，无法获取预支付标识，请联系客服");
                    }
                    else
                    {
                        new_trade_id = _trade._id
                        let request = PayReq()
                        request.partnerId = MCH_ID;
                        request.prepayId = _prepayid
                        
                        request.package = "Sign=WXPay";
                        request.nonceStr = String(random())
                        request.timeStamp =  UInt32(NSDate().timeIntervalSince1970)
                        var strPara:NSString!  = NSString(format: "appid=%@&noncestr=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%u&key=%@",APP_ID, request.nonceStr, request.partnerId, request.prepayId, request.timeStamp, PARTNER_ID);
                        
                        strPara.UTF8String
                        var md5sign:String! =  WXUtil.md5(strPara as String).uppercaseString;
                        request.sign = md5sign;
                
                        WXApi.sendReq(request)
                        ////-------------------方式一 End-------------------／
                        
    ////-------------------方式二 begin-------------------／
    //                //创建支付签名对象
    //                let req: payRequsestHandler = payRequsestHandler()
    //                //初始化支付签名对象
    //                req.initWith(APP_ID, mch_id: MCH_ID)
    //                //设置密钥
    //                req.setKey(PARTNER_ID)
    //                //获取到实际调起微信支付的参数后，在app端调起支付
    //                 let dict = req.sendPayOrderName(self.item.name, orderPrice: "1", nonceString: _trade._id, orderNo: _trade._id, prePayid: _prepayid)
    //                if (dict == nil) {
    //                    //错误提示
    //                    let debug: NSString = req.getDebugifo()
    //                    NSLog("debug:%@\n\n",debug);
    //                }else{
    //                      NSLog("dict:%@\n\n",dict);
    //                    NSLog("debug:%@\n\n",req.getDebugifo());
    ////                    调起微信支付
    //                    let req                 = PayReq()
    //                    req.openID              = dict["appid"] as? String;
    //                    req.partnerId           = dict["partnerid"] as? String;
    //                    req.prepayId            = dict["prepayid"] as? String;
    //                    req.nonceStr            = dict["noncestr"] as? String;
    //                    req.timeStamp           = UInt32((dict["timestamp"]?.intValue)!);
    //                    req.package             = dict["package"] as? String;
    //                    req.sign                = dict["sign"] as? String;
    //                    
    //                    WXApi.sendReq(req)
    //                }
    //                    //-------------------方式二 End-------------------／
                        
                        strPara = nil;
                        md5sign = nil;
                        
                    }
                    tradeDic = nil;
                    _tradeDic = nil;
                    payDic = nil;
                    
                }
                else
                {
                    UIHEPLER.alertErrMsg("微信预支付出现问题，请联系客服");
                }
                
            }
            
        }
        else if(tag == 99)//交易回调请求（Postpay成后后返回的请求）
        {
            var trade_Dic:NSDictionary! = response as? NSDictionary
         
            print(trade_Dic)
            if(trade_Dic != nil && trade_Dic.objectForKey("trade") != nil)
            {
         
//                let tradeDic:NSDictionary! = trade_Dic.objectForKey("trade") as! NSDictionary
//                var   _trade_result = TradeModel(dict: tradeDic)
              
            }
            
            SVProgressHUD.dismiss();
            self.navigationController?.popToRootViewControllerAnimated(true);
            
            UIHEPLER.gotoU02Page();
            trade_Dic = nil;
        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }

    //MARK:WXApiDelegate
    func onResp(resp: BaseResp!) {
        NSLog("onResp")
    }
    func onReq(req: BaseReq!) {
        NSLog("onReq")
    }
 
}
