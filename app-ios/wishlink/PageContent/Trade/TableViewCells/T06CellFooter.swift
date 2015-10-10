//
//  TradeTableViewCellFooter.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

protocol T06CellFooterDelegate: NSObjectProtocol {

  func grabOrderButtonAction(sender: UIButton)
}

class T06CellFooter: UITableViewCell {

    @IBOutlet weak var btnGrabOrder: UIButton!
    
    var delegate: T06CellFooterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func grabOrderButtonAction(sender: UIButton) {
        delegate!.grabOrderButtonAction(sender)
    }
    
}
