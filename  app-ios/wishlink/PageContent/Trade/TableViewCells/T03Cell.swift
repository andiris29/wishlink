//
//  T03Cell.swift
//  wishlink
//
//  Created by Andy Chen on 8/22/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

protocol t03CellDelegate
{
    func btnAction(btnindex:Int,rowIndex:Int);
}

class T03Cell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var v_leftLine: UIView!
    @IBOutlet weak var sv: UIScrollView!

    
    var myDelegate:t03CellDelegate!
    var selectIndex = 2;
    var dataArr:[String]!;
    var rowIndex = 0;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func btnAction(sender:UIButton)
    {
        var tag = sender.tag;
        self.myDelegate?.btnAction(tag, rowIndex: self.rowIndex);
    }
    func lodaData(rowindex:Int,selectindex:Int)
    {
        self.rowIndex = rowindex;
        self.selectIndex = selectindex;
        var imgWidth = ScreenWidth / 6;
        var spance = (ScreenWidth - 5*imgWidth)/6
        
        if(self.sv.subviews.count>0)
        {
            for v in self.sv.subviews
            {
                var vi = v as! UIView;
                vi.removeFromSuperview()
                
            }
        }
        
        var index = 0;
        var martop:CGFloat = 10;
        for item in dataArr
        {
            var rectX = (imgWidth+spance)*CGFloat(index);
            var btnRect = CGRectMake(rectX,  martop, imgWidth, imgWidth)
            var imgName_u = self.dataArr[index]
            var imgView = UIImageView(frame: btnRect)
            
            var btn = UIButton(frame: btnRect);
            btn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside);
            btn.tag = index;
            var lRect = CGRectMake(rectX, imgWidth+10+martop, imgWidth, imgWidth/2)
            var lbName = UILabel(frame: lRect)
            lbName.text = imgName_u;
            lbName.textAlignment = NSTextAlignment.Center;
            
            var currColor = UIColor.grayColor();
            var imgName = imgName_u
            if(Int(index) == selectIndex)
            {
                btn.selected = true;
                currColor = UIHEPLER.mainColor
                imgName = imgName_u
            }
            else
            {
                currColor = UIColor.grayColor();
                imgName = imgName_u+"-b";
            }
        
            imgView.image = UIImage(named:imgName);
            lbName.textColor = currColor;
            
            UIHEPLER.buildButtonFilletStyleWithRadius(btn, borderColor: currColor, titleColor: currColor, radius: btn.frame.height/2);
            
             self.sv.addSubview(imgView);
            self.sv.addSubview(btn);
            self.sv.addSubview(lbName);
            var sizeWidth = (imgWidth+spance)*CGFloat(dataArr.count)+spance
            self.sv.contentSize = CGSizeMake(sizeWidth,imgWidth*1.5+10);
            index++;
        }
        
    }

    
}
