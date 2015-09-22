//
//  T01HomePageVC.swift
//  wishlink
//
//  Created by whj on 15/9/14.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T01HomePageVC: RootVC {
    
    @IBOutlet weak var searchBgImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var heartView: UIView!
    
    @IBOutlet weak var allWishLabel: UILabel!
    @IBOutlet weak var finishWishLabel: UILabel!
    
    var sphereView: ZYQSphereView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true

        initWithView()
    }
    
    func initWithView() {
        
        var colorArray = [RGBA(234, 234, 234, 1.0), RGBA(254, 216, 222, 1.0),RGBA(229, 204, 222, 1.0)]
        var titles = ["英国", "美国", "法国", "日本", "德国", "澳洲", "Dior", "SKII", "科颜氏", "MK Selma 中号耳朵包", "ALBION 健康水 330ml", "Jurlique 玫瑰护手霜 30ML", " Lancome 真爱香水 50ml", " 娇韵诗活肤舒缓爽肤露 30ML", "Arcteryx 始祖鸟女士羽绒服", "雅诗兰黛修护精华 15ml", " 象印焖烧杯 200ML"]
        
        var window = UIApplication.sharedApplication().keyWindow
        var windowWidth = window?.bounds.size.width
        
        sphereView = ZYQSphereView()
        sphereView.frame = CGRectMake(0, 0, 300, 300)
        sphereView.frame.origin.x = (windowWidth! - sphereView.frame.size.width) / 2.0
        heartView.addSubview(sphereView)
        
        var views: NSMutableArray = NSMutableArray()
        
        for var index = 0; index < titles.count; index++ {
            
            var count: Int = Int(arc4random() % UInt32(colorArray.count))
            var button: UIButton = UIButton(frame: CGRectMake(0, 0, 90, 90))
            button.layer.masksToBounds = true;
            button.layer.cornerRadius = button.frame.size.width / 2.0;
            button.setTitle("\(titles[index])", forState: UIControlState.Normal)
            button.setTitleColor(RGB(124, 0, 90), forState: UIControlState.Normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            button.titleLabel?.font = UIFont(name: "FZLanTingHeiS-EL-GB", size: 13)
            button.backgroundColor = colorArray[count]
            button.titleLabel?.numberOfLines = 3
            button.titleLabel?.textAlignment = NSTextAlignment.Center
            button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
            views.addObject(button)
        }
        
        sphereView.setItems(views as [AnyObject])
        sphereView.isPanTimerStart = true;
        sphereView.timerStart()

    }
    
    //MARK: - Action
    
    func buttonAction(sender: UIButton) {
    
        
        self.dismissViewControllerAnimated(true, completion: nil);
        println("buttonAction:\(sender.tag)")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
