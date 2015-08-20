//
//  T04CreateTradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T04CreateTradeVC: RootVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.preparePage();
    }
    
    override func viewWillAppear(animated: Bool) {
        
      self.navigationController?.navigationBarHidden = false;
    }
    func preparePage() {
        
        let leftBtn : UIButton = UIButton(frame: CGRectMake(0, 0, 32, 32));
        leftBtn.setImage(UIImage(named: "u02-back"), forState: UIControlState.Normal)
        leftBtn.setImage(UIImage(named: "u02-back-w"), forState: UIControlState.Highlighted)
        
        leftBtn.addTarget(self, action: "leftBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem : UIBarButtonItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem;
        
        
        
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 40, 20))
        titleLabel.text = "发布新订单"
        titleLabel.textColor = UIHelper.mainColor;
        titleLabel.font = UIFont.boldSystemFontOfSize(15)
        titleLabel.textAlignment = NSTextAlignment.Center
        
        
        
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBarHidden = false;
        
    }
    func leftBtnClicked(button: UIButton){
        
        self.navigationController?.popViewControllerAnimated(true);
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnAction(sender: UIButton) {
    
        var vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
        self.navigationController?.pushViewController(vc, animated: true);

    }
}
