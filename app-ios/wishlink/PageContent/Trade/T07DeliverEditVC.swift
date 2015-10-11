//
//  T07DeliverEditVC.swift
//  wishlink
//
//  Created by whj on 15/8/20.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T07DeliverEditVC: RootVC, CSDorpListViewDelegate,scanDelegate, WebRequestDelegate {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var scanTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    var dorpListView: CSDorpListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        initDorpListView()
    }
    
    func initDorpListView() {
        
        self.httpObj.mydelegate = self;
        
        let titles: NSArray = ["韵达快递","顺风快递","天天快递"]
        dorpListView = CSDorpListView.sharedInstance
        dorpListView.bindWithList(titles, delegate: self)
    }
    
    func loadData() {
        
        //clear
        self.phoneLabel.text = ""
        self.personLabel.text = ""
        self.addressLabel.text = ""
        self.scanTextField.text = ""
        self.companyTextField.text = ""
        
        self.httpObj.mydelegate = self;
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        self.httpObj.httpGetApi("user/get", parameters: ["registrationId":APPCONFIG.Uid], tag: 71)
    }
    
    //MARK: - override
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        scanTextField.resignFirstResponder()
        companyTextField.resignFirstResponder()
    }
    
    //MARK: - Action
    
    @IBAction func btnAction(sender: UIButton) {
        
        let btnTag = sender.tag;
        if(btnTag == 10)//返回
        {
            self.navigationController?.popViewControllerAnimated(true);
//            self.dismissViewControllerAnimated(true, completion: nil);
        }
        else if(btnTag == 11)//提交
        {
            self.httpObj.httpPostApi("trade/deliver", parameters: ["company": companyTextField.text!, "trackingId": scanTextField.text!], tag: 70)
        }
    }
    
    @IBAction func textFieldEditEnd(sender: UITextField) {
        
        sender.resignFirstResponder()
    }
    
    
    @IBAction func scancompanyTextFieldButtonAction(sender: UIButton) {
        
        
        
        
        let btnTag = sender.tag;
        if(btnTag == 20) {//company
            dorpListView.show(companyTextField)
        } else if (btnTag == 21) {//scan
            
            let vc = ScanVC(nibName: "ScanVC", bundle: NSBundle.mainBundle())
            
            vc.myDelegate = self;
            self.navigationController?.pushViewController(vc, animated: true)
 
        }
    }
    func scanCodeResult(code:String)
    {
        self.scanTextField.text = code;
    }


    //MARK: - CSDorpListViewDelegate
    
    func dorpListButtonItemAction(sender: UIButton!) {
        
        companyTextField.text = sender.titleLabel?.text
    }
    
    //MARK: - Request delegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        print(response, terminator: "")
        
        if(tag == 70) {
            self.navigationController?.popViewControllerAnimated(true);
            //             self.dismissViewControllerAnimated(true, completion: nil);
        } else if(tag == 71) {
        
            SVProgressHUD.dismiss();
            UserModel.shared.userDic = response["user"] as! [String: AnyObject]
            
            let result = UserModel.shared.receiversArray.filter{itemObj -> Bool in
                return (itemObj as ReceiverModel).isDefault == true;
            }
            
            if(result.count>0) {
                
                let defaultAddress = result[0] as ReceiverModel
                
                self.phoneLabel.text = defaultAddress.phone
                self.personLabel.text = defaultAddress.name;
                self.addressLabel.text = defaultAddress.address;
                
            }
        }
    }
    
    func requestDataFailed(error: String) {
        
        SVProgressHUD.showErrorWithStatusWithBlack("获取用户信息失败！");
    }
}
