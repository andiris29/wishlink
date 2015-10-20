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


class T05PayVC: RootVC,WebRequestDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self;
        self.loadData();
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
                
                let order = AlipayOrder()
                order.partner = APPCONFIG.alipay_partner;
                order.seller = APPCONFIG.alipay_seller;
                order.tradeNO = self.trade._id
                order.productName = self.item.name
                order.productDescription = "wishLink-" +  self.item.name + " " + self.item.spec
                order.amount = "0.01"// (self.lbTotalFree.text as! NSString).stringByReplacingOccurrencesOfString("¥", withString:"")
                order.notifyURL = APPCONFIG.alipay_callback_url//回调URL
                
                order.service = "mobile.securitypay.pay";
                order.paymentType = "1";
                order.inputCharset = "utf-8";
                order.itBPay = "30m";
                order.showUrl = "m.alipay.com";
                
                
                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                let appScheme = "alipay";
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
                
                //{{{
                //本实例只是演示签名过程， 请将该过程在商户服务器上实现
                
                //创建支付签名对象
                let req: payRequsestHandler = payRequsestHandler()
                //初始化支付签名对象
                req.initWith(APP_ID, mch_id: MCH_ID)
                //设置密钥
                req.setKey(PARTNER_ID)
                
                //}}}
                
                //获取到实际调起微信支付的参数后，在app端调起支付
                let dict = req.sendPay_demo()
                
                if (dict == nil) {
                    //错误提示
                    let debug: NSString = req.getDebugifo()
                    
                    NSLog("debug:%@\n\n",debug);
                }else{
                    NSLog("debug:%@\n\n",req.getDebugifo());
                    //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
                    
                    //调起微信支付
                    let req                 = PayReq()
                    req.openID              = dict["appid"]?.stringValue;
                    req.partnerId           = dict["partnerid"]?.stringValue;
                    req.prepayId            = dict["prepayid"]?.stringValue;
                    req.nonceStr            = dict["noncestr"]?.stringValue;
                    req.timeStamp           = UInt32((dict["timestamp"]?.intValue)!);
                    req.package             = dict["package"]?.stringValue;
                    req.sign                = dict["sign"]?.stringValue;
                    
                    WXApi.sendReq(req)
                }
            }
            
        }
        else if(tag == 99)//交易回调请求（Postpay成后后返回的请求）
        {
            
            SVProgressHUD.dismiss();
            self.navigationController?.popToRootViewControllerAnimated(true);
            
            if( UIHEPLER.GetAppDelegate().window!.rootViewController as? UITabBarController != nil) {
                let tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
                let vc:U02UserVC! = tababarController.childViewControllers[3] as? U02UserVC
                if(vc != nil)
                {
                    vc.sellerBtnAction(vc.sellerBtn);
                }
                
                tababarController.selectedIndex = 3;
            }

        }
    }
    
    func requestDataFailed(error: String) {
        
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }

 
}
