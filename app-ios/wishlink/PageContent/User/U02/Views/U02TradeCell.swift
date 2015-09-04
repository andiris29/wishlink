//
//  U02TradeCell.swift
//  wishlink
//
//  Created by Yue Huang on 8/18/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum TradeCellType {
    case Buyer, Seller
}

enum TradeCellButtonClickType{
    case Revoke, Confirm, CheckComplain, CheckLogistics,
    EditItemInfo, SendOut,Complain,Chat
}


protocol U02TradeCellDelegate: NSObjectProtocol {
    func tradeCell(cell: U02TradeCell, clickType: TradeCellButtonClickType)
}


class U02TradeCell: UICollectionViewCell {

    let kCornerRadius: CGFloat = 5
    let kBorderWidth: CGFloat = 0.5
    var indexPath: NSIndexPath! {
        didSet {
            self.adjustUI()
        }
    }
    var cellType: TradeCellType! {
        didSet {
            if cellType == .Buyer {
                self.buyerTopView.hidden = false
                self.sellerTopView.hidden = true
            }
            else {
                self.buyerTopView.hidden = true
                self.sellerTopView.hidden = false
            }
        }
    }
    
    weak var delegate: U02TradeCellDelegate?
    
    @IBOutlet weak var buyerTopView: UIView!
    @IBOutlet weak var buyerRoundImageView: UIImageView!
    @IBOutlet weak var buyerStatusLabel: UILabel!
    @IBOutlet weak var buyerRevokeBtn: UIButton!
    @IBOutlet weak var buyerConfirmBtn: UIButton!
    @IBOutlet weak var buyerCheckComplaintBtn: UIButton!
    @IBOutlet weak var buyerCheckLogisticsBtn: UIButton!
    
    @IBOutlet weak var btnComplain: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    
    
