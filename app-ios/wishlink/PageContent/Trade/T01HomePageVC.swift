//
//  T01HomePageVC.swift
//  wishlink
//
//  Created by whj on 15/9/14.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T01HomePageVC: RootVC,UITextFieldDelegate,T11SearchSuggestionDelegate,WebRequestDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifierSearch = "T01SearchCell"
    
    @IBOutlet weak var searchBgImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var heartView: UIView!
    
    @IBOutlet weak var allWishLabel: UILabel!
    @IBOutlet weak var finishWishLabel: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var lbAllCount: UILabel!
    @IBOutlet weak var lbComplateCount: UILabel!
    
    var lastDataArr:[AnyObject]! = []
    var sphereView: ZYQSphereView!
    var isNeedShowLoin = true;
    var itemContents: NSArray = NSArray()
//    var t02VC:T02HotListVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTableView.registerNib(UINib(nibName: cellIdentifierSearch, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifierSearch)
        
        self.searchTextField.delegate = self;
        self.httpObj.mydelegate = self;
        
        self.lbComplateCount.text = "0"
        self.lbAllCount.text = "0"
        getKeyWordData();
        getReportDate();
        
        self.searchBgImageView.layer.borderWidth = 1.0
        self.searchBgImageView.layer.borderColor = RGBC(67).CGColor
        self.searchBgImageView.layer.masksToBounds = true
        self.searchBgImageView.layer.cornerRadius = self.searchBgImageView.frame.size.height / 2.0

        
        
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        httpObj.httpGetApi("user/get", parameters: nil, tag: 101)
        
