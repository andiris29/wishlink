//
//  U01ResetPasswordVC.swift
//  wishlink
//
//  Created by whj on 15/12/26.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class U01ResetPasswordVC: RootVC, WebRequestDelegate {

    
    @IBOutlet weak var inputFillView: UIView!
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        self.initView()
    }
    
    deinit
    {
        NSLog("U01ResetPasswordVC deinit");
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.hidden = true
    }
    
    func initView() {
        
        self.inputFillView.layer.borderColor = RGBC(125).CGColor
        self.inputFillView.layer.borderWidth = 1.0
        self.inputFillView.layer.masksToBounds = true
        self.inputFillView.layer.cornerRadius = 5.0
        
        self.resetButton.layer.masksToBounds = true
        self.resetButton.layer.cornerRadius = 5.0
    }
    
    func initData() {
        
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
        
        self.passwordTextField.resignFirstResponder()
    }
    
    
    // MARK: - Action
    
    @IBAction func backButtonAction(sender: UIButton) {
        
        self.backToLoginPage(false)
    }
    
    func backToLoginPage(isSuccess:Bool) {
        
        self.scrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        if(isSuccess) {
        }
        self.dismissViewControllerAnimated(true) { () -> Void in }
    }
    
    @IBAction func resetButtonAction(sender: UIButton) {
        
        if( self.passwordTextField.text?.trim().length == 0)
        {
            UIHEPLER.alertErrMsg("密码不能为空。")
            return
        }
        
        
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        
        let phone = self.passwordTextField.text!
        
        let para = ["password": phone]
        self.httpObj.httpPostApi("user/", parameters: para, tag: 150)
        
    }

    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if tag == 150 {
            
            SVProgressHUD.dismiss();
            self.backToLoginPage(true)
        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        print(error);
        SVProgressHUD.showErrorWithStatusWithBlack(error);
        
    }
    
}
