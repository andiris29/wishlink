//
//  U02RecommendVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/23/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U02RecommendVC: RootVC, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, WebRequestDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var refreshControl: UIRefreshControl!
    
    var clearView: UIView!
    var clearBtn: UIButton!
    let itemCellIde = "U02ItemCell"
    weak var userVC: U02UserVC!
    var dataArray: [ItemModel] = []
    var currentItemIndex: Int = -1
    var pageNo: Int = 1
    var pageSize: Int = 10
    
    var scrolling:((changePoint: CGPoint) -> Void)!
    var resetScrollPoint:((point: CGPoint) -> Void)!
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self
        self.prepareUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.mainScreen().bounds.size.width - 20 - 10) / 2.0;
        let height: CGFloat = width+100;
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(itemCellIde, forIndexPath: indexPath) as! U02ItemCell
        cell.indexPath = indexPath;
        cell.cellType = .Recommand
        cell.closure = {
            [unowned self]
            (type: ItemCellButtonClickType, selectedIndexPath: NSIndexPath) in
            if type == ItemCellButtonClickType.Favorite {
                self.currentItemIndex = selectedIndexPath.row
                self.favoriteItem()
            }
            else {
                self.currentItemIndex = selectedIndexPath.row
                self.removeRecommendationItem()
            }
        };
        if indexPath.row < self.dataArray.count {
            cell.item = self.dataArray[indexPath.row]
        }
        return cell
    }
    
    //MARK:network delegate
    func requestDataFailed(error: String,tag:Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            self.view.userInteractionEnabled = true
            self.collectionView.reloadData()
        })
    }
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            self.view.userInteractionEnabled = true
        })
        if tag == 10 {
            // recommdation
            if let itemArray = response["items"] as? [[String: AnyObject]] {
                for itemDic in itemArray {
                    let item = ItemModel(dict: itemDic)
                    self.dataArray.append(item)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
            })
        }else if tag == 20 {
            // 取消收藏
            if let itemDic = response["item"] as? [String: AnyObject] {
                let item = ItemModel(dict: itemDic)
                item.isFavorite = false
                self.dataArray.removeAtIndex(self.currentItemIndex)
                self.dataArray.insert(item, atIndex: self.currentItemIndex)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.showSuccessWithStatusWithBlack("取消收藏成功")
                    self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: self.currentItemIndex, inSection: 0)])
                })
            }
        }else if tag == 30 {
            if let itemDic = response["item"] as? [String: AnyObject] {
                let item = ItemModel(dict: itemDic)
                item.isFavorite = true
                self.dataArray.removeAtIndex(self.currentItemIndex)
                self.dataArray.insert(item, atIndex: self.currentItemIndex)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.showSuccessWithStatusWithBlack("收藏成功")
                    self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: self.currentItemIndex, inSection: 0)])
                })
            }
        }else if tag == 40 {
            self.dataArray.removeAtIndex(self.currentItemIndex)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.showSuccessWithStatusWithBlack("删除成功!")
                self.collectionView.reloadData()
            })
        }else if tag == 50 {
            self.dataArray.removeAll()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.showSuccessWithStatusWithBlack("删除成功!")
                var inset = self.collectionView.contentInset
                inset.top = 0
                self.collectionView.contentInset = inset
                
                UIView.animateWithDuration(Double(0.5), animations: { () -> Void in
                    self.collectionView.setContentOffset(CGPointMake(0, -inset.top), animated: false)
                    }) { (xxx: Bool) -> Void in
                        self.collectionView.reloadData()
                }
                self.collectionView.reloadData()
            })
        }
    }
    
    // MARK: - response event
    func clearBtnAction(sender: AnyObject) {
        if self.dataArray.count == 0 {
            return
        }
        self.removeAllRecommendationItems()
        
    }
    
