//
//  T09ComplaintStatusVC.swift
//  wishlink
//
//  Created by whj on 15/8/26.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T09ComplaintStatusVC: RootVC, UITableViewDelegate,UITableViewDataSource {
    
    let cellIdentifierTime = "T09CellTime"
    let cellIdentifierTextLeft = "T09CellTextLeft"
    let cellIdentifierTextRight = "T09CellTextRight"
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet var chatTableView: UITableView!
    
    @IBOutlet weak var iv1: UIImageView!
    @IBOutlet weak var lbNo: UILabel!
    @IBOutlet weak var iv2: UIImageView!
    @IBOutlet weak var lbproblem: UILabel!
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv4: UIImageView!
    @IBOutlet weak var iv5: UIImageView!
    var trade:TradeModel!
    var itemContents: NSArray = ["item0", "item1", "item2", "item3", "item4"]
    //MARK:Life Cycle
    deinit{
        NSLog("T09ComplaintStatusVC -->deinit")
        self.dataArr = nil;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData();
        
        self.loadComNavTitle( "查看投诉");
        self.loadComNaviLeftBtn();
        self.navigationController?.navigationBarHidden = false;
        self.chatTableView.registerNib(UINib(nibName: cellIdentifierTime, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierTime)
        self.chatTableView.registerNib(UINib(nibName: cellIdentifierTextLeft, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierTextLeft)
        self.chatTableView.registerNib(UINib(nibName: cellIdentifierTextRight, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierTextRight)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.loadComNaviLeftBtn();
        self.navigationController?.navigationBarHidden = false;
    }
    func loadData()
    {
        if(self.trade != nil && self.trade.complaints != nil && self.trade.complaints.count>0)
        {
            let itemComplaint = self.trade.complaints[0];
            self.lbNo.text = self.trade._id;
            self.lbproblem.text = itemComplaint.problem;
            if(itemComplaint.images != nil && itemComplaint.images.count>0)
            {
                WebRequestHelper().renderImageView(self.iv1, url: itemComplaint.images[0], defaultName: UIHEPLER.noneImgName);
            }
        }
    }
    
    //MARK:UITableView Delegate
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
