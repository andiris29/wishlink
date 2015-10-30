//
//  T13CellHeader.swift
//  wishlink
//
//  Created by Andy Chen on 10/31/15.
//  Copyright © 2015 edonesoft. All rights reserved.
//

import UIKit

class T13CellHeader: UITableViewCell {
    
    

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSpec: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var lbTotalNumbers: UILabel!
    @IBOutlet weak var iv_trade: UIImageView!
    
    @IBOutlet weak var lb_userName: UILabel!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lb_trde_country: UILabel!
    @IBOutlet weak var lb_trade_totalFree: UILabel!
    var item:ItemModel!
    var trade:TradeModel!
    
    @IBOutlet weak var iv: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadData(_item:ItemModel,_trade:TradeModel!)
    {
        self.item = _item;
        self.trade = _trade;
        self.lbName.text = self.item.name
        self.lbSpec.text = self.item.spec
        self.lbCountry.text = self.item.country
        self.lbPrice.text = self.item.price.format(".0");
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
                    UIHEPLER.buildImageViewWithRadius(self.iv_trade, borderColor: UIHEPLER.mainColor, borderWidth: 1);
                    
                }
                self.lbTitle.text = self.item.price.format(".0") + " * " + String(self.trade.quantity)
                var totalFree = self.item.price * Float(self.trade.quantity)
                self.lb_trade_totalFree.text = totalFree.format(".0");
//                self.lb_trde_country.text = self.trade.
                
            }
        }

    }
    
    deinit
    {
        self.item = nil;
    }
    
}
