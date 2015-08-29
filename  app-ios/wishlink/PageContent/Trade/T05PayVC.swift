//
//  T05PayVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T05PayVC: RootVC {
    
    let selectedButtonWXTag: Int = 1000
    let selectedButtonZFBTag: Int = 1001
    
    let increingButtonTag: Int = 2001
    let declineButtonTag: Int = 2000
    
    var goodsNumbers: Int = 0

    @IBOutlet weak var numbersTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false;
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("发布新订单")
    }
    
    @IBAction func selectedButtonPay(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        if sender.tag == selectedButtonWXTag {
            
        } else if sender.tag == selectedButtonZFBTag {
            
        }
    }
    @IBAction func btnPayTapped(sender: UIButton) {
        
        
        var tag = sender.tag;
        if(tag == 11)//跳转到个人中心
        {
            self.navigationController?.popToRootViewControllerAnimated(true);
           
            if( UIHEPLER.GetAppDelegate().window!.rootViewController as? UITabBarController != nil) {
                var tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
                
                
                var vc:U02UserVC! = tababarController.childViewControllers[3] as? U02UserVC
                if(vc != nil)
                {
                    
                    vc.sellerBtnAction(vc.sellerBtn);
                }
                
                tababarController.selectedIndex = 3;
            }

        }
        else
        {
            
            
            var vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle());
            self.navigationController?.pushViewController(vc, animated: true);

            
        }
    }
    
    @IBAction func incrlineOrDecreingButtonPay(sender: UIButton) {
        
        if sender.tag == increingButtonTag {
            goodsNumbers++
            
        } else if sender.tag == declineButtonTag {
            goodsNumbers > 0 ? goodsNumbers-- : goodsNumbers
        }
        numbersTextField.text = "\(goodsNumbers)"
    }

}
