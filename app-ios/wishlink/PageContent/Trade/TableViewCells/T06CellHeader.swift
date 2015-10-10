//
//  TradeTableViewCellHeader.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

protocol T06CellHeaderDelegate: NSObjectProtocol {

    func dorpListButtonAction(sender: UIButton)
    func orderButtonAction(sender: UIButton)
}

class T06CellHeader: UITableViewCell, CSDorpListViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productTotalLabel: UILabel!
    @IBOutlet weak var productNumberLabel: UILabel!
    @IBOutlet weak var productFormatLabel: UILabel!
    @IBOutlet weak var productMessageLabel: UILabel!
    
    @IBOutlet weak var btnDorp: UIButton!
    @IBOutlet weak var btnFlow: UIButton!
    @IBOutlet weak var imageRollView: CSImageRollView!
    
    var dorpListView: CSDorpListView!
    
    var delegate: T06CellHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var titles: NSArray = ["选择同城0","选择同城1","选择同城2"]
        dorpListView = CSDorpListView.sharedInstance
        dorpListView.bindWithList(titles, delegate: self)

        // clear
        self.titleLabel.text  = ""
        self.productNameLabel.text  = ""
        self.productPriceLabel.text  = ""
        self.productTotalLabel.text  = ""
        self.productNumberLabel.text  = ""
        self.productFormatLabel.text  = ""
        self.productMessageLabel.text  = ""
    }
    
    func initImageRollView(images:[UIImage]) {

        imageRollView.initWithImages(images)
        imageRollView.setcurrentPageIndicatorTintColor(UIColor.grayColor())
        imageRollView.setpageIndicatorTintColor(UIColor(red: 124.0 / 255.0, green: 0, blue: 90.0 / 255.0, alpha: 1))
    }
    
    func initData(item: ItemModel) {
    
        self.titleLabel.text  = item.brand
        self.productNameLabel.text  = "品名：" + item.name
        self.productPriceLabel.text  = "\(item.price)"
//        self.productTotalLabel.text  = item.countryRef
//        self.productNumberLabel.text  = item.country
//        self.productFormatLabel.text  = item.create
        self.productMessageLabel.text  = item.spec
        
        if (item.images == nil) {return}
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            var images: [UIImage] = [UIImage]()
            for imageUrl in item.images {
                var url: NSURL = NSURL(string: imageUrl)!
                var image: UIImage = UIImage(data: NSData(contentsOfURL: url)!)!
                images.append(image)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.initImageRollView(images)
            })
        })
    }
    
    //MARK: - Action
    
    @IBAction func orderButtonAction(sender: UIButton) {
        delegate?.orderButtonAction(sender)
    }
    
    @IBAction func dorpListButtonAction(sender: UIButton) {
        
//        delegate?.dorpListButtonAction(sender)
    
        dorpListView.show(sender)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - CSDorpListViewDelegate
    
    func dorpListButtonItemAction(sender: UIButton!) {
        
        btnDorp.setTitle(sender.titleLabel?.text, forState: UIControlState.Normal)
    }
}
