//
//  U02BuyerTradeVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/23/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum BuyerTradeFilterStatus: Int {
    case All = 0, UnTrade, InTrade, CanceledTade, Delivered, Finished, Complainting
}

class U02BuyerTradeVC: RootVC, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, U02TradeCellDelegate, WebRequestDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var unTradeBtn: U02FilterButton!
    @IBOutlet weak var tradedBtn: U02FilterButton!
    @IBOutlet weak var canceledTradeBtn: U02FilterButton!
    @IBOutlet weak var sendedOutBtn: U02FilterButton!
    @IBOutlet weak var finishedBtn: U02FilterButton!
    @IBOutlet weak var complainingBtn: U02FilterButton!

    var currentStatus: BuyerTradeFilterStatus = .All
    var tradeArray: [TradeModel] = []
    var afterFilterTradeArray: [TradeModel] = []
    var currentTradeIndex: Int = -1

    
    var seletedConditionBtn: UIButton!
    
    var coverTabBarView: UIView!
    
    let tradeCellIde = "U02TradeCell"
    weak var userVC: U02UserVC!
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.prepareData()
        // Do any additional setup after loading the view.
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.coverTabBarView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.unTradeBtn.hideRedRound = false
        self.conditionView.layer.shadowOffset = CGSizeMake(5, 5)
        self.conditionView.layer.shadowColor = UIColor.blackColor().CGColor
        self.conditionView.layer.shadowOpacity = 0.7
        self.conditionView.layer.shadowRadius = 5
        
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
        return self.afterFilterTradeArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(tradeCellIde, forIndexPath: indexPath) as! U02TradeCell
        cell.delegate = self
        cell.cellType = .Buyer
        cell.indexPath = indexPath
        if indexPath.row < self.afterFilterTradeArray.count {
            let trade = self.afterFilterTradeArray[indexPath.row]
            cell.trade = trade
        }
        return cell
        
    }
    
    func tradeCell(cell: U02TradeCell, clickType: TradeCellButtonClickType) {
        switch clickType {
        case .Confirm:
            self.currentTradeIndex = cell.indexPath.row
            self.receiptTrade()
        case .Revoke:
            self.currentTradeIndex = cell.indexPath.row
            self.cancelTrade()
        case .CheckComplain:
            let vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle())
            self.userVC.navigationController!.pushViewController(vc, animated: true)
        case .CheckLogistics:
            //TODO 物流信息
            let tipView = U02LogisticsTipView(name: "物流公司：韵达快递", orderNumber: "物流单号：18815287600")
            tipView.show()
        case .Chat:
            self.userVC.navigationController?.navigationBarHidden = false;
            let vc = T10MessagingVC(nibName: "T10MessagingVC", bundle: NSBundle.mainBundle())
            self.userVC.navigationController!.pushViewController(vc, animated: true)
        case .Complain:
            let vc = T08ComplaintVC(nibName: "T08ComplaintVC", bundle: NSBundle.mainBundle())
            self.userVC.navigationController!.pushViewController(vc, animated: true);
        default:
            print("error")
        }
    }
    
    func requestDataFailed(error: String) {
        
    }
    
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        if tag == 10 {
            let tradeArray = response["trades"] as! NSArray
            if tradeArray.count == 0 {
                return
            }
            for tradeDic in tradeArray {
                let trade = TradeModel(dict: tradeDic as! NSDictionary)
                self.tradeArray.append(trade)
            }
            self.afterFilterTradeArray = self.tradeArray
            self.collectionView.reloadData()
        }else if tag == 20 {
            // 撤单
            if let tradeDic = response["trade"] as? NSDictionary {
                let trade = TradeModel(dict: tradeDic)
                self.afterFilterTradeArray.removeAtIndex(self.currentTradeIndex)
                self.afterFilterTradeArray.insert(trade, atIndex: self.currentTradeIndex)
                self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: self.currentTradeIndex, inSection: 0)])
            }
        }else if tag == 30{
            // 确认收货
            if let tradeDic = response["trade"] as? NSDictionary {
                let trade = TradeModel(dict: tradeDic)
                self.afterFilterTradeArray.removeAtIndex(self.currentTradeIndex)
                self.afterFilterTradeArray.insert(trade, atIndex: self.currentTradeIndex)
                self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: self.currentTradeIndex, inSection: 0)])
            }
        }
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
        self.filterBuyerTradeWithStatus(BuyerTradeFilterStatus(rawValue: btn.tag - 100)!)
        self.filterBtnAction(self.finishedBtn)
    }

    // MARK: - private method
    
    func getBuyerTrade() {
        self.httpObj.httpGetApi("tradeFeeding/asBuyer", parameters: nil, tag: 10)
    }
    
    // 根据状态筛选卖家订单
    func filterBuyerTradeWithStatus(status: BuyerTradeFilterStatus) {
        self.afterFilterTradeArray.removeAll(keepCapacity: false)
        switch status {
        case .All:
            self.afterFilterTradeArray = self.tradeArray
        case .UnTrade:
            for trade in self.tradeArray {
                if trade.status == 2 || trade.status == 1 {
                    self.afterFilterTradeArray.append(trade)
                }
            }
        case .InTrade:
            for trade in self.tradeArray {
                if trade.status == 3 {
                    self.afterFilterTradeArray.append(trade)
                }
            }
        case .CanceledTade:
            for trade in self.tradeArray {
                if trade.status == 7 || trade.status == 8 || trade.status == 9 {
                    self.afterFilterTradeArray.append(trade)
                }
            }
        case .Delivered:
            for trade in self.tradeArray {
                if trade.status == 4 {
                    self.afterFilterTradeArray.append(trade)
                }
            }
        case .Finished:
            for trade in self.tradeArray {
                if trade.status == 5 || trade.status == 6 || trade.status == 11 {
                    self.afterFilterTradeArray.append(trade)
                }
            }
        case .Complainting:
            for trade in self.tradeArray {
                if trade.status == 10 {
                    self.afterFilterTradeArray.append(trade)
                }
            }
        default:
            break
        }
        self.collectionView.reloadData()
    }
    
    // 撤单
    func cancelTrade() {
        let trade = self.afterFilterTradeArray[self.currentTradeIndex]
        let dic = [
            "_id": trade._id
        ]
        self.httpObj.httpPostApi("trade/cancel", parameters: dic, tag: 20)
    }
    
    // 确认收货
    func receiptTrade() {
        let trade = self.afterFilterTradeArray[self.currentTradeIndex]
        let dic = [
            "_id": trade._id
        ]
        self.httpObj.httpPostApi("trade/receipt", parameters: dic, tag: 30)
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
    
    func prepareData() {
        self.httpObj.mydelegate = self
    }
    
    func prepareCollectionView() {
        
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 7.5, left: 10, bottom: 7.5, right: 10)
        self.collectionView.registerNib(UINib(nibName: "U02TradeCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: tradeCellIde)
    }

}
