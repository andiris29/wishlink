//
//  U02LogisticsTipView.swift
//  wishlink
//
//  Created by Yue Huang on 8/22/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit


let labelTextFontSize: CGFloat = 14

class U02LogisticsTipView: UIView {

    let tipViewWidth: CGFloat = 250
    let tipViewHeight: CGFloat = 150
    let labelHeight: CGFloat = 21
    
    var name: String!
    var orderNumber: String!
    lazy var nameLabel: UILabel = {
        var label = UILabel(frame: CGRectZero)
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(labelTextFontSize)
        return label
    }()
    lazy var orderNumberLabel: UILabel = {
        var label = UILabel(frame: CGRectZero)
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(labelTextFontSize)
        return label
        }()
    
    
    init(name: String, orderNumber: String) {
        self.name = name
        self.orderNumber = orderNumber
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        self.prepareUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(self)
    }
    
    func confirmBtnAction(sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    func prepareUI() {
        self.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.6)
        var tipView = UIView()
        tipView.center = self.center
        tipView.bounds = CGRectMake(0, 0, tipViewWidth, tipViewHeight)
        tipView.backgroundColor = UIColor.whiteColor()
        tipView.layer.cornerRadius = 5
        tipView.layer.masksToBounds = true
        self.addSubview(tipView)
        
        // nameLabel
        var nameLabelX = CGFloat(24)
        var nameLabelY = CGFloat(40)
        var nameLabelWidth = tipViewWidth - nameLabelX * 2
        var nameLabelHeight = labelHeight
        self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, nameLabelHeight)
        self.nameLabel.text = self.name
        tipView.addSubview(self.nameLabel)
        
        // orderNumberLabel
        var orderLabelX = nameLabelX
        var orderLabelY = CGRectGetMaxY(self.nameLabel.frame) + 10
        var orderLabelWidth = nameLabelWidth
        var orderLabelHeight = labelHeight
        self.orderNumberLabel.frame = CGRectMake(orderLabelX, orderLabelY, orderLabelWidth, orderLabelHeight)
        self.orderNumberLabel.text = self.orderNumber
        tipView.addSubview(self.orderNumberLabel)
        
        var confirmBtn = UIButton(type: .Custom)
        var btnHeight = CGFloat(35)
        var btnY = tipViewHeight - btnHeight
        var btnWidth = tipViewWidth
        var btnX = 0
        confirmBtn.frame = CGRectMake(0, btnY, btnWidth, btnHeight)
        confirmBtn.setTitleColor(RGB(123, g: 2, b: 90), forState: .Normal)
        confirmBtn.setTitle("确定", forState: .Normal)
        confirmBtn.addTarget(self, action: "confirmBtnAction:", forControlEvents: .TouchUpInside)
        tipView.addSubview(confirmBtn)
        
        var horizontalLine = UIView(frame: CGRectMake(0, 0, btnWidth, 0.5))
        horizontalLine.backgroundColor = UIColor.lightGrayColor()
        confirmBtn.addSubview(horizontalLine)
        
    }
    
}
