//
//  U01RegsiterVC.swift
//  wishlink
//
//  Created by whj on 15/10/31.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class U01RegsiterVC: RootVC, WebRequestDelegate {

    @IBOutlet weak var inputFillView: UIView!
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phonecheckTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initView()
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
     
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func registerButtonAction(sender: UIButton) {
    
    }
    
    @IBAction func sendVerificationCodeButtonAction(sender: UIButton) {
        
    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
    }
    
    func requestDataFailed(error: String) {
        
    }
}
