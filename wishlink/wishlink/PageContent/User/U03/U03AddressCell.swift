//
//  U03AddressCell.swift
//  wishlink
//
//  Created by Yue Huang on 8/24/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U03AddressCell: UITableViewCell {

    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
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
    }
    @IBAction func deleteBtnAction(sender: AnyObject) {
    }
    
    
    
}



