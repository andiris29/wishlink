//
//  T11SearchSuggestionVC.swift
//  wishlink
//
//  Created by whj on 15/9/2.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit
enum SearchModel {
    
    case any,country,brand,name
}


@objc protocol T11SearchSuggestionDelegate
{
    func GetSelectValue(inputValue:String)
}

class T11SearchSuggestionVC: RootVC, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UITextFieldDelegate,WebRequestDelegate {
    
    let cellIdentifierSearch = "T11SearchSuggestionCell"
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTexfield: UITextField!
    @IBOutlet weak var cannelButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    weak var myDelegate:T11SearchSuggestionDelegate!;
    var searchType:SearchModel = .any
    var searchContext:String = ""
    
    var itemContents: NSArray = NSArray()
    //MARK:Life Cycle
    deinit{
        
        NSLog("T11SearchSuggestionVC -->deinit")
        
        self.myDelegate = nil;
        self.dataArr = nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.httpObj.mydelegate = self;
        
        //        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        self.httpObj.httpGetApi("user/get", parameters: ["req.registrationId":APPCONFIG.Uid], tag: 110)
        
        self.searchTableView.registerNib(UINib(nibName: cellIdentifierSearch, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierSearch)
        self.searchTexfield.delegate = self;
        
        
        initView()
    }
    
    func initView() {
        
        self.searchView.layer.masksToBounds = true
        self.searchView.layer.cornerRadius = 5
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBarHidden = true
        self.searchTexfield.text = searchContext
        self.searchTexfield.becomeFirstResponder()
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
        cell.labelName.text = itemContents[indexPath.row] as? String
        cell.selected = false;
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        let isLast: Bool = indexPath.row == itemContents.count - 1
        cell.labelName.textAlignment = isLast ? NSTextAlignment.Center :NSTextAlignment.Left
        cell.lineImageView.hidden = isLast
        
        return cell
        
    }
    
    
    // Override to support conditional rearranging of the table view.
    //     func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return NO if you do not want the item to be re-orderable.
    //        return true
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 { return }
        if indexPath.row == itemContents.count - 1 {
            
            self.httpObj.httpPostApi("user/clearSearchHistory", parameters: ["req.registrationId":APPCONFIG.Uid], tag: 112)
        } else {
            self.searchTexfield.text = itemContents[indexPath.row] as? String
        }
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: - Action
    
    @IBAction func cannelButtonAction(sender: UIButton!) {
        self.navigationController?.popViewControllerAnimated(true);
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    var lastKeyWord = "";
    @IBAction func searchTexfieldValueChange(sender: UITextField) {
        
        
        if (sender.text == nil || sender.text!.length <= 0) {return}
        
        let para = ["keyword":sender.text!.trim()]
        var apiName = "suggestion/any"
        if(self.searchType == .country)
        {
            apiName = "suggestion/country"
        }
        else if(self.searchType == .country)
        {
            apiName = "suggestion/brand"
        }
        else if(self.searchType == .name)
        {
            apiName = "suggestion/name"
        }
        self.httpObj.httpGetApi(apiName, parameters: para, tag: 111);
    }
    
    //MARK: UITextFiledDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.searchTexfield.resignFirstResponder();
        
        if(self.myDelegate != nil)
        {
            self.myDelegate!.GetSelectValue(textField.text!);
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        return false;
    }
    
    //MAEK: webrequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        SVProgressHUD.dismiss();
        if( tag == 110)
        {
            let respDic  = response as! NSDictionary;
            if(respDic.objectForKey("user") != nil)
            {
                
                UserModel.shared.userDic = respDic["user"] as! [String: AnyObject]
                if(UserModel.shared.searchHistory != nil && UserModel.shared.searchHistory.count>0)
                {
                    let dataArray: NSMutableArray = NSMutableArray()
                    dataArray.addObject("历史搜索")
                    
                    for item in UserModel.shared.searchHistory {
                        
                        dataArray.addObject(item.keyword);
                    }
                    dataArray.addObject("清空历史搜索")
                    itemContents = dataArray
                    self.searchTableView.reloadData()
                }
            }
        }
        else if(tag  == 111)
        {
            let dic = response as! NSDictionary;
            if (dic.objectForKey("suggestions") != nil)
            {
                let resultArr = dic.objectForKey("suggestions") as! NSArray;
                if(self.searchTexfield.text!.trim().length > 0  && resultArr.count > 0)
                {
                    
                    let dataArray: NSMutableArray = NSMutableArray()
                    dataArray.addObject("历史搜索")
                    
                    for item in resultArr {
                        
                        dataArray.addObject(item as! String)
                    }
                    dataArray.addObject("清空历史搜索")
                    itemContents = dataArray
                    self.searchTableView.reloadData()
                }
            }
            else
            {
                itemContents = [];
                self.searchTableView.reloadData()
            }
            
        } else if (tag == 112) {
            
            itemContents = [];
            self.searchTableView.reloadData()
        }
    }
    func requestDataFailed(error: String,tag:Int) {
        
        print("T11RequestDataFailed: \(error)")
    }
}
