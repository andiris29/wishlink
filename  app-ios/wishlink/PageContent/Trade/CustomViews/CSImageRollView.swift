//
//  CSImageRollView.swift
//  CateShow
//
//  Created by whj on 15/8/21.
//  Copyright (c) 2015年 whj. All rights reserved.
//

import UIKit

class CSImageRollView: UIView, UIScrollViewDelegate {

   private var containerView:  UIView!
   private var scrollerView:   UIScrollView!
   private var pageControl:    UIPageControl!
    
   private var images: NSArray!
   private let ImageTag = 1000
    
   var delegate:       CSImageRollViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        initViews()
    }
    
    func initViews() {
    
        containerView  = UIView()
        scrollerView   = UIScrollView()
        pageControl    = UIPageControl()
        
        scrollerView.delegate = self
        scrollerView.pagingEnabled = true
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.showsHorizontalScrollIndicator = false
        
        pageControl.backgroundColor = UIColor.clearColor()
        scrollerView.backgroundColor = UIColor.clearColor()
        containerView.backgroundColor = UIColor.clearColor()
        
        scrollerView.addSubview(containerView)
        self.addSubview(scrollerView)
        self.addSubview(pageControl)
        
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func initWithImages(images: [String]?) {
        
        self.images = images
    
        var scrollerViews = Dictionary<NSObject, AnyObject>()
        scrollerViews["pageControl"] = pageControl
        scrollerViews["scrollerView"] = scrollerView
        scrollerViews["containerView"] = containerView
        
        //scrollerView
        self.addConstraintsVisualFormat("H:|[scrollerView]|", views: scrollerViews)
        self.addConstraintsVisualFormat("V:|[scrollerView]|", views: scrollerViews)
        
        //containerView
        scrollerView.addConstraintsVisualFormat("H:|[containerView]|", views: scrollerViews)
        scrollerView.addConstraintsVisualFormat("V:|[containerView(scrollerView)]|", views: scrollerViews)
        scrollerView.addConstraintWidthMultiple(CGFloat(self.images.count), item: containerView, toItem: scrollerView)
        
        //imageView
        for var tag = 0; tag < self.images.count; tag++ {
            
            let key: String = "imageView\(tag)"
            var imageName: String = self.images[tag] as! String
            var imageView: UIImageView = UIImageView(image: UIImage(named: imageName))
            
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.backgroundColor = UIColor.clearColor()
            imageView.userInteractionEnabled = true
            imageView.multipleTouchEnabled = true
            imageView.tag = ImageTag + tag
            containerView.addSubview(imageView)
            
            var imageViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapGestureRecognizerForImageView:"))
            imageView.addGestureRecognizer(imageViewTapGesture)
            
            
            scrollerViews[key] = imageView
            if tag == 0 {
                containerView.addConstraintsVisualFormat("H:|[\(key)]", views: scrollerViews)
            }else if tag == self.images.count - 1 {
                let key0: String = "imageView\(tag-1)"
                containerView.addConstraintsVisualFormat("H:[\(key0)][\(key)]|", views: scrollerViews)
            }else {
                let key0: String = "imageView\(tag-1)"
                containerView.addConstraintsVisualFormat("H:[\(key0)][\(key)]", views: scrollerViews)
            }
            scrollerView.addConstraintsVisualFormat("[\(key)(scrollerView)]", views: scrollerViews)
            containerView.addConstraintsVisualFormat("V:|[\(key)(containerView)]|", views: scrollerViews)
        }

        //pageControl
        pageControl.currentPage = 0
        pageControl.numberOfPages = self.images.count
        pageControl.addTarget(self, action: Selector("pageControlValueChangeAction:"), forControlEvents: UIControlEvents.ValueChanged)
        self.addConstraintWidthMultiple(4.0, item: self, toItem: pageControl)
        self.addConstraintsVisualFormat("V:[pageControl(20)]-10-|", views: scrollerViews)
        self.addConstraintMultiple(1.0, item: pageControl, toItem: self, attribute: NSLayoutAttribute.CenterX)
    }
    
    //MARK: - Method
    
    func setPageControlBackguandColor(color: UIColor) {
        
        self.pageControl.backgroundColor = color
    }
    
    func setcurrentPageIndicatorTintColor(color: UIColor) {
        
        self.pageControl.currentPageIndicatorTintColor = color
    }
    
    func setpageIndicatorTintColor(color: UIColor) {
        
      self.pageControl.pageIndicatorTintColor = color
    }
    
//    func set(color: UIColor) {
//        
//    }
    
    //MARK: - Action
    
    func pageControlValueChangeAction(sender: UIPageControl!) {
        
        var pointX: CGFloat = CGFloat(sender.currentPage) * scrollerView.frame.size.width
        self.scrollerView.setContentOffset(CGPoint(x: pointX, y: 0), animated: true)
    }
    
    func tapGestureRecognizerForImageView(sender: AnyObject!) {
        
        self.delegate?.touchImageAction!(sender.view)
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        var pageCurrent: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)
        self.pageControl.currentPage = pageCurrent
    }
}

//MARK: - Unit


//MARK: - CSImageRollViewDelegate

@objc protocol CSImageRollViewDelegate: NSObjectProtocol {

    optional func touchImageAction(sender: AnyObject!)
}

//MARK: - EXTENSION

extension UIView {
    
    func addConstraintsVisualFormat(format: String, views: [NSObject : AnyObject]) {
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
    }
    
    // view1 是view2 的多少倍
    func addConstraintMultiple(multiplier: CGFloat, item view1: AnyObject, toItem view2: AnyObject?, attribute attr: NSLayoutAttribute) {
        
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: attr, multiplier: multiplier, constant: 0))
    }
    
    func addConstraintWidthMultiple(multiplier: CGFloat, item view1: AnyObject, toItem view2: AnyObject?) {
        self.addConstraintMultiple(multiplier, item: view1, toItem: view2, attribute: NSLayoutAttribute.Width)
    }
    
    func addConstraintHeightMultiple(multiplier: CGFloat, item view1: AnyObject, toItem view2: AnyObject?) {
        self.addConstraintMultiple(multiplier, item: view1, toItem: view2, attribute: NSLayoutAttribute.Height)
    }
    
}

