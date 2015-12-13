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
    @IBOutlet weak var topView: UIView!
    
    var buyerTradeVC: U02BuyerTradeVC!
    var sellerTradeVC: U02SellerTradeVC!
    
    weak var userVC: U02UserVC!
    var currType:BuyerSellerType! = .Buyer
    
    var scrolling:((changePoint: CGPoint) -> Void)!
    var resetScrollPoint:((point: CGPoint) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIHEPLER.buildUIViewWithRadius(self.buyerButton, radius: 6, borderColor: UIColor.clearColor(), borderWidth: 1);
        
        UIHEPLER.buildUIViewWithRadius(self.sellerButton, radius: 6, borderColor: UIColor.clearColor(), borderWidth: 1);
        self.prepareScrollViewSubVC()
        
    }

    override func viewWillAppear(animated: Bool) {
        
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
        
        
        self.buyerTradeVC.scrolling = {
            
            [weak self](changePoint: CGPoint) in self?.topViewScrollerChangePoint(changePoint)
        }
        
        self.sellerTradeVC.scrolling = {
            
            [weak self](changePoint: CGPoint) in self?.topViewScrollerChangePoint(changePoint)
        }
        
        self.buyerTradeVC.resetScrollPoint = {
        
            [weak self](point: CGPoint) in self?.resetScrollerChangePoint(point)
        }
        
        self.sellerTradeVC.resetScrollPoint = {
            
            [weak self](point: CGPoint) in self?.resetScrollerChangePoint(point)
        }
    }
    
    func adjustScrollViewUI() {
        
        self.buyerTradeVC.view.frame = self.scrollView.frame
        self.sellerTradeVC.view.frame = self.scrollView.frame
        
        var center = CGPoint(x: CGRectGetWidth(self.scrollView.frame) * 0.5, y: CGRectGetHeight(self.scrollView.frame) * 0.5)
        self.buyerTradeVC.view.center = center
        
        center.x += ScreenWidth
        self.sellerTradeVC.view.center = center
        
        self.scrollView.contentSize = CGSize(width: CGRectGetWidth(self.scrollView.frame) * 2, height: 0)
        
        var rect: CGRect = self.topView.frame
        rect.origin.y = 300
        self.topView.frame = rect
    }
    
    // MARK: - Action
    
    @IBAction func buyerSellerButtonAction(sender: UIButton) {

        self.currType = sender.tag == 500 ? .Buyer : .Seller
        buyerSellerButtonStatus(self.currType)
    }
    
    // MARK: - Unit
    
    func buyerSellerButtonStatus(type: BuyerSellerType) {
    
        if type == .Buyer {
            
            buyerButton.backgroundColor = UIColor.whiteColor()
            buyerButton.setTitleColor(MainColor(), forState: UIControlState.Normal);
            buyerButton.setImage(UIImage(named: "u02OrderList1"), forState: UIControlState.Normal)
            
            sellerButton.backgroundColor = UIColor.lightGrayColor();
            sellerButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal);
            sellerButton.setImage(UIImage(named: "u02OrderList0"), forState: UIControlState.Normal)
            
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.buyerTradeVC.getBuyerTrade()
        } else {
        
            sellerButton.backgroundColor = UIColor.whiteColor()
            sellerButton.setTitleColor(MainColorRed(), forState: UIControlState.Normal);
            sellerButton.setImage(UIImage(named: "u02OrderList00"), forState: UIControlState.Normal)
            
            buyerButton.backgroundColor = UIColor.lightGrayColor();
            buyerButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal);
            buyerButton.setImage(UIImage(named: "u02OrderList10"), forState: UIControlState.Normal)
            
            
            self.scrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
            self.sellerTradeVC.getSellerTrade()
        }
    }
    
    func resetConditionView() {
        
        self.sellerTradeVC.resetConditionView()
        self.buyerTradeVC.resetConditionView()
        
        self.resetScrollerChangePoint(CGPointZero)
    }
    
    func topViewScrollerChangePoint(point: CGPoint) {
        
        let changeY = point.y + 75
        var rect: CGRect = self.topView.frame
        rect.origin.y = -changeY
        self.topView.frame = rect
        
        
        if let pointTemp = self.scrolling {
            pointTemp(changePoint: point)
        }
    }
    
    func resetScrollerChangePoint(point: CGPoint) {
        
        if let resetPoint = self.resetScrollPoint {
            resetPoint(point: CGPointZero)
        }
    }
    
}
