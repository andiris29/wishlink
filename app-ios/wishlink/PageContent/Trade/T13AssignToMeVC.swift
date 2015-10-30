//
//  T13AssignToMeVC.swift
//  wishlink
//
//  Created by whj on 15/8/16.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T13AssignToMeVC: RootVC, UITableViewDelegate,UITableViewDataSource,  T06CellFooterDelegate,T06CellDelegate, WebRequestDelegate {

    let cellIdentifier = "T06Cell"
    let cellIdentifierHeader = "T13CellHeader"
    let cellIdentifierFooter = "T06CellFooter"

    @IBOutlet weak var button: UIButton!
    @IBOutlet var tradeTableView: UITableView!
    
    var T14VC:T14AssignToMeConfirm!
    
    var t05VC:T05PayVC!
    var item: ItemModel!
    var trade:TradeModel!
    //跟单列表
    var followArr:[TradeModel]! = []
    //选中的抢单列表
    var selectArr:[TradeModel]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self;

        followArr = [];
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
     
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifierHeader, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierHeader)
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifierFooter, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierFooter)
        
        self.httpObj.httpGetApi("tradeFeeding/byItem?_id="+self.item._id, parameters: nil, tag: 60)
        self.navigationController?.navigationBarHidden = false;
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("抢单列表")
    }
    
    deinit{
        
        NSLog("T06TradeVC -->deinit")
        self.item = nil;
        self.tradeTableView = nil;
        
        if(self.dataArr != nil && self.dataArr.count>0)
        {
            self.dataArr.removeAll();
            self.dataArr = nil;
        }
        if(self.followArr != nil && self.followArr.count>0)
        {
            self.followArr.removeAll();
            self.followArr = nil;
        }
        if(self.selectArr != nil && self.selectArr.count>0)
        {
            self.selectArr.removeAll();
            self.selectArr = nil;
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if(self.t05VC != nil)
        {
            self.t05VC = nil;
        }
        if(self.T14VC != nil)
        {
            self.T14VC = nil;
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.tradeTableView.layoutIfNeeded();
        self.view.layoutIfNeeded();
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(followArr.count>0)
        {
            let last: Int = followArr.count - 1
            
            switch indexPath.row {
            case 0:
                return 276
            case last:
                return 65
            default :
                return 90
            }
        }
        else
        {
            
            return 568+20+65;
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return followArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        let last: Int = followArr.count - 1
        
        
        switch indexPath.row {
        case 0:
           let  tCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierHeader, forIndexPath: indexPath) as! T13CellHeader
//           tCell.delegate = self
           tCell.loadData(self.item,_trade: self.trade);
           
           cell = tCell;
        case last:
           let  fcell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierFooter, forIndexPath: indexPath) as! T06CellFooter
           fcell.delegate = self
           cell = fcell;
        default:
            let  tCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T06Cell
            tCell.loadData(followArr[indexPath.row - 1],item:self.item);
            tCell.myDelegate = self;
            cell = tCell;
            
        }
        
        return cell
    }
     func selectItemChange(selectTrade:TradeModel,isSelected:Bool)
     {
        if(isSelected)//insert
        {
            self.selectArr.append(selectTrade);
        }
        else//remove
        {
            if(self.selectArr.count>0)
            {
                var index = 0;
               for tradeObj in self.selectArr
               {
                    if(tradeObj._id == selectTrade._id)
                    {
                        break;
                    }
                    index+=1;
                }
                self.selectArr.removeAtIndex(index);
            }
            
        }
    }
    //MARK: - Action
    //跟单
//    func btnFollowAction(sernder:UIButton) {
//        
//        if(UserModel.shared.isLogin)
//        {
//            SVProgressHUD.showWithStatusWithBlack("请稍后...")
//            let para  = ["itemRef":item._id,
//                "quantity":"1"];
//            self.httpObj.httpPostApi("trade/create", parameters: para, tag: 62);
//        }
//        else
//        {
//            UIHEPLER.showLoginPage(self);
//        }
//    }
    
    //抢单
    func btnGrabOrderAction(sernder:UIButton) {
        
        
        
         self.T14VC = T14AssignToMeConfirm(nibName: "T14AssignToMeConfirm", bundle: NSBundle.mainBundle());
        
//        vc.item = self.item;
        self.presentViewController(self.T14VC, animated: true, completion: nil);
   
        
        
        
//        if(UserModel.shared.isLogin)
//        {
//            if(self.selectArr.count>0)
//            {
//                SVProgressHUD.showWithStatusWithBlack("请稍后...")
//                
//                for tradeItem in self.selectArr
//                {
//                    self.httpObj.httpPostApi("trade/assignToMe", parameters: ["_id":tradeItem._id], tag: 61)
//                }
//            }
//            else
//            {
//                UIHEPLER.alertErrMsg("请先选择");
//            }
//          
//        }
//        else
//        {
//            UIHEPLER.showLoginPage(self);
//        }
    }
    
    //MARK: - T06CellHeaderDelegate
    
    func dorpListButtonAction(sender: UIButton) {
    
    }
    
   

    //MARK: - T06CellFooterDelegate
    
    func grabOrderButtonAction(sender: UIButton) {
        
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        self.httpObj.httpPostApi("trade/assignToMe", tag: 61)

    }
    
    //MARK: - Request delegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        SVProgressHUD.dismiss();
//        print(response, terminator: "")
        if(tag == 60)
        {
            
            let tradesObj:NSArray! = (response as? NSDictionary)?.objectForKey("trades") as? NSArray
            print(tradesObj);
            if(tradesObj != nil && tradesObj!.count>0)
            {
                if(followArr != nil && followArr.count>0)
                {
                    self.followArr.removeAll();
                }
                for  itemObj in tradesObj!
                {
                    let tradeItem = TradeModel(dict: itemObj as! NSDictionary);
                    if(tradeItem.item != nil && tradeItem.item._id == self.item._id)
                    {
                        self.trade = tradeItem
                    }
                    self.followArr.append(tradeItem);
                }
                
                
                
                self.tradeTableView.reloadData();
            }
            
            
            
        } else if(tag == 61) {
            
            
            if( UIHEPLER.GetAppDelegate().window!.rootViewController as? UITabBarController != nil) {
                let tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
                let vc: U02UserVC! = tababarController.childViewControllers[3] as? U02UserVC
                if(vc != nil)
                {
                    vc.orderBtnAction(vc.orderBtn);
                }
                
                tababarController.selectedIndex = 3;
            }
            
            
        } else if(tag == 62) {//跟单成功转向支付页面
            
            let dic = response as! NSDictionary;
            let tradeDic = dic.objectForKey("trade") as!  NSDictionary;
            let tradeItem = TradeModel(dict: tradeDic);
            if( self.t05VC == nil)
            {
                self.t05VC = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            }
            self.t05VC.item = self.item;
            self.t05VC.trade = tradeItem;
            self.t05VC.isNewOrder = false;
            self.navigationController?.pushViewController(self.t05VC, animated: true);
            
        }
    }
    
    func requestDataFailed(error: String) {
        
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }
    
}
