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

enum SellerTradeFilterStatus: Int {
    case All = 0, InTrade, CanceledTade, Delivered, Finished, Complainting
}

class U02SellerTradeVC: RootVC, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,U02TradeCellDelegate, WebRequestDelegate {


    
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
    
    var currentStatus: SellerTradeFilterStatus = .All
    var currentTradeIndex: Int = -1
    var tradeArray: [TradeModel] = []
    var seletedConditionBtn: UIButton!
    var coverTabBarView: UIView!
    
    let tradeCellIde = "U02TradeCell"
    weak var userVC: U02UserVC!

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self
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
    
    required init?(coder aDecoder: NSCoder) {
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
        let width: CGFloat = UIScreen.mainScreen().bounds.size.width - 20;
        let height: CGFloat = 223
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tradeArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(tradeCellIde, forIndexPath: indexPath) as! U02TradeCell
        cell.delegate = self
        cell.cellType = .Seller
        cell.indexPath = indexPath
        if indexPath.row < self.tradeArray.count {
            let trade = self.tradeArray[indexPath.row]
            cell.trade = trade
        }
        

        return cell
        
    }
    
    func tradeCell(cell: U02TradeCell, clickType: TradeCellButtonClickType) {
        switch clickType {
        case .EditItemInfo:
            let vc = T07DeliverEditVC(nibName: "T07DeliverEditVC", bundle: NSBundle.mainBundle())
            vc.hidesBottomBarWhenPushed = true
            self.userVC.navigationController!.pushViewController(vc, animated: true)
            
        case .Revoke:
            self.currentTradeIndex = cell.indexPath.row
            self.cancelTrade()
            
        case .CheckComplain:
            if let dic = cell.trade.owner!["rongcloud"] as? NSDictionary {
                let targetId = dic["token"] as! String
                let vc = T09SimpleComplaintStatusVC()
                vc.targetId = targetId
                vc.conversationType = .ConversationType_PRIVATE
                vc.title = "投诉处理"
                vc.hidesBottomBarWhenPushed = true
                self.userVC.navigationController!.navigationBar.hidden = false;
                self.userVC.navigationController!.pushViewController(vc, animated: true)
            }
//            let vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle())
//            self.userVC.navigationController!.pushViewController(vc, animated: true)
            
        case .SendOut:
            let vc = T07DeliverEditVC(nibName: "T07DeliverEditVC", bundle: NSBundle.mainBundle())
            vc.hidesBottomBarWhenPushed = true
            self.userVC.navigationController!.pushViewController(vc, animated: true)
            
        case .Chat:
//            self.goto
            if let dic = cell.trade.owner!["rongcloud"] as? NSDictionary {
                let targetId = dic["token"] as! String
                let vc = T10SimpleMessagingVC()
                vc.targetId = targetId
                vc.conversationType = .ConversationType_PRIVATE
                vc.hidesBottomBarWhenPushed = true
                self.userVC.navigationController!.navigationBar.hidden = false;
                self.userVC.navigationController!.pushViewController(vc, animated: true)
            }
//            let vc = T10MessagingVC(nibName: "T10MessagingVC", bundle: NSBundle.mainBundle())
            
        case .Complain:
            
            let vc = T08ComplaintVC(nibName: "T08ComplaintVC", bundle: NSBundle.mainBundle())
            self.userVC.navigationController!.pushViewController(vc, animated: true);
            
        default:
            print("error")
        }
    }
    
    
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            self.view.userInteractionEnabled = true
        })
        if tag == 10 {
            let tradeArray = response["trades"] as! NSArray
            print(tradeArray)
            if tradeArray.count == 0 {
                return
            }
            for tradeDic in tradeArray {
                let trade = TradeModel(dict: tradeDic as! NSDictionary)
                self.tradeArray.append(trade)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
            })
        }else if tag == 20 {
            if let tradeDic = response["trade"] as? NSDictionary {
                let tempTrade = TradeModel(dict: tradeDic)
                let trade = self.tradeArray[self.currentTradeIndex]
                trade.status = tempTrade.status
                trade.statusOrder = tempTrade.statusOrder
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: self.currentTradeIndex, inSection: 0)])
                })
            }
        }
    }
    
    func requestDataFailed(error: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            self.view.userInteractionEnabled = true
            self.collectionView.reloadData()
        })
    }
    
    // MARK: - response event
    
    @IBAction func filterBtnAction(sender: AnyObject) {
        self.conditionView.hidden = !self.conditionView.hidden
        self.coverView.hidden = self.conditionView.hidden
        self.isCoverTabBar(!self.conditionView.hidden)
    }
    
    @IBAction func conditionBtnAction(sender: AnyObject) {
        let btn = sender as! UIButton
        if btn !== self.seletedConditionBtn {
            self.seletedConditionBtn.selected = false
            self.seletedConditionBtn = btn
            self.seletedConditionBtn.selected = true
        }
        self.currentStatus = SellerTradeFilterStatus(rawValue: btn.tag - 100)!
        self.filterSellerTrade()
        self.filterBtnAction(self.finishedBtn)

    }
    
    // MARK: - private method

    func getSellerTrade() {
        self.filterSellerTrade()
    }
    
    // 根据状态筛选卖家订单
    func filterSellerTrade() {
        self.tradeArray.removeAll()
        var dic: [String: AnyObject]
        switch self.currentStatus {
        case .All:
            dic = [
                "statuses": []
            ]
        case .InTrade:
            dic = [
                "statuses": [3]
            ]
        case .CanceledTade:
            dic = [
                "statuses": [7]
            ]
        case .Delivered:
            dic = [
                "statuses": [4]
            ]

        case .Finished:
            dic = [
                "statuses": [5, 6, 11]
            ]

        case .Complainting:
            dic = [
                "statuses": [10]
            ]

        default:
            break
        }
        self.httpObj.httpGetApi("tradeFeeding/asSeller", parameters: dic, tag: 10)
        
        // TODO test
    }
    
    func cancelTrade() {
        self.view.userInteractionEnabled = false
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        let trade = self.tradeArray[self.currentTradeIndex]
        let dic = [
            "_id": trade._id
        ]
        self.httpObj.httpPostApi("trade/cancel", parameters: dic, tag: 20)
    }
    
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
