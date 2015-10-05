//
//  U03AddressManagerVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/24/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U03AddressManagerVC: RootVC, UITableViewDelegate, UITableViewDataSource,
U03AddressCellDelegate, WebRequestDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var selectedReciver: ReceiverModel!
    
    var addressArray = [ReceiverModel]() {
        didSet {
            if self.addressArray.count > 0 {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.httpObj.mydelegate = self
        self.tableView.registerNib(UINib(nibName: "U03AddressCell", bundle: MainBundle), forCellReuseIdentifier: "U03AddressCell")
        self.prepareUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let array = UserModel.shared.receiversArray {
            self.addressArray = array
        }
        self.tableView.reloadData()
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
        if receiver.isDefault == true {
            self.selectedReciver = receiver
        }
        return cell
    }
    
    func addressCell(cell: U03AddressCell, btnClickWithTag tag: NSInteger, indexPath: NSIndexPath) {
        if tag == 0 {
            var vc = U03AddAddressVC(nibName: "U03AddAddressVC", bundle: NSBundle.mainBundle())
            vc.operationType = .Edit
            vc.receiver = self.addressArray[indexPath.row]
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else if tag == 1{
            // 删除收货地址
            var receiver = self.addressArray[indexPath.row]
            self.removeReceiver(receiver.uuid)
        }else if tag == 2{
            // 选中
            var receiver = self.addressArray[indexPath.row]
            if receiver == self.selectedReciver {
                return
            }
            self.setDefaultReceiver(receiver)
        }else {
            
        }
    }
    
    func requestDataFailed(error: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
        })
    }
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
        })
        if tag == 10 {
            if let userDic = response["user"] as? [String: AnyObject] {
                UserModel.shared.userDic = userDic
                self.addressArray = UserModel.shared.receiversArray
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }else if tag == 20 {
            if let userDic = response["user"] as? [String: AnyObject] {
                UserModel.shared.userDic = userDic
                self.addressArray = UserModel.shared.receiversArray
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }else {
            
        }
        
    }
    
    // MARK: - response event
    
    func addAddressBtnAction(sender: AnyObject) {
        var vc = U03AddAddressVC(nibName: "U03AddAddressVC", bundle: NSBundle.mainBundle())
        vc.operationType = .Add
        vc.callBackClosure = {
            [unowned self]
            (type: AddAddressVCOperationType, receiver: ReceiverModel)
            in
            self.addressArray.append(receiver)
            self.tableView.reloadData()
        }
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // MARK: - prive method
    
    func setDefaultReceiver(receiver: ReceiverModel) {
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        receiver.isDefault = true
        var dic = receiver.keyValuesWithType(.Update)
        self.httpObj.httpPostApi("user/saveReceiver", parameters: dic, tag: 20)
    }
    
    func removeReceiver(uuid: String) {
        if uuid.length == 0 {
            return
        }
        var dic = [
            "uuid": uuid
        ]
        SVProgressHUD.showInfoWithStatus("请稍等...")
        self.httpObj.httpPostApi("user/removeReceiver", parameters: dic, tag: 10)
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
