//
//  T04CreateTradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T04CreateTradeVC: RootVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  
    }
    
    override func viewWillAppear(animated: Bool) {
      self.navigationController?.navigationBarHidden = false;
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("发布新订单")
    }

    @IBAction func btnAction(sender: UIButton) {
    
        var vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
        self.navigationController?.pushViewController(vc, animated: true);

    }
}
