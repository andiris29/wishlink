//
//  U02UserVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U02UserVC: RootVC, WebRequestDelegate {

    @IBOutlet weak var sellerBtn: UIButton!
    
    @IBOutlet weak var buyerBtn: UIButton!
    
    @IBOutlet weak var recommendBtn: UIButton!
    
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var subVCView: UIView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contryLabel: UILabel!
    
    
    var selectedBtn: UIButton!
    
    var buyerTradeVC: U02BuyerTradeVC!
    var sellerTradeVC: U02SellerTradeVC!
    var recommendVC: U02RecommendVC!
    var favoriteVC: U02FavoriteVC!
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareData()
        self.prepareSubVC()
        self.selectedBtn = self.sellerBtn
        self.sellerBtnAction(self.sellerBtn)
        self.fillDataForUI()
        self.getUser()
        self.navigationController!.navigationBar.hidden = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = true;
//        self.navigationController?.navigationBar.frame = CGRectMake(0, -100.0, ScreenWidth, 44)
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buyerTradeVC.view.frame = self.subVCView.frame
        self.sellerTradeVC.view.frame = self.subVCView.frame
        self.recommendVC.view.frame = self.subVCView.frame
        self.favoriteVC.view.frame = self.subVCView.frame
        self.headImageView.layer.cornerRadius = self.headImageView.w * 0.5
        self.headImageView.layer.masksToBounds = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - delegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        
    }
    
    func requestDataFailed(error: String) {
        
    }
    
    // MARK: - response event
    
    @IBAction func sellerBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.buyerTradeVC.resetConditionView()
        self.view.bringSubviewToFront(self.sellerTradeVC.view)
    }
    
    @IBAction func buyerBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.sellerTradeVC.resetConditionView()
        self.view.bringSubviewToFront(self.buyerTradeVC.view)
    }
    
    @IBAction func recommendBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.sellerTradeVC.resetConditionView()
        self.buyerTradeVC.resetConditionView()
        self.view.bringSubviewToFront(self.recommendVC.view)
    }
    
    @IBAction func collectionBtnAction(sender: AnyObject) {
        self.selectedBtn.selected = false;
        self.selectedBtn = sender as! UIButton
        self.selectedBtn.selected = true;
        self.sellerTradeVC.resetConditionView()
        self.buyerTradeVC.resetConditionView()
        self.view.bringSubviewToFront(self.favoriteVC.view)
    }
    
    @IBAction func settingBtnAction(sender: AnyObject) {
        let vc = U03SettingVC(nibName: "U03SettingVC", bundle: NSBundle.mainBundle())
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // MARK: - prive method
    
    func getUser() {
//        var parameters = ["nickname": "Yeo", ""]
//        self.httpObj.httpGetApi("user/update", parameters: <#[String : AnyObject]?#>, tag: <#Int#>)
    }
    
    func prepareData() {
        self.httpObj.mydelegate = self
    }
    
    // 根据用户数据填充界面
    func fillDataForUI() {
        if UserModel.shared.isLogin == true {
            self.nicknameLabel.text = UserModel.shared.nickname;
            
            self.httpObj.renderImageView(self.headImageView, url: UserModel.shared.portrait, defaultName: "")
            self.contryLabel.text = "上海杨浦区国和路555弄"
        }
    }
    
    func prepareSubVC() {
        self.buyerTradeVC = U02BuyerTradeVC(nibName: "U02BuyerTradeVC", bundle: NSBundle.mainBundle())
        self.buyerTradeVC.userVC = self
        self.view.addSubview(self.buyerTradeVC.view)
        
        self.sellerTradeVC = U02SellerTradeVC(nibName: "U02SellerTradeVC", bundle: NSBundle.mainBundle())
        self.sellerTradeVC.userVC = self
        self.view.addSubview(self.sellerTradeVC.view)
        
        self.recommendVC = U02RecommendVC(nibName: "U02RecommendVC", bundle: NSBundle.mainBundle())
        self.recommendVC.userVC = self
        self.view.addSubview(self.recommendVC.view)
        
        self.favoriteVC = U02FavoriteVC(nibName: "U02FavoriteVC", bundle: NSBundle.mainBundle())
        self.favoriteVC.userVC = self
        self.view.addSubview(self.favoriteVC.view)
        
    }
    // MARK: - setter and getter

}









