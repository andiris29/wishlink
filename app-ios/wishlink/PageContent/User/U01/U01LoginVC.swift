//
//  U01LoginVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

let WBLoginSuccessNotification: String = "WBLoginSuccess"
let WXLoginSuccessNotification: String = "WXLoginSuccess"
let LoginSuccessNotification: String = "LoginSuccess"

class U01LoginVC: RootVC,WebRequestDelegate {
    
    @IBOutlet weak var inputFillView: UIView!
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
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
        print("跳过")
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func forgotPasswordButtonAction(sender: AnyObject) {
    }
    
    @IBAction func registerButtonAction(sender: AnyObject) {
        
        let regsiterVC = U01RegsiterVC(nibName: "U01RegsiterVC", bundle: NSBundle.mainBundle())
        self.presentViewController(regsiterVC, animated: true) { () -> Void in
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
            self.httpObj.httpPostApi("user/login", parameters: ["nickname": userName!, "password": pwd!], tag: 10)
        }
        userName = nil;
        pwd = nil;
    }
    
    // MARK: - prive method
    
    func wbLogin() {
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        var registrationId = ""
        if APService.registrationID() != nil {
            registrationId = APService.registrationID()
        }
        let parametersDic = [
            "access_token" : self.wbToekn,
            "uid" : self.wbUserID,
            "registrationId" : registrationId]
        print(parametersDic)
        self.httpObj.httpPostApi("user/loginViaWeibo", parameters: parametersDic, tag: 10)
    }
    @IBAction func testLoginAction(sender: AnyObject) {
        
        self.httpObj.httpPostApi("user/login", parameters: ["nickname": "12345678901", "password": "testtest"], tag: 10)
    }
    
    func wxLogin() {
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        var registrationId = ""
        if APService.registrationID().length != 0 {
            registrationId = APService.registrationID()
        }
        let parametersDic = [
            "code" : self.wxCode,
            "registrationId" : registrationId]
        self.httpObj.httpPostApi("user/loginViaWeixin", parameters: parametersDic, tag: 20)
    }
    
    func registerNotification() {
        NSNotificationCenter.defaultCenter().addObserverForName(WBLoginSuccessNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) in
            
            
            let temp = noti.object as! WBAuthorizeResponse
            if temp.statusCode == .Success {
                self.wbToekn = temp.accessToken
                self.wbUserID = temp.userID
                self.wbLogin()
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(WXLoginSuccessNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) -> Void in
            let temp = noti.object as! SendAuthResp
            print("\(temp.errCode)")
            if temp.errCode != -2 {
                self.wxCode = temp.code
                self.wxLogin()
            }
            
        }
    }
    
    func parseUserData(data: AnyObject!) {
        NSHTTPCookieStorage.sharedHTTPCookieStorage().cookieAcceptPolicy = .Always
        SVProgressHUD.dismiss();
        UserModel.shared.userDic = data["user"] as! [String: AnyObject]
        
        //存储用户ID
        APPCONFIG.Uid = UserModel.shared._id;
        print(data)
    }
    
    // MARK: - setter and getter

    //MARK:WebRequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {

        self.parseUserData(response)
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(LoginSuccessNotification, object: nil)
            SVProgressHUD.dismiss();
            self.dismissViewControllerAnimated(true, completion: nil);
        })
    }
    func requestDataFailed(error: String,tag:Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIHEPLER.alertErrMsg(error);
            SVProgressHUD.dismiss();
        })
        
        
    }
}
