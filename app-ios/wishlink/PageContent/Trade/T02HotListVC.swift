//
//  T02HotListVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/21/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class T02HotListVC: RootVC, U02ItemCellDelegate, WebRequestDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbTipMessage: UILabel!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let itemCellIde = "U02ItemCell"
    
    var keyword = "奶粉";
    var isNeedShowNavi = false;
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preparePage()

        self.httpObj.mydelegate = self;
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
        
        let para:[String : AnyObject] = ["pageNo":1,
            "pageSize":10,
        "keyword":self.keyword]
        self.maskView.hidden = false;
        self.lbTipMessage.text = "正在搜索中..."
        
        self.httpObj.httpGetApi("search/search", parameters: para , tag: 10);
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
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
        let width: CGFloat = (UIScreen.mainScreen().bounds.size.width - 20 - 10) / 2.0;
        let height: CGFloat = 250.0
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.dataArr != nil && self.dataArr.count>0)
        {
            return self.dataArr.count;
        }
        else
        {
            return 0;
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(itemCellIde, forIndexPath: indexPath) as! U02ItemCell
        cell.delegate = self
        let item = self.dataArr[indexPath.row] as! ItemModel
        cell.loadFromhotVC(item);
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let vc = T06TradeVC(nibName: "T06TradeVC", bundle: NSBundle.mainBundle());
        vc.product = self.dataArr[indexPath.row] as! ItemModel
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

    //MARK: - U02ItemCellDelegate 
    
    func itemCell(cell: U02ItemCell, clickType: ItemCellButtonClickType) {
        
        var urlSub: String = "item/favorite"
        if (cell.favoriteBtn.selected) {
            urlSub = "item/unfavorite"
        }
        self.httpObj.httpPostApi(urlSub , tag: 21);
    }
    
    //MARK:WebRequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        self.lbTipMessage.text = ""
        SVProgressHUD.dismiss();
        if(tag == 10)
        {
            if(response as! NSDictionary).objectForKey("items") != nil{
            
                if( self.dataArr != nil &&  self.dataArr.count>0)
                {
                    self.dataArr.removeAll(keepCapacity: false);
                }
                self.dataArr = [];
                
                let itemArr = (response as! NSDictionary).objectForKey("items") as! NSArray;
                if(itemArr.count>0)
                {
                    
                    self.maskView.hidden = true;
                    for itemObj in itemArr
                    {
                        let item = ItemModel(dict: itemObj as! NSDictionary);
                        if(item._id != "")
                        {
                            self.dataArr.append(item);
                        }
                    }
                    collectionView.reloadData();
                    
                }
                else
                {
                    self.dataArr = [];
                }
            }
            else
            {
                
                self.maskView.hidden = false;
                self.lbTipMessage.text = "没有搜索数据"
            }
            
        } else if (tag == 21) {
        
        }
    }
    
    func requestDataFailed(error: String) {
        SVProgressHUD.showErrorWithStatusWithBlack("获取数据出错");
    }

    
}










