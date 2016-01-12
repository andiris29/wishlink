//
//  T14AssignToMeConfirm.swift
//  wishlink
//
//  Created by whj on 15/10/29.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class T14AssignToMeConfirm: RootVC, UITableViewDataSource, UITableViewDelegate, WebRequestDelegate, T06CellDelegate {
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbSpec: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var iv_item: UIImageView!
    let cellIdentifier = "T06Cell"
    @IBOutlet weak var tradeTableView: UITableView!
    var selectItemRemove:((_trade: TradeModel)->Void)!;
    var reSelectEvent:(()->Void)!
    var item: ItemModel!
    //跟单列表
    var followArr:[TradeModel]! = []
    //选中的抢单列表
    var selectArr:[TradeModel]! = []
    
    //MARK:Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
    }
    deinit{
        
        NSLog("T14AssignToMeConfirm -->deinit")
        self.item = nil;
        self.tradeTableView = nil;
        self.dataArr = nil;
        self.followArr = nil;
        self.selectArr = nil;
        self.tradeTableView = nil;
    }
    
    func initData() {
        
        self.httpObj.mydelegate = self
        self.tradeTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)

        if(self.item != nil)
        {
            self.lbTitle.text = self.item.name;
            UIHEPLER.setLabelLineSpan( self.lbTitle, lineSpacing: 6);
            self.lbSpec.text = "规格：\(self.item.spec)";
            self.lbPrice.text = "出价：\(self.item.price.format(".2"))/\(self.item.unit)";
            self.lbCountry.text = "购买地：\(self.item.country)";
            if(self.item.images != nil && self.item.images.count>0)
            {
                self.iv_item.sd_setImageWithURL(NSURL(string: self.item.images[0]), placeholderImage:  UIHEPLER.noneImg)
            }
        }

        
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("确认订单")
        
        if(self.followArr != nil && self.followArr.count>0)
        {
            var totalFree:Float = 0;
            for _trade in self.followArr
            {
                totalFree += (Float(_trade.quantity) * self.item.price)
            }
            
        }
    }
    //MARK:UITableView Delegate
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
        let tdata = followArr[indexPath.row]
        cell.loadData(tdata,item:self.item);
     
        cell.iv_userImg.image = nil;
   
        if(tdata.owner != nil)
        {
            if  let imgUrl:String! = tdata.owner!.objectForKey("portrait") as? String
            {
                WebRequestHelper().renderImageView( cell.iv_userImg, url: imgUrl!, defaultName: "")
            }
            else
            {
                cell.iv_userImg.image = UIHEPLER.noneImg;
            }
        }
        cell.selectedButton.selected = true;
        cell.myDelegate = self;
        
        return cell
    }
    
    // MARK: - IBAction
    
//    @IBAction func closeButtonAction(sender: UIButton) {
//        self.dismissViewControllerAnimated(true, completion: nil);
//    }
    
    @IBAction func tradeButtonAction(sender: UIButton) {
        
        if sender.tag == 500 { //继续抢单
            if(self.reSelectEvent != nil)
            {
                self.reSelectEvent();
            }
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
            if(self.selectItemRemove != nil)
            {
                self.selectItemRemove(_trade: trade);
            }
            
            if(self.followArr.count>0)
            {
                var index = 0;
                for tradeObj in self.followArr
                {
                    if(tradeObj._id == trade._id)
                    {
                        break;
                    }
                    index+=1;
                }
                self.followArr.removeAtIndex(index);
            }
            self.tradeTableView.reloadData();
        }
    }
    
    // MARK: - web request Delegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        SVProgressHUD.dismiss();
        if(tag == 141)
        {
            self.dismissViewControllerAnimated(true, completion: nil);
            //跳转到卖家订单
            UIHEPLER.gotoU02Page(false);
        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }
    
}