//        if UserModel.shared.isLogin == false
//        {
//            UIHEPLER.showLoginPage(self);
//        }

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated);
//        if(self.t02VC != nil)
//        {
//            self.t02VC = nil;
//        }

        self.navigationController?.navigationBarHidden = true
    }
 
    override func viewDidAppear(animated: Bool) {
         super.viewDidAppear(animated);
        self.navigationController?.navigationBarHidden = true
    }
    func getKeyWordData()
    {
        self.httpObj.httpGetApi("trend/keywords", parameters: nil, tag: 10)
        
    }
    func getReportDate()
    {
        self.httpObj.httpGetApi("report/numTrades", parameters: nil, tag: 11)
        
    }
    func initWithView() {
        
        if(self.dataArr.count>0)
        {
        
            var colorArray = [RGBA(234, g: 234, b: 234, a: 1.0), RGBA(254, g: 216, b: 222, a: 1.0),RGBA(229, g: 204, b: 222, a: 1.0)]
  
            let windowWidth = ScreenWidth
            var isfirstTime = false;
            if( self.sphereView == nil)
            {
                isfirstTime = true;
                sphereView = ZYQSphereView()
                sphereView.frame = CGRectMake(0, 0, 300, 300)
                sphereView.frame.origin.x = (windowWidth - sphereView.frame.size.width) / 2.0
                heartView.addSubview(sphereView)
            }
            
            // clear
            for btView in sphereView.subviews {
                btView.removeFromSuperview()
            }
            
            let views: NSMutableArray = NSMutableArray()
            
            for var index = 0; index < self.dataArr.count; index++ {
                
                let count: Int = Int(arc4random() % UInt32(colorArray.count))
                let button: UIButton = UIButton(frame: CGRectMake(0, 0, 90, 90))
                button.layer.masksToBounds = true;
                button.layer.cornerRadius = button.frame.size.width / 2.0;
                button.setTitle("\(self.dataArr[index])", forState: UIControlState.Normal)
                button.setTitleColor(RGB(124, g: 0, b: 90), forState: UIControlState.Normal)
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                button.titleLabel?.font = UIFont(name: "FZLanTingHeiS-EL-GB", size: 13)
                button.backgroundColor = colorArray[count]
                button.titleLabel?.numberOfLines = 3
                button.titleLabel?.textAlignment = NSTextAlignment.Center
                button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                views.addObject(button)
            }
         
            if(isfirstTime)
            {
                
                sphereView.setItems(views as [AnyObject])
                sphereView.isPanTimerStart = true;
                sphereView.timerStart()
            }
            else
            {
                
                
                sphereView.appentItems(views as [AnyObject])
            }
        }

    }
    
    // MARK: - Touched
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.searchTableView.hidden = true
        self.searchTextField.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemContents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierSearch, forIndexPath: indexPath) as! T01SearchCell
        cell.labelName.text = itemContents[indexPath.row] as? String
        cell.selected = false;
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        cell.cellDataFrom("", lastCell: itemContents.count == indexPath.row + 1)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.row == 0 { return }
        
        self.searchTableView.hidden = true
        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = itemContents[indexPath.row] as? String
    }
    
    //MARK: - 标签点击操作
    
    func buttonAction(sender: UIButton) {
    
        
        self.gotoNextPage(sender.titleLabel!.text!);
        
        print("buttonAction:\(sender.tag)")
    }
    
    @IBAction func searchButtonAction(sender: UIButton) {
        
        self.gotoNextPage(self.searchTextField.text!);
    }
    
    @IBAction func textFieldEndAndExit(sender: UITextField) {
        
//        self.gotoNextPage(sender.text!);
    }
    
    func gotoNextPage(strKeyWord:String)
    {
        var vc:T02HotListVC! =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        vc.keyword = strKeyWord;
        vc.pagemodel  = .search;
        self.navigationController?.pushViewController(vc, animated: true);
        vc = nil;

        self.removeTimer();
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - UItextFiledDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.searchTextField.resignFirstResponder();
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        self.httpObj.httpGetApi("user/get", parameters: ["registrationId":APPCONFIG.Uid], tag: 12)
        

        return true
    }
    

    @IBAction func searchTexfieldValueChange(sender: AnyObject) {
        
        if (sender.text == nil || sender.text!.length <= 0) {return}
        
        let para = ["keyword" : sender.text!]
        self.httpObj.httpGetApi("suggestion/any", parameters: para, tag: 13)
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        self.searchTableView.hidden = true
        
        return true
    }

    //MARK: 手动输入的搜索结果
    func GetSelectValue(inputValue:String)
    {
        self.searchTextField.text = inputValue;
        
        self.gotoNextPage(inputValue);
    }
    //MARK:WebRequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if(tag == 101 || tag == 102)
        {
            if let userDic = response["user"] as? NSDictionary
            {
                if(userDic.count>0)
                {
                    
                    SVProgressHUD.dismiss();
                    UserModel.shared.userDic = userDic as! [String: AnyObject]
                }
                else
                {
                    httpObj.httpPostApi("user/loginAsGuest",  tag: 102)
                    
                }
            }
            else
            {
                
                SVProgressHUD.dismiss();
            }
        }
        else if(tag == 10)
        {
            SVProgressHUD.dismiss();
            
            let trendsArr = (response as! NSDictionary).objectForKey("trends") as! NSArray
            if(trendsArr.count>0)
            {
                if(self.dataArr.count>0)
                {
                    self.dataArr.removeAll(keepCapacity: false);
                    
                }
                self.dataArr = [];
                for itemObj in trendsArr
                {
                    let item = TrendModel(dict: (itemObj as! NSDictionary));
                    if(item.name != nil && item.name != "")
                    {
                        self.dataArr.append(item.name);
                    }
                }
                self.initWithView();
            }
        }
        else  if(tag == 11)
        {
            SVProgressHUD.dismiss();
            
            let numTrades = (response as! NSDictionary).objectForKey("numTrades") as! Int
            let numCompleteTrades = (response as! NSDictionary).objectForKey("numCompleteTrades") as! Int
            self.lbAllCount.text = String(numTrades);
            self.lbComplateCount.text = String(numCompleteTrades);
            
        }
        else if( tag == 12)
        {
            SVProgressHUD.dismiss();
            
//            UserModel.shared.userDic = response["user"] as! [String: AnyObject]
//            if(UserModel.shared.searchHistory != nil && UserModel.shared.searchHistory.count>0)
//            {
//                let dataArray: NSMutableArray = NSMutableArray()
//                dataArray.addObject("历史搜索")
//                
//                for item in UserModel.shared.searchHistory {
//                    
//                    dataArray.addObject(item.keyword);
//                }
//                
//                itemContents = dataArray
//                self.searchTableView.reloadData()
//            }
//            self.searchTableView.hidden = false
        }
        else if(tag  == 13)
        {
            SVProgressHUD.dismiss();
            
            let dic = response as! NSDictionary;
            if (dic.objectForKey("suggestions") != nil)
            {
                
                itemContents = [];
                let resultArr = dic.objectForKey("suggestions") as! NSArray;
                if(self.searchTextField.text!.trim().length > 0  && resultArr.count > 0)
                {
                    
                    let dataArray: NSMutableArray = NSMutableArray()
                    dataArray.addObject("历史搜索")
                    
                    for item in resultArr {
                        dataArray.addObject(item as! String)
                    }
                    itemContents = dataArray
                }
                self.searchTableView.reloadData()
            }
            else
            {
                itemContents = [];
                self.searchTableView.reloadData()
            }
            self.searchTableView.hidden = false
        }

    }
    
    func requestDataFailed(error: String,tag:Int) {
        
        if(tag == 101)
        {
            httpObj.httpPostApi("user/loginAsGuest",  tag: 102)
        }
        
//        if(error == "ErrorCode:1001 ERR_NOT_LOGGED_IN")
//        {
//            
//            SVProgressHUD.showWithStatusWithBlack("请稍等...")
//        }
        NSLog("Error in page T01 :%@", error)
    }
    
    //MARK: 定时器相关
    var orderTimer:NSTimer!
    var record = 0;
    func startTimer()
    {
        orderTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:Selector("checkUpdate"), userInfo: nil, repeats: true)
        orderTimer.fire()
        record = 0;
    }
    
    func checkUpdate()
    {
        if(record % 2 == 0)
        {
            getReportDate();
            NSLog("select report Data")
        }
        if(record == 6)
        {
            
            NSLog("select keyword Data")
            record = 1;
            getKeyWordData();
        }
        record += 1;
    }
    
    
    func removeTimer()
    {
        if(orderTimer != nil)
        {
            self.orderTimer.invalidate();
            self.orderTimer = nil;
        }
    }
}
