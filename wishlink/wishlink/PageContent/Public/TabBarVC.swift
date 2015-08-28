//
//  TabBarViewController.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

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
        
        var hotVC =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        hotVC.tabBarItem = UITabBarItem.tabBarItem("最热", image: UIImage(named: "hot")!, selectedImage: UIImage(named: "hot-p")!);
        var hotNav =  NavigationPageVC(rootViewController: hotVC)
        
        
        var releaseVC = T04CreateTradeVC(nibName: "T04CreateTradeVC", bundle: NSBundle.mainBundle())
        releaseVC.tabBarItem.title = "发布"
        releaseVC.tabBarItem = UITabBarItem.tabBarItem("发布", image: UIImage(named: "release")!, selectedImage: UIImage(named: "release-p")!);
        var createNav =  NavigationPageVC(rootViewController: releaseVC)
        
        
//        var searchVC = T03SearchHelperVC(nibName: "T03SearchHelperVC", bundle: NSBundle.mainBundle())
        var searchVC = T03SearchVC(nibName: "T03SearchVC", bundle: NSBundle.mainBundle())
        searchVC.tabBarItem.title = "搜索"
        searchVC.tabBarItem = UITabBarItem.tabBarItem("搜索", image: UIImage(named: "search")!, selectedImage: UIImage(named: "search-p")!);
        var searchNav =  NavigationPageVC(rootViewController: searchVC)


        var mineVC = U02UserVC(nibName: "U02UserVC", bundle: NSBundle.mainBundle())
        var mineNav = NavigationPageVC(rootViewController: mineVC)
        mineVC.tabBarItem = UITabBarItem.tabBarItem("我的", image: UIImage(named: "me")!, selectedImage: UIImage(named: "me-p")!)
        
        self.addChildViewController(hotNav)
        self.addChildViewController(createNav)
        self.addChildViewController(searchNav)
        self.addChildViewController(mineNav)
        
    }


}
