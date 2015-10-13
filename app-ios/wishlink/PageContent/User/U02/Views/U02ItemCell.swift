//
//  U02ItemCell.swift
//  wishlink
//
//  Created by Yue Huang on 8/18/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum ItemCellType {
    case Recommand, Favorite
}

enum ItemCellButtonClickType {
    case Favorite, Delete
}


protocol U02ItemCellDelegate: NSObjectProtocol {
    func itemCell(cell: U02ItemCell, clickType: ItemCellButtonClickType)
}

class U02ItemCell: UICollectionViewCell {

    
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbIntro: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    var indexPath: NSIndexPath!
 
    var closure: ((ItemCellButtonClickType, NSIndexPath) -> ())?
    
    var cellType: ItemCellType = .Recommand {
        didSet {
            if cellType == .Recommand {
                favoriteBtn.hidden = false
            }
            else {
                favoriteBtn.hidden = true
            }
        }
    }
    
    var item: ItemModel! {
        didSet {
            self.filldataForUI()
        }
    }
    var delegate: U02ItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1
    }
    @IBAction func favoriteBtnAction(sender: AnyObject) {
        let btn = sender as! UIButton
        btn.selected = !btn.selected
        if let c = self.closure {
            c(ItemCellButtonClickType.Favorite, self.indexPath)
//            c(self.indexPath, ItemCellType.Favorite)
        }
        self.delegate?.itemCell(self, clickType: ItemCellButtonClickType.Favorite)
    }
    @IBAction func deleteBtnAction(sender: AnyObject) {
        if let c = self.closure {
            c(ItemCellButtonClickType.Delete, self.indexPath)
            //            c(self.indexPath, ItemCellType.Favorite)
        }
    }
    
    func filldataForUI() {
        self.lbCountry.text = item.country;
        self.lbPrice.text = "￥" + item.price.format(".2");
        self.lbIntro.text = item.name + " " + item.spec;
    }
    
    //从热门列表中加载的时候调用此方法
    func loadFromhotVC(_item:ItemModel)
    {
        self.item = _item
        self.btnDelete.hidden = true;
        
    }
    
    
    
}
