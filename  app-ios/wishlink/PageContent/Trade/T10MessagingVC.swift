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
    
    var itemContents: NSArray = ["item0", "item1", "item2", "item3", "item4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            var  leftCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierTime, forIndexPath: indexPath) as! T09CellTime
            cell = leftCell;
        case 1:
            var  rightCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierTextRight, forIndexPath: indexPath) as! T09CellTextRight
            cell = rightCell;
        default:
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierTextLeft, forIndexPath: indexPath) as! T09CellTextLeft
        }
        
        return cell
    }
    
    
}
