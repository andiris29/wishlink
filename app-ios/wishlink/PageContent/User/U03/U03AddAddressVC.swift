//
//  U03AddAddressVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/24/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum AddAddressVCOperationType {
    case Add, Edit
}

class U03AddAddressVC: RootVC {
    
    var operationType: AddAddressVCOperationType = .Add
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareNav()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - delegate
    // MARK: - response event
    func saveBtnAction(sender: AnyObject) {
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // MARK: - prive method
    
    func prepareNav() {
        if self.operationType == .Add {
            self.loadComNavTitle("新增地址")
        }
        else {
            self.loadComNavTitle("编辑地址")

        }
        self.loadComNaviLeftBtn()
        var rightBtn = UIButton.buttonWithType(.Custom) as! UIButton
        rightBtn.frame = CGRectMake(0, 0, 60, 44)
        rightBtn.setTitleColor(UIColor.redColor(), forState: .Normal)
        rightBtn.setTitle("保存", forState: .Normal)
        rightBtn.titleLabel!.font = UIFont.systemFontOfSize(13)
        rightBtn.contentHorizontalAlignment = .Right
        rightBtn.addTarget(self, action: "saveBtnAction:", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
    }
    
    // MARK: - setter and getter

}
