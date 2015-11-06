//
//  U06RegsiterVC.swift
//  wishlink
//
//  Created by whj on 15/10/31.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class U06RegsiterVC: RootVC, WebRequestDelegate {

    @IBOutlet weak var inputFillView: UIView!
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phonecheckTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var lb_VerifyWaitSecond: UILabel!
    @IBOutlet weak var view_verifyMask: UIView!
    @IBOutlet weak var btnSendVerifyCode: UIButton!
    var isRegisterModel = true;
    var verifyCode = "";
    var timer:NSTimer!

    var VerifyWaitSecond = 0;//验证码发送时间间隔
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_verifyMask.hidden = true;
    
        self.initData()
        self.initView()
    }
    deinit
    {
        NSLog("U06RegsiterVC deinit");
        self.timer = nil;
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.hidden = true
    }
    
    func initView() {
    
        self.inputFillView.layer.borderColor = RGBC(125).CGColor
        self.inputFillView.layer.borderWidth = 1.0
        self.inputFillView.layer.masksToBounds = true
        self.inputFillView.layer.cornerRadius = 5.0
        
        self.registerButton.layer.masksToBounds = true
        self.registerButton.layer.cornerRadius = 5.0
    }
    
    func initData() {
        if(!self.isRegisterModel)
        {
            self.registerButton.setTitle("绑定", forState:UIControlState.Normal );
            
        }
        
        self.verifyCode = "";
        self.httpObj.mydelegate = self
    }

    // MARK: - UITextfield
    
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
        
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.phoneTextField.resignFirstResponder()
        self.phonecheckTextField.resignFirstResponder()
    }
    
    
    // MARK: - Action
    
    @IBAction func backButtonAction(sender: UIButton) {
     
        self.backToLoginPage();
    }
    func backToLoginPage()
    {
        
        self.scrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if(self.timer != nil)
        {
            self.removeTimer();
            self.timer = nil;
        }
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
        
    }
    
    @IBAction func registerButtonAction(sender: UIButton) {
        
        
        if( self.usernameTextField.text?.trim().length == 0)
        {
            UIHEPLER.alertErrMsg("用户昵称不能为空。")
             return
        }
        
        if( self.passwordTextField.text?.trim().length == 0)
        {
             UIHEPLER.alertErrMsg("密码不能为空。")
             return
        }
        if( self.phoneTextField.text?.trim().length == 0)
        {
              UIHEPLER.alertErrMsg("手机号不能为空。")
             return
        }
        if( self.phonecheckTextField.text?.trim().length == 0)
        {
              UIHEPLER.alertErrMsg("验证码不能为空。")
             return
        }
//        
//        let username = self.usernameTextField.text!
//        
//        
//        guard let password = self.passwordTextField.text else {
//            SVProgressHUD.showWithStatusWithBlack("密码不能为空。")
//            return
//        }
//        
//        guard let phone = self.phoneTextField.text else {
//            SVProgressHUD.showWithStatusWithBlack("手机号不能为空。")
//            return
//        }
        
         let _verifyCode = self.phonecheckTextField.text!
        
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        let parameters = ["code": _verifyCode]
        self.httpObj.httpPostApi("user/bindMobile", parameters: parameters, tag: 101)
        
    }
    
    @IBAction func sendVerificationCodeButtonAction(sender: UIButton) {
        
        
        if( self.phoneTextField.text?.trim().length == 0)
        {
             UIHEPLER.alertErrMsg("手机号不能为空。")
            return;
        }
         let phone = self.phoneTextField.text!
        
     
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        let para = ["mobile": phone]
        self.httpObj.httpPostApi("user/requestBindMobile", parameters: para, tag: 102)
    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if tag == 100 {//注册接口回调
            
            SVProgressHUD.dismiss();
            print(response);//注册成功
            if let userDic = response as? NSDictionary//注册用户信息成功
            {
                print(userDic);
                UIHEPLER.alertErrMsg("注册账户成功！");
                
                self.backToLoginPage();
            }

        } else if tag == 101 {//根据验证码绑定手机号
            print(response);
             let username = self.usernameTextField.text!
             let password = self.passwordTextField.text!
             let phone = self.phoneTextField.text!
            
            let para = ["nickname": username, "password": password, "mobile": phone]
            self.httpObj.httpPostApi("user/register", parameters: para, tag: 100)

            
        } else if tag == 102 {//发送验证码
         
            SVProgressHUD.dismiss();
            if let  reDic = response as? NSDictionary
            {
                if(reDic.count>0)
                {
                    verifyCode =   reDic.objectForKey("code") as! String;
                  
                }
            }
            self.startTimer();
            
        }
        
    }
    
    func requestDataFailed(error: String,tag:Int) {
        print(error);
        SVProgressHUD.showErrorWithStatusWithBlack(error);

    }
    
    //MARK:Timer method
    func startTimer()
    {
        VerifyWaitSecond = APPCONFIG.defaultWaitSecond;
        
        print("startTimer")
        self.view_verifyMask.hidden = false;
        self.lb_VerifyWaitSecond.text = String(VerifyWaitSecond)
        
        btnSendVerifyCode.enabled = false;

        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:Selector("changeResendTime"), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func changeResendTime()
    {
        if(VerifyWaitSecond <= 0 )
        {
            if(!btnSendVerifyCode.enabled)
            {
                self.removeTimer()
            }
        }
        else
        {
            VerifyWaitSecond--;
            self.lb_VerifyWaitSecond.text = String(VerifyWaitSecond)
        }
        
    }
    
    
    func removeTimer()
    {
        print("removeTimer")
        self.view_verifyMask.hidden = true;
        btnSendVerifyCode.enabled = true

        timer.invalidate();
        timer = nil;
    }
    

}
