//
//  ShareVC.swift
//  wishlink
//
//  Created by Andy Chen on 11/19/15.
//  Copyright © 2015 edonesoft. All rights reserved.
//

import UIKit

protocol ShareDelegate : NSObjectProtocol {
    
    func btnTapAction(btntag:Int);
}
class ShareVC: UIWindow {

    var shareAction:((tag:Int)->Void)!
    

    private var viewConstraints: Dictionary<String, NSObject>!
    //MARK:点击头部图片时弹出层
//    var main_imgShowView:UIView!
    //var main_maskView:UIView!
    var main_tapGesture:UITapGestureRecognizer!
    var   shareView:UIView!;
    var duration = 0.6;
    let width:CGFloat = 45
    let viewHeight:CGFloat = 108
    
    deinit{
        NSLog("ShareVC deinit")
        main_tapGesture = nil;
    }
    
    class var sharedInstance : ShareVC {
        struct Static {
            static let instance: ShareVC = ShareVC(frame: CGRectZero)
        }
        return Static.instance
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    
    
    func CreateView()
    {
        if(self.subviews.count>0)
        {
            for view in self.subviews {
                view.removeFromSuperview()
            }
        }

        NSLog("CreateView");
        self.frame = KeyWindow.bounds
        self.windowLevel = UIWindowLevelStatusBar
        self.backgroundColor = RGBCA(0, a: 0.3)
        
        if(shareView == nil)
        {
             viewConstraints = Dictionary<String, NSObject>()

            
            shareView = UIView();
            shareView.layer.shadowRadius = 1;
            shareView.layer.shadowColor = UIColor.grayColor().CGColor;
            shareView.backgroundColor = UIColor.whiteColor()
            shareView.userInteractionEnabled = true
            shareView.translatesAutoresizingMaskIntoConstraints = false
            viewConstraints["shareView"] = shareView
            self.addSubview(shareView)

            
            
            self.addConstraintsVisualFormat("H:|[shareView]|", views: viewConstraints);
            self.addConstraintsVisualFormat("V:[shareView(\(self.viewHeight))]|", views: viewConstraints);
        }
        
        
        let marginTop:CGFloat = 23;

        let btnSina = UIButton()
        btnSina.translatesAutoresizingMaskIntoConstraints = false
        btnSina.setBackgroundImage(UIImage(named:"shareSina"), forState: UIControlState.Normal);
        btnSina.setTitle("新浪微博", forState: UIControlState.Normal);
        btnSina.tag == 1;
        btnSina.addTarget(self, action: Selector("btnSinaShareAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        viewConstraints["btnSina"] = btnSina
        shareView.addSubview(btnSina);
        self.addConstraintsVisualFormat("H:|-\(marginTop)-[btnSina(\(width))]", views: viewConstraints);
        self.addConstraintsVisualFormat("V:|-\(marginTop)-[btnSina(\(width))]", views: viewConstraints);
        
        let lbSina = UILabel();
        lbSina.translatesAutoresizingMaskIntoConstraints = false;
        lbSina.font = UIHEPLER.getCustomFont(true, fontSsize: 14);
        lbSina.textColor = UIHEPLER.mainColor
        lbSina.text = "新浪微博";
        viewConstraints["lbSina"] = lbSina
        shareView.addSubview(lbSina);
        self.addConstraintsVisualFormat("V:[btnSina]-10-[lbSina]", views: viewConstraints);

        self.addConstraint(NSLayoutConstraint(item: lbSina, attribute: .CenterX, relatedBy: .Equal, toItem: btnSina, attribute: .CenterX, multiplier: 1, constant: 0));
        
        
        let btnshareWiXin = UIButton()
        btnshareWiXin.translatesAutoresizingMaskIntoConstraints = false
        btnshareWiXin.setBackgroundImage(UIImage(named:"shareWiXin"), forState: UIControlState.Normal);
        btnshareWiXin.tag == 2;
        btnshareWiXin.addTarget(self, action: Selector("btnWiXinShareAction:"), forControlEvents: UIControlEvents.TouchUpInside)
         viewConstraints["btnshareWiXin"] = btnshareWiXin
        shareView.addSubview(btnshareWiXin);
        self.addConstraintsVisualFormat("H:|-\(ScreenWidth/2-width/2)-[btnshareWiXin(\(width))]", views: viewConstraints);
        self.addConstraintsVisualFormat("V:|-\(marginTop)-[btnshareWiXin(\(width))]", views: viewConstraints);
        
        let lbWiXin = UILabel();
        lbWiXin.translatesAutoresizingMaskIntoConstraints = false;
        lbWiXin.font = UIHEPLER.getCustomFont(true, fontSsize: 14);
        lbWiXin.textColor = UIHEPLER.mainColor
        lbWiXin.text = "微信好友";
        viewConstraints["lbWiXin"] = lbWiXin
        shareView.addSubview(lbWiXin);
        self.addConstraintsVisualFormat("V:[btnshareWiXin]-10-[lbWiXin]", views: viewConstraints);
        self.addConstraint(NSLayoutConstraint(item: lbWiXin, attribute: .CenterX, relatedBy: .Equal, toItem: btnshareWiXin, attribute: .CenterX, multiplier: 1, constant: 0));
        
        
        let btnshareMontent = UIButton()
        btnshareMontent.setTitleColor(UIColor.magentaColor(), forState: UIControlState.Normal)
        btnshareMontent.translatesAutoresizingMaskIntoConstraints = false
        btnshareMontent.setBackgroundImage(UIImage(named:"shareMontent"), forState: UIControlState.Normal);
        btnshareMontent.tag == 3;
        btnshareMontent.addTarget(self, action: Selector("btnMontentShareAction:"), forControlEvents: UIControlEvents.TouchUpInside)
         viewConstraints["btnshareMontent"] = btnshareMontent
        shareView.addSubview(btnshareMontent);
        self.addConstraintsVisualFormat("H:[btnshareMontent(\(width))]-\(marginTop)-|", views: viewConstraints);
        self.addConstraintsVisualFormat("V:|-\(marginTop)-[btnshareMontent(\(width))]", views: viewConstraints);
        
        let lbMontent = UILabel();
        lbMontent.translatesAutoresizingMaskIntoConstraints = false;
        lbMontent.textColor = UIHEPLER.mainColor
        lbMontent.font = UIHEPLER.getCustomFont(true, fontSsize: 14);
        lbMontent.text = "朋友圈";
        viewConstraints["lbMontent"] = lbMontent
        shareView.addSubview(lbMontent);
        self.addConstraintsVisualFormat("V:[btnshareMontent]-10-[lbMontent]", views: viewConstraints);
  
        self.addConstraint(NSLayoutConstraint(item: lbMontent, attribute: .CenterX, relatedBy: .Equal, toItem: btnshareMontent, attribute: .CenterX, multiplier: 1, constant: 0));

        
    }
    func btnMontentShareAction(serder:UIButton)
    {
        
        self.shareActionFun(3);
    }
    
    func btnWiXinShareAction(serder:UIButton)
    {
        self.shareActionFun(2);
        
    }
    
    func btnSinaShareAction(sender:UIButton)
    {
        NSLog("share action");
        self.shareActionFun(1);
        
        
        
    }
    func shareActionFun(kind:Int)
    {
        if(self.shareAction != nil)
        {
            self.shareAction(tag:kind);
        }

    }
    
    //MARK: - touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        show(false)
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
    func backguandImageViewBeginOriginY(show: Bool) {
        
//        self.main_imgShowView.frame.origin.y = show ? self.frame.size.height - main_imgShowView.frame.size.height : self.frame.size.height
        self.shareView.frame.origin.y = show ? self.frame.size.height - shareView.frame.size.height : self.frame.size.height
    }

    

    //分享按钮
    func btnTapAction(sender:UIButton)
    {
        
    }
}
