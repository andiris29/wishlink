//
//  U03SettingVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/19/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U03SettingVC: RootVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = false
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("个人设置")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func btnAction(sender: UIButton) {
        var tag = sender.tag ; 
        if(tag == 10)
        {
            var vc =  T07DeliverEditVC(nibName: "T07DeliverEditVC", bundle: NSBundle.mainBundle())
           // self.navigationController?.pushViewController(vc, animated: true);
            self.presentViewController(vc, animated: true, completion: nil);
        }
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

}
