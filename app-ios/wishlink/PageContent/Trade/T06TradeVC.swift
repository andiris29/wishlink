//
//  T06-TradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/16.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06TradeVC: RootVC, UITableViewDelegate,UITableViewDataSource, T06CellHeaderDelegate, T06CellFooterDelegate,T06CellDelegate, WebRequestDelegate {

    let cellIdentifier = "T06Cell"
    let cellIdentifierHeader = "T06CellHeader"
    let cellIdentifierFooter = "T06CellFooter"

    @IBOutlet weak var button: UIButton!
    @IBOutlet var tradeTableView: UITableView!
    
    
    var item: ItemModel!
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
        
        self.httpObj.httpGetApi("tradeFeeding/byItem?item._id="+self.item._id, parameters: nil, tag: 60)
        self.navigationController?.navigationBarHidden = false;
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("订单详情")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(followArr.count>0)
        {
            let last: Int = followArr.count - 1
            
            switch indexPath.row {
            case 0:
                return 568
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
           let  tCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierHeader, forIndexPath: indexPath) as! T06CellHeader
           tCell.delegate = self
           tCell.initData(item)
           
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
    func btnFollowAction(sernder:UIButton) {
        
        if(UserModel.shared.isLogin)
        {
            SVProgressHUD.showWithStatusWithBlack("请稍后...")
            let para  = ["itemRef":item._id,
                "quantity":"1"];
            self.httpObj.httpPostApi("trade/create", parameters: para, tag: 62);
        }
        else
        {
            UIHEPLER.showLoginPage(self);
        }
    }
    
    //抢单
    func btnGrabOrderAction(sernder:UIButton) {
        
        if(UserModel.shared.isLogin)
        {
            if(self.selectArr.count>0)
            {
                SVProgressHUD.showWithStatusWithBlack("请稍后...")
                var tradeidArr:[String]! = [];
                for tradeItem in self.selectArr
                {
                    tradeidArr.append(tradeItem._id);
                }
                self.httpObj.httpPostApi("trade/assignToMe", parameters: ["_id":tradeidArr], tag: 61)
            }
            else
            {
                UIHEPLER.alertErrMsg("请先选择");
            }
          
        }
        else
        {
            UIHEPLER.showLoginPage(self);
        }
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
        print(response, terminator: "")
        if(tag == 60)
        {
            
            let tradesObj:NSArray! = (response as? NSDictionary)?.objectForKey("trades") as? NSArray
        
            if(tradesObj != nil && tradesObj!.count>0)
            {
                if(followArr != nil && followArr.count>0)
                {
                    self.followArr.removeAll();
                }
                for  itemObj in tradesObj!
                {
                    let tradeItem = TradeModel(dict: itemObj as! NSDictionary);
                    self.followArr.append(tradeItem);
                }
                self.tradeTableView.reloadData();
            }
        } else if(tag == 61) {
            
            let vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            vc.item = self.item;
            vc.isNewOrder = false;
            self.navigationController?.pushViewController(vc, animated: true);
            //todo:
        } else if(tag == 62) {//跟单成功转向支付页面
            
            
            let dic = response as! NSDictionary;
            let tradeDic = dic.objectForKey("trade") as!  NSDictionary;
            let tradeItem = TradeModel(dict: tradeDic);
            
            let vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            vc.item = self.item;
            vc.trade = tradeItem;
            vc.isNewOrder = false;
            self.navigationController?.pushViewController(vc, animated: true);
            
        }
    }
    
    func requestDataFailed(error: String) {
        
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }
    
}
