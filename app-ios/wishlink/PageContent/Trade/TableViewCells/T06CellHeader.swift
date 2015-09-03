//
//  TradeTableViewCellHeader.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T06CellHeader: UITableViewCell {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFlow: UIButton!
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imageRollView.initWithImages(["c1_0047","c1_0047","c1_0047","c1_0047"])
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
