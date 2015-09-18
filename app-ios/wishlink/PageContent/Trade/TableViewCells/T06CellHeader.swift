//
//  TradeTableViewCellHeader.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

@objc protocol T06CellHeaderDelegate: NSObjectProtocol {

    optional func dorpListButtonAction(sender: UIButton)
}

class T06CellHeader: UITableViewCell {

    @IBOutlet weak var btnDorp: UIButton!
    @IBOutlet weak var btnFlow: UIButton!
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    var delegate: T06CellHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imageRollView.initWithImages(["c1_0047","c1_0047","c1_0047","c1_0047"])
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
    }
    
    //MARK: - Action
    
    @IBAction func dorpListButtonAction(sender: UIButton) {
        
        delegate?.dorpListButtonAction!(sender)
        
//        var buttonRect: CGRect! = sender.convertRect(sender.frame, toView: KeyWindow)
//        println("====\(buttonRect)")
//        var titles: NSArray = ["选择同城0","选择同城1","选择同城2"]
//        var dorpListView: CSDorpListView = CSDorpListView(frame: buttonRect, titles: titles)
//        dorpListView.showInWindow(dorpListView)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
