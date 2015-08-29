//
//  U02FilterButton.swift
//  wishlink
//
//  Created by Yue Huang on 8/23/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class U02FilterButton: UIButton {

    lazy var redRoundImageView: UIImageView = {
        var imageView = UIImageView(frame: CGRectMake(5, 5, 10, 10))
        imageView.backgroundColor = UIColor.redColor()
        imageView.layer.cornerRadius = 10 * 0.5
        imageView.layer.masksToBounds = true
        return imageView
    }()

    var hideRedRound: Bool = true {
        didSet {
            if hideRedRound {
                self.redRoundImageView.hidden = true
            }
            else {
                if (self.redRoundImageView.superview == nil) {
                    self.addSubview(self.redRoundImageView)
                }
                self.redRoundImageView.x = self.titleLabel!.x - self.redRoundImageView.w
                self.redRoundImageView.y = self.titleLabel!.y - self.redRoundImageView.h
                self.redRoundImageView.hidden = false
            }
        }
    }
}
