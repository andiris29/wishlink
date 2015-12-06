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


class T05PayVC: RootVC,WebRequestDelegate,WXApiDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,UIScrollViewDelegate {
    
    let selectedButtonWXTag: Int = 1000
    let selectedButtonZFBTag: Int = 1001
    
    let increingButtonTag: Int = 2001
    let declineButtonTag: Int = 2000
    
    var goodsNumbers: Int = 0
    var isNewOrder: Bool = true
    var currPayModel:PayModel = .Alipay
    var item:ItemModel!
    var trade:TradeModel!
    
    @IBOutlet weak var btnWeChatPay: UIButton!
    @IBOutlet weak var btnAliPay: UIButton!
    
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
//    @IBOutlet weak var lbReceverName: UILabel!
//    @IBOutlet weak var lbReceverMobile: UILabel!
//    @IBOutlet weak var lbRecevierAddress: UILabel!
    
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationPickView: UIPickerView!
    @IBOutlet weak var txtReviceArea: UITextField!
    @IBOutlet weak var txtReciveName: UITextField!
    @IBOutlet weak var txtReviceMobile: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbSpec: UILabel!
    @IBOutlet weak var numbersTextField: UITextField!
    
    @IBOutlet weak var lbTotalFree: UILabel!
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    private var new_trade_id:String!
    
    var provinceDic: NSDictionary!
    var cityDic: NSDictionary!
    var districtDic: NSDictionary!
    var provinceCodeArray: [String] = []
    var cityArray: [[String]] = []
    var districArray: [[String]] = []
    
