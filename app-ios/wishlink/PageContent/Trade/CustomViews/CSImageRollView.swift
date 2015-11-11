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
    
   weak var delegate:       CSImageRollViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        initViews()
    }
    
    deinit{
        
        NSLog("CSImageRollView -->deinit")
      
        
        self.delegate = nil
        self.containerView = nil;
        self.scrollerView = nil;
        self.pageControl = nil;
        self.images = nil;
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
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        scrollerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initWithImages(images: [UIImage]?) {
        
        self.images = images
    
        var scrollerViews = Dictionary<String, AnyObject>()
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
            let image: UIImage = self.images[tag] as! UIImage
            let imageView: UIImageView = UIImageView(image: image)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.backgroundColor = UIColor.clearColor()
            imageView.userInteractionEnabled = true
            imageView.multipleTouchEnabled = true
            imageView.tag = ImageTag + tag
            containerView.addSubview(imageView)
            
            let imageViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapGestureRecognizerForImageView:"))
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
        pageControl.hidden = self.images.count < 1;
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
        
        let pointX: CGFloat = CGFloat(sender.currentPage) * scrollerView.frame.size.width
        self.scrollerView.setContentOffset(CGPoint(x: pointX, y: 0), animated: true)
    }
    
    func tapGestureRecognizerForImageView(sender: AnyObject!) {
        
        self.delegate?.touchImageAction!(sender.view)
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        let pageCurrent: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)
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
    
    func addConstraintsVisualFormat(format: String, views: [String : AnyObject]) {
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: views))
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
    
    //Width : Height = Multiple
    func addConstraintWidthAndHeightMultiple(multiplier: CGFloat, item view1: AnyObject) {
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view1, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
    }
}

