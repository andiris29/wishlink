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

class U01LoginVC: RootVC,WebRequestDelegate {
    
    
    @IBOutlet weak var skipBtn: UIButton!
    
    var wxCode: String!
    var wbToekn: String!
    var wbUserID: String!
    var hideSkipBtn: Bool = false
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.httpObj.mydelegate = self
        NSNotificationCenter.defaultCenter().addObserverForName(WBLoginSuccessNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) in
            let temp = noti.object as! WBAuthorizeResponse
            self.wbToekn = temp.accessToken
            self.wbUserID = temp.userID
            self.wbLogin()
        }
        NSNotificationCenter.defaultCenter().addObserverForName(WXLoginSuccessNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) -> Void in
            let temp = noti.object as! SendAuthResp
            self.wxCode = temp.code
            self.wxLogin()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.skipBtn.hidden = self.hideSkipBtn
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - delegate
    // MARK: - response event
    
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
        self.httpObj.httpPostApi("user/login", parameters: ["nickname": "testtest", "password": "testtest"], tag: 10)
        
        return
        let request = WBAuthorizeRequest()
        request.scope = "all"
        request.redirectURI = AppConfig.wbRedirectURI
        WeiboSDK.sendRequest(request)
    }
    
    
    @IBAction func skipAction(sender: AnyObject) {
        print("跳过")
        APPCONFIG.AccessToken = "temp_token";
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: - prive method
    
    func wbLogin() {
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        var registrationId = "1234"
        if APService.registrationID() != nil {
            registrationId = APService.registrationID()
        }
        let parametersDic = [
            "access_token" : self.wbToekn,
            "uid" : self.wbUserID,
            "registrationId" : registrationId]
        self.httpObj.httpPostApi("user/loginViaWeibo", parameters: parametersDic, tag: 10)
    }
    
    func wxLogin() {
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        var registrationId = "1234"
        if APService.registrationID().length != 0 {
            registrationId = APService.registrationID()
        }
        let parametersDic = [
            "code" : self.wxCode,
            "registrationId" : registrationId]
        self.httpObj.httpPostApi("user/loginViaWeixin", parameters: parametersDic, tag: 20)
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
        if tag == 10 {
            self.parseUserData(response)
        }else if tag == 20 {
            self.parseUserData(response)
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss();
            self.dismissViewControllerAnimated(true, completion: nil);
        })
    }
    func requestDataFailed(error: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIHEPLER.alertErrMsg(error);
            SVProgressHUD.dismiss();
        })
        
        
    }
}
