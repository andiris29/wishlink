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

class U02BuyerTradeVC: RootVC, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, U02TradeCellDelegate, WebRequestDelegate, UIAlertViewDelegate {
    

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
    var currentTradeIndex: Int = -1
    
    var scrolling:((isUp:Bool)->Void)!
//    var scorlling:(isUp:Bool)!;
    
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
    
    //MARK:ScrollView delegate
    var contentOffsetY:CGFloat! = 0;
    var oldContentOffsetY:CGFloat! = 0;
    var newContentOffsetY:CGFloat! = 0;
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        contentOffsetY = scrollView.contentOffset.y;
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oldContentOffsetY = scrollView.contentOffset.y;
        
        
        NSLog("end dragging");
        
        if(self.lastDraging != self._isUp)
        {
            if(self.scrolling != nil)
            {
                self.scrolling(isUp:_isUp);
            }
            self.lastDraging = _isUp
        }
    }
    
    var lastDraging:Bool!
    var _isUp:Bool!
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        newContentOffsetY = scrollView.contentOffset.y;
        
        if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {  // 向上滚动
            
            NSLog("up");
            
        } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
            
            NSLog("down");
            
        } else {
            
            
        }
        if (scrollView.dragging) {  // 拖拽
            
            NSLog("scrollView.dragging");
            NSLog("contentOffsetY: %f", contentOffsetY);
            NSLog("newContentOffsetY: %f", scrollView.contentOffset.y);
            if ((scrollView.contentOffset.y - contentOffsetY) > 20.0) {  // 向上拖拽
                
                self._isUp = true;
                NSLog("drag up");
              
            } else if ((contentOffsetY - scrollView.contentOffset.y) > 20.0) {   // 向下拖拽
               
                
                self._isUp = false;
                NSLog("drag down");
                
            } else {
                
            }
        }
    }

    
    // MARK: - delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = UIScreen.mainScreen().bounds.size.width - 20;
        let height: CGFloat = 146 // 223
        return CGSize(width: width, height: height)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tradeArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(tradeCellIde, forIndexPath: indexPath) as! U02TradeCell
        cell.delegate = self
        cell.cellType = .Buyer
        cell.indexPath = indexPath
        if indexPath.row < self.tradeArray.count {
            let trade = self.tradeArray[indexPath.row]
            cell.trade = trade
        }
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let vc = U07OrderTradeDetailVC(nibName: "U07OrderTradeDetailVC", bundle: NSBundle.mainBundle())
        vc.role = .buyyer
        vc.trade = self.tradeArray[indexPath.row]
//        vc.hidesBottomBarWhenPushed = true
        self.userVC.navigationController!.pushViewController(vc, animated: true)
    }
    
    func tradeCell(cell: U02TradeCell, clickType: TradeCellButtonClickType) {
        switch clickType {
        case .Confirm:
            self.currentTradeIndex = cell.indexPath.row
            self.receiptTrade()
        case .Revoke:
            self.currentTradeIndex = cell.indexPath.row
			let alert = UIAlertView()
			alert.title = "温馨提示"
			alert.message = "买家临时变卦，请帮助买家取消此订单，谢谢！"
			alert.addButtonWithTitle("确定取消订单")
			alert.delegate = self
			alert.show()

//            self.cancelTrade()
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
        case .CheckLogistics:
            //TODO 物流信息
            let tipView = U02LogisticsTipView(name: "物流公司：韵达快递", orderNumber: "物流单号：18815287600")
            tipView.show()
        case .Chat:
            if let dic = cell.trade.owner!["rongcloud"] as? NSDictionary {
                let targetId = dic["token"] as! String
                let vc = T10SimpleMessagingVC()
                vc.targetId = targetId
                vc.conversationType = .ConversationType_PRIVATE
                vc.hidesBottomBarWhenPushed = true
                self.userVC.navigationController!.navigationBar.hidden = false;
                self.userVC.navigationController!.pushViewController(vc, animated: true)
            }
        case .Complain:
         
                let vc = T08ComplaintVC(nibName: "T08ComplaintVC", bundle: NSBundle.mainBundle())
                vc.tradeid = cell.trade._id;
                self.userVC.presentViewController(vc, animated: true, completion: nil);
//                self.userVC.navigationController!.pushViewController(vc, animated: true);
            
        default:
            print("error")
        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.collectionView.reloadData()
        })
    }
    
    
    func requestDataComplete(response: AnyObject, tag: Int) {
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
            // 撤单
            if let tradeDic = response["trade"] as? NSDictionary {
                let tempTrade = TradeModel(dict: tradeDic)
                let trade = self.tradeArray[self.currentTradeIndex]
                trade.status = tempTrade.status
                trade.statusOrder = tempTrade.statusOrder
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: self.currentTradeIndex, inSection: 0)])
                })
            }
        }else if tag == 30{
            // 确认收货
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
	
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		if buttonIndex == 0 {
			self.cancelTrade()
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
        self.currentStatus = BuyerTradeFilterStatus(rawValue: btn.tag - 100)!
        self.filterBuyerTrade()
        self.filterBtnAction(self.finishedBtn)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.conditionView.hidden = true
        self.coverView.hidden = true
        self.isCoverTabBar(!self.conditionView.hidden)
    }
    
    // MARK: - private method
    
    func getBuyerTrade() {
        self.filterBuyerTrade()
    }
    
    // 根据状态筛选卖家订单
    func filterBuyerTrade() {
        self.tradeArray.removeAll()
        var dic: [String: AnyObject]
        switch self.currentStatus {
        case .All:
            dic = [
                "statuses": []
            ]
        case .UnTrade:
            dic = [
                "statuses": [2, 1]
            ]
        case .InTrade:
            dic = [
                "statuses": [3]
            ]

        case .CanceledTade:
            dic = [
                "statuses": [7, 8, 9]
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
        self.httpObj.httpGetApi("tradeFeeding/asBuyer", parameters: dic, tag: 10)

    }
    
    // 撤单
    func cancelTrade() {
        let trade = self.tradeArray[self.currentTradeIndex]
        let dic = [
            "_id": trade._id
        ]
        self.httpObj.httpPostApi("trade/cancel", parameters: dic, tag: 20)
    }
    
    // 确认收货
    func receiptTrade() {
        let trade = self.tradeArray[self.currentTradeIndex]
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
