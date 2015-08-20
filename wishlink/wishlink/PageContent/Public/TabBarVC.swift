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
//        self.tabBar.barTintColor = UIColor.whiteColor()
//        self.tabBar.tintColor = UIColor.redColor()
        self.addAllChildControllers()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAllChildControllers() {
        
        var hotVC =  HomeVC(nibName: "HomeVC", bundle: NSBundle.mainBundle())
        hotVC.view.backgroundColor = UIColor.yellowColor()
        hotVC.tabBarItem = UITabBarItem.tabBarItem("最热", image: UIImage(named: "hot")!, selectedImage: UIImage(named: "hot-p")!);
        var hotNav =  NavigationPageVC(rootViewController: hotVC)
        
        
        var releaseVC = UIViewController();
        releaseVC.view.backgroundColor = UIColor.redColor()
        releaseVC.tabBarItem.title = "发布"
        releaseVC.tabBarItem = UITabBarItem.tabBarItem("发布", image: UIImage(named: "Release")!, selectedImage: UIImage(named: "Release-p")!);
        
        var searchVC = UIViewController()
        searchVC.view.backgroundColor = UIColor.blueColor()
        searchVC.tabBarItem.title = "搜索"
        searchVC.tabBarItem = UITabBarItem.tabBarItem("搜索", image: UIImage(named: "Search")!, selectedImage: UIImage(named: "Search-p")!);

        var mineVC = U02UserVC(nibName: "U02UserVC", bundle: NSBundle.mainBundle())
        var mineNav = NavigationPageVC(rootViewController: mineVC)
        mineVC.tabBarItem = UITabBarItem.tabBarItem("我的", image: UIImage(named: "me")!, selectedImage: UIImage(named: "me-p")!)

        
        
        self.addChildViewController(hotNav)
        self.addChildViewController(releaseVC)
        self.addChildViewController(searchVC)
        self.addChildViewController(mineNav)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
