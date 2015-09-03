//
//  T08ComplaintVC.swift
//  wishlink
//
//  Created by whj on 15/8/25.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T08ComplaintVC: RootVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    override func viewDidAppear(animated: Bool) {
        
        self.loadComNaviLeftBtn();
        self.navigationController?.navigationBarHidden = false;
    }

}
