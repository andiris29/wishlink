//
//  U02SellerTradeVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/23/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//


// 思路
// 1.按钮的tag跟trade的状态一致
// 2.切换筛选条件时，通过selectedConditionBtn.tag去筛选数组，得到筛选以后的数组

import UIKit

class U02SellerTradeVC: RootVC, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,U02TradeCellDelegate {


    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var conditionView: UIView!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var inTradeBtn: U02FilterButton!
    @IBOutlet weak var canceledTradeBtn: U02FilterButton!
    @IBOutlet weak var deliveredBtn: U02FilterButton!
    @IBOutlet weak var finishedBtn: U02FilterButton!
    @IBOutlet weak var complaintingBtn: U02FilterButton!
    
    
    var seletedConditionBtn: UIButton!
    
    var coverTabBarView: UIView!
    
    let tradeCellIde = "U02TradeCell"
    weak var userVC: U02UserVC!

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.inTradeBtn.hideRedRound = false
        self.conditionView.layer.shadowOffset = CGSizeMake(5, 5)
        self.conditionView.layer.shadowColor = UIColor.blackColor().CGColor
        self.conditionView.layer.shadowOpacity = 0.7
        self.conditionView.layer.shadowRadius = 5
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.coverTabBarView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetConditionView() {
        if !self.conditionView.hidden {
            self.filterBtnAction(self.filterBtn)
        }
    }
    
    // MARK: - delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width: CGFloat = UIScreen.mainScreen().bounds.size.width - 20;
        var height: CGFloat = 223
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(tradeCellIde, forIndexPath: indexPath) as! U02TradeCell
        cell.delegate = self
        cell.cellType = .Seller
        cell.indexPath = indexPath
        return cell
        
    }
    
    func tradeCell(cell: U02TradeCell, clickType: TradeCellButtonClickType) {
        var msg = ""
        switch clickType {
        case .EditItemInfo:
            var vc = T07DeliverEditVC(nibName: "T07DeliverEditVC", bundle: NSBundle.mainBundle())
            vc.hidesBottomBarWhenPushed = true
            self.userVC.navigationController!.pushViewController(vc, animated: true)
        case .Revoke:
            println("撤单")
            msg = "撤单"
        case .CheckComplain:
            println("查看投诉")
            msg = "查看投诉"
        case .SendOut:
            println("发货")
            var vc = T07DeliverEditVC(nibName: "T07DeliverEditVC", bundle: NSBundle.mainBundle())
            self.userVC.presentViewController(vc, animated: true, completion: nil)
        case .Chat:
            
            self.userVC.navigationController?.navigationBarHidden = false;
            var vc = T10MessagingVC(nibName: "T10MessagingVC", bundle: NSBundle.mainBundle())
            self.userVC.navigationController!.pushViewController(vc, animated: true)
        case .Complain:
            var vc = T08ComplaintVC(nibName: "T08ComplaintVC", bundle: NSBundle.mainBundle())
            self.userVC.navigationController!.presentViewController(vc, animated: true, completion: nil);
        default:
            println("error")
        }
        if msg.length > 0 {
            var alertView = UIAlertView(title: "提示", message: msg, delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    // MARK: - response event
    
    @IBAction func filterBtnAction(sender: AnyObject) {
        self.conditionView.hidden = !self.conditionView.hidden
        self.coverView.hidden = self.conditionView.hidden
        self.isCoverTabBar(!self.conditionView.hidden)
    }
    
    @IBAction func conditionBtnAction(sender: AnyObject) {
        var btn = sender as! UIButton
        if btn !== self.seletedConditionBtn {
            self.seletedConditionBtn.selected = false
            self.seletedConditionBtn = btn
            self.seletedConditionBtn.selected = true
        }
        self.filterBtnAction(self.finishedBtn)

    }
    
    // MARK: - private method

    func isCoverTabBar(isCover: Bool) {
        self.coverTabBarView.hidden = !isCover
    }
    
    func prepareUI() {
        self.prepareCollectionView()
        
        self.seletedConditionBtn = self.allBtn
        
        self.coverTabBarView = UIView()
        self.coverTabBarView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 49, UIScreen.mainScreen().bounds.size.width, 49)
        self.coverTabBarView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        self.coverTabBarView.hidden = true
        UIApplication.sharedApplication().keyWindow!.addSubview(self.coverTabBarView)
    }
    
    func prepareCollectionView() {
        
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 7.5, left: 10, bottom: 7.5, right: 10)
        self.collectionView.registerNib(UINib(nibName: "U02TradeCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: tradeCellIde)
    }
    
}
