//
//  CSActionSheet.swift
//  CateShow
//
//  Created by whj on 15/8/18.
//  Copyright (c) 2015年 whj. All rights reserved.
//

import UIKit

class CSActionSheet : UIWindow {
    
    private var viewConstraints: Dictionary<String, NSObject>!
    var delegate: CSActionSheetDelegate?
    var titles: NSArray!
    var backguandImageView: UIImageView!

    let ButtonTag: Int = 1000
    var ButtonHeight: CGFloat = 45
    
    class var sharedInstance : CSActionSheet {
        struct Static {
            static let instance: CSActionSheet = CSActionSheet(frame: CGRectZero)
        }
        return Static.instance
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func bindWithData(titles: NSArray, delegate: CSActionSheetDelegate?) {
        
        if titles.count < 2 { return }
        
        self.titles = titles
        self.delegate = delegate
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
            
        self.frame = KeyWindow.bounds
        self.windowLevel = UIWindowLevelStatusBar
        self.backgroundColor = RGBCA(0, a: 0.3)
        
        viewConstraints = Dictionary<String, NSObject>()
        
        backguandImageView = UIImageView()
        backguandImageView.backgroundColor = RGBC(229.0)
        backguandImageView.userInteractionEnabled = true
        backguandImageView.translatesAutoresizingMaskIntoConstraints = false
        viewConstraints["backguandImageView"] = backguandImageView
        self.addSubview(backguandImageView)
        
        for var index = 0; index < titles.count; index++ {
        
            let space: Int = index == 1 ? 5 : 1
            let key: String = "button\(index)"
            
            let button: UIButton = UIButton()
            button.backgroundColor = UIColor.whiteColor()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(titles[index] as? String, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = ButtonTag + index
            backguandImageView.addSubview(button)
            
            viewConstraints[key] = button
            
            if index == 0 {
                self.addConstraintsVisualFormat("V:[\(key)]|", views: viewConstraints)
            } else {
                let key0: String = "button\(index-1)"
                backguandImageView.addConstraintsVisualFormat("V:[\(key)]-\(space)-[\(key0)]", views: viewConstraints)
            }
            backguandImageView.addConstraintsVisualFormat("H:|[\(key)]|", views: viewConstraints)
            backguandImageView.addConstraintsVisualFormat("V:[\(key)(\(ButtonHeight))]", views: viewConstraints)
        }
        
        let backguandImageViewHeight: CGFloat = CGFloat(titles.count) * ButtonHeight + CGFloat(titles.count - 2) * 1 + 5
        self.addConstraintsVisualFormat("H:|[backguandImageView]|", views: viewConstraints)
        self.addConstraintsVisualFormat("V:[backguandImageView(\(backguandImageViewHeight))]|", views: viewConstraints)
    }
    
    func show(show: Bool) {
        
        if show { self.hidden = !show }
        
        backguandImageViewBeginOriginY(!show)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
           self.backguandImageViewBeginOriginY(show)
        }) { finish -> Void in
            if !show { self.hidden = !show }
        }
    }

    //MARK: - touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        show(false)
    }
    
    //MARK: - Action
    
    func buttonAction(sender: UIButton) {
        
        self.delegate?.csActionSheetAction(self, selectedIndex: sender.tag)
        
        if sender.tag == ButtonTag {
           
        }
        
        self.show(false)
    }
    
    //MARK: -  Unit
    
    func backguandImageViewBeginOriginY(show: Bool) {
        
        self.backguandImageView.frame.origin.y = show ? self.frame.size.height - backguandImageView.frame.size.height : self.frame.size.height
    }
}

protocol CSActionSheetDelegate : NSObjectProtocol {

   func csActionSheetAction(view: CSActionSheet, selectedIndex index: Int)
}