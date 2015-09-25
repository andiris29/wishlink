//
//  T02HotListVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/21/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class T02HotListVC: RootVC, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let itemCellIde = "U02ItemCell"

    var isNeedShowNavi = false;
//    var isNeedShowLoin = true;
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preparePage()

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
    }
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: collectionView Delegete
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width: CGFloat = (UIScreen.mainScreen().bounds.size.width - 20 - 10) / 2.0;
        var height: CGFloat = 250.0
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(itemCellIde, forIndexPath: indexPath) as! U02ItemCell
        cell.loadFromhotVC();
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var vc = T06TradeVC(nibName: "T06TradeVC", bundle: NSBundle.mainBundle());
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    
    // MARK: - prive method
    func preparePage() {
        
        
        
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 7.5, right: 10)
        self.collectionView.registerNib(UINib(nibName: "U02ItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: itemCellIde)
        self.collectionView.scrollEnabled = true;
        if(isNeedShowNavi)
        {
            self.loadComNaviLeftBtn()
        }
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("热门")
        

    }


    
}










