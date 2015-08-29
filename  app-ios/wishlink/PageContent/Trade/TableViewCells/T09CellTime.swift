//
//  T09CellTime.swift
//  wishlink
//
//  Created by whj on 15/8/26.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T09CellTime: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.timeLabel.layer.masksToBounds = true
        self.timeLabel.layer.cornerRadius = 3
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
