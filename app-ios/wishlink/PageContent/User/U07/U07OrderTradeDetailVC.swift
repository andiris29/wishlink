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
class U07OrderTradeDetailVC: RootVC, WebRequestDelegate,UIAlertViewDelegate {

    
    @IBOutlet weak var v_targetUser: UIView!
    @IBOutlet var optBtn3: UIButton!
    @IBOutlet var optBtn2: UIButton!
    @IBOutlet var optBtn1: UIButton!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var tradeIdLabel: UILabel!
    @IBOutlet weak var goodImageView: UIImageView!
    @IBOutlet weak var goodName: UILabel!
    @IBOutlet weak var goodFrom: UILabel!
    @IBOutlet weak var goodFormat: UILabel!
    @IBOutlet weak var goodPrice: UILabel!
    @IBOutlet weak var goodNumber: UILabel!
    @IBOutlet weak var goodTotal: UILabel!
    
//    @IBOutlet weak var linkTitle: UILabel!
    @IBOutlet weak var avterImageView: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var reveicerName: UILabel!
    @IBOutlet weak var reveicerPhone: UILabel!
    @IBOutlet weak var reveicerAddress: UILabel!
    
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var orderReveicedTime: UILabel!

    
    var role: U07Role!
    var trade: TradeModel!
//    var receiver: ReceiverModel!
    var assigneeModel: AssigneeModel!
    var orderStatusArr: [OrderStatusModel]! = []
    
    var orderStatusDic: [Int : String]!
    var orderSellerStatusDic: [Int : String]!
    
    deinit
    {
        NSLog("U07OrderTradeDetailVC --> deinit");
        self.orderStatusArr = nil;
        self.assigneeModel = nil;
//        self.receiver = nil;
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
        self.maskView.hidden = false;
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
        
        self.optBtn1.hidden = true;
        self.optBtn2.hidden = true;
        self.optBtn3.hidden = true;
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
        
        
        let _orderState = self.trade.status
        
        if(_orderState == 0 || _orderState == 1 || _orderState == 2 )
        {
            self.v_targetUser.hidden = true;
        }
        else
        {
            self.v_targetUser.hidden = false;
        }
        if self.role == .buyyer {
            self.avterImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: UserModel.shared.portrait)!)!)
            self.personName.text = "\(UserModel.shared.nickname)"
            self.orderTimeData()
            self.orderState.text = self.orderStatusDic[_orderState]
            self.linkButton.setImage(UIImage(named: "u02-contactsell"), forState: UIControlState.Normal)
            
            if(_orderState == 1 || _orderState == 2 || _orderState == 3 || _orderState == 12)
            {
                self.optBtn3.hidden = false;
                self.optBtn3.setTitle("撤单", forState: UIControlState.Normal);
                if(orderState == 3 )
                {
                    self.optBtn1.hidden = false;
                    self.optBtn1.setTitle("投诉", forState: UIControlState.Normal);
                }
            }
            else if(_orderState == 4)
            {
                self.optBtn1.hidden = false;
                self.optBtn2.hidden = false;
                self.optBtn3.hidden = false;
                self.optBtn1.setTitle("投诉", forState: UIControlState.Normal);
                self.optBtn2.setTitle("查看物流", forState: UIControlState.Normal);
                self.optBtn3.setTitle("确认收货", forState: UIControlState.Normal);
            }
            if(_orderState == 7)
            {
                self.optBtn1.hidden = false;
                self.optBtn1.setTitle("投诉", forState: UIControlState.Normal);
            }
            else if(_orderState == 10 || _orderState == 11)
            {
                self.optBtn3.hidden = false;
                self.optBtn3.setTitle("查看投诉", forState: UIControlState.Normal);
            }
        } else {
            
            
            if(self.assigneeModel != nil)
            {
                self.avterImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.assigneeModel.portrait)!)!)
                self.personName.text = "\(self.assigneeModel.nickname)"
                self.orderTimeData()
                self.orderState.text = self.orderSellerStatusDic[_orderState]
                self.linkButton.setImage(UIImage(named: "u02-contactbuy"), forState: UIControlState.Normal)
            }
            
            if(_orderState == 3 || _orderState == 7)
            {
                self.optBtn1.hidden = false;
                self.optBtn3.hidden = false;
                self.optBtn1.setTitle("投诉", forState: UIControlState.Normal);
                self.optBtn3.setTitle("取消抢单", forState: UIControlState.Normal);
                if(_orderState == 3)
                {
                    self.optBtn2.hidden = false;
                    self.optBtn2.setTitle("发货", forState: UIControlState.Normal);
                }
            }
            else if(_orderState == 4)
            {
                self.optBtn1.hidden = false;
                self.optBtn3.hidden = false;
                self.optBtn1.setTitle("投诉", forState: UIControlState.Normal);
                self.optBtn3.setTitle("编辑发货信息", forState: UIControlState.Normal);
            }
            else if(_orderState == 10 || _orderState == 11)
            {
                self.optBtn3.hidden = false;
                self.optBtn3.setTitle("查看投诉", forState: UIControlState.Normal);
            }
        }
        if(self.trade.receiver != nil)
        {
     
            self.reveicerName.text = "收货人：\(self.trade.receiver.name)"
            self.reveicerPhone.text = "\(self.trade.receiver.phone)"
            self.reveicerAddress.text = "收货地址：\(self.trade.receiver.province + self.trade.receiver.address)"
        }
        if( self.orderStatusArr != nil &&  self.orderStatusArr.count>0)
        {
            var createLogs =  self.orderStatusArr.filter{itemObj -> Bool in
            return itemObj.status == 3;
            }
            if(createLogs.count > 0)
            {
                
                self.orderReveicedTime.text = "接单时间：\(UIHEPLER.formartTime(createLogs.last!.create))"
            }
        }

      
    
        
