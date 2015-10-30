//
//  T06ItemVC.swift
//  wishlink
//
//  Created by whj on 15/10/28.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06ItemVC: RootVC, WebRequestDelegate {

    @IBOutlet weak var tradeNameLabel   : UILabel!
    @IBOutlet weak var tradeTimeLabel   : UILabel!
    @IBOutlet weak var goodNameLabel    : UILabel!
    @IBOutlet weak var goodFormatLabel  : UILabel!
    @IBOutlet weak var goodAddressLabel : UILabel!
    @IBOutlet weak var goodPriceLabel   : UILabel!
    @IBOutlet weak var goodNumberLabel  : UILabel!
    @IBOutlet weak var goodAllTradeLabel: UILabel!
    @IBOutlet weak var goodTotalLabel   : UILabel!
    
    @IBOutlet weak var lbRemark: UILabel!
    var nextVC:UIViewController!
    
    @IBOutlet weak var img_tips: UIImageView!
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    
    var item: ItemModel!
    var trade: TradeModel!
    //跟单列表
    var followArr:[TradeModel]! = []
    //选中的抢单列表
    var selectArr:[TradeModel]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if(self.nextVC != nil)
        {
            self.nextVC = nil
        }
        self.navigationController?.navigationBarHidden = true;
    }
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true;
    }

    func initData() {
        
        self.httpObj.mydelegate = self
        
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        
        self.httpObj.httpGetApi("tradeFeeding/byItem?_id="+self.item._id, parameters: nil, tag: 60)
     

        //绑定数据
        self.goodPriceLabel.text = "出价：\(self.item.price)";
     

        self.goodNameLabel.text = "品名：\(self.item.name)";
        self.goodFormatLabel.text = "规格：\(self.item.name)";
        self.goodAddressLabel.text = "购买地：\(self.item.country)";
        self.goodAllTradeLabel.text = "\(self.item.numTrades)";
        if(self.item.notes != nil && self.item.notes.trim().length>0)
        {
            self.img_tips.hidden = false;
            self.lbRemark.text = self.item.notes;
        }
        else
        {
            self.img_tips.hidden = true;
            self.lbRemark.text = ""
        }
  
        if (self.item.images == nil) {return}
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            var images: [UIImage] = [UIImage]()
            for imageUrl in self.item.images {
                let url: NSURL = NSURL(string: imageUrl)!
                let image: UIImage = UIImage(data: NSData(contentsOfURL: url)!)!
                images.append(image)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.initImageRollView(images)
            })
        })

    
