//
//  T05PayVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T05PayVC: RootVC,WebRequestDelegate {
    
    let selectedButtonWXTag: Int = 1000
    let selectedButtonZFBTag: Int = 1001
    
    let increingButtonTag: Int = 2001
    let declineButtonTag: Int = 2000
    
    var goodsNumbers: Int = 0
    var isNewOrder: Bool = true

    var item:ItemModel!
    var trade:TradeModel!
//    var defaultAddress:ReceiverModel!
    
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    @IBOutlet weak var lbReceverName: UILabel!
    @IBOutlet weak var lbReceverMobile: UILabel!
    @IBOutlet weak var lbRecevierAddress: UILabel!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbSpec: UILabel!
    @IBOutlet weak var numbersTextField: UITextField!
   
    @IBOutlet weak var lbTotalFree: UILabel!
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData();
    }
    
    func initImageRollView(images:[UIImage]) {
        
        imageRollView.initWithImages(images)
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
    }
    
    func loadData() {
        
        self.lbName.text = "";
        self.lbCountry.text = "";
        self.lbSpec.text = "";
        self.lbPrice.text = "";
        self.numbersTextField.text = "0";
        if(self.item != nil)
        {
            self.lbName.text = self.item.name;
            self.lbCountry.text = self.item.country;
            self.lbSpec.text = self.item.spec;
            self.lbPrice.text = self.item.price.format(".2");
            
        }
        if(self.trade != nil && self.trade._id != "")
        {
            self.numbersTextField.text = String(self.trade.quantity)
            goodsNumbers = self.trade.quantity
        }
        if(self.item != nil)
        {
            self.lbTotalFree.text = "¥" + (self.item.price * Float(goodsNumbers)).format(".2");
        }
        
        self.httpObj.mydelegate = self;
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        self.httpObj.httpGetApi("user/get", parameters: ["registrationId":APPCONFIG.Uid], tag: 10)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false;
        
        self.increaseButton.enabled = !self.isNewOrder
        self.decreaseButton.enabled = !self.isNewOrder
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle(self.isNewOrder ? "发布" : "我要跟单")
    }
    
    @IBAction func selectedButtonPay(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        if sender.tag == selectedButtonWXTag {
            
        } else if sender.tag == selectedButtonZFBTag {
            
        }
    }
    @IBAction func btnPayTapped(sender: UIButton) {
        
        
        let tag = sender.tag;
        if(tag == 11)//跳转到个人中心
        {
            self.navigationController?.popToRootViewControllerAnimated(true);
           
            if( UIHEPLER.GetAppDelegate().window!.rootViewController as? UITabBarController != nil) {
                let tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
                let vc:U02UserVC! = tababarController.childViewControllers[3] as? U02UserVC
                if(vc != nil)
                {
                    vc.sellerBtnAction(vc.sellerBtn);
                }
                
                tababarController.selectedIndex = 3;
            }

        }
        else
        {
            let vc = U03AddressManagerVC(nibName: "U03AddressManagerVC", bundle: NSBundle.mainBundle())
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    @IBAction func incrlineOrDecreingButtonPay(sender: UIButton) {
        
        if sender.tag == increingButtonTag {
            goodsNumbers++
            
        } else if sender.tag == declineButtonTag {
            goodsNumbers > 1 ? goodsNumbers-- : goodsNumbers
        }
        self.decreaseButton.enabled = goodsNumbers > 1
        
        numbersTextField.text = "\(goodsNumbers)"
        let totalfree = (self.item.price * Float(goodsNumbers)).format(".2")
        self.lbTotalFree.text =  "¥\(totalfree)";
    }
    
    //WebRequesrDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if(tag == 10)
        {
            SVProgressHUD.dismiss();
            print(response, terminator: "");
            if(response["user"] != nil)
            {
                UserModel.shared.userDic = response["user"] as! [String: AnyObject]
            
            }
            
            if( UserModel.shared.isLogin)
            {
                let result = UserModel.shared.receiversArray.filter{itemObj -> Bool in
                    return (itemObj as ReceiverModel).isDefault == true;
                }
                self.lbReceverName.text = "";
                self.lbReceverMobile.text = "";
                self.lbRecevierAddress.text = "";
                if(result.count>0)
                {
                    let defaultAddress = result[0] as ReceiverModel
                    
                    self.lbReceverName.text = defaultAddress.name
                    self.lbReceverMobile.text = defaultAddress.phone;
                    self.lbRecevierAddress.text = defaultAddress.address;
                    
                    if (item == nil ||  item.images == nil) {return}
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        
                        var images: [UIImage] = [UIImage]()
                        for imageUrl in self.item.images {
                            let url: NSURL = NSURL(string: imageUrl)!
                            let image: UIImage = UIImage(data: NSData(contentsOfURL: url)!)!
                            images.append(image)
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.initImageRollView(images)
                        })
                    })

                }
            }
            else
            {
            }
        
        }
    }
    
    func requestDataFailed(error: String) {
        
        SVProgressHUD.showErrorWithStatusWithBlack("获取用户地址失败！");
    }

    //MARK: - Unit
    
    func alipaySetting() {
        
        AlipaySDK.defaultService().payOrder("", fromScheme: "") { (_: [NSObject : AnyObject]!) -> Void in
            
        }
    }
}