//    func refreshRecommendation() {
//        self.refreshControl.beginRefreshing()
//        self.pageNo = 1
//        self.getRecommendation()
//    }
    
    // MARK: - prive method
    
    func getRecommendation() {
        self.dataArray.removeAll()
        self.pageNo = 1
        let dic = [
            "pageNo": self.pageNo,
            "pageSize": self.pageSize
        ]
        self.httpObj.httpGetApi("itemFeeding/recommendation", parameters: dic, tag: 10)
        
        self.resetScollerPoint()
    }
    
    func loadMoreRecommendation() {
        self.pageNo++
        let dic = [
            "pageNo": self.pageNo,
            "pageSize": self.pageSize
        ]
        self.httpObj.httpGetApi("itemFeeding/recommendation", parameters: dic, tag: 10)
    }
    
    func removeRecommendationItem() {
        self.view.userInteractionEnabled = false
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        let item = self.dataArray[self.currentItemIndex]
        let dic = [
            "_id": item._id
        ]
        self.httpObj.httpPostApi("user/removeRecommendedItem", parameters: dic, tag: 40)
    }
    
    func removeAllRecommendationItems() {
        self.view.userInteractionEnabled = false
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        self.httpObj.httpPostApi("user/removeAllRecommendedItems", parameters: nil, tag: 50)
    }
    
    func favoriteItem() {
        let item = self.dataArray[self.currentItemIndex]
        let dic = [
            "_id": item._id
        ]
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        self.view.userInteractionEnabled = false
        if item.isFavorite == true {
            // 取消收藏
            self.httpObj.httpPostApi("item/unfavorite", parameters: dic, tag: 20)

        }
        else {
            // 收藏
            self.httpObj.httpPostApi("item/favorite", parameters: dic, tag: 30)

        }
        
    }

    func unfavoriteItem(itemIndex: Int) {
        
    }
    
    func prepareUI() {
        self.prepareCollectionView()
//        self.prepareRefreshControl()
    }
    
    func prepareRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshRecommendation", forControlEvents: .ValueChanged)
    }
    
    func prepareCollectionView() {
        self.clearView = UIView(frame: CGRectMake(0, -40, UIScreen.mainScreen().bounds.size.width, 40))
        self.clearView.userInteractionEnabled = true
        self.collectionView.addSubview(self.clearView)
        let clearBtnW = CGRectGetWidth(self.clearView.frame) * 0.6
        let clearBtnH = CGFloat(30)
        let clearBtnX = (CGRectGetWidth(self.clearView.frame) - clearBtnW) * 0.5
        let clearBtnY = (CGRectGetHeight(self.clearView.frame) - clearBtnH) * 0.5
        self.clearBtn = UIButton(type: .Custom)
        self.clearBtn.frame = CGRectMake(clearBtnX, clearBtnY, clearBtnW, clearBtnH)
        self.clearBtn.setTitle("清空推荐", forState: .Normal)
        self.clearBtn.setBackgroundImage(UIImage(named: "u02-clearcollection"), forState: .Normal)
        self.clearBtn.addTarget(self, action: "clearBtnAction:", forControlEvents: .TouchUpInside)
        self.clearView.addSubview(self.clearBtn)
        
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 7.5, left: 10, bottom: 7.5, right: 10)
        self.collectionView.contentInset = UIEdgeInsetsMake(340, 0, 0, 0)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.registerNib(UINib(nibName: "U02ItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: itemCellIde)
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        print("\(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y <= -600 {
            self.resetScollerPoint()
        }
        
        if let point = self.scrolling {
            point(changePoint: scrollView.contentOffset)
        }
    }
    
     // MARK: - Unit
    
    func resetScollerPoint() {
        
        var rect: CGRect = self.collectionView.frame
        rect.origin.y = -300
        self.collectionView.scrollRectToVisible(rect, animated: false)
        
        if let resetPoint = self.resetScrollPoint {
            resetPoint(point: CGPointZero)
        }
    }
}
