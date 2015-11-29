//
//  U07OrderTradeDetailVC.swift
//  wishlink
//
//  Created by whj on 15/10/27.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

enum U07Role{
    case buyyer, seller
}
class U07OrderTradeDetailVC: RootVC, WebRequestDelegate {

    @IBOutlet weak var tradeIdLabel: UILabel!
    @IBOutlet weak var goodImageView: UIImageView!
    @IBOutlet weak var goodName: UILabel!
    @IBOutlet weak var goodFrom: UILabel!
    @IBOutlet weak var goodFormat: UILabel!
    @IBOutlet weak var goodPrice: UILabel!
    @IBOutlet weak var goodNumber: UILabel!
    @IBOutlet weak var goodTotal: UILabel!
    
    @IBOutlet weak var linkTitle: UILabel!
    @IBOutlet weak var avterImageView: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var reveicerName: UILabel!
    @IBOutlet weak var reveicerPhone: UILabel!
    @IBOutlet weak var reveicerAddress: UILabel!
    
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var orderReveicedTime: UILabel!
    @IBOutlet weak var revokeButton: UIButton!
    
    var role: U07Role!
    var trade: TradeModel!
    var receiver: ReceiverModel!
    var assigneeModel: AssigneeModel!
    var orderStatus: [OrderStatusModel]! = []
    
    var orderStatusDic: [Int : String]! = [:]
    var orderSellerStatusDic: [Int : String]! = [:]
    
    deinit
    {
        NSLog("U07OrderTradeDetailVC --> deinit");
        self.orderStatus = nil;
        self.assigneeModel = nil;
        self.receiver = nil;
        self.trade = nil;
        self.role = nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData()
        self.setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.hidden = false
    }
    
    func setupData() {
    
        // buy
        self.orderStatusDic = [0 : "N/A", 1 : "未接单", 2 : "未接单", 3 : "已被接单", 4 : "已发货", 5 : "已完成", 6 : "已完成", 7 : "请求撤单中", 8 : "已撤单", 9 : "已撤单", 10 : "投诉处理中", 11 : "已完成", 12 : "未接单", 13 : "TBD", 14 : "TBD"]
        // seller
        self.orderSellerStatusDic = [0 : "N/A", 1 : "N/A", 2 : "N/A", 3 : "已抢单", 4 : "已发货", 5 : "已完成", 6 : "已完成", 7 : "买家要求撤单", 8 : "N/A", 9 : "N/A", 10 : "投诉处理中", 11 : "已完成", 12 : "N/A", 13 : "TBD", 14 : "TBD"]
        
        self.httpObj.mydelegate = self
        self.httpObj.httpGetApi("trade/query", parameters: ["_id" : self.trade._id], tag: 700)
         SVProgressHUD.showWithStatusWithBlack("请稍等...")
        
        self.loadComNavTitle("订单详情")
        self.loadComNaviLeftBtn()
    }
    
    func setupView() {
    
        self.avterImageView.layer.masksToBounds = true
        self.avterImageView.layer.cornerRadius = self.avterImageView.frame.size.height / 2
    }
    
    func initViewData() {
        
        let item = self.trade.item
        
        if(item != nil  && item._id != "")
        {
            if (item.images != nil && item.images.count > 0) {
                self.goodImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.trade.item.images[0])!)!)
            }
            self.tradeIdLabel.text = "订单号：\(item._id)"
            self.goodName.text = "品名：\(item.brand) \(item.name)"
            self.goodFrom.text = "购买地：\(item.country)"
            self.goodFormat.text = "规格：\(item.spec)"
            if(item.price != nil)
            {
                self.goodPrice.text = "价格：RMB\(item.price.format(".2"))/件"
            }
            self.goodNumber.text = "数量：\(trade.quantity)"
            
            if(item != nil && item.price != nil)
            {
                self.goodTotal.text = "合计：RMB\((item.price * Float(trade.quantity)).format(".2"))"
            }
        }
        
        let orderState = self.trade.status
        if self.role == .buyyer {
            self.avterImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: UserModel.shared.portrait)!)!)
            self.personName.text = "\(UserModel.shared.nickname)"
            self.orderTime.text = "接单：" + UIHEPLER.formartTime(UserModel.shared.create)
            self.linkTitle.text = "卖家信息"
            self.orderState.text = self.orderStatusDic[orderState]
            self.linkButton.setImage(UIImage(named: "u02-contactsell"), forState: UIControlState.Normal)
            
            
            self.revokeButton.hidden = true;
            if(orderState == 1 || orderState == 2 || orderState == 3 || orderState == 12)
            {
                self.revokeButton.hidden = false;
                self.revokeButton.setTitle("我要撤单", forState: UIControlState.Normal);
                if(orderState == 3 )
                {
                    self.loadSpecNaviRightTextBtn("投诉", _selecotr: "navigationRightButtonAction:")
                }
            }
            else if(orderState == 4)
            {
                self.loadSpecNaviRightTextBtn("投诉", _selecotr: "navigationRightButtonAction:")
                self.revokeButton.hidden = false;
                self.revokeButton.setTitle("确认收货", forState: UIControlState.Normal);
                
                
                self.loadSpecNaviRightTextBtn("投诉", _selecotr: "navigationRightButtonAction:")
            }
            if(orderState == 7)
            {
                self.loadSpecNaviRightTextBtn("投诉", _selecotr: "navigationRightButtonAction:")
            }
            else if(orderState == 10 || orderState == 11)
            {
                self.revokeButton.hidden = false;
                self.revokeButton.setTitle("查看投诉", forState: UIControlState.Normal);
            }
            else
            {
                self.revokeButton.hidden = true;
            }
        } else {
            if(self.assigneeModel != nil)
            {
                self.avterImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.assigneeModel.portrait)!)!)
                self.personName.text = "\(self.assigneeModel.nickname)"
                self.orderTime.text = "接单：" + UIHEPLER.formartTime(self.assigneeModel.create)
                self.linkTitle.text = "买家信息"
                self.orderState.text = self.orderSellerStatusDic[orderState]
                self.linkButton.setImage(UIImage(named: "u02-contactbuy"), forState: UIControlState.Normal)
            }
            
            if(orderState != 3 || orderState != 7)
            {
                
                self.revokeButton.hidden = false;
                self.revokeButton.setTitle("取消抢单", forState: UIControlState.Normal);
            }
            else if(orderState != 4)
            {
                
                self.revokeButton.hidden = false;
                self.revokeButton.setTitle("确认收货", forState: UIControlState.Normal);
            }
            else
            {
                self.revokeButton.hidden = true;
            }

            
        }
        
        if self.receiver != nil {
            self.reveicerName.text = "收货人：\(self.receiver.name)"
            self.reveicerPhone.text = "\(self.receiver.phone)"
            self.reveicerAddress.text = "收货地址：\(self.receiver.province + self.receiver.address)"
        }
        
        if( self.orderStatus != nil &&  self.orderStatus.count>0)
        {
            var createLogs =  self.orderStatus.filter{itemObj -> Bool in
            return itemObj.status == 3;
            }
            if(createLogs.count > 0)
            {
                
                self.orderReveicedTime.text = "接单时间：\(UIHEPLER.formartTime(createLogs.last!.create))"
            }
        }

      
    
        
