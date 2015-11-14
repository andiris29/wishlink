//
//  T08ComplaintVC.swift
//  wishlink
//
//  Created by whj on 15/8/25.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T08ComplaintVC: RootVC, WebRequestDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {

    @IBOutlet weak var contexTextView: UITextView!
    
    @IBOutlet weak var btnImage5: UIButton!
    @IBOutlet weak var btnImage4: UIButton!
    @IBOutlet weak var btnImage3: UIButton!
    @IBOutlet weak var btnImage2: UIButton!
    @IBOutlet weak var btnImage1: UIButton!
    @IBOutlet weak var lbCount: UILabel!
    
    var tradeid:String!
    var currentButton: UIButton!
    var images = Dictionary<String, UIImage>()
    var defaultMsg:String = "在此描述您遇到的具体问题，将有客服人员更快的处理您的申请"
    deinit{
        
        NSLog("T08ComplaintVC -->deinit")
        
        self.dataArr = nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexTextView.delegate = self;
        self.httpObj.mydelegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.loadComNaviLeftBtn();
        self.navigationController?.navigationBarHidden = false;
    }
    
    //MARK: - override
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        contexTextView.resignFirstResponder()
    }
    var selectImgTag = 0;
    @IBAction func btnAction(sender: AnyObject) {
        
        selectImgTag = 0;
        currentButton = sender as! UIButton
        
        let tag = (sender as! UIButton).tag
        
        if(tag >= 1 && tag <= 5)
        {
            selectImgTag = tag
            
            let actionSheet: UIActionSheet = UIActionSheet(title: "上传照片", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册中选取")
            actionSheet.showInView(self.view)


        }
        else if(tag == 10)
        {
            if(self.navigationController != nil)
            {
                self.navigationController?.popViewControllerAnimated(true);
            }
            else
            {
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        else if(tag == 11)
        {
//            self.httpObj.httpPostApi("trade/complaint", parameters: ["problem": contexTextView.text], tag: 80)
            submit()
        }
        else if(tag == 22)
        {
//            var vc = T09ComplaintStatusVC(nibName: "T09ComplaintStatusVC", bundle: NSBundle.mainBundle())
//            self.navigationController!.pushViewController(vc, animated: true)
            

        } else if(tag == 30) {
            
            let strUrl:NSURL = NSURL(string: "telprompt://18601746164")!
            UIApplication.sharedApplication().openURL(strUrl);

            
        } else if(tag == 31) {
            let vc = T10MessagingVC(nibName: "T10MessagingVC", bundle: NSBundle.mainBundle());
           
            
            if(self.navigationController != nil)
            {
                 self.navigationController?.pushViewController(vc, animated: true);
            }
            else
            {
                
                self.presentViewController(vc, animated: true, completion: nil);
            }
        }
    }
    
    func submit()
    {
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        self.view.userInteractionEnabled = false;
        let apiurl = APPCONFIG.SERVICE_ROOT_PATH + "trade/complaint"
        upload(
            .POST,
            apiurl,
            multipartFormData: {
                multipartFormData in
                 multipartFormData.appendBodyPart(data: self.tradeid.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "_id")
                multipartFormData.appendBodyPart(data: self.contexTextView.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "problem")
 
                for var index = self.btnImage1.tag; index <= self.btnImage5.tag; index++ {
                    
                    let image = self.images["T08Complaint_\(index)"]
                    if (image != nil) {
                        let imgName = "T08Complaint_\(index).jpg"
                        let imageData = UIHEPLER.compressionImageToDate(image!);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                }
            
            },
            encodingCompletion: {
                encodingResult in
                switch encodingResult {
                    
                case .Success(let _upload, _, _ ):
                    
                    _upload.responseJSON { _response in
                        
                        let resultObj:(request:NSURLRequest?, respon:NSHTTPURLResponse?, result:Result) = _response;

                        switch resultObj.result {
                        case .Success(let json):
                            
                            SVProgressHUD.dismiss();
                            if(self.navigationController != nil)
                            {
                                self.navigationController?.popViewControllerAnimated(true);
                            }
                            else
                            {
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            
                            print("complaint Successful")
                            print(json);
                            let itemData =  json.objectForKey("data") as! NSDictionary
                            if(itemData.objectForKey("trade") != nil) {

                            } else {
                                
                                SVProgressHUD.showErrorWithStatusWithBlack("提交数据失败！");
                                self.view.userInteractionEnabled = true;
                                NSLog("Fail:")
                            }
                        case .Failure(let error):
                            
                            SVProgressHUD.showErrorWithStatusWithBlack("提交数据失败！");
                            self.view.userInteractionEnabled = true;
                            print("Fail:\(error)")
                        }
                    }
                case .Failure(let encodingError):
                    
                    SVProgressHUD.showErrorWithStatusWithBlack("编码数据失败！");
                    self.view.userInteractionEnabled = true;
                    print("Failure")
                    print(encodingError)
                }
            }
        )
        
    }
    
    //MARK:ActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            [self .presentViewController(imagePicker, animated: true, completion: { () -> Void in
                
            })]
            
        }else if buttonIndex == 2 {
            let imagePicker = UIImagePickerController()
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
    
            self.images["T08Complaint_\(self.currentButton.tag)"] = gotImage
            self.currentButton.setImage(gotImage, forState: UIControlState.Normal);
            UIHEPLER.saveImageToLocal(gotImage, strName: "T08Complaint_\(self.currentButton.tag).jpg")
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    var currMsgLength = 0;
    
    //textViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        return CalculationLenght();
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.text = "";
        textView.textColor = UIColor.blackColor();
    }
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text == "")
        {
            textView.text = " 填写其他补充信息！";
            textView.textColor = UIColor.lightGrayColor();
        }
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        
        if(textView.text == self.defaultMsg)
        {
            textView.text = "";
            
            self.lbCount.text = "0/500";
        }
        else
        {
            CalculationLenght();
        }
        return true;
        
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if(textView.text!.trim().length<1)
        {
            textView.text = self.defaultMsg;
            self.lbCount.text = "\(self.defaultMsg.length)/500";
        }
        else
        {
            CalculationLenght();
        }
        return true;
    }
    
    func CalculationLenght()->Bool
    {
        var resut = true;
        currMsgLength = self.contexTextView.text.trim().length
        if(currMsgLength>=500)
        {
            self.lbCount.text = "500/500";
            resut = false;
        }
        else
        {
            self.lbCount.text = "\(currMsgLength)/500";
        }
        return resut;
    }

    //MARK: - Request delegate
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        
        SVProgressHUD.dismiss();
//        if(tag == 80) {
//            self.navigationController?.popViewControllerAnimated(true);
//            //             self.dismissViewControllerAnimated(true, completion: nil);
//        }
    }
    
    func requestDataFailed(error: String,tag:Int) {
        
        SVProgressHUD.dismiss();
    }
}
