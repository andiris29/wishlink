//
//  U07OrderTradeDetailVC.swift
//  wishlink
//
//  Created by whj on 15/10/27.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class U07OrderTradeDetailVC: RootVC, WebRequestDelegate {

    @IBOutlet weak var goodImageView: UIImageView!
    @IBOutlet weak var goodName: UILabel!
    @IBOutlet weak var goodFrom: UILabel!
    @IBOutlet weak var goodFormat: UILabel!
    @IBOutlet weak var goodPrice: UILabel!
    @IBOutlet weak var goodNumber: UILabel!
    @IBOutlet weak var goodTotal: UILabel!
    
    @IBOutlet weak var linkTitle: UILabel!
    @IBOutlet weak var avterImageView: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var reveicerName: UILabel!
    @IBOutlet weak var reveicerPhone: UILabel!
    @IBOutlet weak var reveicerAddress: UILabel!
    
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var orderReveicedTime: UILabel!
    @IBOutlet weak var revokeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData()
        self.setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    func setupData() {
    
        self.httpObj.mydelegate = self
        
        self.loadComNavTitle("订单详情")
        self.loadComNaviLeftBtn()
        self.loadSpecNaviRightTextBtn("投诉", _selecotr: "navigationRightButtonAction:")
    }
    
    func setupView() {
    
        self.avterImageView.layer.masksToBounds = true
        self.avterImageView.layer.cornerRadius = self.avterImageView.frame.size.height / 2
    }
    
    // MARK: - Action
    
    func navigationRightButtonAction(sender: UIButton) {
    
        print("==>>: \(sender)")
    }
    
    @IBAction func linkPersonButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func revokeButtonAction(sender: UIButton) {
    
    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
    }
    
    func requestDataFailed(error: String) {
        
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
