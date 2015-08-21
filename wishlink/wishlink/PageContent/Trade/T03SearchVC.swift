//
//  T03SearchVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/22/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class T03SearchVC: RootVC,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var myTableView: UITableView!
    var cellIdentifier = "T03Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadComNaviLeftBtn();
        self.loadComNavTitle("搜索");
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.myTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 190;
        
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:T03Cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T03Cell
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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
