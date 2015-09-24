//
//  T03SearchVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/22/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class T03SearchVC: RootVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,t03CellDelegate,WebRequestDelegate  {

    @IBOutlet weak var myTableView: UITableView!
    var cellIdentifier = "T03Cell"
    
    @IBOutlet weak var txtSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadComNavTitle("搜索");
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.myTableView.registerNib(UINib(nibName: cellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
        
        self.httpObj.mydelegate = self;
        self.txtSearch.delegate = self;
        var para = ["req.pageNo":1,
        "req.pageSize":10]
//        para = nil
        self.httpObj.httpGetApi("trend/country", parameters: para, tag: 10);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 150;
        
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    var countryArr_name = ["美国","日本","韩国","法国","英国"]
    var categoryArr_name = ["包袋","化妆品","服装","母婴","配饰"]
    var nameArr_name = ["BURBERRY","HERMES","MCM","TODS","VALENTINO"]
    
    var countryArr = ["american","japan","korea","france","english"]
    var categoryArr = ["bag","cosmetics","clothing","baby","ormament"]
    var nameArr = ["bur","her","MCM","tod","VAL"]
    
    var index0=2
    var index1=2
    var index2 = 2;
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:T03Cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! T03Cell
       
        if(indexPath.row == 0)
        {
             cell.lbTitle.text  = "国家和地区"
            cell.dataArr = self.countryArr
            cell.dataArr_Name = self.countryArr_name
            cell.lodaData(indexPath.row,selectindex:index0)
        }
        else if(indexPath.row == 1)
        {
            
            cell.dataArr = self.categoryArr
            cell.dataArr_Name = self.categoryArr_name
            cell.lbTitle.text  = "种类"
        
            cell.lodaData(indexPath.row,selectindex:index1)
        }
        else if(indexPath.row == 2)
        {
            cell.dataArr = self.nameArr
            cell.dataArr_Name = self.nameArr_name
            cell.lbTitle.text  = "热门品牌"
        
            cell.lodaData(indexPath.row,selectindex:index2)
        }
        cell.myDelegate = self;

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        return cell
    }
    
     func btnAction(btnindex:Int,rowIndex:Int)
    {
        if(rowIndex == 0)
        {
            self.index0 = btnindex;
        }
        if(rowIndex == 1)
        {
            self.index1 = btnindex;
        }
        if(rowIndex == 2)
        {
            self.index2 = btnindex;
        }
 
         self.myTableView!.reloadRowsAtIndexPaths([NSIndexPath(forRow: rowIndex, inSection: 0)], withRowAnimation: .Automatic)
    
    
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        var hotVC =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        hotVC.isNeedShowNavi = true;
        self.navigationController?.pushViewController(hotVC, animated: true);
        
        return true;
    }

    //MARK:Request delegate
    func requestDataComplete(response: AnyObject, tag: Int) {
     
        if(tag == 10)
        {
            if let trendDic = response as? NSDictionary
            {
                var trendArr:NSArray! = trendDic.objectForKey("trends") as! NSArray
                if(trendArr != nil && trendArr.count>0)
                {
                    if(self.dataArr.count>0)
                    {
                        self.dataArr.removeAll(keepCapacity: false);
                    }
                    
                    for itemObj in trendArr
                    {
                        var itemdic = itemObj as! NSDictionary;
                        var item =  TrendModel(dict: itemdic);
                        self.dataArr.append(item);
                    }
                    self.myTableView.reloadData();
                }
                
            }
        }
    }
    func requestDataFailed(error: String) {
        
    }

}
