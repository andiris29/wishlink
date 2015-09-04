//
//  TabBarItem.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import Foundation
import UIKit
extension UITabBarItem {
    
    class func tabBarItem(title: String, image: UIImage, selectedImage:UIImage) -> UITabBarItem{
        var tabBarItem = UITabBarItem(title: title, image: image.imageWithRenderingMode(.AlwaysOriginal), selectedImage: selectedImage.imageWithRenderingMode(.AlwaysOriginal))
        NSFontAttributeName
        let selectedDic = [
            NSFontAttributeName : UIHEPLER.getCustomFont(true, fontSsize: 12),
            NSForegroundColorAttributeName : UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0),
            
        ]
        tabBarItem.setTitleTextAttributes(selectedDic, forState: .Selected)
        tabBarItem.setTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -3))
        return tabBarItem;
    }
}
 