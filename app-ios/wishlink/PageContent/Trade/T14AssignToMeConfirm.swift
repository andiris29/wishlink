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
        
        
        
        self.totalLabel.text = "订单总金额："
        if(self.followArr != nil && self.followArr.count>0)
        {
            var totalFree:Float = 0;
            for _trade in self.followArr
            {
                totalFree += (Float(_trade.quantity) * self.item.price)
            }
            
            self.totalLabel.text = "订单总金额：\(totalFree)";
        }

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

        cell.loadData(self.followArr[indexPath.row],item:self.item);
        cell.selectedButton.selected = true;
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
            if(UserModel.shared.isLogin)
            {
                if(self.selectArr.count>0)
                {
                    SVProgressHUD.showWithStatusWithBlack("请稍后...")
    
                    for tradeItem in self.selectArr
                    {
                        self.httpObj.httpPostApi("trade/assignToMe", parameters: ["_id":tradeItem._id], tag: 141)
                    }
                }
                else
                {
                    UIHEPLER.alertErrMsg("请先选择");
                }
              
            }
            else
            {
                UIHEPLER.showLoginPage(self,isToHomePage: false);
            }

        }
    }
    
    
    // MARK: - T06CellDelegate
    
    func selectItemChange(trade: TradeModel, isSelected: Bool) {
        
        if(isSelected)//insert
        {
            self.selectArr.append(trade);
        }
        else//remove
        {
            if(self.selectArr.count>0)
            {
                var index = 0;
                for tradeObj in self.selectArr
                {
                    if(tradeObj._id == trade._id)
                    {
                        break;
                    }
                    index+=1;
                }
                self.selectArr.removeAtIndex(index);
            }
            
        }

    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        SVProgressHUD.dismiss();
        if(tag == 141)
        {
            self.dismissViewControllerAnimated(true, completion: nil);
            UIHEPLER.gotoU02Page();
        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }

}
