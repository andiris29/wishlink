//
//  DefaultCell.swift
//  wishlink
//
//  Created by Andy Chen on 9/1/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit


class DefaultCell: UITableViewCell {
    
    var isShowBottonLine:Bool = true;
    //居左的像素
    var bottonLine_OffSet_X:CGFloat = 0.0;
    override func awakeFromNib() {
        super.awakeFromNib()
//        // Initialization code
//        //        self.textLabel?.font = UIHelper.mainFont;
////        self.textLabel?.font = UIHelper.mainFont14;
//        self.textLabel?.textColor  = UIColor.darkGrayColor();
//        
////        self.detailTextLabel?.font = UIHelper.mainFont14;
//        self.detailTextLabel?.textColor  = UIColor.darkGrayColor();
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func  drawRect(rect: CGRect) {
        var context:CGContextRef = UIGraphicsGetCurrentContext();
        
//        if(isShowBottonLine)
//        {
//            //下分割线
//            CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor());
//            CGContextStrokeRect(context, CGRectMake(bottonLine_OffSet_X, rect.size.height, rect.size.width - 2*bottonLine_OffSet_X, 1));
//        }
    }
    
}

