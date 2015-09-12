//
//  SearchCollectionViewCell.swift
//  wishlink
//
//  Created by whj on 15/8/21.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

protocol SearchCollectionViewCellDelegate: NSObjectProtocol {
    
    func searchCollectionViewCell(cell: SearchCollectionViewCell, buttonIndex: Int)
}

class SearchCollectionViewCell: UICollectionViewCell {

    weak var delegate: SearchCollectionViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func initData(model: TrendModel) {
        
        self.nameLabel.text = model.name;
    }
    
    //MARK: - Action
    
    @IBAction func buttonAction(sender: UIButton) {
        
        self.delegate?.searchCollectionViewCell(self, buttonIndex: sender.tag)
    }
}
