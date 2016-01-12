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
    var trade:TradeModel!
    //MARK:Life Cycle
    deinit{
        
        NSLog("T07DeliverEditVC -->deinit")
        self.dorpListView = nil;
        
        self.dataArr = nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        initDorpListView()
    }
    
    func initDorpListView() {
        
        self.httpObj.mydelegate = self;
        
        let titles: NSArray = ["韵达快递","顺风快递","天天快递","圆通快递","中通快递","百世汇通","全峰快递","德邦物流","宅急送","速尔","EMS"]
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
        bindData();
//        SVProgressHUD.showWithStatusWithBlack("请稍后...")
//        self.httpObj.httpGetApi("user/get", parameters: ["registrationId":APPCONFIG.Uid], tag: 71)
    }
    
    //MARK: - Ibaction
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        scanTextField.resignFirstResponder()
        companyTextField.resignFirstResponder()
    }
    @IBAction func btnAction(sender: UIButton) {
        
        let btnTag = sender.tag;
        if(btnTag == 10)//返回
        {
            if self.navigationController == nil {
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }else {
                
                self.navigationController?.popViewControllerAnimated(true);
            }
        }
        else if(btnTag == 11)//提交
        {
            var para = ["_id":self.trade._id,"company": companyTextField.text!, "trackingId": scanTextField.text!]
            
            self.httpObj.httpPostApi("trade/deliver", parameters: para, tag: 70)
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
    
    func bindData()
    {
        if(self.trade != nil && self.trade.receiver != nil) {
        
          
            self.phoneLabel.text = self.trade.receiver.phone
            self.personLabel.text = self.trade.receiver.name;
            self.addressLabel.text = "\(self.trade.receiver.province + " " + self.trade.receiver.address)"
       }
    }


    //MARK: - CSDorpListViewDelegate
    func dorpListButtonItemAction(sender: UIButton!) {
        companyTextField.text = sender.titleLabel?.text
    }
    
    //MARK: - Request delegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        print(response, terminator: "")
        
        if(tag == 70) {
            
            let tradeData = (response as! NSDictionary).objectForKey("trade")
            if tradeData != nil {
                self.trade = TradeModel(dict: tradeData as! NSDictionary)
                
                NotificationCenter.postNotificationName(APPCONFIG.TradeStatusChange_NotifKey, object: self.trade );
            }
//            self.navigationController?.popViewControllerAnimated(true);
             self.dismissViewControllerAnimated(true, completion: nil);
        }
//        else if(tag == 71) {
//        
//            SVProgressHUD.dismiss();
//            UserModel.shared.userDic = response["user"] as! [String: AnyObject]
//            
//            let result = UserModel.shared.receiversArray.filter{itemObj -> Bool in
//                return (itemObj as ReceiverModel).isDefault == true;
//            }
//            
//            if(result.count>0) {
//                
//                let defaultAddress = result[0] as ReceiverModel
//                self.phoneLabel.text = defaultAddress.phone
//                self.personLabel.text = defaultAddress.name;
//                self.addressLabel.text = defaultAddress.address;
//            }
//        }
    }
    
    
    
    func requestDataFailed(error: String,tag:Int) {
        SVProgressHUD.showErrorWithStatusWithBlack("获取用户信息失败！");
    }
}
