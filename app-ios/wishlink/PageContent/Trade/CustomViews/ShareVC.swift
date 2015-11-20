//
//  ShareVC.swift
//  wishlink
//
//  Created by Andy Chen on 11/19/15.
//  Copyright © 2015 edonesoft. All rights reserved.
//

import UIKit

class ShareVC: UIViewController {

    //MARK:点击头部图片时弹出层
    var main_imgShowView:UIView!
    
    var main_maskView:UIView!
    var main_tapGesture:UITapGestureRecognizer!

    var   shareView:UIView!;
    var duration = 0.6;
    
    let width = UIHEPLER.resizeHeight(43);
    let viewHeight = UIHEPLER.resizeHeight(108);
    
    

  
    
    
    deinit{
        NSLog("ShareVC deinit")
        main_tapGesture = nil;
 
        
    }
    

    
    func CreateView()
    {
        NSLog("CreateView");
        if(main_imgShowView == nil)
        {
            main_imgShowView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight));
            main_imgShowView.backgroundColor = UIColor.clearColor()
            
            
            main_maskView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight));
            main_maskView.backgroundColor = UIColor.blackColor();
            main_maskView.alpha = 0.7;
            
            shareView = UIView(frame: CGRectMake(0, ScreenHeight, ScreenWidth, self.viewHeight));
            shareView.backgroundColor = UIColor.whiteColor();
        }
        
        
        
        let sinaFrame = CGRectMake(UIHEPLER.resizeHeight(33), UIHEPLER.resizeHeight(23), width, width);
        let btnSina = UIButton(frame: sinaFrame)
        btnSina.setBackgroundImage(UIImage(named:"shareSina"), forState: UIControlState.Normal);
        
        
        
        
        let wxFrame = CGRectMake((ScreenWidth-width)/2, UIHEPLER.resizeHeight(23), width, width);
        let btnWx = UIButton(frame: wxFrame)
        btnWx.setBackgroundImage(UIImage(named:"shareWiXin"), forState: UIControlState.Normal);
        
        
        let wxMonentFrame = CGRectMake(ScreenWidth-UIHEPLER.resizeHeight(23+43), UIHEPLER.resizeHeight(23), width, width);
        let btnMontent = UIButton(frame: wxMonentFrame)
        btnMontent.setBackgroundImage(UIImage(named:"shareMontent"), forState: UIControlState.Normal);
        
        
        
        shareView.addSubview(btnSina);
        shareView.addSubview(btnWx);
        shareView.addSubview(btnMontent);
        
        main_imgShowView.addSubview(shareView);
        
        self.view.backgroundColor = UIColor.clearColor();
        
        
        self.view.addSubview(self.main_maskView)
        self.view.addSubview(self.main_imgShowView)
        
        APPLICATION.keyWindow?.addSubview(self.view);
    }
    
    func beginAnimate()
    {
        CreateView();
        NSLog("beginAnimate");
        
        self.main_tapGesture = UITapGestureRecognizer(target: self, action: "endTapGestureHideView:")
        
        self.main_imgShowView.addGestureRecognizer(self.main_tapGesture);
 
        UIView.animateWithDuration(duration, animations: {
            
            }, completion: {
                
                [weak self](Bool completion) in
                
                if completion {
                    
                    self!.shareView.frame = CGRectMake(0, ScreenHeight-self!.viewHeight, ScreenWidth, self!.viewHeight)

                }
                else {
                    
                }
        })
    }
    
    func endTapGestureHideView(recognizer:UIGestureRecognizer)
    {
        self.main_imgShowView.hidden = true;
        UIView.animateWithDuration(duration, animations: {
            
            self.main_maskView.alpha = 0
            
            }, completion: {
                 [weak self](Bool completion) in
                if completion {
                    
                    self!.main_imgShowView.alpha = 0;
                    self!.main_imgShowView.removeFromSuperview();
                    self!.main_maskView.removeFromSuperview();
                    self!.main_maskView = nil;
                    self!.main_imgShowView = nil;
                    self!.main_tapGesture = nil;
              
         
                }
                else {
                    
                }
        })
    }
    //分享按钮
    func btnTapAction(sender:UIButton)
    {
        
    }
}
