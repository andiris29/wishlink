//
//  U02UserVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U02UserVC: RootVC, WebRequestDelegate, UIScrollViewDelegate {

    @IBOutlet weak var orderBtn:        UIButton!
    @IBOutlet weak var recommendBtn:    UIButton!
    @IBOutlet weak var collectionBtn:   UIButton!
    @IBOutlet weak var settingBtn:      UIButton!
    
    @IBOutlet weak var subVCView: UIView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contryLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var v_TopView: UIView!
    @IBOutlet weak var v_baseInfo: UIView!
    
    
    var selectedBtn: UIButton!
    var userModel: UserModel = UserModel.shared
    
    var orderTradeVC: U02OrderTradeVC!
    var recommendVC: U02RecommendVC!
    var favoriteVC: U02FavoriteVC!
    var settingVC: U03SettingVC!
    
    var orderListDefaultModel:BuyerSellerType!;
    
//    lazy var loginVC: U01LoginVC = {
//        let vc = U01LoginVC(nibName: "U01LoginVC", bundle: MainBundle)
//        vc.hideSkipBtn = true
//        return vc
//    }()
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareData()
        self.prepareUI()
        
        
        var bar = self.navigationController?.navigationBar;
        bar?.tintColor = UIColor.whiteColor();
        self.navigationController?.automaticallyAdjustsScrollViewInsets = true;

        self.getUser()
        NSNotificationCenter.defaultCenter().addObserverForName(LoginSuccessNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti) -> Void in
            self.fillDataForUI()
        }
        self.loadComNavTitle("我的wishlink");


        
    }
    
    var isTop = false;


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController!.navigationBar.hidden = true;

        if self.userModel.isLogin == false {//弹出登陆窗体
            self.view.hidden = true;
            UIHEPLER.showLoginPage(self, isToHomePage: true);
            
        }
        else
        {
            
            self.view.hidden = false;
            self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
            self.fillDataForUI()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scrollView.delegate = self;
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.adjustUI()

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - delegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        if tag == 10 {
            if let userDic = response["user"] as? [String: AnyObject] {
                self.userModel.userDic = userDic
                
                if(self.userModel.isLogin)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.fillDataForUI()
                    })
                }
                else
                {
                    
                }
            }
        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        if(tag == 10)
        {
            httpObj.httpGetApi("user/loginAsGuest", tag: 10);
        }
    }
    
    // MARK: - response event
    
    @IBAction func orderBtnAction(sender: AnyObject) {
        
        self.selectedBtn.selected = false
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
    
        self.orderTradeVC.resetConditionView()
   
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func recommendBtnAction(sender: AnyObject) {
        
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.orderTradeVC.resetConditionView()
        self.scrollView.setContentOffset(CGPoint(x: ScreenWidth * 1, y: 0), animated: true)

        self.recommendVC.getRecommendation()
    }
    
    @IBAction func collectionBtnAction(sender: AnyObject) {
        
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.orderTradeVC.resetConditionView()
        self.scrollView.setContentOffset(CGPoint(x: ScreenWidth * 2, y: 0), animated: true)
        self.favoriteVC.getFavoriteList()
    }
    
    @IBAction func settingBtnAction(sender: AnyObject) {
        
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.orderTradeVC.resetConditionView()
        self.settingVC.fillDataForUI()
        self.scrollView.setContentOffset(CGPoint(x: ScreenWidth * 3, y: 0), animated: true)
    }
    
//    @IBAction func settingBtnAction(sender: AnyObject) {
//        let vc = U03SettingVC(nibName: "U03SettingVC", bundle: NSBundle.mainBundle())
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
    
    // MARK: - prive method
    
    func getUser() {
        if self.userModel.isLogin == true {
            return
        }
//        var registrationId = ""
//        var rid = APService.registrationID()
//        if rid.length != 0 {
//            registrationId = rid;
//        }
        self.httpObj.httpGetApi("user/get", parameters: nil, tag: 10)
    }
    
    func prepareData() {
        self.httpObj.mydelegate = self
    }
    
    // 根据用户数据填充界面
    func fillDataForUI() {
        if userModel.isLogin == true {
            self.nicknameLabel.text = self.userModel.nickname;
            
            self.httpObj.renderImageView(self.headImageView, url: userModel.portrait, defaultName: "")
            self.httpObj.renderImageView(self.bgImageView, url: userModel.background, defaultName: "")
            if(self.userModel.receiversArray != nil && self.userModel.receiversArray.count>0)
            {
                let result = UserModel.shared.receiversArray.filter{itemObj -> Bool in
                    return (itemObj as ReceiverModel).isDefault == true;
                }
                if(result.count>0)
                {
                    self.contryLabel.text = result[0].province;
                }
                else
                {
                    self.contryLabel.text = self.userModel.receiversArray[0].province;
                }
            }
            else
            {
                self.contryLabel.text = "--"
            }
        }
    }
    
    func adjustUI() {
        self.orderTradeVC.view.frame = self.subVCView.frame
        self.recommendVC.view.frame = self.subVCView.frame
        self.favoriteVC.view.frame = self.subVCView.frame
        self.settingVC.view.frame = self.subVCView.frame
        
        self.headImageView.layer.cornerRadius = self.headImageView.w * 0.5
        self.headImageView.layer.masksToBounds = true
        self.headImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.headImageView.layer.borderWidth = 2.0
        
        var center = CGPoint(x: CGRectGetWidth(self.scrollView.frame) * 0.5, y: CGRectGetHeight(self.scrollView.frame) * 0.5)
        self.orderTradeVC.view.center = center
        
        center.x += ScreenWidth
        self.recommendVC.view.center = center
        
        center.x += ScreenWidth
        self.favoriteVC.view.center = center
        
        center.x += ScreenWidth
        self.settingVC.view.center = center

        self.scrollView.contentSize = CGSize(width: CGRectGetWidth(self.scrollView.frame) * 4, height: 0)
    }
    
    func prepareSubVC() {
        
        self.orderTradeVC = U02OrderTradeVC(nibName: "U02OrderTradeVC", bundle: NSBundle.mainBundle())
        self.orderTradeVC.userVC = self
        if(orderListDefaultModel != nil)
        {
            orderTradeVC.currType = self.orderListDefaultModel;
        }
        self.orderTradeVC.orderListScrolling = {[weak self](isup:Bool) in
             self!.isSetting = false;
            self!.scrolling(isup);
        }
        self.orderTradeVC.view.frame = self.scrollView.bounds
        self.scrollView.addSubview(self.orderTradeVC.view)

        self.recommendVC = U02RecommendVC(nibName: "U02RecommendVC", bundle: NSBundle.mainBundle())
        self.recommendVC.userVC = self
        self.scrollView.addSubview(self.recommendVC.view)
        
        self.favoriteVC = U02FavoriteVC(nibName: "U02FavoriteVC", bundle: NSBundle.mainBundle())
        self.favoriteVC.userVC = self
        self.scrollView.addSubview(self.favoriteVC.view)

        self.settingVC = U03SettingVC(nibName: "U03SettingVC", bundle: NSBundle.mainBundle())
        
        settingVC.scrolling = {[weak self](isup:Bool) in
            self!.isSetting = true;
            self!.scrolling(isup);
        }
        settingVC.draging = {[weak self](isup:Bool,offsetY:CGFloat) in
            self!.draging(isup,offsetY: offsetY);
        }
        
        self.settingVC.userVC = self
        self.scrollView.addSubview(self.settingVC.view)
        
        self.adjustUI()
    }
    
    var orginFrame = CGRectMake(0, 0, ScreenWidth, 300);
    func draging(isUp:Bool,offsetY:CGFloat)
    {
        NSLog("_**_Draging View:"+String(offsetY));
        if(offsetY>0 && offsetY<=300)
        {
//            self.sv.contentOffset.y = offsetY;
            
//            self.v_TopView.frame = CGRectMake(0, 0-offsetY, ScreenWidth, 300);
//            self.view.frame = CGRectMake(0, 0-offsetY, ScreenWidth, ScreenHeight+offsetY);
//
            
//            self.constrain_TopView_MarginTop.constant = 0-offsetY
//            self.v_TopView.bounds = CGRectMake(0,0, ScreenWidth, 300)
//
//            self.settingVC.view.frame = CGRectMake(0, 300-offsetY, ScreenWidth, ScreenHeight-300+offsetY);
            
        }
        else if(offsetY == 0)
        {
//            self.constrain_TopView_MarginTop.constant = 0
            
//            self.v_TopView.frame = CGRectMake(0, 0, ScreenWidth, 300);
//                self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//           self.settingVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

//
//            self.v_TopView.bounds = CGRectMake(0,0, ScreenWidth, 300)
//
//        self.scrollView.frame = CGRectMake(0, 300, ScreenWidth, ScreenHeight-300);
            
        }
//        else
//        {
//            if(self.v_TopView.frame.origin.y<0)
//            {
//                var newFrame = CGRectMake(0, 0-offsetY, ScreenWidth, 300);
//                self.v_TopView.frame = newFrame;
//                
//            }
//        }
    }
    var animDuration = 0.3
    var isSetting = false;
   func scrolling(isUp:Bool)
   {
        NSLog("scrolling on U02UserVC");
    
//        var scroHeight:CGFloat = 180;
//        if(isSetting)
//        {
//            scroHeight = 120;
//        }
//        if(!isTop)
//        {
//            UIView.animateWithDuration(animDuration, animations: { () -> Void in
//                self.view.frame = CGRectMake(0, 0-scroHeight, ScreenWidth, ScreenHeight+scroHeight-(self.tabBarController?.tabBar.frame.height)!);
//                }, completion: { [weak self](finish) -> Void in
//                    if(finish)
//                    {
//                        self!.isTop = true;
//                    }
//            })
//        }
//        else
//        {
//            UIView.animateWithDuration(animDuration, animations: { () -> Void in
//                self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//                
//                }, completion: { [weak self](finish) -> Void in
//                    if(finish)
//                    {
//                        self!.isTop = false;
//                    }
//            })
//        }
    }
    
    func prepareUI() {
        
        self.prepareSubVC()
        self.selectedBtn = self.orderBtn
        self.orderBtnAction(self.orderBtn)
        
   
    }
    
    // MARK: - setter and getter
    
    //MARK:ScrollView delegate
//    var contentOffsetY:CGFloat! = 0;
//    var oldContentOffsetY:CGFloat! = 0;
//    var newContentOffsetY:CGFloat! = 0;
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        
//        contentOffsetY = scrollView.contentOffset.y;
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        oldContentOffsetY = scrollView.contentOffset.y;
//    }
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        //NSLog(@"scrollView.contentOffset:%f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
//        
//        newContentOffsetY = scrollView.contentOffset.y;
//        
//        if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {  // 向上滚动
//            
//            NSLog("up");
//            
//        } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
//            
//            NSLog("down");
//            
//        } else {
//            
//            NSLog("dragging");
//            
//        }
//        if (scrollView.dragging) {  // 拖拽
//            
//            NSLog("scrollView.dragging");
//            NSLog("contentOffsetY: %f", contentOffsetY);
//            NSLog("newContentOffsetY: %f", scrollView.contentOffset.y);
//            if ((scrollView.contentOffset.y - contentOffsetY) > 5.0) {  // 向上拖拽
//                    UIView.animateWithDuration(0.5, animations: { () -> Void in
//                        self.view.frame = CGRectMake(0, -245, ScreenWidth, ScreenHeight);
//                        
//                        }, completion: { (finish) -> Void in
//                            if(finish)
//                            {
//                                
//                            }
//                    })
//                
//            } else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0) {   // 向下拖拽
//                
//                UIView.animateWithDuration(0.5, animations: { () -> Void in
//                    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//                    
//                    }, completion: { (finish) -> Void in
//                        if(finish)
//                        {
//                            
//                        }
//                })
//            } else {
//                
//            }
//        }
//    }
//    


}









