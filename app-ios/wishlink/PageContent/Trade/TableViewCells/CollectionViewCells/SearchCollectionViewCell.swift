//
//  SearchCollectionViewCell.swift
//  wishlink
//
//  Created by whj on 15/8/21.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

protocol SearchCollectionViewCellDelegate: NSObjectProtocol {
    
    func searchCollectionViewCell(cell: SearchCollectionViewCell, title: NSString, buttonIndex: Int)
}

class SearchCollectionViewCell: UICollectionViewCell {

    weak var delegate: SearchCollectionViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func initData(model: TrendModel, indexPath: NSIndexPath) {
        
        self.nameLabel.text = model.name;
        self.iconButton.tag = indexPath.row;
    }
    
    var cellSelected:Bool = false;
    func setCellSelectStatus(_selected:Bool)
    {
        if(_selected != cellSelected)
        {
            self.cellSelected = _selected
            if(self.cellSelected)
            {
                self.nameLabel.textColor = UIHEPLER.mainColor;
                self.iconButton.setImage(UIImage(named: "T03eee1"), forState: UIControlState.Normal);
                self.iconButton.setBackgroundImage(UIImage(named: "T03aaa"), forState: UIControlState.Normal)
            }
            else
            {
                
                self.nameLabel.textColor =  UIColor.lightGrayColor();
                self.iconButton.setImage(UIImage(named: "T03eee0"), forState: UIControlState.Normal);
                self.iconButton.setBackgroundImage(UIImage(named: "T03bbb"), forState: UIControlState.Normal)
            }
        }
    }
  
    //MARK: - Action
    
    @IBAction func buttonAction(sender: UIButton) {
        
        self.delegate?.searchCollectionViewCell(self, title: self.nameLabel.text!, buttonIndex: sender.tag)
    }
}
