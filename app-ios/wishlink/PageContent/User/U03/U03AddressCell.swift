//
//  U03AddressCell.swift
//  wishlink
//
//  Created by Yue Huang on 8/24/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

/*  tag    function
    0       编辑
    1       删除
    2       选中
*/

protocol U03AddressCellDelegate: NSObjectProtocol {
    func addressCell(cell: U03AddressCell, btnClickWithTag tag: NSInteger, indexPath: NSIndexPath)
}

class U03AddressCell: UITableViewCell {

    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var defaultReceiver: Bool = false {
        didSet {
            self.adjustUI()
        }
    }
    
    
    var receiver: ReceiverModel! {
        didSet {
            self.fillDataForUI()
        }
    }
    var indexPath: NSIndexPath!

    weak var delegate: U03AddressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectBtnAction(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.addressCell(self, btnClickWithTag: 2, indexPath: self.indexPath)
        }
    }

    @IBAction func editBtnAction(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.addressCell(self, btnClickWithTag: 0, indexPath: self.indexPath)
        }
    }
    @IBAction func deleteBtnAction(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.addressCell(self, btnClickWithTag: 1, indexPath: self.indexPath)
        }
    }
    
    func adjustUI() {
        self.selectBtn.selected = self.defaultReceiver
        self.editBtn.selected = self.selectBtn.selected
        self.deleteBtn.selected = self.selectBtn.selected
    }
    
    func fillDataForUI() {
        self.nameLabel.text = self.receiver.name
        self.phoneLabel.text = self.receiver.phone
        self.provinceLabel.text = self.receiver.province
        self.addressLabel.text = self.receiver.address
        self.defaultReceiver = self.receiver.isDefault
    }
    
}



