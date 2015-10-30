//
//  T14AssignToMeConfirm.swift
//  wishlink
//
//  Created by whj on 15/10/29.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class T14AssignToMeConfirm: RootVC, UITableViewDataSource, UITableViewDelegate, WebRequestDelegate, T06CellDelegate {
    
    let cellIdentifier = "T06Cell"
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tradeTableView: UITableView!
    
    
    var t05VC:T05PayVC!
    var item: ItemModel!
    //跟单列表
    var followArr:[TradeModel]! = []
    //选中的抢单列表
    var selectArr:[TradeModel]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
    }
    
    func initData() {
    
        self.httpObj.mydelegate = self
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 88
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return followArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T06Cell
        cell.loadData(followArr[indexPath.row - 1],item:self.item);
        cell.myDelegate = self;
        
        return cell
    }
    
    // MARK: - Action
    
    @IBAction func closeButtonAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func tradeButtonAction(sender: UIButton) {
        
        if sender.tag == 500 { //继续抢单
            self.dismissViewControllerAnimated(true, completion: nil);
        } else if sender.tag == 501 { //确定抢单
            //调用抢单接口
        
        }
    }
    
    
    // MARK: - T06CellDelegate
    
    func selectItemChange(trade: TradeModel, isSelected: Bool) {
        
    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
    }
    
    func requestDataFailed(error: String) {
        
    }

}
