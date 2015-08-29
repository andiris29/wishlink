//
//  T07DeliverEditVC.swift
//  wishlink
//
//  Created by whj on 15/8/20.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T07DeliverEditVC: RootVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
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

}
