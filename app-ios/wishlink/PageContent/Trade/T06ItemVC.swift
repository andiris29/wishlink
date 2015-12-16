//
//  T06ItemVC.swift
//  wishlink
//
//  Created by whj on 15/10/28.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06ItemVC: RootVC, WebRequestDelegate {
    
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var goodNameLabel    : UILabel!
    @IBOutlet weak var goodFormatLabel  : UILabel!
    @IBOutlet weak var goodAddressLabel : UILabel!
    @IBOutlet weak var goodPriceLabel   : UILabel!
    @IBOutlet weak var goodNumberLabel  : UILabel!
    @IBOutlet weak var goodAllTradeLabel: UILabel!
    @IBOutlet weak var goodTotalLabel   : UILabel!
    @IBOutlet weak var iv_userImg: UIImageView!
    @IBOutlet weak var lb_CreateTime: UILabel!
    @IBOutlet weak var lb_CreaterName: UILabel!
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var lbRemark: UILabel!
    @IBOutlet weak var img_tips: UIImageView!
    @IBOutlet weak var imageRollView: CSImageRollView!
    @IBOutlet weak var view_btn: UIView!
    //var nextVC:UIViewController!
    
    var item: ItemModel!
    var trade: TradeModel!
    //跟单列表
    var followArr:[TradeModel]! = []
    //选中的抢单列表
    var selectArr:[TradeModel]! = []
    
    //MARK:Life Cycle
    deinit
    {
        NSLog("T06ItemVC deinit")
        
        self.httpObj.mydelegate = nil;
        self.item = nil;
        self.trade = nil;
        self.followArr = nil;
        self.selectArr = nil;
        self.imageRollView = nil;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.initData()
    }
    
    var isFav = false;
    func changeBtnFav(_isFav:Bool)
    {
        self.isFav = _isFav
        if(!isFav)
        {
            self.btnFav.setImage(UIImage(named: "T06heart0"), forState: UIControlState.Normal)
            self.btnFav.setImage(UIImage(named: "T06heart0"), forState: UIControlState.Highlighted)
        }
        else
        {
            self.btnFav.setImage(UIImage(named: "T06heart1"), forState: UIControlState.Normal)
            self.btnFav.setImage(UIImage(named: "T06heart1"), forState: UIControlState.Highlighted)
            
        }
        
    }
    
    func initData() {
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle( "商品详情");
        
        self.view_btn.hidden = true;
        self.httpObj.mydelegate = self
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        self.sv.hidden = true;
        self.httpObj.httpGetApi("tradeFeeding/byItem?_id="+self.item._id, parameters: nil, tag: 60)
        self.goodPriceLabel.text = "出价：RMB \(self.item.price.format("0.2"))"
        //绑定数据
        if(self.item.unit != nil && self.item.unit.trim().length>0)
        {
            self.goodPriceLabel.text! += "/\(self.item.unit)";
        }
        
        UIHEPLER.buildImageViewWithRadius(self.iv_userImg, borderColor: UIColor.whiteColor(), borderWidth: 1);
        self.changeBtnFav(self.item.isFavorite);
        self.goodNameLabel.text = "品名：\(self.item.brand) \(self.item.name) "
        self.goodFormatLabel.text = "规格：\(self.item.spec)";
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
    }
    
    
    func initImageRollView(images:[UIImage]) {
        
        imageRollView.initWithImages(images)
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
    }
    
    // MARK: - IBAction
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
                UIHEPLER.showLoginPage(self,isToHomePage: false);
            }
            
        } else if sender.tag == 61 { //抢单
            
            var vc:T13AssignToMeVC!  = T13AssignToMeVC(nibName: "T13AssignToMeVC", bundle: NSBundle.mainBundle());
            vc.item = self.item;
            vc.trade = self.trade;
            self.navigationController?.pushViewController(vc, animated: true);
            vc = nil;
        }
    }
    
    @IBAction func hotButtonAction(sender: UIButton) {
        
        if sender.tag == 62 { //fav
            
            if(UserModel.shared.isLogin)
            {
                
                var urlSub: String = "item/favorite"
                if (self.isFav) {
                    urlSub = "item/unfavorite"
                }
                let para = ["_id" : self.item._id]
                self.httpObj.httpPostApi(urlSub , parameters:para, tag: 63);
            }
            else
            {
                UIHEPLER.showLoginPage(self, isToHomePage: false);
            }
            
            
            
        } else if sender.tag == 63 { //share
            
            
            if(self.shareVC == nil)
            {
                shareVC = ShareVC.sharedInstance;
                shareVC.CreateView();
            }
            
            self.shareVC.shareAction = {[weak self](tag:Int)  in
                
                if(tag == 1)//新浪微博
                {
                    
                }
                else  if(tag == 2)//微信好友
                {
                    let logo = UIImage(named:"AppIcon");
                    let url  =  SERVER_BASE_URL + "/share/tid=" + self!.trade._id
                    WXApiResponseHandler.respLinkURL(url, title: "订单详情", description: "点击查看订单详情等信息", thumbImage: logo);
                }
                else  if(tag == 3)//朋友圈
                {
                    
                }
                
            }
            shareVC.show(true);
            
            
        }
    }
    var shareVC:ShareVC!
    
    // MARK: - T06CellDelegate
    func selectItemChange(trade: TradeModel, isSelected: Bool) {
        
    }
    
    func bindData()
    {
        if(self.followArr != nil && followArr.count>0)
        {
            self.goodNumberLabel.text = "数量：--";
            self.goodTotalLabel.text = "合计：--";
            if(self.trade != nil)
            {
                self.goodNumberLabel.text = "数量：\(self.trade.quantity)";
                let totalFree = Float(self.trade.quantity) * self.item.price
                self.goodTotalLabel.text = "合计：RMB \(totalFree.format(".2"))";
                
                self.lb_CreaterName.text = "";
                self.lb_CreateTime.text = "";
                self.iv_userImg.image = nil;
                if let strNickName = self.trade.owner?.objectForKey("nickname") as? String
                {
                    self.lb_CreaterName.text = strNickName;
                }
                if let strImgUrl = self.trade.owner?.objectForKey("portrait") as? String
                {
                    WebRequestHelper().renderImageView(self.iv_userImg, url: strImgUrl, defaultName: "");
                }
                if(self.trade.create != nil)
                {
                    self.lb_CreateTime.text = "发布：" + UIHEPLER.formartTime(self.trade.create);
                }
            }
        }
        
    }
    
    // MARK: - WebRequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        SVProgressHUD.dismiss();
        if(tag == 60)//加载跟单列表
        {
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
            }
            self.sv.hidden = false;
            self.bindData();
            self.view_btn.hidden = false;
            
        } else if(tag == 61) {//跟单
            
            UIHEPLER.gotoU02Page(true);
            
        } else if(tag == 62) {//跟单成功转向支付页面
            
            let dic = response as! NSDictionary;
            let tradeDic = dic.objectForKey("trade") as!  NSDictionary;
            let tradeItem = TradeModel(dict: tradeDic);
            
            var vc:T05PayVC!  = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            vc.item = self.item;
            vc.trade = tradeItem;
            vc.isNewOrder = false;
            self.navigationController?.pushViewController(vc, animated: true);
            vc = nil;
            
            
        } else if(tag == 63) {//收藏 or 取消收藏
            
            self.changeBtnFav(!self.isFav);
            if(self.isFav)
            {
                UIHEPLER.alertErrMsg("收藏成功");
            }
            else
            {
                
                UIHEPLER.alertErrMsg("取消收藏成功");
            }
        }
        
        
    }
    
    func requestDataFailed(error: String,tag:Int) {
        
        SVProgressHUD.showErrorWithStatusWithBlack(error);
    }
}
