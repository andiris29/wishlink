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
    
    @IBOutlet weak var iv1_bg: UIImageView!
    @IBOutlet weak var iv2_bg: UIImageView!
    @IBOutlet weak var iv3_bg: UIImageView!
    @IBOutlet weak var iv4_bg: UIImageView!
    @IBOutlet weak var iv5_bg: UIImageView!
    
    @IBOutlet weak var iv1: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv4: UIImageView!
    @IBOutlet weak var iv5: UIImageView!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    @IBOutlet weak var btn1_del: UIButton!
    @IBOutlet weak var btn2_del: UIButton!
    @IBOutlet weak var btn3_del: UIButton!
    @IBOutlet weak var btn4_del: UIButton!
    @IBOutlet weak var btn5_del: UIButton!
    //5张上传图片的宽度
    @IBOutlet weak var constrain_ImgBtn_Width: NSLayoutConstraint!
    //顶部标题View的高度约束
    @IBOutlet weak var constraint_topViewHieght: NSLayoutConstraint!
    //通用View高度约束
    @IBOutlet weak var constraint_viewHeight: NSLayoutConstraint!
    var actionSheet: CSActionSheet!
    var item:ItemModel!
    var t05VC:T05PayVC!
    var imgArr:[UIImage]!
    
    var imgEmpty:UIImage! = UIImage(named: "T08bbb");
    var imgSelect:UIImage! = UIImage(named: "T04_Img_Select");
    
  
    //MARK:System func
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
        
  
        self.constrain_ImgBtn_Width.constant = (ScreenWidth - (7*8))/5
        self.sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"));
        self.loadImagesData();
        csActionSheet()
        
        
    }

    override func viewWillAppear(animated: Bool) {
        
     
        
        
        if(self.t05VC != nil)
        {
            self.t05VC.view.removeFromSuperview();
            self.t05VC.view  = nil;
            self.t05VC = nil;
        }
        
        self.constraint_viewHeight.constant = UIHEPLER.resizeHeight(50.0);
        self.constraint_topViewHieght.constant=UIHEPLER.resizeHeight(120);
        
        self.navigationController?.navigationBarHidden = false;
        
        self.item = nil;
        
        self.loadComNavTitle("发布新订单")
        
        self.navigationController?.navigationBarHidden = false;
        
    }
    
    //MARK:Customer func
    func loadImagesData()
    {
        self.btn1_del.hidden = true;
        self.btn2_del.hidden = true;
        self.btn3_del.hidden = true;
        self.btn4_del.hidden = true;
        self.btn5_del.hidden = true;
        self.iv1.image = nil
        self.iv2.image = nil
        self.iv3.image = nil
        self.iv4.image = nil
        self.iv5.image = nil
        
        self.iv1_bg.image = imgEmpty
        self.iv2_bg.image = imgEmpty
        self.iv3_bg.image = imgEmpty
        self.iv4_bg.image = imgEmpty
        self.iv5_bg.image = imgEmpty
        
    
        if(self.imgArr != nil && self.imgArr.count>0)
        {
            
            if(self.imgArr.count>=1)
            {
                self.iv1.image = self.imgArr[0]
                self.iv1_bg.image = imgSelect
            }
            if(self.imgArr.count>=2)
            {
                self.iv2.image = self.imgArr[1]
                self.iv2_bg.image = imgSelect
            }
            if(self.imgArr.count>=3)
            {
                self.iv3.image = self.imgArr[2]
                self.iv3_bg.image = imgSelect
            }
            if(self.imgArr.count>=4)
            {
                self.iv4.image = self.imgArr[3]
                self.iv4_bg.image = imgSelect
            }
            if(self.imgArr.count>=5)
            {
                self.iv5.image = self.imgArr[4]
                self.iv5_bg.image = imgSelect
                
            }
            
        }
    }

    


    func csActionSheet() {
        
        let titles: Array<String> = ["取消", "从手机相册中选择", "拍照"]
        actionSheet = CSActionSheet.sharedInstance
        actionSheet.bindWithData(titles, delegate: self)
    }
    
    func submit()
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
                multipartFormData.appendBodyPart(data: self.txtRemark.text.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "notes")
