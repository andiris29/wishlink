//
//  T09CellTextLeft.swift
//  wishlink
//
//  Created by whj on 15/8/26.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T09CellTextLeft: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var contextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.contextLabel.layer.masksToBounds = true
        self.contextLabel.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
