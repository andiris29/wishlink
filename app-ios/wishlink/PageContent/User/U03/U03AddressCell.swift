//
//  U03AddressCell.swift
//  wishlink
//
//  Created by Yue Huang on 8/24/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

protocol U03AddressCellDelegate: NSObjectProtocol {
    func addressCell(cell: U03AddressCell, btnClickWithTag tag: NSInteger, indexPath: NSIndexPath)
}

class U03AddressCell: UITableViewCell {

    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
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
        var btn = sender as! UIButton
        btn.selected = !btn.selected
        self.editBtn.selected = btn.selected
        self.deleteBtn.selected = btn.selected
        self.editBtn.userInteractionEnabled = btn.selected
        self.deleteBtn.userInteractionEnabled = btn.selected
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
    
    
    
}



