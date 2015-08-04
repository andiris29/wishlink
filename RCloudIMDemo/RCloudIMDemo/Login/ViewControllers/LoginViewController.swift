//
//  LoginViewController.swift
//  RCloudIMDemo
//
//  Created by Yue Huang on 8/4/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginAction(sender: AnyObject) {
        
        self.login("joke0918", password: "aA2881319");
    }
    
    func login(userName: String, password: String) {
        let status: RCNetworkStatus = RCIMClient.sharedRCIMClient().getCurrentNetworkStatus();
        if .NotReachable == status {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                UIAlertView(title: "提示", message: "当前网络不可用，请检查！", delegate: nil, cancelButtonTitle: "确定").show();
            });
            return;
        }
        
        RCIM.sharedRCIM().connectWithToken("A6i4NTzqPkX+Wqjf/LGR8eE/PRMHOUPCCup7dUYDRLSZtH3YVfYNUg3AkPFvh9zNYufWeXtBXYHINe973JluOxBM6EQ18LbY", success: { (userId: String!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBarVC") as! TabBarViewController;
                var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    appDelegate.window!.rootViewController = vc;
                })
            })
            }, error: { (errorCode: RCConnectErrorCode) -> Void in
                println(errorCode);
            }) { () -> Void in
                
        };
        
        
    }
    
}
