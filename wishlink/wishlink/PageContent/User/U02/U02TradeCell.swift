//
//  U02TradeCell.swift
//  wishlink
//
//  Created by Yue Huang on 8/18/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U02TradeCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.redColor().CGColor
    }

}
