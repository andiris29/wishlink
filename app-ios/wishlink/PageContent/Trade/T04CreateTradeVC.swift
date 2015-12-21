//
//  T04CreateTradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T04CreateTradeVC: RootVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate, CSActionSheetDelegate,WebRequestDelegate,T11SearchSuggestionDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var selectPhotoView: UIView!
    
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtRemark: UITextView!
    @IBOutlet weak var txtCount: UITextField!
    @IBOutlet weak var txtSize: UITextField!
    @IBOutlet weak var txtBuyArea: UITextField!
    @IBOutlet weak var txtUnit: UITextField!
    
    @IBOutlet weak var iv1_bg: UIImageView! // tag:61
    @IBOutlet weak var iv2_bg: UIImageView!
    @IBOutlet weak var iv3_bg: UIImageView!
    @IBOutlet weak var iv4_bg: UIImageView!
    @IBOutlet weak var iv5_bg: UIImageView!
    
    @IBOutlet weak var iv1: UIImageView! // tag:51
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
    @IBOutlet weak var constrat_remarkView_Height: NSLayoutConstraint!
    var actionSheet: CSActionSheet!
    var item:ItemModel!
    //    var t05VC:T05PayVC!
    var imgArr:[UIImage]!
    
    var imgEmpty:UIImage! = UIImage(named: "T08bbb");
    var imgSelect:UIImage! = UIImage(named: "T04_Img_Select");
    var defaultRemark="填写其他补充信息";
    
    var contentOffsetY:CGFloat! = 0;
    var oldContentOffsetY:CGFloat! = 0;
    var newContentOffsetY:CGFloat! = 0;
    var OrginFrame :CGRect!
    //MARK:Life Cycle
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
        self.txtRemark.text = defaultRemark;
        
        self.constrain_ImgBtn_Width.constant = (ScreenWidth - (7*8))/5
        //点击手势
        self.sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"));
        
        self.constraint_viewHeight.constant = 50;//UIHEPLER.ResizeHeightWithFullScreen(50.0);
        self.constrat_remarkView_Height.constant = 65//UIHEPLER.ResizeHeightWithFullScreen(65.0);
        self.constraint_topViewHieght.constant=120//UIHEPLER.ResizeHeightWithFullScreen(120);
        
        self.loadImagesData();
        csActionSheet()
        
        
        
    }

    override func viewWillAppear(animated: Bool) {
        
        OrginFrame = self.tabBarController?.tabBar.frame;
        self.navigationController?.navigationBarHidden = false;
        self.item = nil;
        self.loadComNavTitle("发布新订单")
        self.loadComNaviLeftBtn()
        
        
    }
    override func leftNavBtnAction(button: UIButton) {
        var tvc:TabBarVC! =  self.tabBarController as? TabBarVC
        tvc!.selectedIndex = tvc!.lastIndex ;
        
    }
    
    
    //MARK:Private
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
    func checkInput()->String{
        
        let result = "";
        self.dismissKeyboard();
        
        if(txtCategory.text!.trim().length == 0)
        {
            return "品牌不能为空"
        }
        if(txtName.text!.trim().length == 0)
        {
            return "品名不能为空"
        }
        if(txtBuyArea.text!.trim().length == 0)
        {
            return "购买地不能为空"
        }
        if(txtPrice.text!.trim().length == 0)
        {
            return "出价不能为空"
        }
        if(txtUnit.text!.trim().length == 0)
        {
            return "单位不能为空"
        }
        
        if(txtSize.text!.trim().length == 0)
        {
            return "规格不能为空"
        }
        
        if(txtCount.text!.trim().length == 0)
        {
            return "数量不能为空"
        }
        
        if(self.imgArr == nil || self.imgArr.count == 0)
        {
            return "请上传图片"
        }
        return result;
        
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
        self.txtUnit.text = "";
        self.dataArr = nil;
        self.imgArr = nil;
        loadImagesData();
    }
    func submit()
    {
        SVProgressHUD.showWithStatusWithBlack("请稍后...")
        self.view.userInteractionEnabled = false;
        let apiurl = APPCONFIG.SERVICE_ROOT_PATH + "item/create"
        upload(
            .POST,
            apiurl,
            multipartFormData: {
                multipartFormData in
                
                multipartFormData.appendBodyPart(data: self.txtName.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "name")
                multipartFormData.appendBodyPart(data: self.txtCategory.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "brand")
                multipartFormData.appendBodyPart(data: self.txtBuyArea.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "country")
                
                
                let price =    self.txtPrice.text!.trim().uppercaseString.stringByReplacingOccurrencesOfString("RMB", withString: "").stringByReplacingOccurrencesOfString("/", withString: "");
                
                
                multipartFormData.appendBodyPart(data: price.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "price")
                multipartFormData.appendBodyPart(data: self.txtSize.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "spec")
                multipartFormData.appendBodyPart(data: self.txtRemark.text.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "notes")
                multipartFormData.appendBodyPart(data: self.txtUnit.text!.trim().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "unit")
                //                if(self.imagrArr.count>0)
                if(self.imgArr != nil && self.imgArr.count > 0)
                {
                    if(self.imgArr.count > 0)
                    {
                        let imgName = "item_a"
                        let imageData = UIHEPLER.compressionImageToDate(self.iv1.image!);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                    if(self.imgArr.count > 1)
                    {
                        
                        let imgName = "item_b"
                        let imageData = UIHEPLER.compressionImageToDate(self.iv2.image!);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                    if(self.imgArr.count > 2)
                    {
                        let imgName = "item_c"
                        let imageData = UIHEPLER.compressionImageToDate(self.iv3.image!);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                    if(self.imgArr.count > 3)
                    {
                        let imgName = "item_d"
                        let imageData = UIHEPLER.compressionImageToDate(self.iv4.image!);
                        
                        let imgStream  = NSInputStream(data: imageData);
                        let len =   UInt64(imageData.length)
                        
                        multipartFormData.appendBodyPart(stream:imgStream, length:len, name: imgName, fileName: imgName, mimeType: "image/jpeg")
                    }
                    if(self.imgArr.count > 4)
                    {
                        let imgName = "item_e"
                        let imageData = UIHEPLER.compressionImageToDate(self.iv5.image!);
                        
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
                            
                            self.view.userInteractionEnabled = true;
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
    //IBAction
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
                    UIHEPLER.showLoginPage(self,isToHomePage: false);
                }
            }
        }
        else
        {
            self.selectTag = tag;
            if(tag >= 41 && tag <= 45)//上传图片
            {
                self.dismissKeyboard();
                self.sv.setContentOffset(CGPoint(x: 0, y: 0), animated: true);
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
        
        let button: UIButton = sender.view as! UIButton
        let deleteButtonTag: Int = button.tag / 10 * 100 + button.tag % 40
        let deleteButton: UIButton = self.selectPhotoView.viewWithTag(deleteButtonTag) as! UIButton
        let iv: UIImageView = self.selectPhotoView.viewWithTag(button.tag + 10) as! UIImageView
        
        if iv.image != nil {
            
            for var index = 401; index <= 405; index++ {
                
                let deleteButton: UIButton = self.selectPhotoView.viewWithTag(index) as! UIButton
                deleteButton.hidden = true
            }
            
            deleteButton.hidden = false
            
        }
    }
    
 
    
    @IBAction func textFieldBegin(sender: UITextField) {
        
        let viewframe: CGRect = sender.convertRect(view.frame, toView: self.sv)
        let spaceY = ScreenHeight - viewframe.origin.y
        
        if(sender.tag == 4)//价格自动去掉RMB，
        {
            var orginStr=sender.text?.trim().uppercaseString;
            if(orginStr?.length > 0)
            {
                orginStr = orginStr?.stringByReplacingOccurrencesOfString("RMB", withString: "")
                orginStr = orginStr?.componentsSeparatedByString("/")[0]
                sender.text = orginStr
            }
            
        }
        
        if spaceY < 300 {
            self.sv.setContentOffset(CGPoint(x: 0, y: 345 - spaceY), animated: true)
        }
    }
    @IBAction func textFieldEnd(sender: UITextField) {
        
        if(sender.tag == 4) {
            
            var orginStr=sender.text?.trim().uppercaseString
            if orginStr?.length < 1 { return }
            
            orginStr = orginStr?.stringByReplacingOccurrencesOfString("RMB", withString: "")
            orginStr = orginStr?.componentsSeparatedByString("/")[0]
            if let originNumber = Double(orginStr!) {
                
                orginStr = NSString(format: "%.2f", originNumber) as String
            }
            orginStr = "RMB " + orginStr!
            sender.text = orginStr
            
            let unit: String = (self.sv.viewWithTag(5) as! UITextField).text!
            if unit.length < 1 { return }
            orginStr = orginStr! + "/" + unit
            sender.text = orginStr
            
        } else if (sender.tag == 5){
            
            let orginStr=sender.text?.trim()
            if orginStr?.length < 1 { return }
            
            let unitTextField: UITextField = self.sv.viewWithTag(4) as! UITextField
            var unit: String = unitTextField.text!
            if unit.length < 1 { return }
            unit = unit.componentsSeparatedByString("/")[0]
            unit = unit + "/" + orginStr!
            unitTextField.text = unit
            
        }
        self.sv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    //弹出图片上传选择框
    func imgHeadChange(index: Int) {
        
        if index == 1001 {
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self;
            self.presentViewController(imagePicker, animated: true, completion: nil);
        } else if index == 1002 {
            
            let imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self;
                self.presentViewController(imagePicker, animated: true, completion: nil);
            }
        }
    }
    
    //MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //        let icount = self.imagrArr.count;
        let gotImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
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
        contentOffsetY = scrollView.contentOffset.y;
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oldContentOffsetY = scrollView.contentOffset.y;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //NSLog(@"scrollView.contentOffset:%f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
        
        newContentOffsetY = scrollView.contentOffset.y;
        
        if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {  // 向上滚动
            
            NSLog("up");
            
        } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
            
            NSLog("down");
            
        } else {
            
            NSLog("dragging");
            
        }
        if (scrollView.dragging) {  // 拖拽
            
            NSLog("scrollView.dragging");
            NSLog("contentOffsetY: %f", contentOffsetY);
            NSLog("newContentOffsetY: %f", scrollView.contentOffset.y);
            if ((scrollView.contentOffset.y - contentOffsetY) > 5.0) {  // 向上拖拽
                // 隐藏导航栏和选项栏
                
                // [self layoutView];
                //                self.navigationController?.setNavigationBarHidden(true, animated: true);
                
                
                
            } else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0) {   // 向下拖拽
                
                // 显示导航栏和选项栏
                //                self.navigationController?.setNavigationBarHidden(false, animated: true);
                
            } else {
                
            }
            
        }
        
        
    }
    
    func hideTabBar(){
        //Swift中调用animateWithDuration方法
        self.tabBarController?.tabBar.hidden = true
        UIView.animateWithDuration(0.5, animations: alphaDown)
    }
    func alphaDown(){
        //        bgImageView!.alpha = 0
        
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
 
    
    //MARK:UItextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            self.txtRemark.resignFirstResponder();
            return false;
        }
        return true;
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        let viewframe: CGRect = textView.convertRect(view.frame, toView: self.sv)
        let spaceY = ScreenHeight - viewframe.origin.y
        if(textView.text.trim() == defaultRemark )
        {
            textView.text = "";
            textView.textColor = UIColor.blackColor();
        }
        if spaceY < 300 {
            self.sv.setContentOffset(CGPoint(x: 0, y:  spaceY), animated: true)
        }
        
    }
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text.trim() == "")
        {
            
            textView.text = defaultRemark
            textView.textColor = UIColor.grayColor();
        }
        
        self.sv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
            
            var vc:T05PayVC! = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
            
            vc.item = self.item;
            vc.trade = tradeItem;
            vc.isNewOrder = true;
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
            vc = nil;
            
        }
    }
    func requestDataFailed(error: String,tag:Int) {
        
        SVProgressHUD.dismiss();
        UIHEPLER.alertErrMsg(error);
        
    }
    
    
}
