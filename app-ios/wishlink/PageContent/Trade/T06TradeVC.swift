//
//  T06-TradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/16.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06TradeVC: RootVC, UITableViewDelegate,UITableViewDataSource, T06CellHeaderDelegate, T06CellFooterDelegate, WebRequestDelegate {

    let cellIdentifier = "T06Cell"
    let cellIdentifierHeader = "T06CellHeader"
    let cellIdentifierFooter = "T06CellFooter"

    @IBOutlet weak var button: UIButton!
    @IBOutlet var tradeTableView: UITableView!
    
    
    var product: ItemModel!
    var followArr:[TradeModel]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self;

        followArr = [];
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        let param = ["item.id" : self.product._id]
        self.httpObj.httpGetApi("tradeFeeding/byItem", parameters: param, tag: 60)
        
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifierHeader, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierHeader)
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifierFooter, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierFooter)
        
        self.httpObj.mydelegate = self;
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
   
//           tCell.btnFlow.addTarget(self, action: "btnFollowAction:", forControlEvents: UIControlEvents.TouchUpInside)
           tCell.delegate = self
           tCell.initData(product)
           
           cell = tCell;
        case last:
           let  fcell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierFooter, forIndexPath: indexPath) as! T06CellFooter
//           fcell.btnGrabOrder.addTarget(self, action: "btnGrabOrderAction:", forControlEvents: UIControlEvents.TouchUpInside)
           fcell.delegate = self
           cell = fcell;
        default:
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T06Cell
            
            
        }
        
        return cell
    }
    
    //MARK: - Action
    
    func btnFollowAction(sernder:UIButton) {
        
        if(UserModel.shared.isLogin)
        {
            let vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle())
            vc.isNewOrder = false
            vc.item = product;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        else
        {
            UIHEPLER.showLoginPage(self);
        }
    }
    
    func btnGrabOrderAction(sernder:UIButton) {
        
        if(UserModel.shared.isLogin)
        {
            SVProgressHUD.showWithStatusWithBlack("请稍后...")
            self.httpObj.httpPostApi("trade/assignToMe", tag: 61)
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
        
        print(response, terminator: "")
        if(tag == 60)
        {
            let tradesObj = response as? NSArray
            if(tradesObj != nil && tradesObj?.count>0)
            {
                if(followArr != nil && followArr.count>0)
                {
                    self.followArr.removeAll();
                }
                for  itemObj in tradesObj!
                {
                    let tradeItem = TradeModel(dict: itemObj as! NSDictionary);
                    self.followArr.append(tradeItem);
                    self.tradeTableView.reloadData();
                }
            }
        } else if(tag == 61) {
            
            SVProgressHUD.dismiss();
            
            let vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            vc.item = self.product;
            vc.isNewOrder = false;
            self.navigationController?.pushViewController(vc, animated: true);

            
            //todo:
        } else if(tag == 62) {
            
        }
    }
    
    func requestDataFailed(error: String) {
        
        SVProgressHUD.showErrorWithStatusWithBlack("获取用户信息失败！");
    }
    
}
