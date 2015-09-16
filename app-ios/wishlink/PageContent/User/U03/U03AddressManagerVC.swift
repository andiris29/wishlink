//
//  U03AddressManagerVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/24/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U03AddressManagerVC: RootVC, UITableViewDelegate, UITableViewDataSource,
U03AddressCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var addressArray = [ReceiverModel]()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.loadAddressList()
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
    
    // MARK: --delegate--
    
    // MARK: tableView delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: tableView dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("U03AddressCell", forIndexPath: indexPath) as! U03AddressCell
        cell.selectionStyle = .None
        cell.indexPath = indexPath
        cell.delegate = self
        var receiver = self.addressArray[indexPath.row]
        cell.receiver = receiver
        return cell
    }
    
    func addressCell(cell: U03AddressCell, btnClickWithTag tag: NSInteger, indexPath: NSIndexPath) {
        if tag == 0 {
            var vc = U03AddAddressVC(nibName: "U03AddAddressVC", bundle: NSBundle.mainBundle())
            vc.operationType = .Edit
            vc.receiver = self.addressArray[indexPath.row]
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else {
            // 删除收货地址
            self.addressArray.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - response event
    
    func addAddressBtnAction(sender: AnyObject) {
        var vc = U03AddAddressVC(nibName: "U03AddAddressVC", bundle: NSBundle.mainBundle())
        vc.operationType = .Add
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // MARK: - prive method
    
    func loadAddressList() {
        for i in 0 ... 5 {
            var dic = [
                "name" : "kelly",
                "phone" : "18815287600",
                "province" : "上海",
                "address" : "国和路555弄",
                "isDefault" : 0
            ]
            var reciver: ReceiverModel = ReceiverModel(dic: dic)
            self.addressArray.append(reciver)
        }
        self.tableView.reloadData()
    }
    
    func prepareUI() {
        self.prepareNav()
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "U03AddressCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "U03AddressCell")
    }
    
    func prepareNav() {
        self.loadComNavTitle("收货地址管理")
        self.loadComNaviLeftBtn()
        var rightBtn = UIButton.buttonWithType(.Custom) as! UIButton
        rightBtn.frame = CGRectMake(0, 0, 60, 44)
        rightBtn.setTitleColor(UIColor.redColor(), forState: .Normal)
        rightBtn.setTitle("新增地址", forState: .Normal)
        rightBtn.titleLabel!.font = UIFont.systemFontOfSize(13)
        rightBtn.contentHorizontalAlignment = .Right
        rightBtn.addTarget(self, action: "addAddressBtnAction:", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
    }
    
    // MARK: - setter and getter
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
