//
//  TabBarViewController.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController,UITabBarControllerDelegate {

    var whiteImage:UIImage! = UIImage(named: "tabbar_bg");
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundImage = self.whiteImage;
        self.addAllChildControllers()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addAllChildControllers() {
        
        //var hotVC =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        
        
        let homeVC =  T01HomePageVC(nibName: "T01HomePageVC", bundle: NSBundle.mainBundle())
        homeVC.tabBarItem = UITabBarItem.tabBarItem("首页", image: UIImage(named: "home_unselect")!, selectedImage: UIImage(named: "home_select")!);
        
        let homeNav =  NavigationPageVC(rootViewController: homeVC)
        
        let hotVC =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        hotVC.tabBarItem = UITabBarItem.tabBarItem("最热", image: UIImage(named: "hot")!, selectedImage: UIImage(named: "hot-p")!);
        
        let hotNav =  NavigationPageVC(rootViewController: hotVC)
        
        let releaseVC = T04CreateTradeVC(nibName: "T04CreateTradeVC", bundle: NSBundle.mainBundle())
        releaseVC.tabBarItem.title = "发布"
         releaseVC.tabBarItem.tag = 9
        releaseVC.tabBarItem = UITabBarItem.tabBarItem("发布", image: UIImage(named: "release_unselect")!, selectedImage: UIImage(named: "release_select")!);
        
        
        let createNav =  NavigationPageVC(rootViewController: releaseVC)
        
        
        let searchVC = T03SearchHelperVC(nibName: "T03SearchHelperVC", bundle: NSBundle.mainBundle())
        searchVC.tabBarItem.title = "搜索"
        searchVC.tabBarItem = UITabBarItem.tabBarItem("搜索", image: UIImage(named: "search_unselect")!, selectedImage: UIImage(named: "search_select")!);
        let searchNav =  NavigationPageVC(rootViewController: searchVC)


        let mineVC = U02UserVC(nibName: "U02UserVC", bundle: NSBundle.mainBundle())
        mineVC.tabBarItem = UITabBarItem.tabBarItem("我的", image: UIImage(named: "me")!, selectedImage: UIImage(named: "me-p")!)
        let mineNav = NavigationPageVC(rootViewController: mineVC)
        
        
        
        homeNav.navigationBar.setBackgroundImage(self.whiteImage, forBarMetrics: UIBarMetrics.Default)
        hotNav.navigationBar.setBackgroundImage(self.whiteImage, forBarMetrics: UIBarMetrics.Default)
        createNav.navigationBar.setBackgroundImage(self.whiteImage, forBarMetrics: UIBarMetrics.Default)
        searchNav.navigationBar.setBackgroundImage(self.whiteImage, forBarMetrics: UIBarMetrics.Default)
        mineNav.navigationBar.setBackgroundImage(self.whiteImage, forBarMetrics: UIBarMetrics.Default)
        self.addChildViewController(homeNav)
        self.addChildViewController(hotNav)
        self.addChildViewController(createNav)
        
        self.addChildViewController(searchNav)
        self.addChildViewController(mineNav)
        self.selectedIndex = 0;
        
       
//        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//        button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//        
//        CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
//        if (heightDifference < 0)
//        button.center = self.tabBar.center;
//        else
//        {
//            CGPoint center = self.tabBar.center;
//            center.y = center.y - heightDifference/2.0;
//            button.center = center;
//        }
//        
//        [self.view addSubview:button];

        
        
        
    }
    var centerButton:UIButton!
    var centerBtn_Normal:UIImage! = UIImage(named: "tabbar_gray_bg");
    var centerBtn_HightLight:UIImage! = UIImage(named: "tabbar_red_bg");
    override func viewWillAppear(animated: Bool) {
        
        //tabbar_red_bg
        
        let btnWidth:CGFloat = self.tabBar.frame.height-5;
        
        centerButton = UIButton(type: UIButtonType.Custom);
        centerButton.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin,UIViewAutoresizing.FlexibleBottomMargin,
            UIViewAutoresizing.FlexibleTopMargin,UIViewAutoresizing.FlexibleRightMargin]
        centerButton.frame = CGRectMake(0, 0, btnWidth, btnWidth);
        
        centerButton.setBackgroundImage(centerBtn_Normal, forState: UIControlState.Normal);
      
        centerButton.addTarget(self, action: Selector("centerBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
     
        var center = self.tabBar.center;
        center.y = center.y - 15;
        centerButton.center = center;
        
        self.view.addSubview(centerButton);
    }
    func centerBtnAction(sender:UIButton)
    {
        self.selectedIndex = 2;
        self.backToTopVC();
        if(self.centerButton != nil)
        {
            self.centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Normal);
            self.centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Highlighted);
        }
    }
    
    func backToTopVC()
    {
        
        let navigationController = self.selectedViewController as! UINavigationController
        navigationController.popToRootViewControllerAnimated(false)
    }
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
      
        self.backToTopVC();
        
        if(item.tag == 9)
        {
            if(self.centerButton != nil)
            {
                self.centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Normal);
                self.centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Highlighted);
            }
        }
        else
        {
            if(self.centerButton != nil)
            {
                self.centerButton.setBackgroundImage(centerBtn_Normal, forState: UIControlState.Normal);
                self.centerButton.setBackgroundImage(centerBtn_Normal, forState: UIControlState.Highlighted);
            }
        }
    }
}
