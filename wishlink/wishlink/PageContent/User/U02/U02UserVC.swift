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

class U02UserVC: RootVC, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    @IBOutlet weak var sellerBtn: UIButton!
    
    @IBOutlet weak var buyerBtn: UIButton!
    
    @IBOutlet weak var recommendBtn: UIButton!
    
    
    @IBOutlet weak var collectionBtn: UIButton!
    
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
        var cell: UICollectionViewCell?;
        if self.cellType == .CollectionViewCellTypeTrade {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(tradeCellIde, forIndexPath: indexPath) as! U02TradeCell
        }
        else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(itemCellIde, forIndexPath: indexPath) as! U02ItemCell
        }
        return cell!
    }
    
    // MARK: - delegate
    
    // MARK: - response event
    
    @IBAction func sellerBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.cellType = .CollectionViewCellTypeTrade
        self.collectionView.reloadData()
    }
    
    @IBAction func buyerBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.cellType = .CollectionViewCellTypeTrade
        self.collectionView.reloadData()
    }
    
    @IBAction func recommendBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.cellType = .CollectionViewCellTypeItem
        self.collectionView.reloadData()
    }
    
    @IBAction func collectionBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.cellType = .CollectionViewCellTypeItem
        self.collectionView.reloadData()
    }
    
    @IBAction func settingBtnAction(sender: AnyObject) {
        var vc = U03SettingVC(nibName: "U03SettingVC", bundle: NSBundle.mainBundle())
        self.navigationController!.pushViewController(vc, animated: true)
    }
    // MARK: - prive method
    
    func prepareCollectionView() {
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 7.5, left: 10, bottom: 7.5, right: 10)
        self.collectionView.registerNib(UINib(nibName: "U02ItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: itemCellIde)
        self.collectionView.registerNib(UINib(nibName: "U02TradeCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: tradeCellIde)
    }
    // MARK: - setter and getter

}









