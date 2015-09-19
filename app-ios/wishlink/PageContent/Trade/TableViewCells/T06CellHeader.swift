//
//  TradeTableViewCellHeader.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

protocol T06CellHeaderDelegate: NSObjectProtocol {

    func dorpListButtonAction(sender: UIButton)
}

class T06CellHeader: UITableViewCell, CSDorpListViewDelegate {

    @IBOutlet weak var btnDorp: UIButton!
    @IBOutlet weak var btnFlow: UIButton!
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    var dorpListView: CSDorpListView!
    
    var delegate: T06CellHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imageRollView.initWithImages(["c1_0047","c1_0047","c1_0047","c1_0047"])
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
        
        var titles: NSArray = ["选择同城0","选择同城1","选择同城2"]
        dorpListView = CSDorpListView.sharedInstance
        dorpListView.bindWithList(titles, delegate: self)
    }
    
    //MARK: - Action
    
    @IBAction func dorpListButtonAction(sender: UIButton) {
        
//        delegate?.dorpListButtonAction(sender)
    
        dorpListView.show(sender)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - CSDorpListViewDelegate
    
    func dorpListButtonItemAction(sender: UIButton!) {
        
        btnDorp.setTitle(sender.titleLabel?.text, forState: UIControlState.Normal)
    }
}