    //MARK:Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self;
        self.loadData();
        self.prepareData()
        UIHEPLER.buildUIViewWithRadius(self.btnAliPay, radius: 6, borderColor: UIHEPLER.mainColor , borderWidth: 1);
        UIHEPLER.buildUIViewWithRadius(self.btnWeChatPay, radius: 6, borderColor: UIColor.lightGrayColor(), borderWidth: 1);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("receiveWeXinPayResultNotification:"), name: APPCONFIG.NotificationActionPayResult, object: nil)
        
    }
    func prepareData() {
        
        locationPickView.dataSource = self;
        locationPickView.delegate = self;
        self.locationView.hidden = true;
        
        self.txtReciveName.delegate = self;
        self.txtAddress.delegate = self;
        self.txtReviceArea.delegate = self;
        self.txtReviceMobile.delegate = self;
        
        let fileName = NSBundle.mainBundle().pathForResource("area.json", ofType: nil)
        let data = NSData(contentsOfFile: fileName!)
        do {
            let dic = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            self.provinceDic = dic["area0"] as! NSDictionary
            self.cityDic = dic["area1"] as! NSDictionary
            self.districtDic = dic["area2"] as! NSDictionary
            self.provinceCodeArray = (self.provinceDic.allKeys as! [String]).sort(<)
            
            let provinceCode = self.provinceCodeArray[0]
            self.bindCity(provinceCode)
            self.bindDistrict(0)
            
        }catch _ {
            print("error")
        }
    }

    func receiveWeXinPayResultNotification(obj:NSNotification)
    {
        let result = obj.object as! PayResp
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
        
        self.httpObj.mydelegate = nil;
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

        
        if(self.trade != nil && self.trade._id != "")
        {
            self.numbersTextField.text = String(self.trade.quantity)
            goodsNumbers = self.trade.quantity
        }
        
        if(self.item != nil)
        {
            self.lbName.text = self.item.brand + " " + self.item.name;
            self.lbCountry.text = self.item.country;
            self.lbSpec.text = self.item.spec;
             var unitStr = ""
            if(self.item.unit != nil)
            {
                unitStr = self.item.unit;
            }
            self.lbPrice.text = "RMB " + self.item.price.format(".2") + unitStr
            if(goodsNumbers>0)
            {
                self.lbTotalFree.text = "¥" + (self.item.price * Float(goodsNumbers)).format(".2");
            }
            else
            {
                self.lbTotalFree.text = "¥" + self.item.price.format(".2");
            }
            if (item == nil ||  item.images == nil) {return}
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                var images: [UIImage] = []
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
        
        
        self.decreaseButton.enabled = goodsNumbers > 1
//        self.lbReceverName.text = "";
//        self.lbReceverMobile.text = "";
//        self.lbRecevierAddress.text = "";
        if( UserModel.shared.isLogin && UserModel.shared.receiversArray != nil && UserModel.shared.receiversArray.count>0)
        {
            let result = UserModel.shared.receiversArray.filter{itemObj -> Bool in
                return (itemObj as ReceiverModel).isDefault == true;
            }
            if(result.count>0)
            {
                let defaultAddress = result[0] as ReceiverModel
                
//                self.lbReceverName.text = defaultAddress.name
//                self.lbReceverMobile.text = defaultAddress.phone;
//                self.lbRecevierAddress.text = defaultAddress.address;
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
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

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        self.locationView.hidden = true
    }
    @IBAction func locationBtnAction(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        self.locationView.hidden = false
        self.txtReviceArea.text = self.locationString()
    }
    
    @IBAction func selectPayAction(sender: AnyObject) {
        
        var tag = (sender as! UIButton).tag
        if(tag == 1)
        {
            currPayModel = .Weixin;
            self.btnWeChatPay.layer.borderColor = UIHEPLER.mainColor.CGColor
            self.btnAliPay.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
        else if(tag == 2)
        {
            currPayModel = .Alipay
            self.btnAliPay.layer.borderColor = UIHEPLER.mainColor.CGColor
            self.btnWeChatPay.layer.borderColor = UIColor.lightGrayColor().CGColor
            
        }
        
    }
//    var currentButton: UIButton = UIButton()
//    @IBAction func selectedButtonPay(sender: UIButton) {
//        
//        sender.selected = !sender.selected
//        
//        if sender.tag == selectedButtonWXTag {
//            
//            self.currPayModel = .Weixin
//        } else if sender.tag == selectedButtonZFBTag {
//            
//            self.currPayModel = .Alipay
//        }
//        // single select
//        if currentButton != sender { currentButton.selected = false }
//        currentButton = sender
//    }
    @IBAction func btnPayTapped(sender: UIButton) {
        
//        if(self.lbReceverName.text?.trim() == "")
//        {
//            
//            UIAlertView(title: "提示" , message: "请先选择收获地址" , delegate: nil , cancelButtonTitle: " 确定 " ).show()
//            return
//            
//        }
        
        let tag = sender.tag;
        if(tag == 11)//确认支付
        {
            if(!validateContent())
            {
                return;
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
        else//修改收货地址
        {
            let u03VC = U03AddressManagerVC(nibName: "U03AddressManagerVC", bundle: NSBundle.mainBundle())
            u03VC.isHiddleEditModel = true;
            u03VC.selectDefaultReceiver  = {[weak self](item:ReceiverModel) in
            
//                self!.lbReceverName.text = item.name
//                self!.lbReceverMobile.text = item.phone;
//                self!.lbRecevierAddress.text = item.address;
                
                let para = ["_id":self!.trade._id,
                    "receiver":[
                        "name":item.name,
                        "phone":item.phone,
                        "province":item.province,
                        "address":item.address
                    ]
                ]
                //TODU:更换支付地址
                self!.httpObj.httpPostApi("trade/updateReceiver", parameters: para as? [String : AnyObject], tag: 51)
            }
            self.navigationController?.pushViewController(u03VC, animated: true);
            
        }
    }

    func bindCity(key: String) {
        self.cityArray = self.cityDic[key] as! [[String]]
    }
    
    func bindDistrict(row: Int) {
        let tempCity = self.cityArray[row]
        let key =  tempCity[1]
        self.districArray = self.districtDic[key] as! [[String]]
    }
    
    func locationString() -> String {
        var string = ""
        let provinceRow = self.locationPickView.selectedRowInComponent(0)
        string += self.provinceDic[self.provinceCodeArray[provinceRow]] as! String + " "
        
        let cityRow = self.locationPickView.selectedRowInComponent(1)
        string += self.cityArray[cityRow][0] + " "
        
        let districtRow = self.locationPickView.selectedRowInComponent(2)
        string += self.districArray[districtRow][0]
        return string
    }
    
    func validateContent() -> Bool {
        var msg = ""
        if self.txtReciveName.text!.length == 0 {
            msg = "收货人姓名不能为空"
        }else if self.txtReviceArea.text!.length == 0 {
            msg = "收货地区不能为空"
        }else if self.txtAddress.text!.length == 0{
            msg = "收货地址不能为空"
        } else if self.txtReviceMobile.text!.length == 0 {
            msg = "收货人电话不能为空"
        } else {
            
        }
        if msg.length == 0 {
            return true
        }else {
            let alertView = UIAlertView(title: "", message: msg, delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return false
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
    
    //MARK:WebRequesrDelegate
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
                
                
                let _tradeDic:NSDictionary! = response as? NSDictionary
                var _trade:TradeModel!
//                var _prepayid:String!;
                if(_tradeDic != nil && _tradeDic.objectForKey("trade") != nil)
                {
                    let tradeDic:NSDictionary! = _tradeDic.objectForKey("trade") as! NSDictionary
                    _trade = TradeModel(dict: tradeDic)
                    
                }
                new_trade_id = _trade._id;
                
                let order = Order()
                order.partner = APPCONFIG.alipay_partner;
                order.seller = APPCONFIG.alipay_seller;
                order.tradeNO = new_trade_id
                order.productName = self.item.name
                order.productDescription = "wishLink-" +  self.item.name + " " + self.item.spec
                order.amount =  (self.lbTotalFree.text! as NSString).stringByReplacingOccurrencesOfString("¥", withString:"").trim();
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
            //跳转到买家订单
            UIHEPLER.gotoU02Page(true);
            
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
    
    //MARK:UIPIckViewDelegate   
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let provinceCode = self.provinceCodeArray[row]
            self.bindCity(provinceCode)
            self.locationPickView.reloadComponent(1)
            self.locationPickView.selectRow(0, inComponent: 1, animated: false)
        }else if component == 1 {
            self.bindDistrict(row)
            self.locationPickView.reloadComponent(2)
            self.locationPickView.selectRow(0, inComponent: 2, animated: false)
        }else if component == 2 {
            
        }else {
            
        }
        self.txtReviceArea.text = self.locationString()
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.provinceCodeArray.count
        }else if component == 1 {
            return self.cityArray.count
        }else if component == 2 {
            return self.districArray.count
        }
        else {
            return 0
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var label: UILabel;
        if let tempLabel = view as? UILabel {
            label = tempLabel
        }else {
            
            label = UILabel(frame: CGRectMake(0, 0, 0, 0))
            label.textColor = UIColor.blackColor()
            label.textAlignment = .Center
            label.adjustsFontSizeToFitWidth = true
        }
        var string = ""
        if component == 0 {
            string = self.provinceDic[self.provinceCodeArray[row]] as! String
        }else if component == 1 {
            let tempCityArray = self.cityArray[row]
            string = tempCityArray[0]
        }else if component == 2 {
            let tempDistrictArray = self.districArray[row]
            string = tempDistrictArray[0]
        }
        else {
            string = ""
        }
        label.text = string
        return label
    }

    //MARK:TextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == self.txtReciveName {
            
            self.view.endEditing(true)
            self.locationView.hidden = false
            self.txtReviceArea.text = self.locationString()
            self.txtReviceArea.becomeFirstResponder()
        }else if textField == self.txtReviceMobile {
            
        }else if textField == self.txtReviceArea {
            self.txtAddress.becomeFirstResponder()
            
        }
        if textField == self.txtAddress {
            self.txtReviceMobile.becomeFirstResponder()
        }
        return true
    }
    @IBAction func textFieldBegin(sender: UITextField) {
        
        let viewframe: CGRect = sender.convertRect(view.frame, toView: self.sv)
        let spaceY = ScreenHeight - viewframe.origin.y
        
        if(sender.tag == 4)//价格自动去掉RMB，
        {
            var orginStr=sender.text?.trim().uppercaseString;
            if(orginStr?.length > 0)
            {
                orginStr = orginStr?.stringByReplacingOccurrencesOfString("RMB", withString: "")
                orginStr = orginStr?.componentsSeparatedByString("/")[0]
                sender.text = orginStr
            }
            
        }
        
        if spaceY < 300 {
            self.sv.setContentOffset(CGPoint(x: 0, y: 345 - spaceY), animated: true)
        }
    }
    @IBAction func textFieldEnd(sender: UITextField) {
        
        if(sender.tag == 4) {
            
            var orginStr=sender.text?.trim().uppercaseString
            if orginStr?.length < 1 { return }
            
            orginStr = orginStr?.stringByReplacingOccurrencesOfString("RMB", withString: "")
            orginStr = orginStr?.componentsSeparatedByString("/")[0]
            if let originNumber = Double(orginStr!) {
                
                orginStr = NSString(format: "%.2f", originNumber) as String
            }
            orginStr = "RMB " + orginStr!
            sender.text = orginStr
            
            let unit: String = (self.sv.viewWithTag(5) as! UITextField).text!
            if unit.length < 1 { return }
            orginStr = orginStr! + "/" + unit
            sender.text = orginStr
            
        } else if (sender.tag == 5){
            
            let orginStr=sender.text?.trim()
            if orginStr?.length < 1 { return }
            
            let unitTextField: UITextField = self.sv.viewWithTag(4) as! UITextField
            var unit: String = unitTextField.text!
            if unit.length < 1 { return }
            unit = unit.componentsSeparatedByString("/")[0]
            unit = unit + "/" + orginStr!
            unitTextField.text = unit
            
        }
        self.sv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    

    
    
    //MARK: scrollViewDelegate: hidden keyboard
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.dismissKeyboard();
    }
    
    func dismissKeyboard()
    {
        self.txtAddress.resignFirstResponder();
        self.txtReciveName.resignFirstResponder();
        self.txtReviceArea.resignFirstResponder();
        self.txtReviceMobile.resignFirstResponder();
        self.locationView.hidden = true;
    }
    
    
    
}
