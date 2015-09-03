//
//  T06-TradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/16.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06TradeVC: RootVC, UITableViewDelegate,UITableViewDataSource {

    let cellIdentifier = "T06Cell"
    let cellIdentifierHeader = "T06CellHeader"
    let cellIdentifierFooter = "T06CellFooter"
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet var tradeTableView: UITableView!
    
    var itemContents: NSArray = ["item0", "item1", "item2", "item3", "item4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tradeTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifierHeader, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierHeader)
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifierFooter, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierFooter)
        

        self.navigationController?.navigationBarHidden = false;
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("订单详情")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var last: Int = itemContents.count - 1
        
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
        var last: Int = itemContents.count - 1
        
        switch indexPath.row {
        case 0:
           var  tCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierHeader, forIndexPath: indexPath) as! T06CellHeader
   
           tCell.btnFlow.addTarget(self, action: "btnFollowAction:", forControlEvents: UIControlEvents.TouchUpInside)
           
           cell = tCell;
        case last:
           var  fcell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierFooter, forIndexPath: indexPath) as! T06CellFooter
           fcell.btnGrabOrder.addTarget(self, action: "btnGrabOrderAction:", forControlEvents: UIControlEvents.TouchUpInside)
           cell = fcell;
        default:
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T06Cell
        }
        
        return cell
    }
    
    
    func btnFollowAction(sernder:UIButton)
    {
         var vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle())
        self.navigationController?.pushViewController(vc, animated: true);
    }
    func btnGrabOrderAction(sernder:UIButton)
    {
        self.navigationController?.popToRootViewControllerAnimated(true);
        if( UIHEPLER.GetAppDelegate().window!.rootViewController as? UITabBarController != nil) {
            var tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
            tababarController.selectedIndex = 3;
        }

    }

}