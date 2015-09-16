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

class U03AddAddressVC: RootVC, UITextFieldDelegate {
    
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
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        var alertView = UIAlertView(title: "温馨提示", message: "保存成功", delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func validateContent() -> Bool {
        return true
    }
    
    func fillDataForUI() {
        self.nameTextField.text = self.receiver.name
        self.phoneTextField.text = self.receiver.phone
        self.provinceTextField.text = self.receiver.province
        self.addressTextField.text = self.receiver.address
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