//        self.titleLabel.text  = item.brand
//        self.productNameLabel.text  = "品名：" + item.name
//        self.productPriceLabel.text  = "\(item.price)"
//        var totalPrice:Float = item.price
//        if(item.numTrades != nil && item.numTrades>0)
//        {
//            totalPrice = item.price * Float(item.numTrades)
//        }
//        self.productTotalLabel.text = totalPrice.format(".2")
//        self.productNumberLabel.text  = "\(item.numTrades)件"
//        self.productFormatLabel.text  = item.spec
//        self.productMessageLabel.text  = item.notes
//        if(self.productMessageLabel.text?.trim().length>0)
//        {
//            self.iv_notes.hidden = false;
//        }
//        else
//        {
//            self.iv_notes.hidden = true;
//            
//        }
//        
//        self.lbTotalCount.text = "\(item.numTrades)件"
//        if (item.images == nil) {return}
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            
//            var images: [UIImage] = [UIImage]()
//            for imageUrl in item.images {
//                let url: NSURL = NSURL(string: imageUrl)!
//                let image: UIImage = UIImage(data: NSData(contentsOfURL: url)!)!
//                images.append(image)
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                self.initImageRollView(images)
//            })
//        })

        

    }

    
    func initImageRollView(images:[UIImage]) {
        
        imageRollView.initWithImages(images)
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
    }
    
    // MARK: - Action
    
    @IBAction func backButtonAction(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    @IBAction func tradeButtonAction(sender: UIButton) {
        
        if sender.tag == 60 { //确认跟单
            
            if(UserModel.shared.isLogin)
            {
                SVProgressHUD.showWithStatusWithBlack("请稍后...")
                let para  = ["itemRef":item._id,
                    "quantity":"1"];
                self.httpObj.httpPostApi("trade/create", parameters: para, tag: 62);
            }
            else
            {
                UIHEPLER.showLoginPage(self);
            }
            
        } else if sender.tag == 61 { //继续抢单
            
            
            var vc:T13AssignToMeVC!  = T13AssignToMeVC(nibName: "T13AssignToMeVC", bundle: NSBundle.mainBundle());
            
            vc.item = self.item;
            self.nextVC = vc;
            self.navigationController?.pushViewController(self.nextVC, animated: true);
            vc = nil;
        }
    }
    
    @IBAction func hotButtonAction(sender: UIButton) {
        
        if sender.tag == 62 { //hot
            
        } else if sender.tag == 63 { //share
            
        }
    }
    
    
    // MARK: - T06CellDelegate
    
    func selectItemChange(trade: TradeModel, isSelected: Bool) {
        
    }
    
    func bindData()
    {
        if(self.followArr != nil && followArr.count>0)
        {
            self.goodNumberLabel.text = "数量：\(self.trade.quantity)";
            let totalFree = Float(self.trade.quantity) * self.item.price
            self.goodTotalLabel.text = "合计：\(totalFree)";
            
        }
        
    }

    // MARK: - WebRequestDelegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        
        SVProgressHUD.dismiss();
        
        
        if(tag == 60)//加载跟单列表
        {
//            var _tradeDic:NSDictionary! = response as? NSDictionary
//            var _trade:TradeModel!
//            var _prepayid:String!;
//            if(_tradeDic != nil && _tradeDic.objectForKey("trade") != nil)
//            {
//                var tradeDic:NSDictionary! = _tradeDic.objectForKey("trade") as! NSDictionary
//                _trade = TradeModel(dict: tradeDic)
//                
//            }

            
            let tradesObj:NSArray! = (response as? NSDictionary)?.objectForKey("trades") as? NSArray
            print(tradesObj);
            if(tradesObj != nil && tradesObj!.count>0)
            {
                if(followArr != nil && followArr.count>0)
                {
                    self.followArr.removeAll();
                    self.followArr = [];
                }
                for  itemObj in tradesObj!
                {
                    let tradeItem = TradeModel(dict: itemObj as! NSDictionary);
                    if(tradeItem.item != nil && tradeItem.item._id == self.item._id)
                    {
                        self.trade = tradeItem
                    }

                    self.followArr.append(tradeItem);
                }
                if(self.trade != nil)
                {
                    self.bindData();
                }
            }
            
        } else if(tag == 61) {
            
            
            if( UIHEPLER.GetAppDelegate().window!.rootViewController as? UITabBarController != nil) {
                let tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
                let vc: U02UserVC! = tababarController.childViewControllers[3] as? U02UserVC
                if(vc != nil)
                {
                    vc.orderBtnAction(vc.orderBtn);
                }
                
                tababarController.selectedIndex = 3;
            }
            
            
        } else if(tag == 62) {//跟单成功转向支付页面
            
            let dic = response as! NSDictionary;
            let tradeDic = dic.objectForKey("trade") as!  NSDictionary;
            let tradeItem = TradeModel(dict: tradeDic);
            self.nextVC = nil;
          
            var vc:T05PayVC!  = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            
            vc.item = self.item;
            vc.trade = tradeItem;
            vc.isNewOrder = false;
            self.nextVC = vc;
            self.navigationController?.pushViewController(self.nextVC, animated: true);
            vc = nil;
            
        }

        
    }
    
    func requestDataFailed(error: String) {
        
    }
}
