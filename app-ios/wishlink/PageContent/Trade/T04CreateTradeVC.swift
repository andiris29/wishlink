//
//  T04CreateTradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T04CreateTradeVC: RootVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate, CSActionSheetDelegate {

    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtRemark: UITextView!
    @IBOutlet weak var txtCount: UITextField!
    @IBOutlet weak var txtSize: UITextField!
    @IBOutlet weak var txtBuyArea: UITextField!
    //顶部标题View的高度约束
    @IBOutlet weak var constraint_topViewHieght: NSLayoutConstraint!
    //通用View高度约束
    @IBOutlet weak var constraint_viewHeight: NSLayoutConstraint!

    var actionSheet: CSActionSheet!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sv.delegate = self;
  
        self.sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"));
        
        csActionSheet()
    }

    
    override func viewWillAppear(animated: Bool) {
        
        self.constraint_viewHeight.constant = UIHEPLER.resizeHeight(60.0);
        self.constraint_topViewHieght.constant=UIHEPLER.resizeHeight(75);
 
      self.navigationController?.navigationBarHidden = false;
        
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 80, 20))
        titleLabel.text = "发布新订单"
        titleLabel.textColor = UIHEPLER.mainColor;
        titleLabel.font =  UIHEPLER.mainChineseFont15
        titleLabel.textAlignment = NSTextAlignment.Center
        
        
        let txtRemark: UILabel = UILabel(frame: CGRectMake(0, 20, 80, 20))
        txtRemark.text = "(*为必填项)"
        txtRemark.textColor = UIColor.redColor();
        txtRemark.font = UIHEPLER.getCustomFont(true, fontSsize: 11);
        txtRemark.textAlignment = NSTextAlignment.Center
  
        
        
        var titleView = UIView(frame: CGRectMake(0, 0, 50, 40))
        titleView.addSubview(titleLabel);
        titleView.addSubview(txtRemark);
        self.navigationItem.titleView = titleView;
        
        self.navigationController?.navigationBarHidden = false;
        
        
    }

    func csActionSheet() {
        
        var titles: Array<String> = ["取消", "从手机相册中选择", "拍照"]
        actionSheet = CSActionSheet.sharedInstance
        actionSheet.bindWithData(titles, delegate: self)
    }
    
    @IBAction func btnAction(sender: UIButton) {
    
        var tag = sender.tag;
        if(tag==11)
        {
            var vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            self.navigationController?.pushViewController(vc, animated: true);
        }
        else
        {
            actionSheet.show(true)
        }

    }
    
    //MARK:弹出图片上传选择框
    func imgHeadChange(index: Int) {
        
        if index == 1001 {
            
            var imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self;
            self.presentViewController(imagePicker, animated: true, completion: nil);
        } else if index == 1002 {
            
            var imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.delegate = self;
                self.presentViewController(imagePicker, animated: true, completion: nil);
            }
        }
    }
    
    //MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
            
            var imgData = UIImageJPEGRepresentation(gotImage, 1.0)
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissKeyboard()
    {
        self.txtCategory.resignFirstResponder();
        self.txtName.resignFirstResponder();
        self.txtPrice.resignFirstResponder();
        self.txtRemark.resignFirstResponder();
        self.txtCount.resignFirstResponder();
        self.txtSize.resignFirstResponder();
        self.txtBuyArea.resignFirstResponder();
        
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.dismissKeyboard();
    }
    
    //MARK: - CSActionSheetDelegate
    
    func csActionSheetAction(view: CSActionSheet, selectedIndex index: Int) {
        
        imgHeadChange(index)
    }
}
