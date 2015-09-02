//
//  T11SearchSuggestionVC.swift
//  wishlink
//
//  Created by whj on 15/9/2.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T11SearchSuggestionVC: RootVC, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifierSearch = "T11SearchSuggestionCell"
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTexfield: UITextField!
    @IBOutlet weak var cannelButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    
    var itemContents: NSArray = ["item0", "item1", "item2", "item3", "item4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
        self.searchTableView.registerNib(UINib(nibName: cellIdentifierSearch, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierSearch)
        
        initView()
    }

    func initView() {
        
        self.searchView.layer.masksToBounds = true
        self.searchView.layer.cornerRadius = 5
        
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemContents.count
    }


     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierSearch, forIndexPath: indexPath) as! T11SearchSuggestionCell

        return cell
    }


    // Override to support conditional rearranging of the table view.
     func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

    
    //MARK: - Action
    
    @IBAction func cannelButtonAction(sender: UIButton!) {
        
    }
}
