//
//  U01LoginVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U01LoginVC: RootVC {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - delegate
    // MARK: - response event
    
    @IBAction func weiXinLoginAction(sender: AnyObject) {
        println("微信登入")
        APPCONFIG.AccessToken = "temp_token";
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    @IBAction func weiBoLoginAction(sender: AnyObject) {
        println("微博登入")
        APPCONFIG.AccessToken = "temp_token";
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    @IBAction func skipAction(sender: AnyObject) {
        println("跳过")
        APPCONFIG.AccessToken = "temp_token";
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: - prive method
    // MARK: - setter and getter


}