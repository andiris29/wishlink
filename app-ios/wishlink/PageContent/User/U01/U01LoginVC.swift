//
//  U01LoginVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

let WBloginSuccessNotification: String = "WBLoginSuccess"
let WXloginSuccessNotification: String = "WXLoginSuccess"
let LoginSuccessNotification: String = "LoginSuccess"
let RegisterSuccessNotification: String = "RegisterSuccess"

class U01LoginVC: RootVC,WebRequestDelegate {
    
    @IBOutlet weak var inputFillView: UIView!
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    var nextVC:UIViewController!
    var wxCode: String!
    var wbToekn: String!
    var wbUserID: String!
    var hideSkipBtn: Bool = false {
        didSet {
            if self.skipBtn != nil {
                self.skipBtn.hidden = self.hideSkipBtn
            }
        }
    }
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.httpObj.mydelegate = self
        self.registerNotification()
        
        self.initView()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
    
        self.inputFillView.layer.borderColor = RGBC(125).CGColor
        self.inputFillView.layer.borderWidth = 1.0
        self.inputFillView.layer.masksToBounds = true
        self.inputFillView.layer.cornerRadius = 5.0
        
        self.registerBtn.layer.masksToBounds = true
        self.registerBtn.layer.cornerRadius = 5.0
        
        self.loginBtn.layer.masksToBounds = true
        self.loginBtn.layer.cornerRadius = 5.0
    }
    
    // MARK: - delegate
    // MARK: - response event
    
    @IBAction func textFieldBegin(sender: UITextField) {
        
        let viewframe: CGRect = sender.convertRect(view.frame, toView: self.scrollerView)
        let spaceY = ScreenHeight - viewframe.origin.y
        
        if spaceY < 300 {
            self.scrollerView.setContentOffset(CGPoint(x: 0, y: 345 - spaceY), animated: true)
        }
    }
    
    @IBAction func textFieldEnd(sender: UITextField) {
        
        self.scrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func tapScollerViewAction(sender: AnyObject) {
        
        self.userNameTextField.resignFirstResponder()
        self.passWordTextField.resignFirstResponder()
    }
    
    @IBAction func weiXinLoginAction(sender: AnyObject) {
        
        if WXApi.isWXAppInstalled() == false {
            UIHEPLER.alertErrMsg("未安装微信")
            return
        }
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo,snsapi_base"
        req.state = "wishlink"
        WXApi.sendReq(req)
         //发送登录请求
        
    }
    
    
    @IBAction func weiBoLoginAction(sender: AnyObject) {
//        self.httpObj.httpPostApi("user/login", parameters: ["nickname": "testtest", "password": "testtest"], tag: 10)
//        
//        return
        let request = WBAuthorizeRequest()
        request.scope = "all"
        request.redirectURI = AppConfig.wbRedirectURI
        WeiboSDK.sendRequest(request)
    }
    
    
    @IBAction func skipAction(sender: AnyObject) {
    
        
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func forgotPasswordButtonAction(sender: AnyObject) {
        
        self.nextVC = U01ForgetPassword(nibName: "U01ForgetPassword", bundle: NSBundle.mainBundle())
        
        self.presentViewController( self.nextVC, animated: true) { () -> Void in
        }
    }
    
    @IBAction func registerButtonAction(sender: AnyObject) {
        
        if(self.nextVC != nil)
        {
            self.nextVC = nil;
        }

        self.nextVC = U06RegsiterVC(nibName: "U06RegsiterVC", bundle: NSBundle.mainBundle())

        self.presentViewController( self.nextVC, animated: true) { () -> Void in
        }
    }
    
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        
        var userName = self.userNameTextField.text?.trim();
        var pwd = self.passWordTextField.text?.trim();
        
        if(userName?.trim().length == 0 || pwd?.trim().length == 0)
        {
            UIHEPLER.alertErrMsg("请输入用户名和密码")
        }
        else
        {
            self.httpObj.httpPostApi("user/login", parameters: ["mobile": userName!, "password": pwd!], tag: 10)
        }
        userName = nil;
        pwd = nil;
    }
    
    // MARK: - prive method
    
    func wbLogin() {
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        var registrationId = ""
        var rid = APService.registrationID()
        if  rid != nil {
            registrationId = rid
            rid = nil;
        }
        let parametersDic = [
            "access_token" : self.wbToekn,
            "uid" : self.wbUserID,
            "registrationId" : registrationId]
        print(parametersDic)
        self.httpObj.httpPostApi("user/loginViaWeibo", parameters: parametersDic, tag: 10)
    }
    @IBAction func testLoginAction(sender: AnyObject) {
        
        self.httpObj.httpPostApi("user/login", parameters: ["mobile": "18601746164", "password": "123456"], tag: 10)
    }
    
    func wxLogin() {
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        var registrationId = ""
        var rid = APService.registrationID()
        if rid.length != 0 {
            registrationId = rid
        }
        let parametersDic = [
            "code" : self.wxCode,
            "registrationId" : registrationId]
        self.httpObj.httpPostApi("user/loginViaWeixin", parameters: parametersDic, tag: 20)
    }
    
    func registerNotification() {
        NSNotificationCenter.defaultCenter().addObserverForName(WBloginSuccessNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) in
            
            
            let temp = noti.object as! WBAuthorizeResponse
            if temp.statusCode == .Success {
                self.wbToekn = temp.accessToken
                self.wbUserID = temp.userID
                self.wbLogin()
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(WXloginSuccessNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) -> Void in
            let temp = noti.object as! SendAuthResp
            print("\(temp.errCode)")
            if temp.errCode != -2 {
                self.wxCode = temp.code
                self.wxLogin()
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(RegisterSuccessNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) -> Void in
            
           
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
               
                if(self.nextVC != nil)
                {
                    self.nextVC = nil;
                }
            });
            
        }

    }
    

    
    // MARK: - setter and getter

    //MARK:WebRequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {

     
    
        print(response)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().cookieAcceptPolicy = .Always
        SVProgressHUD.dismiss();
        UserModel.shared.userDic = response["user"] as! [String: AnyObject]
        //存储用户ID
        APPCONFIG.Uid = UserModel.shared._id;
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(LoginSuccessNotification, object: nil)
            
        })
        if(tag == 10 || tag == 20)
        {
            if(!UserModel.shared.isLogin)
            {
                if(self.nextVC != nil)
                {
                    self.nextVC = nil;
                }
                var vc:U06RegsiterVC! = U06RegsiterVC(nibName: "U06RegsiterVC", bundle: NSBundle.mainBundle())
                vc.isRegisterModel = false
                self.nextVC = vc;
                self.presentViewController( self.nextVC, animated: true) { () -> Void in
                }
                vc = nil;
            }
            else
            {
                self.dismissViewControllerAnimated(true, completion: nil);
            }
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
    }
    func requestDataFailed(error: String,tag:Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIHEPLER.alertErrMsg(error);
            SVProgressHUD.dismiss();
        })
        
        
    }
}