//        self.revokeButton.setTitle("我要撤单", forState: UIControlState.Normal)
    }
    
    // MARK: - IBAction
    //投诉
    @IBAction func optBtn1Action(sender: UIButton) {
        
        let vc = T08ComplaintVC(nibName: "T08ComplaintVC", bundle: NSBundle.mainBundle())
        vc.tradeid = self.trade._id;
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func optBtn2Action() {
        
        
        if self.role == .buyyer {
            if self.trade.status == 4 {//查看物流
                
                let alertView:UIAlertView = UIAlertView();
                alertView.message = "物流公司:韵达快递 \r\n 物流单号:FSDFSDFSDFSDFSDF";
                alertView.addButtonWithTitle("取消");
                alertView.addButtonWithTitle("确认");
//                alertView.delegate = self;
                alertView.show()
            }
        }
        else
        {
            if self.trade.status == 3//发货
            {
                let vc = T07DeliverEditVC(nibName: "T07DeliverEditVC", bundle: NSBundle.mainBundle())
                vc.hidesBottomBarWhenPushed = true
                vc.trade = self.trade;
                self.presentViewController(vc, animated: true, completion: nil);
                return;
                
            }
        }
        

    }
    @IBAction func optBtn3Action(sender: UIButton) {
    
        var url: String = ""
        var tag: Int = 700
        if self.role == .buyyer {
            if self.trade.status == 1 ||  self.trade .status == 2 ||  self.trade .status == 3 {//撤单
                url = "trade/cancel"
                tag = 701
            } else if self.trade.status == 4 {
                url = "trade/receipt"//确认收货
                tag = 702
            } else if self.trade.status == 10 ||  self.trade .status == 11 {//查看投诉
                
                var vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle())
                vc.hidesBottomBarWhenPushed = true;
                vc.trade = self.trade;
                self.navigationController!.pushViewController(vc, animated: true)
                return;
            }
        } else {
            if self.trade.status == 3 ||  self.trade.status == 7 {//取消抢单
                url = "trade/unassign"
                tag = 705
            } else if self.trade.status == 4 {//编辑发货信息
                
                let vc = T07DeliverEditVC(nibName: "T07DeliverEditVC", bundle: NSBundle.mainBundle())
                vc.hidesBottomBarWhenPushed = true
                vc.trade = self.trade;
                self.presentViewController(vc, animated: true, completion: nil);
                return;
                
            }  else if self.trade.status == 10 ||  self.trade .status == 11 {//查看投诉
                
                var vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle())
                vc.hidesBottomBarWhenPushed = true;
                vc.trade = self.trade;
                self.navigationController!.pushViewController(vc, animated: true)
                return;
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
    @IBAction func linkPersonButtonAction(sender: UIButton) {
        
        let vc = T10MessagingVC(nibName: "T10MessagingVC", bundle: NSBundle.mainBundle())
        vc.trade = self.trade;
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
     
        if (tag == 700) {
            let tradeData = (response as! NSDictionary).objectForKey("trade")
            if tradeData != nil {
                self.trade = TradeModel(dict: tradeData as! NSDictionary)
                
                let assigneeRef = (tradeData as! NSDictionary).objectForKey("assigneeRef")
                if let assignDIc  = assigneeRef as? NSDictionary
                {
                    self.assigneeModel = AssigneeModel(dic: assignDIc)
                }
                let statusLogs = (tradeData as! NSDictionary).objectForKey("statusLogs")
                
                if let logArr = statusLogs as? NSArray
                {
                    if(orderStatusArr != nil && orderStatusArr.count>0)
                    {
                        self.orderStatusArr.removeAll();
                        self.orderStatusArr = [];
                    }

                    for statusLog in logArr {
                        
                        self.orderStatusArr.append(OrderStatusModel(dic: statusLog as! NSDictionary))
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
                    
                    if(orderStatusArr != nil && orderStatusArr.count>0)
                    {
                        self.orderStatusArr.removeAll();
                        self.orderStatusArr = [];
                    }
                    
                    for statusLog in statusLogs as! NSArray {
                        self.orderStatusArr.append(OrderStatusModel(dic: statusLog as! NSDictionary))
                    }
                }

            }
            self.initViewData()
        } else {
        
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.maskView.hidden = true;
        SVProgressHUD.dismiss();
    }
    
    func requestDataFailed(error: String,tag:Int) {
    
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }

    // MARK: -  Unit
    
    func changeOrderStatus(status: Int) {
    
    }
    
    func orderTimeData() {
        
        if(UserModel.shared.receiversArray != nil && UserModel.shared.receiversArray.count>0) {
            let result = UserModel.shared.receiversArray.filter{itemObj -> Bool in
                return (itemObj as ReceiverModel).isDefault == true;
            }
            if(result.count>0) {
                self.orderTime.text = result[0].province;
            } else {
                self.orderTime.text = UserModel.shared.receiversArray[0].province;
            }
        } else {
            self.orderTime.text = "--"
        }
    }
}
