//
//  U03AddAddressVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/24/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum AddAddressVCOperationType {
    case Add, Edit
}

class U03AddAddressVC: RootVC, UITextFieldDelegate, WebRequestDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var provinceTextField: UITextField!

    @IBOutlet weak var addressTextField: UITextField!
    
    var saveBtn: UIButton!
    
    var operationType: AddAddressVCOperationType! {
        didSet {
            if self.operationType == .Add {
                self.receiver = ReceiverModel();
            }
        }
    }
    var receiver: ReceiverModel!
    
    var callBackClosure: ((AddAddressVCOperationType, ReceiverModel) -> Void)?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self
        self.prepareNav()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fillDataForUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - delegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
        })
        if tag == 10 {
            UserModel.shared.userDic = response["user"] as! [String: AnyObject]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var alertView = UIAlertView(title: "温馨提示", message: "保存成功", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
                self.navigationController!.popViewControllerAnimated(true)
            })
            
        }
    }
    
    func requestDataFailed(error: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.nameTextField {
            self.phoneTextField.becomeFirstResponder()
        }else if textField == self.phoneTextField {
//            self.provinceTextField.becomeFirstResponder()

        }else if textField == self.provinceTextField {
            self.addressTextField.becomeFirstResponder()

        }
        else {
            self.saveBtnAction(self.saveBtn)
        }
        return true
    }
    
    // MARK: - response event
    func saveBtnAction(sender: AnyObject) {
        if self.validateContent() == false {
            return
        }
        self.saveAddress()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // MARK: - prive method
    
    func saveAddress() {
        // TODO 本地数据
        var dic: [String: AnyObject]
        if self.operationType == .Add {
            dic = [
                "name": self.nameTextField.text,
                "phone": self.phoneTextField.text,
                "province": self.provinceTextField.text,
                "address": self.addressTextField.text]
        }
        else {
            dic = [
                "uuid": "",
                "name": self.nameTextField.text,
                "phone": self.phoneTextField.text,
                "province": self.provinceTextField.text,
                "address": self.addressTextField.text,
                "isDefault": NSNumber(bool: false)]
        }
        
        
        SVProgressHUD.showSuccessWithStatusWithBlack("请稍等...")
        self.httpObj.httpPostApi("user/saveReceiver", parameters: dic, tag: 10)
//        self.receiver.name = self.nameTextField.text
//        self.receiver.phone = self.phoneTextField.text
//        self.receiver.province = self.provinceTextField.text
//        self.receiver.address = self.addressTextField.text
    }
    
    func validateContent() -> Bool {
        var msg = ""
        if self.nameTextField.text.length == 0 {
            msg = "姓名不能为空"
        } else if self.phoneTextField.text.length == 0 {
            msg = "电话不能为空"
        } else if self.provinceTextField.text.length == 0 {
            msg = "地区不能为空"
        }else if self.addressTextField.text.length == 0{
            msg = "地址不能为空"
        }else {
            
        }
        if msg.length == 0 {
            return true
        }else {
            var alertView = UIAlertView(title: "温馨提示", message: msg, delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return false
        }
    }
    
    func fillDataForUI() {
        self.nameTextField.text = self.receiver.name
        self.phoneTextField.text = self.receiver.phone
        self.provinceTextField.text = self.receiver.province
        self.addressTextField.text = self.receiver.address
        
        // TODO test inputting
        self.nameTextField.text = "黄悦"
        self.provinceTextField.text = "上海"
        self.phoneTextField.text = "18815287600"
        self.addressTextField.text = "杨浦"
    }
    
    func prepareNav() {
        if self.operationType == .Add {
            self.loadComNavTitle("新增地址")
        }
        else {
            self.loadComNavTitle("编辑地址")

        }
        self.loadComNaviLeftBtn()
        var rightBtn = UIButton.buttonWithType(.Custom) as! UIButton
        rightBtn.frame = CGRectMake(0, 0, 60, 44)
        rightBtn.setTitleColor(UIColor.redColor(), forState: .Normal)
        rightBtn.setTitle("保存", forState: .Normal)
        rightBtn.titleLabel!.font = UIFont.systemFontOfSize(13)
        rightBtn.contentHorizontalAlignment = .Right
        rightBtn.addTarget(self, action: "saveBtnAction:", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        self.saveBtn = rightBtn
    }
    
    // MARK: - setter and getter

}
