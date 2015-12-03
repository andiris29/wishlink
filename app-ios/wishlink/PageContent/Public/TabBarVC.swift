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
    var isFirstTime = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundImage = self.whiteImage;
        isFirstTime = true;
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
        homeVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-3)
        let homeNav =  NavigationPageVC(rootViewController: homeVC)
        
        let hotVC =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        hotVC.tabBarItem = UITabBarItem.tabBarItem("最热", image: UIImage(named: "hot")!, selectedImage: UIImage(named: "hot-p")!);
        hotVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-3)
        
        let hotNav =  NavigationPageVC(rootViewController: hotVC)
        
        let releaseVC = T04CreateTradeVC(nibName: "T04CreateTradeVC", bundle: NSBundle.mainBundle())
        releaseVC.tabBarItem.title = "发布"
        releaseVC.tabBarItem.tag = 9
      //  releaseVC.tabBarItem = UITabBarItem.tabBarItem("发布", image: UIImage(named: "release_unselect")!, selectedImage: UIImage(named: "release_select")!);
         releaseVC.tabBarItem = UITabBarItem.tabBarItem("发布", image: UIImage(named: "release_unselect")!, selectedImage: UIImage(named: "release_select")!);
        releaseVC.hidesBottomBarWhenPushed = true;
        
          releaseVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-3)
        let createNav =  NavigationPageVC(rootViewController: releaseVC)
 
        createNav.tabBarItem.tag = 9;
        
        let searchVC = T03SearchHelperVC(nibName: "T03SearchHelperVC", bundle: NSBundle.mainBundle())
        searchVC.tabBarItem.title = "搜索"
        searchVC.tabBarItem = UITabBarItem.tabBarItem("搜索", image: UIImage(named: "search_unselect")!, selectedImage: UIImage(named: "search_select")!);
        
        searchVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-3)
        let searchNav =  NavigationPageVC(rootViewController: searchVC)


        let mineVC = U02UserVC(nibName: "U02UserVC", bundle: NSBundle.mainBundle())
        mineVC.tabBarItem = UITabBarItem.tabBarItem("我的", image: UIImage(named: "me")!, selectedImage: UIImage(named: "me-p")!)
        
        mineVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-3)
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
        
        self.selectedIndex = 1;
        



    }
//    var centerButton:UIButton!
//    var centerBtn_Normal:UIImage! = UIImage(named: "tabbar_gray_bg");
//    var centerBtn_HightLight:UIImage! = UIImage(named: "tabbar_red_bg");
    override func viewWillAppear(animated: Bool) {
        
//        if(self.centerButton == nil)
//        {
//            self.createCenterBtn();
//        }
        
        if(isFirstTime)
        {
            isFirstTime = false;
            self.selectedIndex = 0;
        }
    }
//    func createCenterBtn()
//    {
//        let sIndex = self.selectedIndex;
//        
//        //中上部自定义BUtton
//        let btnWidth:CGFloat = self.tabBar.frame.height-5;
//        centerButton = UIButton(type: UIButtonType.Custom);
//        centerButton.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin,UIViewAutoresizing.FlexibleBottomMargin,
//            UIViewAutoresizing.FlexibleTopMargin,UIViewAutoresizing.FlexibleRightMargin]
//        centerButton.frame = CGRectMake(0, 0, btnWidth, btnWidth);
//        if(sIndex == 2)
//        {
//            centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Normal);
//        }
//        else
//        {
//            centerButton.setBackgroundImage(centerBtn_Normal, forState: UIControlState.Normal);
//        }
//        centerButton.addTarget(self, action: Selector("centerBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
//        var center = self.tabBar.center;
//        center.y = center.y - 15;
//        centerButton.center = center;
//        self.view.addSubview(centerButton);
//    }
//    func centerBtnAction(sender:UIButton)
//    {
//        self.selectedIndex = 2;
//        self.centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Normal);
//        self.centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Highlighted);
//    }
    
    func backToTopVC()
    {
        let navigationController = self.selectedViewController as! UINavigationController
        navigationController.popToRootViewControllerAnimated(true);
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
    }
   
    var lastIndex = 0;
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
      
        if(self.selectedIndex != lastIndex)
        {
            self.backToTopVC();
            NSLog(" tag:%d",item.tag);
            self.lastIndex = self.selectedIndex;
            if(item.tag == 9)
            {
                
            }
        }
        
//        if(self.centerButton != nil)
//        {
//            if(item.tag == 9)
//            {
//                self.centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Normal);
//                self.centerButton.setBackgroundImage(centerBtn_HightLight, forState: UIControlState.Highlighted);
//            }
//            else
//            {
//                self.centerButton.setBackgroundImage(centerBtn_Normal, forState: UIControlState.Normal);
//                self.centerButton.setBackgroundImage(centerBtn_Normal, forState: UIControlState.Highlighted);
//            }
//        }

       
    }


 


}
