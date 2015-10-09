//
//  T08ComplaintVC.swift
//  wishlink
//
//  Created by whj on 15/8/25.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T08ComplaintVC: RootVC, WebRequestDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var contexTextView: UITextView!
    
    @IBOutlet weak var btnImage5: UIButton!
    @IBOutlet weak var btnImage4: UIButton!
    @IBOutlet weak var btnImage3: UIButton!
    @IBOutlet weak var btnImage2: UIButton!
    @IBOutlet weak var btnImage1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.httpObj.mydelegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.loadComNaviLeftBtn();
        self.navigationController?.navigationBarHidden = false;
    }
    
    //MARK: - override
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        contexTextView.resignFirstResponder()
    }
    
    var selectImgTag = 0;
    @IBAction func btnAction(sender: AnyObject) {
        selectImgTag = 0;
        var tag = (sender as! UIButton).tag
        if(tag >= 1 && tag <= 5)
        {
            selectImgTag = tag
            
            var actionSheet: UIActionSheet = UIActionSheet(title: "上传照片", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册中选取")
            actionSheet.showInView(self.view)


        }
        else if(tag == 10)
        {
            self.navigationController?.popViewControllerAnimated(true);
//            self.dismissViewControllerAnimated(true, completion: nil);
        }
        else if(tag == 11)
        {
            self.httpObj.httpPostApi("trade/complaint", parameters: ["problem": contexTextView.text], tag: 80)
        }
        else if(tag == 22)
        {
//            var vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle())
//            self.navigationController!.pushViewController(vc, animated: true)
            

        } else if(tag == 30) {
            
            var strUrl:NSURL = NSURL(string: "telprompt://18601746164")!
            UIApplication.sharedApplication().openURL(strUrl);

            
        } else if(tag == 31) {
            var vc = T10MessagingVC(nibName: "T10MessagingVC", bundle: NSBundle.mainBundle());
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    //MARK:ActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            [self .presentViewController(imagePicker, animated: true, completion: { () -> Void in
                
            })]
            
        }else if buttonIndex == 2 {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            [self .presentViewController(imagePicker, animated: true, completion: { () -> Void in
                
            })]
            
        }else{
            actionSheet.dismissWithClickedButtonIndex(0, animated: true)
        }
    }

    //MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
            
            var btn:UIButton!;
            if(self.selectImgTag == 1)
            {
                btn = self.btnImage1;
                self.btnImage1.setBackgroundImage(gotImage, forState: UIControlState.Normal);
            }
            else if(self.selectImgTag == 2)
            {
                btn = self.btnImage2;
            }
            else if(self.selectImgTag == 3)
            {
                btn = self.btnImage3;
            }
            else if(self.selectImgTag == 4)
            {
                btn = self.btnImage4;
            }
            else if(self.selectImgTag == 5)
            {
                btn = self.btnImage5;
            }
            btn.setBackgroundImage(gotImage, forState: UIControlState.Normal);
//            var imgData = UIImageJPEGRepresentation(gotImage, 1.0)
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: - Request delegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        if(tag == 80) {
            self.navigationController?.popViewControllerAnimated(true);
            //             self.dismissViewControllerAnimated(true, completion: nil);
        }
    }
    
    func requestDataFailed(error: String) {
        
    }
}
