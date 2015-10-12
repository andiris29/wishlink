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
    
    var itemContents: NSArray = ["item0", "item1", "item2", "item3", "item4"]
    
    var product: ItemModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tradeTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifierHeader, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierHeader)
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifierFooter, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierFooter)
        

        self.httpObj.mydelegate = self;
        self.navigationController?.navigationBarHidden = false;
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("订单详情")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let last: Int = itemContents.count - 1
        
        switch indexPath.row {
        case 0:
            return 568
        case last:
            return 65
        default :
            return 90
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemContents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        let last: Int = itemContents.count - 1
        
        switch indexPath.row {
        case 0:
           let  tCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierHeader, forIndexPath: indexPath) as! T06CellHeader
   
           tCell.btnFlow.addTarget(self, action: "btnFollowAction:", forControlEvents: UIControlEvents.TouchUpInside)
           tCell.delegate = self
           tCell.initData(product)
           
           cell = tCell;
        case last:
           let  fcell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierFooter, forIndexPath: indexPath) as! T06CellFooter
           fcell.btnGrabOrder.addTarget(self, action: "btnGrabOrderAction:", forControlEvents: UIControlEvents.TouchUpInside)
           fcell.delegate = self
           cell = fcell;
        default:
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T06Cell
        }
        
        return cell
    }
    
    //MARK: - Action
    
    func btnFollowAction(sernder:UIButton) {
        
        let vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle())
        vc.isNewOrder = false
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    func btnGrabOrderAction(sernder:UIButton) {
        
        let vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle())
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    //MARK: - T06CellHeaderDelegate
    
    func dorpListButtonAction(sender: UIButton) {
    
    }
    
    func orderButtonAction(sender: UIButton) {

    }

    //MARK: - T06CellFooterDelegate
    
    func grabOrderButtonAction(sender: UIButton) {
        
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        self.httpObj.httpPostApi("trade/assignToMe", tag: 61)
        
        self.navigationController?.popToRootViewControllerAnimated(true);
        if( UIHEPLER.GetAppDelegate().window!.rootViewController as? UITabBarController != nil) {
            let tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
            tababarController.selectedIndex = 3;
        }
    }
    
    //MARK: - Request delegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        print(response, terminator: "")
        
        if(tag == 60) {
        } else if(tag == 61) {
            
            SVProgressHUD.dismiss();
            //todo:
        }
    }
    
    func requestDataFailed(error: String) {
        
        SVProgressHUD.showErrorWithStatusWithBlack("获取用户信息失败！");
    }
}
