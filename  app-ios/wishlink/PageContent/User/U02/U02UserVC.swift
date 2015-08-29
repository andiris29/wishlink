//
//  U02UserVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U02UserVC: RootVC {

    @IBOutlet weak var sellerBtn: UIButton!
    
    @IBOutlet weak var buyerBtn: UIButton!
    
    @IBOutlet weak var recommendBtn: UIButton!
    
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var subVCView: UIView!
    @IBOutlet weak var headImageView: UIImageView!

    
    var selectedBtn: UIButton!
    
    var buyerTradeVC: U02BuyerTradeVC!
    var sellerTradeVC: U02SellerTradeVC!
    var recommendVC: U02RecommendVC!
    var favoriteVC: U02FavoriteVC!
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareSubVC()
        self.selectedBtn = self.sellerBtn
        self.sellerBtnAction(self.sellerBtn)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buyerTradeVC.view.frame = self.subVCView.frame
        self.sellerTradeVC.view.frame = self.subVCView.frame
        self.recommendVC.view.frame = self.subVCView.frame
        self.favoriteVC.view.frame = self.subVCView.frame
        self.headImageView.layer.cornerRadius = self.headImageView.w * 0.5
        self.headImageView.layer.masksToBounds = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - response event
    
    @IBAction func sellerBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.buyerTradeVC.resetConditionView()
        self.view.bringSubviewToFront(self.sellerTradeVC.view)
    }
    
    @IBAction func buyerBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.sellerTradeVC.resetConditionView()
        self.view.bringSubviewToFront(self.buyerTradeVC.view)
    }
    
    @IBAction func recommendBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.sellerTradeVC.resetConditionView()
        self.buyerTradeVC.resetConditionView()
        self.view.bringSubviewToFront(self.recommendVC.view)
    }
    
    @IBAction func collectionBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.sellerTradeVC.resetConditionView()
        self.buyerTradeVC.resetConditionView()
        self.view.bringSubviewToFront(self.favoriteVC.view)
    }
    
    @IBAction func settingBtnAction(sender: AnyObject) {
        var vc = U03SettingVC(nibName: "U03SettingVC", bundle: NSBundle.mainBundle())
        self.navigationController!.pushViewController(vc, animated: true)
    }

    
    // MARK: - prive method
    
    func handleBuyerEvent(type: TradeCellButtonClickType) {

    }
    
    func handleSellerEvent(type: TradeCellButtonClickType) {
        
    }
    
    // MARK: - setter and getter
    func prepareSubVC() {
        self.buyerTradeVC = U02BuyerTradeVC(nibName: "U02BuyerTradeVC", bundle: NSBundle.mainBundle())
        self.buyerTradeVC.userVC = self
        self.view.addSubview(self.buyerTradeVC.view)
        
        self.sellerTradeVC = U02SellerTradeVC(nibName: "U02SellerTradeVC", bundle: NSBundle.mainBundle())
        self.sellerTradeVC.userVC = self
        self.view.addSubview(self.sellerTradeVC.view)

        self.recommendVC = U02RecommendVC(nibName: "U02RecommendVC", bundle: NSBundle.mainBundle())
        self.recommendVC.userVC = self
        self.view.addSubview(self.recommendVC.view)

        self.favoriteVC = U02FavoriteVC(nibName: "U02FavoriteVC", bundle: NSBundle.mainBundle())
        self.favoriteVC.userVC = self
        self.view.addSubview(self.favoriteVC.view)

    }
}









