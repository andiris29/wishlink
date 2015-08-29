//
//  T03SearchVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/22/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class T03SearchVC: RootVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate  {

    @IBOutlet weak var myTableView: UITableView!
    var cellIdentifier = "T03Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadComNavTitle("搜索");
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.myTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 190;
        
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:T03Cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T03Cell
        cell.awakeFromNib();
        if(indexPath.row == 1)
        {
            cell.lbTitle.text  = "种类"
        }
        else if(indexPath.row == 2)
        {
            cell.lbTitle.text  = "热门品牌"
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        
        return cell
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        var hotVC =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        hotVC.isNeedShowNavi = true;
        hotVC.isNeedShowLoin = false;
        self.navigationController?.pushViewController(hotVC, animated: true);
        
        return true;
    }


}
