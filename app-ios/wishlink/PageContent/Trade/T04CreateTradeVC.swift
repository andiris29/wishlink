//
//  T04CreateTradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T04CreateTradeVC: RootVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate, CSActionSheetDelegate,WebRequestDelegate,T11SearchSuggestionDelegate {

    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtRemark: UITextView!
    @IBOutlet weak var txtCount: UITextField!
    @IBOutlet weak var txtSize: UITextField!
    @IBOutlet weak var txtBuyArea: UITextField!
    
    @IBOutlet weak var iv0: UIImageView!
    @IBOutlet weak var iv1: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    @IBOutlet weak var iv3: UIImageView!

    //顶部标题View的高度约束
    @IBOutlet weak var constraint_topViewHieght: NSLayoutConstraint!
    //通用View高度约束
    @IBOutlet weak var constraint_viewHeight: NSLayoutConstraint!

    var actionSheet: CSActionSheet!
    
    var item:ItemModel!
    
    //上传的图像列表
    var imagrArr:[UIImage] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sv.delegate = self;
        
        self.txtCategory.delegate = self;
        self.txtName.delegate = self;
        self.txtPrice.delegate = self;
        self.txtRemark.delegate = self;
        self.txtCount.delegate = self;
        self.txtSize.delegate = self;
        self.txtBuyArea.delegate = self;
        self.httpObj.mydelegate = self;
        
  
        self.sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"));
        
        csActionSheet()
    }

    
    override func viewWillAppear(animated: Bool) {
        
        self.constraint_viewHeight.constant = UIHEPLER.resizeHeight(60.0);
        self.constraint_topViewHieght.constant=UIHEPLER.resizeHeight(75);
       
        self.navigationController?.navigationBarHidden = false;
        
         self.item = nil;
        
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
  
        
        
        let titleView = UIView(frame: CGRectMake(0, 0, 50, 40))
        titleView.addSubview(titleLabel);
        titleView.addSubview(txtRemark);
        self.navigationItem.titleView = titleView;
        
        self.navigationController?.navigationBarHidden = false;
        
        
    }

    func csActionSheet() {
        
        let titles: Array<String> = ["取消", "从手机相册中选择", "拍照"]
        actionSheet = CSActionSheet.sharedInstance
        actionSheet.bindWithData(titles, delegate: self)
    }
    
    @IBAction func btnAction(sender: UIButton) {
    
        let tag = sender.tag;
        if(tag==11)//确认发布
        {
            let errmsg =  checkInput();
            if(errmsg != "")
            {
                UIHEPLER.alertErrMsg(errmsg);
            }
            else
            {
                SVProgressHUD.showWithStatusWithBlack("请稍后...")
                self.view.userInteractionEnabled = false;
                let apiurl = SERVICE_ROOT_PATH + "item/create"
                   upload(
                        .POST,
                        apiurl,
                        multipartFormData: {
                            multipartFormData in
                            
                            multipartFormData.appendBodyPart(data: self.txtName.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "name")
                            multipartFormData.appendBodyPart(data: self.txtCategory.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "brand")
                            multipartFormData.appendBodyPart(data: self.txtBuyArea.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "country")
                            multipartFormData.appendBodyPart(data: self.txtPrice.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "price")
                            multipartFormData.appendBodyPart(data: self.txtSize.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "spec")
                            multipartFormData.appendBodyPart(data: self.txtRemark.text.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "comment")
                            if(self.imagrArr.count>0)
                            {
                                let imgName = "item_a.jpg"
                                let imageData = UIHEPLER.compressionImageToDate(self.imagrArr[0]);
                                
                                let imgStream  = NSInputStream(data: imageData);
                                let len =   UInt64(imageData.length)
                                
                                multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                            }
                            if(self.imagrArr.count>1)
                            {
                                
                                let imgName = "item_b.jpg"
                                let imageData = UIHEPLER.compressionImageToDate(self.imagrArr[1]);
                                
                                let imgStream  = NSInputStream(data: imageData);
                                let len =   UInt64(imageData.length)
                                
                                multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                            }
                            if(self.imagrArr.count>2)
                            {
                                let imgName = "item_c.jpg"
                                let imageData = UIHEPLER.compressionImageToDate(self.imagrArr[2]);
                                
                                let imgStream  = NSInputStream(data: imageData);
                                let len =   UInt64(imageData.length)
                                
                                multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                            }
                            if(self.imagrArr.count>3)
                            {
                                let imgName = "item_d.jpg"
                                let imageData = UIHEPLER.compressionImageToDate(self.imagrArr[3]);
                                
                                let imgStream  = NSInputStream(data: imageData);
                                let len =   UInt64(imageData.length)
                                
                                multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
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
                                        
                                        print("Validation Successful")
                                        print(json);
                                        let itemData =  json.objectForKey("data") as! NSDictionary
                                        if(itemData.objectForKey("item") != nil)
                                        {
                                            let itemObj =  itemData.objectForKey("item") as! NSDictionary
                                            let item = ItemModel(dict: itemObj);
                                            self.item = item;
                                            print(item, terminator: "");
                                            if(item._id.length>0)
                                            {
                                                
                                                let para  = ["itemRef":item._id,
                                                    "quantity":self.txtCount.text!.trim()];
                                                self.httpObj.httpPostApi("trade/create", parameters: para, tag: 12);
                                            }
                                        }
                                        else
                                        {
                                            
                                            SVProgressHUD.showErrorWithStatusWithBlack("提交数据失败！");
                                            self.view.userInteractionEnabled = true;
                                            NSLog("Fail:")
                                            
                                        }
                                    case .Failure(let error):
                                        
                                        SVProgressHUD.showErrorWithStatusWithBlack("提交数据失败！");
                                        self.view.userInteractionEnabled = true;
                                        NSLog("Fail:")
                                        print(error)
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
        }
        else
        {
            actionSheet.show(true)
        }

    }
    
      func checkInput()->String{
        
        let result = "";
        
        let category = txtCategory.text!.trim();
        if(category.length == 0)
        {
            return "品牌不能为空"
        }
        let name = txtName.text!.trim();
        if(name.length == 0)
        {
            return "品名不能为空"
        }
        let country = txtBuyArea.text!.trim();
        if(country.length == 0)
        {
            return "购买地不能为空"
        }
        let price = txtPrice.text!.trim();
        if(price.length == 0)
        {
            return "出价不能为空"
        }
        let spec = txtSize.text!.trim();
        if(spec.length == 0)
        {
            return "规格不能为空"
        }
        
        let count = txtCount.text!.trim();
        if(count.length == 0)
        {
            return "数量不能为空"
        }
        if(self.imagrArr.count == 0)
        {
            
            return "请上传图片"
        }
        return result;
        
    }
    
    //MARK:弹出图片上传选择框
    func imgHeadChange(index: Int) {
        
        if index == 1001 {
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self;
            self.presentViewController(imagePicker, animated: true, completion: nil);
        } else if index == 1002 {
            
            let imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.delegate = self;
                self.presentViewController(imagePicker, animated: true, completion: nil);
            }
        }
    }
    
    //MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let icount = self.imagrArr.count;
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
        
            if(self.imagrArr.count<4)
            {
                
                self.imagrArr.append(gotImage);
                
            }
            
            if(self.imagrArr.count>0 && icount == 0)
            {
                self.iv0.image = self.imagrArr[0];
            }
            
            if(self.imagrArr.count>1 && icount == 1)
            {
                self.iv1.image = self.imagrArr[1];
            }
            if(self.imagrArr.count>2 && icount == 2)
            {
                self.iv2.image = self.imagrArr[2];
            }
            if(self.imagrArr.count>3 && icount == 3)
            {
                self.iv3.image = self.imagrArr[3];
            }
            
//            var imgData = UIImageJPEGRepresentation(gotImage, 1.0)
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
    
    //MARK:UItextFiledDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.dismissKeyboard();
        return true;
    }
    var lastSelectTextFiledTag = -1;
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if(textField.tag>3 || textField.tag == 0)
        {
            return true;
        }
        else
        {
            self.lastSelectTextFiledTag = textField.tag;
            let vc =  T11SearchSuggestionVC(nibName: "T11SearchSuggestionVC", bundle: NSBundle.mainBundle())
            vc.myDelegate = self;
            if(textField.tag == 1)
            {
                vc.searchType = .brand;
            }
            else if(textField.tag == 2)
            {
                vc.searchType = .name;
            }
            else if(textField.tag == 3)
            {
                vc.searchType = .country;
            }
            self.presentViewController(vc, animated: true, completion: nil);
            return false;
        }
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            
            self.txtRemark.resignFirstResponder();
            
            return false;
        }
        
        return true;
    }

    //MAEK: WebrequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
     if(tag == 12)//trade创建成功,准备页面跳转
        {
            
            SVProgressHUD.dismiss();
            let dic = response as! NSDictionary;
            let tradeDic = dic.objectForKey("trade") as!  NSDictionary;
            let tradeItem = TradeModel(dict: tradeDic);
            
            let vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            vc.item = self.item;
            vc.trade = tradeItem;
            self.navigationController?.pushViewController(vc, animated: true);
            
        }
    }
    func requestDataFailed(error: String) {
        
        SVProgressHUD.dismiss();
        UIHEPLER.alertErrMsg(error);
        
    }
    
    //T11SelectSuggestionDelegate
    func GetSelectValue(inputValue: String) {
        if(self.lastSelectTextFiledTag == 1)
        {
            txtCategory.text = inputValue;
        }
        else if(self.lastSelectTextFiledTag == 2)
        {
            txtName.text =  inputValue;
        }
        else if(self.lastSelectTextFiledTag == 3)
        {
            txtBuyArea.text = inputValue;
        }
        
        self.lastSelectTextFiledTag = -1;
    }
    
}
