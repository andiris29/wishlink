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
        

        // Do any additional setup after loading the view.
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
        var vc = T06TradeVC(nibName: "T06TradeVC", bundle: NSBundle.mainBundle());
        self.navigationController?.pushViewController(vc, animated: true);
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