//                if(self.imagrArr.count>0)
                if(self.imgArr != nil && self.imgArr.count>0)
                {
                    if(self.imgArr.count == 1)
                    {
                        let imgName = "item_a.jpg"
                        let imageData = UIHEPLER.compressionImageToDate(self.imgArr[0]);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                    if(self.imgArr.count>1)
                    {
                        
                        let imgName = "item_b.jpg"
                        let imageData = UIHEPLER.compressionImageToDate(self.imgArr[1]);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                    if(self.imgArr.count>2)
                    {
                        let imgName = "item_c.jpg"
                        let imageData = UIHEPLER.compressionImageToDate(self.imgArr[2]);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                    if(self.imgArr.count>3)
                    {
                        let imgName = "item_d.jpg"
                        let imageData = UIHEPLER.compressionImageToDate(self.imgArr[3]);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                    if(self.imgArr.count>4)
                    {
                        let imgName = "item_e.jpg"
                        let imageData = UIHEPLER.compressionImageToDate(self.imgArr[4]);
                        
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
                                let metaDic:NSDictionary! =  json.objectForKey("metadata") as? NSDictionary
                                var errorMsg = "提交数据失败！"
                                if(metaDic != nil && metaDic.count>0)
                                {
                                
                                    var errCode  = 0;
                                    var errDesc = "";
                                    let errDic = metaDic.objectForKey("devInfo") as! NSDictionary;
                                    if(errDic.count>0)
                                    {
                                        errCode =  errDic.objectForKey("errorCode") as! Int;
                                        errDesc =  errDic.objectForKey("description") as! String;
                                        errorMsg = "ErrorCode:\(errCode) \(errDesc)";
                                    }
                                    
                                    if(errCode == 1001 || errDesc == "ERR_NOT_LOGGED_IN")
                                    {
                                        UserModel.shared.logout()
                                    }
                                }
                                
                                SVProgressHUD.showErrorWithStatusWithBlack(errorMsg);
                                self.view.userInteractionEnabled = true;
                                NSLog("Fail:"+errorMsg);
                                
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

    
    var selectTag:Int!
//    var startTime:Double = 0;
//    @IBAction func touchDownAction(sender: AnyObject) {
//        self.selectTag = (sender as! UIButton).tag;
//   
//        
//        let timeNow:NSTimeInterval = NSDate().timeIntervalSince1970;
//        self.startTime = timeNow;
//        
//        print("touchDownAction")
//        //开启定时器
//    }
    @IBAction func btnAction(sender: UIButton) {
        //关闭定时器
        print("btnAction")
        
        
        
        let tag = sender.tag;
        if(tag==11)//确定发布   
        {
            let errmsg =  checkInput();
            if(errmsg != "")
            {
                UIHEPLER.alertErrMsg(errmsg);
            }
            else
            {
                if(UserModel.shared.isLogin)
                {
                    self.submit()
                }
                else
                {
                    UIHEPLER.showLoginPage(self);
                }
            }
        }
        else
        {
            self.selectTag = tag;
            if(tag >= 41 && tag <= 45)//上传图片
            {
                actionSheet.show(true)
                
            }
            else if(tag>=401 && tag <= 405)//删除图片
            {
                self.selectTag = tag;
                let index = tag - 401;
                
                self.imgArr.removeAtIndex(index);
                self.loadImagesData();
            }
        }
    }
 
    
    @IBAction func buttonLongPressAction(sender: AnyObject) {
        print("==>>:\(sender)")
        
      
        var isShowDel = false;
            if(self.iv1.image != nil)
            {
                self.btn1_del.hidden = false;
                isShowDel = true
            }
            if(self.iv2.image != nil)
            {
                self.btn2_del.hidden = false;
                isShowDel = true
            }
            if(self.iv3.image != nil)
            {
                self.btn3_del.hidden = false;
                isShowDel = true
            }
            if(self.iv4.image != nil)
            {
                self.btn4_del.hidden = false;
                isShowDel = true
            }
            if(self.iv5.image != nil)
            {
                self.btn5_del.hidden = false;
                isShowDel = true
            }
            if(!isShowDel)
            {
                actionSheet.show(true)
            }
       
        
        
    }
    
      func checkInput()->String{
        
        let result = "";
        self.dismissKeyboard();
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
        
        if(self.imgArr == nil || self.imgArr.count == 0)
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
//    var pickImageCount = 0;
    
    //MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
//        let icount = self.imagrArr.count;
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in

            
            if(self.imgArr == nil || self.imgArr == [] || self.imgArr.count == 0)
            {
                self.imgArr = [];
                self.imgArr.append(gotImage);
                self.iv1.image = gotImage;
                self.iv1_bg.image = self.imgSelect
            }
            else if(self.imgArr.count == 1)
            {
                self.imgArr.append(gotImage);
                self.iv2.image = gotImage;
                self.iv2_bg.image = self.imgSelect
            }
            else if(self.imgArr.count == 2)
            {
                self.imgArr.append(gotImage);
                self.iv3.image = gotImage;
                self.iv3_bg.image = self.imgSelect
            }
            else if(self.imgArr.count == 3)
            {
                self.imgArr.append(gotImage);
                self.iv4.image = gotImage;
                self.iv4_bg.image = self.imgSelect
            }
            else if(self.imgArr.count == 4)
            {
                self.imgArr.append(gotImage);
                self.iv5.image = gotImage;
                self.iv5_bg.image = self.imgSelect
            }
            
//            var imgData = UIImageJPEGRepresentation(gotImage, 1.0)
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: hidden keyboard
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
    //MARK: scrollViewDelegate: hidden keyboard
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
            
            self.sv.contentOffset.y = self.sv.contentOffset.y + 200
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
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {//结束编辑
        if(textField.tag>3 || textField.tag == 0)
        {
            self.sv.contentOffset.y = self.sv.contentOffset.y - 200
        }
        return true
    }
    
    //MARK:UItextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            
            self.txtRemark.resignFirstResponder();
            
            return false;
        }
        
        return true;
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        self.sv.contentOffset.y = self.sv.contentOffset.y + 200
        return true
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        self.sv.contentOffset.y = self.sv.contentOffset.y - 200
        return true
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
    func clearInput()
    {
        self.txtCategory.text = "";
        self.txtName.text = "";
        self.txtPrice.text = "";
        self.txtRemark.text = "";
        self.txtCount.text = "";
        self.txtSize.text = "";
        self.txtBuyArea.text = "";
//        self.iv0.image = nil;
//        self.iv1.image = nil;
//        self.iv2.image = nil;
//        self.iv3.image = nil;
        self.dataArr = nil;
        self.imgArr = nil;
        loadImagesData();
    }

    //MARK: WebrequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
     if(tag == 12)//trade创建成功,准备页面跳转
        {
            self.clearInput();
            SVProgressHUD.dismiss();
            let dic = response as! NSDictionary;
            let tradeDic = dic.objectForKey("trade") as!  NSDictionary;
            let tradeItem = TradeModel(dict: tradeDic);
            
            if(self.t05VC == nil)
            {
                self.t05VC = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            }
            self.t05VC.item = self.item;
            self.t05VC.trade = tradeItem;
            self.t05VC.isNewOrder = true;
            self.navigationController?.pushViewController(self.t05VC, animated: true);
            
        }
    }
    func requestDataFailed(error: String,tag:Int) {
        
        SVProgressHUD.dismiss();
        UIHEPLER.alertErrMsg(error);
        
    }

    
}
