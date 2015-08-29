//
//  T03Cell.swift
//  wishlink
//
//  Created by Andy Chen on 8/22/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class T03Cell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var iv_mid: UIImageView!
    @IBOutlet weak var constratins_Right: NSLayoutConstraint!
    @IBOutlet weak var consraion_Left: NSLayoutConstraint!
    var isShowBottonLine = false;
    @IBOutlet weak var marginSpan: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var width = self.iv_mid.frame.width;
       var result = (ScreenWidth - 5*width) / 6
        constratins_Right.constant = result;
        consraion_Left.constant = result;
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func  drawRect(rect: CGRect) {
        var context:CGContextRef = UIGraphicsGetCurrentContext();
        
        if(isShowBottonLine)
        {
//            //下分割线
//            CGContextSetStrokeColorWithColor(context, UIHelper.layBordeColor);
//            CGContextStrokeRect(context, CGRectMake(bottonLine_OffSet_X, rect.size.height, rect.size.width - 2*bottonLine_OffSet_X, 1));
        }
    }
    
}
