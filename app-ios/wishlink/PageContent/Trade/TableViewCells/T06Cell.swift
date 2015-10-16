//
//  TradeTableViewCell.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06Cell: UITableViewCell {

    @IBOutlet weak var selectedButton: UIButton!
    
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    
    @IBOutlet weak var lbUserImage: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbTotalFree: UILabel!
    var trade:TradeModel!
    var item:ItemModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectedButtonAction(sender: UIButton) {
        
        sender.selected = !sender.selected
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //TODO:缺少用户信息绑定
    func loadData(trade:TradeModel! , item:ItemModel)
    {
        self.trade = trade;
        self.item = item;
        self.lbCount.text = item.price.format(".2") + " * " + String(trade.quantity)
        self.lbCountry.text = item.country;
        
        
        var totalPrice:Float = item.price
        if(item.numTrades != nil && item.numTrades>0)
        {
            totalPrice = item.price * Float(trade.quantity)
        }
        self.lbTotalFree.text = totalPrice.format(".2")

        
    }
    deinit
    {
        trade = nil;
        item = nil;
    }
    
}
