//
//  T03SearchHelperVC.swift
//  wishlink
//
//  Created by whj on 15/8/21.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T03SearchHelperVC: RootVC, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let cellIdentifier = "SearchCollectionViewCell"
    let cellHeaderIdentifier = "SearchCollectionReusableViewHeader"
    
    var goods: NSArray!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goods = ["国家地区", "种类", "热门品牌"]
        
        collectionCellRegisterNib()
    }
    
    func collectionCellRegisterNib() {
    
        self.collectionView.registerNib(UINib(nibName: "SearchCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.registerNib(UINib(nibName: "SearchCollectionReusableViewHeader", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellHeaderIdentifier)
        
//        self.collectionView!.registerClass(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
//        self.collectionView!.registerClass(SearchCollectionReusableViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellHeaderIdentifier)

    }

    //MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
        
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: cellHeaderIdentifier, forIndexPath: indexPath) as! UICollectionReusableView
            
            var label: UILabel = reusableView.viewWithTag(100) as! UILabel
            label.text = goods[indexPath.section] as? String
        }
        return reusableView
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: SearchCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchCollectionViewCell
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
