//
//  T02HotListVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/21/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum t02model:Int
{
    case hot = 0,
    search=1
}


class T02HotListVC: RootVC, U02ItemCellDelegate, WebRequestDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbTipMessage: UILabel!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    let itemCellIde = "U02ItemCell"
    
    var keyword = "";
    var pagemodel = t02model.hot;
    var currentItemCell: U02ItemCell = U02ItemCell()
    var searchTextField: UITextField!
    var topView = UIImageView()
    
    //    var t06VC:T06ItemVC!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.preparePage()
        self.initTopView()
        
        self.httpObj.mydelegate = self;
        
        if(self.pagemodel == .search)
        {
            let para:[String : AnyObject] = ["pageNo":1,
                "pageSize":10,
                "keyword":self.keyword]
            self.httpObj.httpGetApi("itemFeeding/search", parameters: para , tag: 10);
        }
        else
        {
            self.httpObj.httpGetApi("itemFeeding/hot", parameters: nil , tag: 10);
        }
    }
    
    deinit{
        
        NSLog("T02HotListVC -->deinit")
        
        if(self.dataArr != nil && self.dataArr.count>0)
        {
            self.dataArr.removeAll();
            self.dataArr = nil;
        }
        
        self.httpObj.mydelegate = nil;
        self.collectionView = nil;
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        
        self.navigationController?.navigationBarHidden = false;
        
        
        //        self.maskView.hidden = false;
        
        //        SVProgressHUD.showWithStatusWithBlack("请稍等...")
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false;
    }
    
    func initTopView() {
        
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(44, 10, 10, 10)
        
        topView.backgroundColor = RGB(247, g: 247, b: 247)
        topView.frame = CGRectMake(0, 0, ScreenWidth, 44)
        topView.userInteractionEnabled = true
        self.collectionView.addSubview(topView)
        
        
        self.searchTextField = UITextField()
        self.searchTextField.frame = CGRectMake(10, 7, ScreenWidth - 20, 30)
        self.searchTextField.backgroundColor = RGB(228, g: 228, b: 228)
        self.searchTextField.font = UIHEPLER.mainChineseFont15
        self.searchTextField.layer.masksToBounds = true
        self.searchTextField.layer.cornerRadius = 5
        self.searchTextField.placeholder = "请输入搜索内容"
        self.searchTextField.delegate = self
        self.searchTextField.returnKeyType  = UIReturnKeyType.Done;
        self.searchTextField.leftViewMode = UITextFieldViewMode.Always
        self.searchTextField.leftView = UIView(frame: CGRectMake(0, 0, 7, 30))
        topView.addSubview(self.searchTextField)
    }
    
    // MARK: - Touch
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.searchTextField.resignFirstResponder()
    }
    
    //MARK: collectionView Delegete
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.mainScreen().bounds.size.width - 20 - 10) / 2.0;
        let height: CGFloat = width+100;
        
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
        cell.loadFromhotVC(item)
        cell.cellType = .Hot
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var t06VC:T06ItemVC! = T06ItemVC(nibName: "T06ItemVC", bundle: NSBundle.mainBundle());
        
        t06VC.item = self.dataArr[indexPath.row] as! ItemModel
        t06VC.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(t06VC, animated: true);
        t06VC = nil;
    }
    
    
    // MARK: - prive method
    func preparePage() {
        
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 7.5, right: 10)
        self.collectionView.registerNib(UINib(nibName: "U02ItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: itemCellIde)
        self.collectionView.scrollEnabled = true;
        if(self.pagemodel == .search)
        {
            self.loadComNaviLeftBtn()
            self.loadComNavTitle(self.keyword)
        }
        else
        {
            self.loadComNavTitle("最热")
        }
    }
    
    // MARK: - IBAction
    
    func backButtonAction(button: UIButton){
        
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let _keyword = textField.text!;
        if(_keyword.trim().length>0)
        {
            self.keyword = _keyword
            let para:[String : AnyObject] = ["pageNo":1,
                "pageSize":10,
                "keyword":self.keyword]
            self.maskView.hidden = false;
            self.lbTipMessage.text = "正在搜索中..."
            //            if(self.pagemodel == .search)
            //            {
            self.loadComNavTitle(self.keyword)
            //            }
            
            self.httpObj.httpGetApi("itemFeeding/search", parameters: para , tag: 10);
            SVProgressHUD.showWithStatusWithBlack("请稍等...")
        }
        
        return true
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y < 0) {
            
            var topViewRect = self.topView.frame
            topViewRect.origin.y = scrollView.contentOffset.y
            self.topView.frame = topViewRect
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y < 10.0 {
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        if (scrollView.contentOffset.y >= 10.0) && (scrollView.contentOffset.y <= 44.0) {
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 38.0), animated: true)
        }
    }
    
    //MARK: - U02ItemCellDelegate
    
    func itemCell(cell: U02ItemCell, clickType: ItemCellButtonClickType) {
        
        //该页面不需要收藏和取消收藏功能
        
        //        if(UserModel.shared.isLogin)
        //        {
        //
        //            var urlSub: String = "item/favorite"
        //            if (cell.favoriteBtn.selected) {
        //                urlSub = "item/unfavorite"
        //            }
        //            let para = ["_id" : cell.item._id]
        //            self.httpObj.httpPostApi(urlSub , parameters:para, tag: 21);
        //            self.currentItemCell = cell
        //        }
        //        else
        //        {
        //            UIHEPLER.showLoginPage(self, isToHomePage: false);
        //        }
    }
    
    //MARK:WebRequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        if( self.lbTipMessage != nil)
        {
            self.lbTipMessage.text = ""
        }
        SVProgressHUD.dismiss();
        if(tag == 10)
        {
            print(response)
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
                self.lbTipMessage.text = "没有搜索到数据"
            }
            
        }
        else if (tag == 21)//收藏 or 取消收藏
        {
            self.currentItemCell.favoriteBtn.selected = !self.currentItemCell.favoriteBtn.selected
        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        if( self.maskView != nil)
        {
            self.maskView.hidden = false;
        }
        if(tag == 10)
        {
            SVProgressHUD.dismiss();
            if(self.lbTipMessage != nil)
            {
                self.lbTipMessage.text = "暂无数据"
            }
        }
        else
        {
            SVProgressHUD.showErrorWithStatusWithBlack(error);
        }
    }
    
    
}










