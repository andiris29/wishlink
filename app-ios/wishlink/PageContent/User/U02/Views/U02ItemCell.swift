//
//  U02ItemCell.swift
//  wishlink
//
//  Created by Yue Huang on 8/18/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum ItemCellType {
    case Recommand, Favorite, Hot
}

 enum ItemCellButtonClickType {
    case Favorite, Delete
}

protocol U02ItemCellDelegate: NSObjectProtocol {
    func itemCell(cell: U02ItemCell,  clickType: ItemCellButtonClickType)
}

class U02ItemCell: UICollectionViewCell {

    @IBOutlet weak var iv_country: UIImageView!
    
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbIntro: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var iv_Item: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var iconContryView: UIView!
    
    var indexPath: NSIndexPath!
    
 
    var closure: ((ItemCellButtonClickType, NSIndexPath) -> ())?
    var deleteButtonClosure: ((ItemCellType, NSIndexPath) -> ())?
    
    var cellType: ItemCellType = .Recommand {
        didSet {
            if cellType == .Recommand || cellType == .Favorite {
                
                btnDelete.hidden = false
            } else {
                
                btnDelete.hidden = true
            }
            
            
            iconContryView.backgroundColor = UIColor.clearColor()
            if cellType == .Hot {
                favoriteBtn.hidden = false
            } else {
                
                favoriteBtn.hidden = true
            }
        }
    }
    
    var item: ItemModel! {
        didSet {
            self.filldataForUI()
        }
    }
    weak var delegate: U02ItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1
        
        self.iconContryView.layer.masksToBounds = true
        self.iconContryView.layer.cornerRadius = self.iconContryView.frame.size.height / 2.0
    }
    deinit{
        
        NSLog("U02ItemCell -->deinit")
        self.delegate = nil;
        if(self.item != nil)
        {
            self.item = nil;
        }
    }
    
    
    @IBAction func favoriteBtnAction(sender: AnyObject) {
//        let btn = sender as! UIButton
//        btn.selected = !btn.selected
        if let c = self.closure {
            c(ItemCellButtonClickType.Favorite, self.indexPath)
        }
        self.delegate?.itemCell(self, clickType: ItemCellButtonClickType.Favorite)
    }
    @IBAction func deleteBtnAction(sender: AnyObject) {
        if let c = self.closure {
            c(ItemCellButtonClickType.Delete, self.indexPath)
        }
    }
    
    func filldataForUI() {
        self.lbCountry.text = item.country;
        if(self.item.price != nil)
        {
            self.lbPrice.text = "RMB" + item.price.format(".2");
        }
        self.lbIntro.text = item.brand + " " + item.name + " " + item.spec;
        if(self.item.unit != nil && self.item.unit != "")
        {
            self.lbCount.text = "\(item.numTrades)"+self.item.unit;
        }
        else
        {
            self.lbCount.text = "\(item.numTrades)件"
        }
        self.favoriteBtn.selected = self.item.isFavorite
        
        self.iv_country.image = nil;
        if(self.item._countryRef != nil)
        {
            if(self.item._countryRef.icon != nil && self.item._countryRef.icon.length>1)
            {
                if(self.item._countryRef.icon.containsString("http"))
                {
                    WebRequestHelper().renderImageView(self.iv_country, url: self.item._countryRef.icon, defaultName: "")
                }
            }
            
        }
        
        
        if (item == nil ||  item.images == nil) {
            self.iv_Item.image = nil;
            return
        }
        
        WebRequestHelper().renderImageView(self.iv_Item, url: item.images[0], defaultName: "")
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            
//            var images: [UIImage] = [UIImage]()
//            for imageUrl in self.item.images {
//                let url: NSURL = NSURL(string: imageUrl)!
//                let image: UIImage = UIImage(data: NSData(contentsOfURL: url)!)!
//                images.append(image)
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                self.initImageRollView(images)
//            })
//        })
    }
//    func initImageRollView(images:[UIImage]) {
//        
//        imageRollView.initWithImages(images)
//        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
//        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
//    }
    
    //从热门列表中加载的时候调用此方法
    func loadFromhotVC(_item:ItemModel)
    {
        self.item = _item
//        self.btnDelete.hidden = true;
        
        
        
    }
    
    
    
}
