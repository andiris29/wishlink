//
//  U02FavoriteVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/23/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U02FavoriteVC: RootVC, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {


    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var clearView: UIView!
    var clearBtn: UIButton!
    let itemCellIde = "U02ItemCell"
    weak var userVC: U02UserVC!

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareCollectionView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width: CGFloat = (UIScreen.mainScreen().bounds.size.width - 20 - 10) / 2.0;
        var height: CGFloat = 250.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(itemCellIde, forIndexPath: indexPath) as! U02ItemCell
        cell.cellType = .Favorite
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.dragging == false {
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
    
    // MARK: - response event
    func clearBtnAction(sender: AnyObject) {
        var inset = self.collectionView.contentInset
        inset.top = 0
        self.collectionView.contentInset = inset
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.collectionView.setContentOffset(CGPointMake(0, -inset.top), animated: false)
        })
    }
    
    // MARK: - prive method
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
        self.clearBtn.setTitle("清空收藏", forState: .Normal)
        self.clearBtn.setBackgroundImage(UIImage(named: "u02-clearcollection"), forState: .Normal)
        self.clearBtn.addTarget(self, action: "clearBtnAction:", forControlEvents: .TouchUpInside)
        self.clearView.addSubview(self.clearBtn)
        
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 7.5, left: 10, bottom: 7.5, right: 10)
        self.collectionView.registerNib(UINib(nibName: "U02ItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: itemCellIde)
    }

}
