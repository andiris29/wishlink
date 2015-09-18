//
//  CSDorpListView.swift
//  CateShow
//
//  Created by whj on 15/8/29.
//  Copyright (c) 2015年 whj. All rights reserved.
//

import UIKit

class CSDorpListView: UIImageView {
    
    private var scrollerView:  UIScrollView!
    private var containerView: UIView!
    private var titleView: UIView!
        
    private var inputTextField: UITextField!
    private var dorpButton: UIButton!
    
    private var backguandView: UIView!
    
    private var viewConstraints: Dictionary<String, NSObject>!
    private var titles: NSArray!
    
    private let buttonTag = 10000
    
    var delegate: CSDorpListViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, titles: NSArray) {
        
        super.init(frame: frame)
        
        initViews()
        bindWithList(titles)
    }
    
    func initViews() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        titleView      = UIView()
        titleView.backgroundColor = UIColor.clearColor()
        titleView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(titleView)
        
        dorpButton     = UIButton()
        dorpButton.backgroundColor = UIColor.clearColor()
        dorpButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        dorpButton.setTitle("上", forState: UIControlState.Normal)
        dorpButton.setTitle("下", forState: UIControlState.Selected)
        dorpButton.addTarget(self, action: Selector("dorpButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        titleView.addSubview(dorpButton)
        
        inputTextField = UITextField()
        inputTextField.backgroundColor = UIColor.clearColor()
        inputTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleView.addSubview(inputTextField)
        
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
        self.addSubview(scrollerView)
    }
    
    func bindWithList(titles: NSArray) {

        self.titles = titles
        
        viewConstraints = Dictionary<String, NSObject>()
        viewConstraints["inputTextField"] = inputTextField
        viewConstraints["containerView"] = containerView
        viewConstraints["scrollerView"] = scrollerView
        viewConstraints["dorpButton"] = dorpButton
        viewConstraints["titleView"] = titleView
        
        //titleView
        self.addConstraintsVisualFormat("H:|[titleView]|", views: viewConstraints)
        self.addConstraintsVisualFormat("V:|[titleView]", views: viewConstraints)
        
        //dorpButton inputTextField
        titleView.addConstraintWidthAndHeightMultiple(1.0, item: dorpButton)
        titleView.addConstraintsVisualFormat("V:|[dorpButton]|", views: viewConstraints)
        titleView.addConstraintsVisualFormat("V:|[inputTextField]|", views: viewConstraints)
        titleView.addConstraintsVisualFormat("H:|-8-[inputTextField][dorpButton]|", views: viewConstraints)
        
        //scrollerView
        self.addConstraintsVisualFormat("H:|[scrollerView]|", views: viewConstraints)
        self.addConstraintsVisualFormat("V:[titleView][scrollerView]", views: viewConstraints)
        
        //containerView
        scrollerView.addConstraintsVisualFormat("V:|[containerView]|", views: viewConstraints)
        scrollerView.addConstraintsVisualFormat("H:|[containerView(scrollerView)]|", views: viewConstraints)
//        scrollerView.addConstraintHeightMultiple(CGFloat(self.titles.count), item: containerView, toItem: scrollerView)
        scrollerView.addConstraintHeightMultiple(1.0, item: containerView, toItem: scrollerView)
        
        for var index = 0; index < self.titles.count; index++ {
        
            let key: String = "button\(index)"
            var button: UIButton = UIButton()
            button.backgroundColor = UIColor.clearColor()
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
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
    
    func showInWindow(view: CSDorpListView) {
        
        backguandView = UIView(frame: KeyWindow.bounds)
        backguandView.backgroundColor = RGBCA(0, 0.3)
        backguandView.userInteractionEnabled = true
        var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapGestureRecognizerFromBaseView:"))
        backguandView.addGestureRecognizer(tapGestureRecognizer)
        backguandView.addSubview(view)
        KeyWindow.addSubview(backguandView)
    }
    
    //MARK: - Action
    
    func dorpButtonAction(sender: UIButton) {
        
        sender.selected = !sender.selected
        self.delegate?.dorpButtonAction!(sender)
        
        var viewHeight: CGFloat = 0.0
        
        if sender.selected {

            viewHeight = self.frame.size.height * CGFloat(self.titles.count + 1)
            self.addConstraintsVisualFormat("V:|[titleView][scrollerView]|", views: viewConstraints)
        } else {
            viewHeight = self.frame.size.height / CGFloat(self.titles.count + 1)
            self.addConstraintsVisualFormat("V:|[titleView][scrollerView]", views: viewConstraints)
        }
        self.frame.size.height = viewHeight
        self.setNeedsDisplay()
    }
    
    func dorpListButtonAction(sender: UIButton) {
        
        self.inputTextField.text = sender.titleLabel?.text
        println("\(inputTextField.text)")
    }
    
    func tapGestureRecognizerFromBaseView(sender: AnyObject) {
    
        backguandView.removeFromSuperview()
    }
    
}

//MARK: - CSDorpListViewDelegate

@objc protocol CSDorpListViewDelegate: NSObjectProtocol {
    
    optional func dorpButtonAction(sender: UIButton!)
}

