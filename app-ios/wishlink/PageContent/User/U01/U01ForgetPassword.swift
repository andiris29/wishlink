//
//  U01ForgetPassword.swift
//  wishlink
//
//  Created by whj on 15/11/18.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class U01ForgetPassword: RootVC, WebRequestDelegate {

    @IBOutlet weak var inputFillView: UIView!
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var phonecheckTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var lb_VerifyWaitSecond: UILabel!
    @IBOutlet weak var view_verifyMask: UIView!
    @IBOutlet weak var btnSendVerifyCode: UIButton!
    
    var isRegisterModel = true;
    var verifyCode = "";
    var timer:NSTimer!
    var VerifyWaitSecond = 0;// 验证码发送时间间隔
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        self.initView()
    }
    
    deinit
    {
        NSLog("U01ForgetPassword deinit");
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
        
        self.view_verifyMask.hidden = true
    }
    
    func initData() {
        
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
        
        self.phoneTextField.resignFirstResponder()
        self.phonecheckTextField.resignFirstResponder()
    }
    
    
    // MARK: - Action
    
    @IBAction func backButtonAction(sender: UIButton) {
        
        self.backToLoginPage(false)
    }
    
    func backToLoginPage(isSuccess:Bool) {
        
        self.scrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if(self.timer != nil)
        {
            self.removeTimer()
            self.timer = nil
        }
        
        if(isSuccess) {
        }
        self.dismissViewControllerAnimated(true) { () -> Void in }
    }
    
    @IBAction func registerButtonAction(sender: UIButton) {
  
        if( self.phoneTextField.text?.trim().length == 0)
        {
            UIHEPLER.alertErrMsg("手机号不能为空。")
            return
        }
        
        if !UIHEPLER.checkPhone(self.phoneTextField.text!) {
            UIHEPLER.alertErrMsg("请输入正确的手机号码")
            return
        }
        
        if( self.phonecheckTextField.text?.trim().length == 0)
        {
            UIHEPLER.alertErrMsg("验证码不能为空。")
            return
        }
        
        
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        
        let phone = self.phoneTextField.text!
        let verifyCode = self.phonecheckTextField.text!
        
        let para = ["mobile": phone, "code": verifyCode]
        self.httpObj.httpPostApi("user/", parameters: para, tag: 121)
        
    }
    
    @IBAction func sendVerificationCodeButtonAction(sender: UIButton) {
        
        
        if(self.phoneTextField.text?.trim().length == 0)
        {
            UIHEPLER.alertErrMsg("手机号不能为空。")
            return;
        }
        
        if !UIHEPLER.checkPhone(self.phoneTextField.text!) {
            UIHEPLER.alertErrMsg("请输入正确的手机号码")
            return
        }
    
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        
        let phone = self.phoneTextField.text!
        let para = ["mobile": phone]
        self.httpObj.httpPostApi("user/requestBindMobile", parameters: para, tag: 122)
    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if tag == 121 {
            
            print(response)
            self.backToLoginPage(true)
            
        } else if tag == 122 { // 发送验证码
            
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
