//
//  U02OrderTradeVC.swift
//  wishlink
//
//  Created by whj on 15/10/26.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

enum BuyerSellerType {
    case Buyer, Seller
}

class U02OrderTradeVC: RootVC, UIScrollViewDelegate {

    @IBOutlet weak var buyerButton: UIButton!
    @IBOutlet weak var sellerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var buyerTradeVC: U02BuyerTradeVC!
    var sellerTradeVC: U02SellerTradeVC!
    
    weak var userVC: U02UserVC!
    var currType:BuyerSellerType! = .Buyer
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareScrollViewSubVC()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.adjustScrollViewUI()
        
        //        dispatch_after(3, dispatch_get_main_queue()) { () -> Void in
        self.buyerSellerButtonStatus(self.currType)
        //        }
    }
    
    // MARK: - View
    
    func prepareScrollViewSubVC() {
        
        self.buyerTradeVC = U02BuyerTradeVC(nibName: "U02BuyerTradeVC", bundle: NSBundle.mainBundle())
        self.buyerTradeVC.userVC = self.userVC
        self.buyerTradeVC.view.frame = self.scrollView.bounds
        self.scrollView.addSubview(self.buyerTradeVC.view)
        
        self.sellerTradeVC = U02SellerTradeVC(nibName: "U02SellerTradeVC", bundle: NSBundle.mainBundle())
        self.sellerTradeVC.userVC = self.userVC
        self.scrollView.addSubview(self.sellerTradeVC.view)
    }
    
    func adjustScrollViewUI() {
        
        self.buyerTradeVC.view.frame = self.scrollView.frame
        self.sellerTradeVC.view.frame = self.scrollView.frame
        
        var center = CGPoint(x: CGRectGetWidth(self.scrollView.frame) * 0.5, y: CGRectGetHeight(self.scrollView.frame) * 0.5)
        self.buyerTradeVC.view.center = center
        
        center.x += ScreenWidth
        self.sellerTradeVC.view.center = center
        
        self.scrollView.contentSize = CGSize(width: CGRectGetWidth(self.scrollView.frame) * 2, height: 0)
    }
    
    // MARK: - Action
    
    @IBAction func buyerSellerButtonAction(sender: UIButton) {

        self.currType = sender.tag == 500 ? .Buyer : .Seller
        buyerSellerButtonStatus(self.currType)
        
    }
    
    // MARK: - Unit
    
    func buyerSellerButtonStatus(type: BuyerSellerType) {
    
        if type == .Buyer {
        
            buyerButton.backgroundColor = MainColor()
            sellerButton.backgroundColor = RGBC(160)
               self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.buyerTradeVC.getBuyerTrade()
        } else {
        
            buyerButton.backgroundColor = RGBC(160)
            sellerButton.backgroundColor = RGB(248, g: 62, b: 91)
               self.scrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
            self.sellerTradeVC.getSellerTrade()
        }
    }
    
    func resetConditionView() {
        
        self.sellerTradeVC.resetConditionView()
        self.buyerTradeVC.resetConditionView()

    }
    
}
