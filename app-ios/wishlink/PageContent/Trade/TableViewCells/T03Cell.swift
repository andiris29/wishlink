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
    var dataArr_Name:[String]!;
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
        let tag = sender.tag;
        self.myDelegate?.btnAction(tag, rowIndex: self.rowIndex);
    }
    func lodaData(rowindex:Int,selectindex:Int)
    {
        self.rowIndex = rowindex;
        self.selectIndex = selectindex;
        let imgWidth = ScreenWidth / 6;
        let spance = (ScreenWidth - 5 * imgWidth)/6
        
        if(self.sv.subviews.count>0)
        {
            for v in self.sv.subviews
            {
                let vi = v ;
                vi.removeFromSuperview()
                
            }
        }
        
        var index = 0;
        let martop:CGFloat = 10;
        for item in dataArr
        {
            let rectX = (imgWidth+spance)*CGFloat(index);
            let btnRect = CGRectMake(rectX,  martop, imgWidth, imgWidth)
            let imgName_u = self.dataArr[index]
            let imgView = UIImageView(frame: btnRect)
            
            let btn = UIButton(frame: btnRect);
            btn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside);
            btn.tag = index;
            let lRect = CGRectMake(rectX, imgWidth+10+martop, imgWidth, imgWidth/2)
            let lbName = UILabel(frame: lRect)
            lbName.text = self.dataArr_Name[index];
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
            let sizeWidth = (imgWidth+spance)*CGFloat(dataArr.count)+spance
            self.sv.contentSize = CGSizeMake(sizeWidth,imgWidth*1.5+10);
            index++;
        }
        
    }

    
}
