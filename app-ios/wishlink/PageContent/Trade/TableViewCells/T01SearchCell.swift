//
//  T01SearchCell.swift
//  wishlink
//
//  Created by whj on 15/10/22.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

import UIKit

class T01SearchCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.bgView.layer.borderWidth = 1.0
//        self.bgView.layer.borderColor = UIColor.whiteColor().CGColor
        self.bgView.layer.masksToBounds = true
        self.bgView.layer.cornerRadius = 5.0
    }
    
    func cellDataFrom(data: AnyObject ,lastCell: Bool) {
        
        self.lineImageView.hidden = lastCell
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
