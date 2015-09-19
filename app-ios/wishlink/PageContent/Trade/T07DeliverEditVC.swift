//
//  T07DeliverEditVC.swift
//  wishlink
//
//  Created by whj on 15/8/20.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T07DeliverEditVC: RootVC, CSDorpListViewDelegate {

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
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        else if(btnTag == 11)//提交
        {
             self.dismissViewControllerAnimated(true, completion: nil);
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
            
        }
    }

    //MARK: - CSDorpListViewDelegate
    
    func dorpListButtonItemAction(sender: UIButton!) {
        
        companyTextField.text = sender.titleLabel?.text
    }
    
}
