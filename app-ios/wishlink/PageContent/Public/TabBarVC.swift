//
//  TabBarViewController.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor.whiteColor()
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
        releaseVC.tabBarItem = UITabBarItem.tabBarItem("发布", image: UIImage(named: "release_unselect")!, selectedImage: UIImage(named: "release_select")!);
        
        
        let createNav =  NavigationPageVC(rootViewController: releaseVC)
        
        
        let searchVC = T03SearchHelperVC(nibName: "T03SearchHelperVC", bundle: NSBundle.mainBundle())
        searchVC.tabBarItem.title = "搜索"
        searchVC.tabBarItem = UITabBarItem.tabBarItem("搜索", image: UIImage(named: "search_unselect")!, selectedImage: UIImage(named: "search_select")!);
        let searchNav =  NavigationPageVC(rootViewController: searchVC)


        let mineVC = U02UserVC(nibName: "U02UserVC", bundle: NSBundle.mainBundle())
        mineVC.tabBarItem = UITabBarItem.tabBarItem("我的", image: UIImage(named: "me")!, selectedImage: UIImage(named: "me-p")!)
        let mineNav = NavigationPageVC(rootViewController: mineVC)
        
        
        self.addChildViewController(homeNav)
        self.addChildViewController(hotNav)
        self.addChildViewController(createNav)
        
        self.addChildViewController(searchNav)
        self.addChildViewController(mineNav)
        self.selectedIndex = 0;
        
        
        
          [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_button_take.png"] highlightImage:[UIImage imageNamed:@"tabBar_cameraButton_ready_matte.png"]];
        
        var buttonImage:UIImage = UIImage(named: "", inBundle: <#T##NSBundle?#>, compatibleWithTraitCollection: <#T##UITraitCollection?#>)
       var button = UIButton(type: UIButtonType.Custom)
        
//        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
        
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        
        CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
        if (heightDifference < 0)
        button.center = self.tabBar.center;
        else
        {
            CGPoint center = self.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            button.center = center;
        }
        
        [self.view addSubview:button];

        
        
        
    }
    
    
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
      
        let navigationController = self.selectedViewController as! UINavigationController
//        let viewController = (navigationController.viewControllers)[0]
        
      
        
//        if  viewController.isKindOfClass(T03SearchHelperVC) {
        
            navigationController.popToRootViewControllerAnimated(false)
//        }
    }
}
