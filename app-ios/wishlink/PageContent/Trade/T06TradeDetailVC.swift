//
//  T06TradeDetailVC.swift
//  wishlink
//
//  Created by whj on 15/10/28.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06TradeDetailVC: RootVC, WebRequestDelegate {

    @IBOutlet weak var tradeNameLabel   : UILabel!
    @IBOutlet weak var tradeTimeLabel   : UILabel!
    @IBOutlet weak var goodNameLabel    : UILabel!
    @IBOutlet weak var goodFormatLabel  : UILabel!
    @IBOutlet weak var goodAddressLabel : UILabel!
    @IBOutlet weak var goodPriceLabel   : UILabel!
    @IBOutlet weak var goodNumberLabel  : UILabel!
    @IBOutlet weak var goodAllTradeLabel: UILabel!
    @IBOutlet weak var goodTotalLabel   : UILabel!
    
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
    }

    func initData() {
        
        self.httpObj.mydelegate = self
    }
    
    func initImageRollView(images:[UIImage]) {
        
        imageRollView.initWithImages(images)
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
    }
    
    // MARK: - Action
    
    @IBAction func backButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func tradeButtonAction(sender: UIButton) {
        
        if sender.tag == 500 { //确认跟单
            
        } else if sender.tag == 501 { //继续抢单
            
        }
    }
    
    @IBAction func hotButtonAction(sender: UIButton) {
        
        if sender.tag == 600 { //heart
            
        } else if sender.tag == 601 { //share
            
        }
    }
    
    
    // MARK: - T06CellDelegate
    
    func selectItemChange(trade: TradeModel, isSelected: Bool) {
        
    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
    }
    
    func requestDataFailed(error: String) {
        
    }
}
