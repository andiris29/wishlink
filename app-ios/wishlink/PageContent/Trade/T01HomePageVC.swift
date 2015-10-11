//
//  T01HomePageVC.swift
//  wishlink
//
//  Created by whj on 15/9/14.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T01HomePageVC: RootVC,UITextFieldDelegate,T11SearchSuggestionDelegate,WebRequestDelegate {
    
    @IBOutlet weak var searchBgImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var heartView: UIView!
    
    @IBOutlet weak var allWishLabel: UILabel!
    @IBOutlet weak var finishWishLabel: UILabel!
    
    @IBOutlet weak var lbAllCount: UILabel!
    
    @IBOutlet weak var lbComplateCount: UILabel!
    var lastDataArr:[AnyObject]! = []
    var sphereView: ZYQSphereView!
    var isNeedShowLoin = true;
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isNeedShowLoin)
        {
            let vc = U01LoginVC(nibName: "U01LoginVC", bundle: MainBundle);
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        self.searchTextField.delegate = self;
        self.httpObj.mydelegate = self;
        
        self.lbComplateCount.text = "0"
        self.lbAllCount.text = "0"
        getKeyWordData();
        getReportDate();
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated);
        self.navigationController?.navigationBarHidden = true
        
        //self.startTimer();
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
  
//            _ = UIApplication.sharedApplication().keyWindow
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
         
//            sphereView.setItems(views as [AnyObject])
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
    
    //MARK: - 标签点击操作
    
    func buttonAction(sender: UIButton) {
    
        let vc =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        vc.keyword = sender.titleLabel!.text!
        self.navigationController?.pushViewController(vc, animated: true);
        self.removeTimer();
        
        
//        self.dismissViewControllerAnimated(true, completion: nil);
        print("buttonAction:\(sender.tag)")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK:UItextFiledDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.searchTextField.resignFirstResponder();
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let vc =  T11SearchSuggestionVC(nibName: "T11SearchSuggestionVC", bundle: NSBundle.mainBundle())
        vc.myDelegate = self;
        vc.searchType = .any
        self.presentViewController(vc, animated: true, completion: nil);
        return false;
    }

    //MARK: 手动输入的搜索结果
    func GetSelectValue(inputValue:String)
    {
        self.searchTextField.text = inputValue;
        
        let vc =  T02HotListVC(nibName: "T02HotListVC", bundle: NSBundle.mainBundle())
        vc.keyword = inputValue;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    //MARK:WebRequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        SVProgressHUD.dismiss();
        
        if(tag == 10)
        {
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
            let numTrades = (response as! NSDictionary).objectForKey("numTrades") as! Int
            let numCompleteTrades = (response as! NSDictionary).objectForKey("numCompleteTrades") as! Int
            self.lbAllCount.text = String(numTrades);
            self.lbComplateCount.text = String(numCompleteTrades);
        }
    }
    
    func requestDataFailed(error: String) {
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
