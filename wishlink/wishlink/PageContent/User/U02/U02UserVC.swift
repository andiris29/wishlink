//
//  U02UserVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum CollectionViewCellType: Int {
    case CollectionViewCellTypeTrade = 0, CollectionViewCellTypeItem = 1
}

class U02UserVC: RootVC, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, U02TradeCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var filterView: UIView!
    
    
    @IBOutlet weak var sellerBtn: UIButton!
    
    @IBOutlet weak var buyerBtn: UIButton!
    
    @IBOutlet weak var recommendBtn: UIButton!
    
    @IBOutlet weak var collectionBtn: UIButton!
    
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    
    var clearView: UIView!
    var clearBtn: UIButton!
    
    var selectedBtn: UIButton!
    let itemCellIde = "U02ItemCell"
    let tradeCellIde = "U02TradeCell"
    var cellType: CollectionViewCellType = .CollectionViewCellTypeTrade
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareCollectionView()
        self.selectedBtn = self.sellerBtn
        self.sellerBtnAction(self.sellerBtn)
//        self.selectedBtn = self.sellerBtn
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = true
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width: CGFloat = (UIScreen.mainScreen().bounds.size.width - 20 - 10) / 2.0;
        var height: CGFloat = 250.0
        
        if self.cellType == .CollectionViewCellTypeTrade {
            width = UIScreen.mainScreen().bounds.size.width - 20
            height = 223
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if self.cellType == .CollectionViewCellTypeTrade {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier(tradeCellIde, forIndexPath: indexPath) as! U02TradeCell
            cell.delegate = self
            if self.buyerBtn.selected == true {
                cell.cellType = .Buyer
            }
            else {
                cell.cellType = .Seller

            }
            return cell

        }
        else {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier(itemCellIde, forIndexPath: indexPath) as! U02ItemCell
            return cell
        }
        
    }
    
    // MARK: - delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.dragging == false {
            if self.recommendBtn.selected || self.collectionBtn.selected {
                if scrollView.contentOffset.y < -40 {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        var inset = self.collectionView.contentInset
                        inset.top = 40
                        self.collectionView.contentInset = inset
                        self.collectionView.setContentOffset(CGPointMake(0, -inset.top), animated: false)
                        //                    scrollView.setContentOffset(CGPointMake(0, -50), animated: false)
                    })
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func tradeCell(cell: U02TradeCell, buttonClickType: TradeCellButtonClickType) {
        if cell.cellType == TradeCellType.Buyer {
            self.handleBuyerEvent(buttonClickType)
        }
        else {
            self.handleSellerEvent(buttonClickType)
        }
    }
    
    // MARK: - response event
    
    @IBAction func sellerBtnAction(sender: AnyObject) {
        self.clearView.hidden = true
        self.filterView.hidden = false
        self.selectedBtn.selected = false
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.cellType = .CollectionViewCellTypeTrade
        self.collectionView.reloadData()
        self.filterViewHeightConstraint.constant = 35
        self.updateViewConstraints()
    }
    
    @IBAction func buyerBtnAction(sender: AnyObject) {
        self.clearView.hidden = true
        self.filterView.hidden = false
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.cellType = .CollectionViewCellTypeTrade
        self.collectionView.reloadData()
        self.filterViewHeightConstraint.constant = 35
        self.updateViewConstraints()
    }
    
    @IBAction func recommendBtnAction(sender: AnyObject) {
        self.clearView.hidden = false
        self.filterView.hidden = true
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.cellType = .CollectionViewCellTypeItem
        self.collectionView.reloadData()
        self.filterViewHeightConstraint.constant = 0
        self.updateViewConstraints()
    }
    
    @IBAction func collectionBtnAction(sender: AnyObject) {
        self.clearView.hidden = false
        self.filterView.hidden = true
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.cellType = .CollectionViewCellTypeItem
        self.collectionView.reloadData()
        self.filterViewHeightConstraint.constant = 0
        self.updateViewConstraints()
    }
    
    @IBAction func settingBtnAction(sender: AnyObject) {
        var vc = U03SettingVC(nibName: "U03SettingVC", bundle: NSBundle.mainBundle())
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func clearBtnAction(sender: AnyObject) {
        var inset = self.collectionView.contentInset
        inset.top = 0
        self.collectionView.contentInset = inset
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.collectionView.setContentOffset(CGPointMake(0, -inset.top), animated: false)
        })
    }
    
    // MARK: - prive method
    
    func handleBuyerEvent(type: TradeCellButtonClickType) {
        switch type {
        case .CheckLogistics:
            var tipView = U02LogisticsTipView(name: "物流公司：韵达快递", orderNumber: "物流单号：18815287600")
            tipView.show()
        default:
            println("wrong")
        }
    }
    
    func handleSellerEvent(type: TradeCellButtonClickType) {
        
    }
    
    func prepareCollectionView() {
        self.clearView = UIView(frame: CGRectMake(0, -40, UIScreen.mainScreen().bounds.size.width, 40))
        self.clearView.userInteractionEnabled = true
        self.collectionView.addSubview(self.clearView)
        var clearBtnW = CGRectGetWidth(self.clearView.frame) * 0.6
        var clearBtnH = CGFloat(30)
        var clearBtnX = (CGRectGetWidth(self.clearView.frame) - clearBtnW) * 0.5
        var clearBtnY = (CGRectGetHeight(self.clearView.frame) - clearBtnH) * 0.5
        self.clearBtn = UIButton.buttonWithType(.Custom) as! UIButton
        self.clearBtn.frame = CGRectMake(clearBtnX, clearBtnY, clearBtnW, clearBtnH)
        self.clearBtn.setTitle("清空推荐", forState: .Normal)
        self.clearBtn.setBackgroundImage(UIImage(named: "u02-clearcollection"), forState: .Normal)
        self.clearBtn.addTarget(self, action: "clearBtnAction:", forControlEvents: .TouchUpInside)
        self.clearView.addSubview(self.clearBtn)
        
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 7.5, left: 10, bottom: 7.5, right: 10)
        self.collectionView.registerNib(UINib(nibName: "U02ItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: itemCellIde)
        self.collectionView.registerNib(UINib(nibName: "U02TradeCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: tradeCellIde)
    }
    // MARK: - setter and getter

}









