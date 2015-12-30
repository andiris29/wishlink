//
//  T10MessagingVC.swift
//  wishlink
//
//  Created by whj on 15/8/26.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T10MessagingVC: RootVC, UITableViewDelegate,UITableViewDataSource {
    
    let cellIdentifierTime = "T09CellTime"
    let cellIdentifierTextLeft = "T09CellTextLeft"
    let cellIdentifierTextRight = "T09CellTextRight"
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet var chatTableView: UITableView!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSpec: UILabel!
    @IBOutlet weak var lbTotalFree: UILabel!
    
    var trade:TradeModel!
    
    var itemContents: NSArray = ["item0", "item1", "item2", "item3", "item4"]
    //MARK:Life Cycle
    deinit{
        NSLog("T10MessagingVC -->deinit")
        self.dataArr = nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadComNaviLeftBtn();
        self.chatTableView.registerNib(UINib(nibName: cellIdentifierTime, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierTime)
        self.chatTableView.registerNib(UINib(nibName: cellIdentifierTextLeft, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierTextLeft)
        self.chatTableView.registerNib(UINib(nibName: cellIdentifierTextRight, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierTextRight)
        self.loadData();
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
        self.hidesBottomBarWhenPushed = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = false
        self.hidesBottomBarWhenPushed = true;
        self.loadComNaviLeftBtn()
    }
    
    func loadData()
    {
        if(self.trade != nil && self.trade.item != nil)
        {
            self.lbName.text  = "品名：\(self.trade.item.brand) \(self.trade.item.name)"
            self.lbSpec.text = "规格：\(self.trade.item.spec)"
            self.lbTotalFree.text = "合计：RMB\((self.trade.item.price * Float(self.trade.quantity)).format(".2"))";
            
            
        }
        else
        {
            NSLog("no data in page:T10MessageVC")
        }
    }
    //MARk:UITableView Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 30
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
        
        switch indexPath.row {
        case 0:
            let  leftCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierTime, forIndexPath: indexPath) as! T09CellTime
            cell = leftCell;
        case 1:
            let  rightCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierTextRight, forIndexPath: indexPath) as! T09CellTextRight
            cell = rightCell;
        default:
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierTextLeft, forIndexPath: indexPath) as! T09CellTextLeft
        }
        
        return cell
    }
    
    
}
