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
        
        self.preparePage();
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false;
    }
    @IBAction func btnBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    func preparePage() {
        
        let leftBtn : UIButton = UIButton(frame: CGRectMake(0, 0, 32, 32));
        leftBtn.setImage(UIImage(named: "u02-back"), forState: UIControlState.Normal)
        leftBtn.setImage(UIImage(named: "u02-back-w"), forState: UIControlState.Highlighted)
        
        leftBtn.addTarget(self, action: "leftBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem : UIBarButtonItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem;
        
        
        
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 40, 30))
        titleLabel.text = "我要跟单发布"
        titleLabel.textColor = UIHelper.mainColor;
        titleLabel.font = UIFont.boldSystemFontOfSize(15)
        titleLabel.textAlignment = NSTextAlignment.Center
        
        
        
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBarHidden = false;
        
    }
    
    func leftBtnClicked(button: UIButton){
        
        self.navigationController?.popViewControllerAnimated(true);
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
