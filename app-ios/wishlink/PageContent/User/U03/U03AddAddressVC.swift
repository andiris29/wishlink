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

class U03AddAddressVC: RootVC, UITextFieldDelegate, WebRequestDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var locationPickView: UIPickerView!
    
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
    
    var provinceDic: NSDictionary!
    var cityDic: NSDictionary!
    var districtDic: NSDictionary!
    var provinceCodeArray: [String] = []
    var cityArray: [[String]] = []
    var districArray: [[String]] = []
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self
        self.prepareNav()
        self.prepareData()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.hidden = false
        self.fillDataForUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init?(coder aDecoder: NSCoder) {
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
                let alertView = UIAlertView(title: "温馨提示", message: "保存成功", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
                self.navigationController!.popViewControllerAnimated(true)
            })
            
        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
        })
    }
    
    //MARK: textField DELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.nameTextField {
            self.phoneTextField.becomeFirstResponder()
        }else if textField == self.phoneTextField {
//            self.provinceTextField.becomeFirstResponder()
            self.view.endEditing(true)
            self.locationPickView.hidden = false
            self.locationTextField.text = self.locationString()
        }else if textField == self.locationTextField {
            self.addressTextField.becomeFirstResponder()

        }
        else {
            self.saveBtnAction(self.saveBtn)
        }
        return true
    }
    
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
        self.locationTextField.text = self.locationString()
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
    
    // MARK: - response event
    func saveBtnAction(sender: AnyObject) {
        if self.validateContent() == false {
            return
        }
        self.saveAddress()
    }
    
    @IBAction func locationBtnAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.locationPickView.hidden = false
        self.locationTextField.text = self.locationString()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        self.locationPickView.hidden = true
    }
    
    // MARK: - prive method
    
    func saveAddress() {
        // TODO 本地数据
        var dic: [String: AnyObject]
        if self.operationType == .Add {
            dic = [
                "name": self.nameTextField.text!,
                "phone": self.phoneTextField.text!,
                "province": self.locationTextField.text!,
                "address": self.addressTextField.text!]
        }
        else {
            dic = [
                "uuid": "",
                "name": self.nameTextField.text!,
                "phone": self.phoneTextField.text!,
                "province": self.locationTextField.text!,
                "address": self.addressTextField.text!,
                "isDefault": NSNumber(bool: false)]
        }
        
        
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        self.httpObj.httpPostApi("user/saveReceiver", parameters: dic, tag: 10)
//        self.receiver.name = self.nameTextField.text
//        self.receiver.phone = self.phoneTextField.text
//        self.receiver.province = self.provinceTextField.text
//        self.receiver.address = self.addressTextField.text
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
        if self.nameTextField.text!.length == 0 {
            msg = "姓名不能为空"
        } else if self.phoneTextField.text!.length == 0 {
            msg = "电话不能为空"
        } else if self.locationTextField.text!.length == 0 {
            msg = "地区不能为空"
        }else if self.addressTextField.text!.length == 0{
            msg = "地址不能为空"
        }else {
            
        }
        if msg.length == 0 {
            return true
        }else {
            let alertView = UIAlertView(title: "温馨提示", message: msg, delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return false
        }
    }
    
    func fillDataForUI() {
        self.nameTextField.text = self.receiver.name
        self.phoneTextField.text = self.receiver.phone
        self.locationTextField.text = self.receiver.province
        self.addressTextField.text = self.receiver.address
    }
    
    func prepareData() {
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
    
    func prepareNav() {
        if self.operationType == .Add {
            self.loadComNavTitle("新增地址")
        }
        else {
            self.loadComNavTitle("编辑地址")

        }
        self.loadComNaviLeftBtn()
        let rightBtn = UIButton(type: .Custom)
        rightBtn.frame = CGRectMake(0, 0, 60, 44)
        rightBtn.setTitleColor(RGB(248, g: 74, b: 102), forState: .Normal)
        rightBtn.setTitle("保存", forState: .Normal)
        rightBtn.titleLabel!.font = UIFont.systemFontOfSize(13)
        rightBtn.contentHorizontalAlignment = .Right
        rightBtn.addTarget(self, action: "saveBtnAction:", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        self.saveBtn = rightBtn
    }
    
    // MARK: - setter and getter

}
