//
//  T07DeliverEditVC.swift
//  wishlink
//
//  Created by whj on 15/8/20.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T07DeliverEditVC: RootVC, CSDorpListViewDelegate,scanDelegate, WebRequestDelegate {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var scanTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    var dorpListView: CSDorpListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDorpListView()
    }
    
    func initDorpListView() {
        
        self.httpObj.mydelegate = self;
        
        var titles: NSArray = ["韵达快递","顺风快递","天天快递"]
        dorpListView = CSDorpListView.sharedInstance
        dorpListView.bindWithList(titles, delegate: self)
    }
    
    //MARK: - override
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        scanTextField.resignFirstResponder()
        companyTextField.resignFirstResponder()
    }
    
    //MARK: - Action
    
    @IBAction func btnAction(sender: UIButton) {
        
        var btnTag = sender.tag;
        if(btnTag == 10)//返回
        {
            self.navigationController?.popViewControllerAnimated(true);
//            self.dismissViewControllerAnimated(true, completion: nil);
        }
        else if(btnTag == 11)//提交
        {
            self.httpObj.httpPostApi("trade/deliver", parameters: ["company": companyTextField.text, "trackingId": scanTextField.text], tag: 70)
        }
    }
    
    @IBAction func textFieldEditEnd(sender: UITextField) {
        
        sender.resignFirstResponder()
    }
    
    
    @IBAction func scancompanyTextFieldButtonAction(sender: UIButton) {
        
        
        
        
        var btnTag = sender.tag;
        if(btnTag == 20) {//company
            dorpListView.show(companyTextField)
        } else if (btnTag == 21) {//scan
            
            var vc = ScanVC(nibName: "ScanVC", bundle: NSBundle.mainBundle())
            
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
        
        if(tag == 70) {
            self.navigationController?.popViewControllerAnimated(true);
            //             self.dismissViewControllerAnimated(true, completion: nil);
        }
    }
    
    func requestDataFailed(error: String) {
        
    }
}
