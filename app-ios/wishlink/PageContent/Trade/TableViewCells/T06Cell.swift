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
    func loaddata(trade:TradeModel)
    {
        self.lbCount.text = String(trade.quantity)
    }
    
}
