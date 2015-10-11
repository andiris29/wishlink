//
//  T03SearchHelperVC.swift
//  wishlink
//
//  Created by whj on 15/8/21.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

let HttpTag: Int = 1000

import UIKit

class T03SearchHelperVC: RootVC, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WebRequestDelegate, SearchCollectionViewCellDelegate {

    let cellIdentifier = "SearchCollectionViewCell"
    let cellHeaderIdentifier = "SearchCollectionReusableViewHeader"
    
    var marks: NSArray!
    var titles: NSArray!
    var goods: NSMutableDictionary!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionCellRegisterNib()
        initWithData()
        initWithView()
        httpRequest()
    }
    
    func collectionCellRegisterNib() {
    
        self.collectionView.registerNib(UINib(nibName: "SearchCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.registerNib(UINib(nibName: "SearchCollectionReusableViewHeader", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellHeaderIdentifier)
        
//        self.collectionView!.registerClass(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
//        self.collectionView!.registerClass(SearchCollectionReusableViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellHeaderIdentifier)

    }
    
    func httpRequest() {
        
        self.httpObj.mydelegate = self;
        var parameter = ["req.pageNo":1, "req.pageSize":10]
        
        for var index = 0; index < marks.count; index++ {
            
            self.httpObj.httpGetApi("trend/\(marks[index])", parameters: parameter, tag: HttpTag + index);
        }
    }
    
    func initWithData() {
     
        marks = ["country", "category", "brand"]
        titles = ["国家和地区", "种类", "热门品牌"]
        goods = NSMutableDictionary(capacity: marks.count);
    }
    
    func initWithView() {
    
        self.loadComNavTitle("搜索");
    }

    //MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
        
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: cellHeaderIdentifier, forIndexPath: indexPath) as! UICollectionReusableView
            
            var label: UILabel = reusableView.viewWithTag(100) as! UILabel
            label.text = titles[indexPath.section] as? String
        }
        return reusableView
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return self.marks.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var num: Int = 0
        var key: String = marks[section] as! String
        if self.goods[key] == nil { num = 0 } else { num = self.goods[key]!.count }
        
        return num
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: SearchCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchCollectionViewCell
        cell.delegate = self
        
        var key: String = marks[indexPath.section] as! String
        if self.goods[key] != nil {
            var array: NSArray = self.goods[key] as! NSArray
            cell.initData(array[indexPath.row] as! TrendModel, indexPath: indexPath)
        }
        
        return cell
    }
    
    //MARK: - Action
    
    @IBAction func searchButtonAction(sender: AnyObject) {
        
        var vc = T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle());
        vc.keyword = self.searchTextField.text
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func searchTextFiledEndExit(sender: AnyObject) {
        
        
        
        var vc = T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle());
        vc.keyword = self.searchTextField.text
        self.navigationController?.pushViewController(vc, animated: true);
        
        
//        var vc = T11SearchSuggestionVC(nibName: "T11SearchSuggestionVC", bundle: NSBundle.mainBundle());
//        vc.searchContext = self.searchTextField.text
//        vc.searchType = .any
//        self.navigationController?.pushViewController(vc, animated: true);
        
        
    }
    
    //MARK: - WebRequestDelegate 
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if tag < HttpTag || tag >= HttpTag + marks.count {return }
        
        if let trendDic = response as? NSDictionary {
            
            modelConversionFormData(trendDic.objectForKey("trends") as! NSArray, tag: tag)
        }
    }
    
    func requestDataFailed(error: String) {
        
    }
    
    //MARK: - Unit
    
    func modelConversionFormData(dataArray: NSArray!, tag: Int) {
       
        if (dataArray != nil && dataArray.count > 0) {
            
            var temp: NSMutableArray = NSMutableArray();
            
            for itemObj in dataArray {
                
                var itemdic = itemObj as! NSDictionary;
                var item =  TrendModel(dict: itemdic);
                temp.addObject(item);
            }
            var key: String = marks[tag - HttpTag] as! String
            self.goods[key] = temp
            
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - SearchCollectionViewCellDelegate 
    
    func searchCollectionViewCell(cell: SearchCollectionViewCell, title: NSString, buttonIndex: Int) {
        
        self.searchTextField.text = title as String
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
