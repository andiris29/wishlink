//
//  T08ComplaintVC.swift
//  wishlink
//
//  Created by whj on 15/8/25.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T08ComplaintVC: RootVC {

    @IBOutlet weak var contexTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    override func viewDidAppear(animated: Bool) {
        
        self.loadComNaviLeftBtn();
        self.navigationController?.navigationBarHidden = false;
    }
    
    //MARK: - override
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        contexTextView.resignFirstResponder()
    }
    
    @IBAction func btnAction(sender: AnyObject) {
        
        var tag = (sender as! UIButton).tag
        if(tag == 10)
        {
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        else if(tag == 22)
        {
//            var vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle())
//            self.navigationController!.pushViewController(vc, animated: true)
            

        } else if(tag == 30) {
            APPLICATION.openURL(NSURL(fileURLWithPath: "tel://10086")!)
        } else if(tag == 31) {

        }
    }
}