    @IBOutlet weak var sellerTopView: UIView!
    @IBOutlet weak var sellerRoundImageView: UIImageView!
    @IBOutlet weak var sellerStatusLabel: UILabel!
    @IBOutlet weak var sellerRevokeBtn: UIButton!
    @IBOutlet weak var sellerEditItemInfoBtn: UIButton!
    @IBOutlet weak var sellerCheckComplaintBtn: UIButton!
    @IBOutlet weak var sellerSendOutBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.redColor().CGColor
        self.prepareBuyerTopView()
        self.prepareSellerTopView()
    }
    
    @IBAction func revokeBtnAction(sender: AnyObject) {
        self.delegate?.tradeCell(self, clickType: .Revoke)

    }
    @IBAction func confirmBtnAction(sender: AnyObject) {
        self.delegate?.tradeCell(self, clickType: .Confirm)

    }
    @IBAction func checkComplainBtnAction(sender: AnyObject) {
        self.delegate?.tradeCell(self, clickType: .CheckComplain)

    }
    @IBAction func checkLogisticsBtnAction(sender: AnyObject) {
        
        self.delegate?.tradeCell(self, clickType: .CheckLogistics)
    }
    @IBAction func editItemInfoBtnAction(sender: AnyObject) {
        self.delegate?.tradeCell(self, clickType: .EditItemInfo)

    }
    @IBAction func sendOutBtnAction(sender: AnyObject) {
        self.delegate?.tradeCell(self, clickType: .SendOut)

    }
    @IBAction func btnChatAction(sender: AnyObject) {
        self.delegate?.tradeCell(self, clickType: .Chat)

    }
    
    @IBAction func btnComplainAction(sender: AnyObject) {
        self.delegate?.tradeCell(self, clickType: .Complain)

    }

    
    
    func adjustUI() {
        if self.cellType == .Buyer {
            self.adjustBuyerTopView()
        } else {
            self.adjustSellerTopView()
        }
        
    }
    
    func adjustBuyerTopView() {
        let row = self.indexPath.row % 5
        self.hideAllBtns()
        if row == 0 {
            // 已接单
            self.buyerStatusLabel.text = "已接单"
            self.isRead(false)
            self.buyerRevokeBtn.hidden = false
            self.btnComplain.hidden = false
        }else if row == 1 {
            // 已发货
            self.buyerStatusLabel.text = "已发货"
            self.isRead(false)
            self.buyerCheckLogisticsBtn.hidden = false
            self.buyerConfirmBtn.hidden = false
            self.btnComplain.hidden = false
        }else if row == 2 {
            // 未接单
            self.buyerStatusLabel.text = "未接单"
            self.buyerRevokeBtn.hidden = false
            self.isRead(true)
            
        }else if row == 3 {
            // 投诉处理中
            self.buyerStatusLabel.text = "投诉处理中"
            self.buyerCheckComplaintBtn.hidden = false
            self.isRead(true)
            
        }else {
            // 已完成
            self.buyerStatusLabel.text = "已完成"
            self.btnComplain.hidden = false
            self.isRead(true)
        }
    }
    
    func adjustSellerTopView() {
        let row = self.indexPath.row % 5
        self.hideAllBtns()
        if row == 0 {
            // 已接单
            self.sellerStatusLabel.text = "已抢单"
            self.isRead(false)
            self.sellerRevokeBtn.hidden = false
            self.sellerSendOutBtn.hidden = false
            self.btnComplain.hidden = false
        }else if row == 1 {
            // 已发货
            self.sellerStatusLabel.text = "买家要求退单"
            self.isRead(false)
            self.sellerRevokeBtn.hidden = false
            self.btnComplain.hidden = false
        }else if row == 2 {
            // 未接单
            self.sellerStatusLabel.text = "已发货"
            self.sellerEditItemInfoBtn.hidden = false
            self.isRead(true)
            
        }else if row == 3 {
            // 投诉处理中
            self.sellerStatusLabel.text = "投诉处理中"
            self.sellerCheckComplaintBtn.hidden = false
            self.isRead(true)
            
        }else {
            // 已完成
            self.sellerStatusLabel.text = "已完成"
            self.btnComplain.hidden = false
            self.isRead(true)
        }
    }
    
    
    func isRead(isRead: Bool) {
        if isRead {
            self.buyerTopView.backgroundColor = UIColor.whiteColor()
            self.buyerRoundImageView.hidden = true
            self.sellerTopView.backgroundColor = UIColor.whiteColor()
            self.sellerRoundImageView.hidden = true
        }
        else {
            self.buyerTopView.backgroundColor = RGB(253, 234, 237)
            self.buyerRoundImageView.hidden = false
            self.sellerTopView.backgroundColor = RGB(253, 234, 237)
            self.sellerRoundImageView.hidden = false
        }
    }
    
    func hideAllBtns() {
        self.buyerRevokeBtn.hidden = true
        self.buyerConfirmBtn.hidden = true
        self.buyerCheckComplaintBtn.hidden = true
        self.buyerCheckLogisticsBtn.hidden = true
        self.sellerRevokeBtn.hidden = true
        self.sellerSendOutBtn.hidden = true
        self.sellerCheckComplaintBtn.hidden = true
        self.sellerEditItemInfoBtn.hidden = true
        self.btnComplain.hidden = true
    }
    
    func prepareBuyerTopView() {
        self.buyerRoundImageView.layer.cornerRadius = CGRectGetWidth(self.buyerRoundImageView.frame) * 0.5
        self.buyerRoundImageView.layer.masksToBounds = true
        
        self.buyerRevokeBtn.layer.cornerRadius = kCornerRadius
        self.buyerRevokeBtn.layer.masksToBounds = true
        self.buyerRevokeBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.buyerRevokeBtn.layer.borderWidth = kBorderWidth;
        
        self.buyerConfirmBtn.layer.cornerRadius = kCornerRadius
        self.buyerConfirmBtn.layer.masksToBounds = true
        self.buyerConfirmBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.buyerConfirmBtn.layer.borderWidth = kBorderWidth;
        
        self.buyerCheckComplaintBtn.layer.cornerRadius = kCornerRadius
        self.buyerCheckComplaintBtn.layer.masksToBounds = true
        self.buyerCheckComplaintBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.buyerCheckComplaintBtn.layer.borderWidth = kBorderWidth;
        
        self.buyerCheckLogisticsBtn.layer.cornerRadius = kCornerRadius
        self.buyerCheckLogisticsBtn.layer.masksToBounds = true
        self.buyerCheckLogisticsBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.buyerCheckLogisticsBtn.layer.borderWidth = kBorderWidth;
        
        self.buyerRevokeBtn.layer.cornerRadius = kCornerRadius
        self.buyerRevokeBtn.layer.masksToBounds = true
        self.buyerRevokeBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.buyerRevokeBtn.layer.borderWidth = kBorderWidth;
    }
    
    func prepareSellerTopView() {
        
        self.sellerRoundImageView.layer.cornerRadius = CGRectGetWidth(self.sellerRoundImageView.frame) * 0.5
        self.sellerRoundImageView.layer.masksToBounds = true
        
        self.sellerRevokeBtn.layer.cornerRadius = kCornerRadius
        self.sellerRevokeBtn.layer.masksToBounds = true
        self.sellerRevokeBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.sellerRevokeBtn.layer.borderWidth = kBorderWidth;
        
        self.sellerEditItemInfoBtn.layer.cornerRadius = kCornerRadius
        self.sellerEditItemInfoBtn.layer.masksToBounds = true
        self.sellerEditItemInfoBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.sellerEditItemInfoBtn.layer.borderWidth = kBorderWidth;
        
        self.sellerCheckComplaintBtn.layer.cornerRadius = kCornerRadius
        self.sellerCheckComplaintBtn.layer.masksToBounds = true
        self.sellerCheckComplaintBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.sellerCheckComplaintBtn.layer.borderWidth = kBorderWidth;
        
        self.sellerSendOutBtn.layer.cornerRadius = kCornerRadius
        self.sellerSendOutBtn.layer.masksToBounds = true
        self.sellerSendOutBtn.layer.borderColor = UIColor(red: 123 / 255.0, green: 2 / 255.0, blue: 90 / 255.0, alpha: 1.0).CGColor
        self.sellerSendOutBtn.layer.borderWidth = kBorderWidth;
    }
}






