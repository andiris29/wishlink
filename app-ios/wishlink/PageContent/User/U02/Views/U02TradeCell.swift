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
    var indexPath: NSIndexPath!
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
    
    var trade: TradeModel! {
        didSet {
            self.adjustUI()
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
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemCountryLabel: UILabel!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    @IBOutlet weak var itemCountLabel: UILabel!
    
    @IBOutlet weak var itemTotalPrice: UILabel!
    
    @IBOutlet weak var ownerNameLabel: UILabel!
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
        self.itemNameLabel.text = "品名：" + self.trade.item.name
        self.itemCountryLabel.text = "购买地：" + self.trade.item.country
        self.itemPriceLabel.text = "出价：￥" + "\(self.trade.item.price)"
        self.itemCountryLabel.text = "数量：" + "\(self.trade.quantity)"
        let totalPrice: Float = Float(self.trade.quantity) * self.trade.item.price
        self.itemTotalPrice.text = "合计：" + "\(totalPrice)"
        if self.trade.owner != nil {
            self.ownerNameLabel.text = self.trade.owner!["nickname"] as? String
        }
    }
    
    func adjustBuyerTopView() {
        self.btnChat.setImage(UIImage(named: "u02-contactsell"), forState: .Normal)
        self.btnChat.setImage(UIImage(named: "u02-contactsell-new"), forState: .Selected)

        self.hideAllBtns()
        self.isRead(true)
        self.btnComplain.hidden = false
        switch trade.status {
        case 1:
            if trade.statusOrder == .b0 {
                self.buyerStatusLabel.text = "未接单"
                self.buyerRevokeBtn.hidden = false
                self.btnComplain.hidden = true

            }
        case 2:
            if trade.statusOrder == .b0 {
                self.buyerStatusLabel.text = "未接单"
                self.buyerRevokeBtn.hidden = false
                self.btnComplain.hidden = true
            }
        case 3:
            if trade.statusOrder == .c0 {
                self.buyerStatusLabel.text = "已被接单"
                self.buyerRevokeBtn.hidden = false
            }
        case 4:
            if trade.statusOrder == .c0 {
                self.buyerStatusLabel.text = "已发货"
                self.buyerCheckLogisticsBtn.hidden = false
                self.buyerConfirmBtn.hidden = false
            }
        case 5:
            if trade.statusOrder == .d0 {
                self.buyerStatusLabel.text = "已完成"
                self.btnComplain.hidden = true
            }
        case 6:
            if trade.statusOrder == .d0 {
                self.buyerStatusLabel.text = "已完成"
                self.btnComplain.hidden = true

            }
        case 7:
            if trade.statusOrder == .c0 {
                self.buyerStatusLabel.text = "请求撤单中"
                
            }
        case 8:
            if trade.statusOrder == .d0 {
                self.buyerStatusLabel.text = "已撤单"
                self.btnComplain.hidden = true
            }
        case 9:
            if trade.statusOrder == .d0 {
                self.buyerStatusLabel.text = "自动撤单"
                self.btnComplain.hidden = true

            }
        case 10:
            if trade.statusOrder == .d0 {
                self.buyerStatusLabel.text = "投诉处理中"
                self.buyerCheckComplaintBtn.hidden = false
                self.btnComplain.hidden = true
                
            }
        case 11:
            if trade.statusOrder == .d0 {
                self.buyerStatusLabel.text = "已完成"
                self.buyerCheckComplaintBtn.hidden = false
                self.btnComplain.hidden = true
                
            }
        case 12:
            if trade.statusOrder == .b0 {
                self.buyerStatusLabel.text = "未接单"
                self.buyerRevokeBtn.hidden = false
                
            }
        default:
            break
        }
        
    }

    func adjustSellerTopView() {
        self.btnChat.setImage(UIImage(named: "u02-contactbuy"), forState: .Normal)
        self.btnChat.setImage(UIImage(named: "u02-contactbuy-new"), forState: .Selected)
        self.hideAllBtns()
        self.isRead(true)
        switch trade.status {
        case 3:
            if trade.statusOrder == .c0 {
                self.sellerStatusLabel.text = "已抢单"
                self.sellerSendOutBtn.hidden = false
                self.sellerRevokeBtn.hidden = false
                self.btnComplain.hidden = false
            }
        case 4:
            if trade.statusOrder == .c0 {
                self.sellerStatusLabel.text = "已发货"
                self.sellerEditItemInfoBtn.hidden = false
                self.btnComplain.hidden = false
            }
        case 5:
            if trade.statusOrder == .d0 {
                self.sellerStatusLabel.text = "已完成"
            }
        case 6:
            if trade.statusOrder == .d0 {
                self.sellerStatusLabel.text = "已完成"
            }
        case 7:
            if trade.statusOrder == .c0 {
                self.sellerStatusLabel.text = "买家要求撤单"
                self.sellerRevokeBtn.hidden = false
                self.btnComplain.hidden = false
            }
        case 10:
            if trade.statusOrder == .d0 {
                self.sellerStatusLabel.text = "投诉处理中"
                self.sellerCheckComplaintBtn.hidden = false
            }
        case 11:
            if trade.statusOrder == .d0 {
                self.sellerStatusLabel.text = "已完成"
                self.sellerCheckComplaintBtn.hidden = false
            }
        default:
            break
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
            self.buyerTopView.backgroundColor = RGB(253, g: 234, b: 237)
            self.buyerRoundImageView.hidden = false
            self.sellerTopView.backgroundColor = RGB(253, g: 234, b: 237)
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






