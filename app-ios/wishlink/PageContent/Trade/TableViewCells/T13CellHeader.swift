//
//  T13CellHeader.swift
//  wishlink
//
//  Created by Andy Chen on 10/31/15.
//  Copyright © 2015 edonesoft. All rights reserved.
//

import UIKit
@objc protocol T13CellHeaderDelegate
{
    //选中项发生更改的时候
    func t13CellHeaderSelectItemChange(trade:TradeModel,isSelected:Bool);
}

class T13CellHeader: UITableViewCell {
    
    
  

    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSpec: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbBranch: UILabel!
    
    @IBOutlet weak var lbTotalNumbers: UILabel!
    @IBOutlet weak var iv_trade: UIImageView!
    
    @IBOutlet weak var lb_userName: UILabel!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lb_trde_country: UILabel!
    @IBOutlet weak var lb_trade_totalFree: UILabel!
    var item:ItemModel!
    var trade:TradeModel!
    weak var myDelegate:T13CellHeaderDelegate!
    
    @IBOutlet weak var iv: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UIHEPLER.buildImageViewWithRadius(self.iv_trade, borderColor: UIHEPLER.mainColor, borderWidth: 1);
    }
    
    deinit
    {
        NSLog("T13CellHeader deinit");
        self.item = nil;
        self.trade = nil;
        self.myDelegate = nil;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnSelectAction(sender: UIButton) {
        
        
        sender.selected = !sender.selected
        
        if(self.myDelegate != nil)
        {
            self.myDelegate!.t13CellHeaderSelectItemChange(self.trade, isSelected: sender.selected);
        }

    }
    func loadData(_item:ItemModel,_trade:TradeModel!)
    {
        self.item = _item;
        self.trade = _trade;
        self.lbName.text = self.item.brand + " " + self.item.name
        self.lbSpec.text = self.item.spec
        self.lbBranch.text = "品牌：" + self.item.brand
        self.lbCountry.text = self.item.country
        self.lb_trde_country.text = self.item.country
        self.lbPrice.text = "RMB " + self.item.price.format(".2");
        if(self.item.unit != nil && self.item.unit.trim().length>0)
        {
             self.lbPrice.text! += "/\(self.item.unit)"
        }
        if(self.item.images != nil && self.item.images.count>0)
        {
            WebRequestHelper().renderImageView(self.iv, url: self.item.images[0], defaultName: "");
        }
        self.lbTotalNumbers.text =  String(self.item.numTrades)
        if(self.trade != nil)
        {
            if(self.trade.owner != nil && self.trade.owner!.count>0)
            {
                self.lb_userName.text = ""
                self.iv_trade.image = nil;
                let name:String! = self.trade.owner!.objectForKey("nickname") as? String
                let imgUrl:String! = self.trade.owner!.objectForKey("portrait") as? String
                if(name != nil)
                {
                    self.lb_userName.text = name;
                }
                
                if(imgUrl != nil && imgUrl.trim().length>1)
                {
                    WebRequestHelper().renderImageView(self.iv_trade, url: imgUrl, defaultName: "T03aaa")
                    
                }
                
            }
            
            //let count = trade.quantity > 0 ? trade.quantity : 1
           // self.lbTitle.text = (item.price.format(".2") + " * " + String(count))
            
            
            let strCount = trade.quantity > 0 ? String(trade.quantity) : "1"
            var unitStr = "件";
            if(self.item.unit != nil && self.item.unit.length>0)
            {
                unitStr += self.item.unit;
            }
            self.lbTitle.text = "RMB\(item.price.format(".2"))x\(strCount)\(unitStr)";
            
            
            
            let totalFree = self.item.price * Float(self.trade.quantity)
            self.lb_trade_totalFree.text = "RMB" + totalFree.format(".2")
         
            
        }

    }
    
 
    
}
