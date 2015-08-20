//
//  U02TradeCell.swift
//  wishlink
//
//  Created by Yue Huang on 8/18/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U02TradeCell: UICollectionViewCell {

    @IBOutlet weak var buyerTopView: UIView!
    @IBOutlet weak var buyerRoundImageView: UIImageView!
    @IBOutlet weak var buyerStatusLabel: UILabel!
    @IBOutlet weak var buyerRevokeBtn: UIButton!
    @IBOutlet weak var buyerConfirmBtn: UIButton!
    @IBOutlet weak var buyerCheckComplaintBtn: UIButton!
    @IBOutlet weak var buyerCheckLogisticsBtn: UIButton!
    
    
    
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
    }

}