//        self.revokeButton.setTitle("我要撤单", forState: UIControlState.Normal)
    }
    
    // MARK: - Action
    
    func navigationRightButtonAction(sender: UIButton) {
    
        let vc = T08ComplaintVC(nibName: "T08ComplaintVC", bundle: NSBundle.mainBundle())
        vc.tradeid = self.trade._id;
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func linkPersonButtonAction(sender: UIButton) {
        
        let vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle())
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func revokeButtonAction(sender: UIButton) {
    
        var url: String = ""
        var tag: Int = 700
        if self.role == .buyyer {
            if self.trade .status == 1 ||  self.trade .status == 2 ||  self.trade .status == 3 {
                
                url = "trade/cancel"
                tag = 701
            } else if self.trade.statusOrder == .b0 {
                
                url = "trade/receipt"
                tag = 702
            } else if self.trade.statusOrder == .c0 {
                
            } else if self.trade.statusOrder == .d0 {
            }
        } else {
            if self.trade.status == 3 {
                
                url = "trade/unassign"
                tag = 705
            } else if self.trade.statusOrder == .b0 {
            } else if self.trade.statusOrder == .c0 {
            } else if self.trade.statusOrder == .d0 {
            }
        }
        if(url != "")
        {
            self.httpObj.httpPostApi(url, parameters: ["_id" : self.trade._id], tag: tag)
            SVProgressHUD.showWithStatusWithBlack("请稍等...")
        }
        else
        {
            UIHEPLER.alertErrMsg("无效的操作")
        }
        
    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if (tag == 700) {
            let tradeData = (response as! NSDictionary).objectForKey("trade")
            if tradeData != nil {
                self.trade = TradeModel(dict: tradeData as! NSDictionary)
                
                let assigneeRef = (tradeData as! NSDictionary).objectForKey("assigneeRef")
                if assigneeRef != nil {
                    self.assigneeModel = AssigneeModel(dic: assigneeRef as! NSDictionary)
                }
                
                let statusLogs = (tradeData as! NSDictionary).objectForKey("statusLogs")
                if statusLogs != nil {
                    
                    if(orderStatus != nil && orderStatus.count>0)
                    {
                        self.orderStatus.removeAll();
                        self.orderStatus = [];
                    }

                    for statusLog in statusLogs as! NSArray {
                        self.orderStatus.append(OrderStatusModel(dic: statusLog as! NSDictionary))
                    }
                }
            }
            self.initViewData()
        }
        else  if (tag == 701 || tag == 705 ) {//撤单 or 取消抢单操作
            let tradeData = (response as! NSDictionary).objectForKey("trade")
            if tradeData != nil {
                self.trade = TradeModel(dict: tradeData as! NSDictionary)
                
                let assigneeRef = (tradeData as! NSDictionary).objectForKey("assigneeRef")
                if assigneeRef != nil &&  assigneeRef?.description != "<null>" {
              
                   // var assiggnessRefStr = assigneeRef as! String;
                    
                   // self.assigneeModel = AssigneeModel(dic: assigneeRef as! NSDictionary)
                }
                
                let statusLogs = (tradeData as! NSDictionary).objectForKey("statusLogs")
                if statusLogs != nil {
                    
                    if(orderStatus != nil && orderStatus.count>0)
                    {
                        self.orderStatus.removeAll();
                        self.orderStatus = [];
                    }
                    
                    for statusLog in statusLogs as! NSArray {
                        self.orderStatus.append(OrderStatusModel(dic: statusLog as! NSDictionary))
                    }
                }

            }
            self.initViewData()
        } else {
        
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        SVProgressHUD.dismiss();
    }
    
    func requestDataFailed(error: String,tag:Int) {
     
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }

    // MARK: -  Unit
    
    func changeOrderStatus(status: Int) {
    
    }
}
