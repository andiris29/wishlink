//
//  T06-TradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/16.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06TradeVC: RootVC, UITableViewDelegate,UITableViewDataSource {

    let cellIdentifier = "tradeTableViewcell"
    let cellIdentifierHeader = "tradeTableViewcellHeader"
    let cellIdentifierFooter = "tradeTableViewcellFooter"
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet var tradeTableView: UITableView!
    
    var itemContents: NSArray = ["item0", "item1", "item2", "item3", "item4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tradeTableView.registerNib(UINib(nibName: "TradeTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
        self.tradeTableView.registerNib(UINib(nibName: "TradeTableViewCellHeader", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierHeader)
        self.tradeTableView.registerNib(UINib(nibName: "TradeTableViewCellFooter", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierFooter)
        

        self.navigationController?.navigationBarHidden = true;
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
           var  tCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierHeader, forIndexPath: indexPath) as! TradeTableViewCellHeader
            tCell.btnBack.addTarget(self, action: "leftNavBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
           cell = tCell;
        case last:
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierFooter, forIndexPath: indexPath) as! TradeTableViewCellFooter
        default:
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TradeTableViewCell
        }
        
        return cell
    }


}
