//
//  CSDorpListView.swift
//  CateShow
//
//  Created by whj on 15/8/29.
//  Copyright (c) 2015年 whj. All rights reserved.
//

import UIKit

class CSDorpListView: UIWindow {
    
    private var scrollerView:  UIScrollView!
    private var containerView: UIView!
    private var titleView: UIView!
        
//    private var inputTextField: UITextField!
//    private var dorpButton: UIButton!
    
    private var baseView: UIView!
    
    private var viewConstraints: Dictionary<String, NSObject>!
    private var titles: NSArray!
    
    private let buttonTag = 10000
    
    var delegate: CSDorpListViewDelegate?
    
    
    class var sharedInstance : CSDorpListView {
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CSDorpListView? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = CSDorpListView(frame: CGRectZero)
        }
        return Static.instance!
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        initViews()
    }
    
    func initViews() {
        
        self.hidden = true
        self.frame = KeyWindow.bounds
        self.backgroundColor = RGBCA(0, 0.3)
        self.windowLevel = UIWindowLevelStatusBar
        
        baseView = UIView()
        baseView.userInteractionEnabled = true
        baseView.backgroundColor = UIColor.whiteColor()
//        baseView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(baseView)
        
        titleView      = UIView()
        titleView.backgroundColor = UIColor.clearColor()
        titleView.setTranslatesAutoresizingMaskIntoConstraints(false)
        baseView.addSubview(titleView)
        
//        dorpButton     = UIButton()
//        dorpButton.backgroundColor = UIColor.clearColor()
//        dorpButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//        dorpButton.setTitle("上", forState: UIControlState.Normal)
//        dorpButton.setTitle("下", forState: UIControlState.Selected)
//        dorpButton.addTarget(self, action: Selector("dorpButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
//        titleView.addSubview(dorpButton)
//        
//        inputTextField = UITextField()
//        inputTextField.backgroundColor = UIColor.clearColor()
//        inputTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
//        titleView.addSubview(inputTextField)
        
        containerView  = UIView()
        containerView.backgroundColor = UIColor.clearColor()
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        scrollerView   = UIScrollView()
        scrollerView.bounces = true
        scrollerView.pagingEnabled = true
        scrollerView.backgroundColor = UIColor.clearColor()
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollerView.addSubview(containerView)
        baseView.addSubview(scrollerView)
    }
    
    func bindWithList(titles: NSArray, delegate: CSDorpListViewDelegate?) {

        self.titles = titles
        self.delegate = delegate

        for view in containerView.subviews {
            view.removeFromSuperview()
        }
        
        viewConstraints = Dictionary<String, NSObject>()
//        viewConstraints["inputTextField"] = inputTextField
        viewConstraints["containerView"] = containerView
        viewConstraints["scrollerView"] = scrollerView
//        viewConstraints["dorpButton"] = dorpButton
        viewConstraints["titleView"] = titleView
//        viewConstraints["baseView"] = baseView
        
        //titleView
        baseView.addConstraintsVisualFormat("H:|[titleView]|", views: viewConstraints)
        baseView.addConstraintsVisualFormat("V:|[titleView]", views: viewConstraints)
        
        //dorpButton inputTextField
//        titleView.addConstraintWidthAndHeightMultiple(1.0, item: dorpButton)
//        titleView.addConstraintsVisualFormat("V:|[dorpButton]|", views: viewConstraints)
//        titleView.addConstraintsVisualFormat("V:|[inputTextField]|", views: viewConstraints)
//        titleView.addConstraintsVisualFormat("H:|-8-[inputTextField][dorpButton]|", views: viewConstraints)
        
        //scrollerView
        baseView.addConstraintsVisualFormat("H:|[scrollerView]|", views: viewConstraints)
        baseView.addConstraintsVisualFormat("V:[titleView][scrollerView]", views: viewConstraints)
        
        //containerView
        scrollerView.addConstraintsVisualFormat("V:|[containerView]|", views: viewConstraints)
        scrollerView.addConstraintsVisualFormat("H:|[containerView(scrollerView)]|", views: viewConstraints)
//        scrollerView.addConstraintHeightMultiple(CGFloat(self.titles.count), item: containerView, toItem: scrollerView)
        scrollerView.addConstraintHeightMultiple(1.0, item: containerView, toItem: scrollerView)
        
        for var index = 0; index < self.titles.count; index++ {
        
            let key: String = "button\(index)"
            var button: UIButton = UIButton()
            button.backgroundColor = UIColor.clearColor()
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.titleLabel?.font = UIFont(name: "FZLanTingHeiS-EL-GB", size: 15)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.setTitle(self.titles[index] as? String, forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("dorpListButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = buttonTag + index
            containerView.addSubview(button)
            
            viewConstraints[key] = button
            if index == 0 {
                containerView.addConstraintsVisualFormat("V:|[\(key)]", views: viewConstraints)
            }else if tag == self.titles.count - 1 {
                let key0: String = "button\(index-1)"
                containerView.addConstraintsVisualFormat("V:[\(key0)][\(key)]|", views: viewConstraints)
            }else {
                let key0: String = "button\(index-1)"
                containerView.addConstraintsVisualFormat("V:[\(key0)][\(key)]", views: viewConstraints)
            }
            containerView.addConstraintsVisualFormat("H:|-8-[\(key)(containerView)]|", views: viewConstraints)
            containerView.addConstraintHeightMultiple(CGFloat(self.titles.count), item: containerView, toItem: button)
        }
    }
    
    func show(view: UIView) {
        
        self.hidden = false
        //UIApplication.sharedApplication().windows.count
        //将view在当前视图的Rect转换为目标师徒的Rect
        baseView.frame = view.superview!.convertRect(view.frame, toView: KeyWindow)
        baseView.frame.origin.y = baseView.frame.origin.y + baseView.frame.size.height
        baseView.frame.size.height = CGFloat(titles.count + 1) * baseView.frame.size.height
    }
    
    //MARK: - Action
    
//    func dorpButtonAction(sender: UIButton) {
//        
//        sender.selected = !sender.selected
//        
//        var viewHeight: CGFloat = 0.0
//        
//        if sender.selected {
//
//            viewHeight = self.frame.size.height * CGFloat(self.titles.count + 1)
//            self.addConstraintsVisualFormat("V:|[titleView][scrollerView]|", views: viewConstraints)
//        } else {
//            viewHeight = self.frame.size.height / CGFloat(self.titles.count + 1)
//            self.addConstraintsVisualFormat("V:|[titleView][scrollerView]", views: viewConstraints)
//        }
//        self.frame.size.height = viewHeight
//        self.setNeedsDisplay()
//    }
    
    func dorpListButtonAction(sender: UIButton) {
        
        self.hidden = true
        self.delegate?.dorpListButtonItemAction(sender)
    }
    
    //MARK: - override
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.hidden = true
        self.removeFromSuperview()
    }
}

//MARK: - CSDorpListViewDelegate

protocol CSDorpListViewDelegate: NSObjectProtocol {
    
    func dorpListButtonItemAction(sender: UIButton!)
}

