//
//  T04CreateTradeVC.swift
//  wishlink
//
//  Created by whj on 15/8/19.
//  Copyright (c) 2015年 edonesoft. All rights reserved.
//

import UIKit

class T04CreateTradeVC: RootVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate, CSActionSheetDelegate,WebRequestDelegate {

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
        if(tag==11)//确认发布
        {
            var errmsg = checkInput();
            if(errmsg != "")
            {
                UIHEPLER.alertErrMsg(errmsg);
            }
            else
            {
                
                
                var para:[String:AnyObject] = ["name":txtName.text.trim(),
                    "brand":txtCategory.text.trim(),
                    "country":txtBuyArea.text.trim(),
                    "price":txtPrice.text.trim().toInt()!,
                    "spec":txtSize.text.trim(),
                    "comment":txtRemark.text.trim()
//                    "file_a":(self.imagrArr.count>0?self.imagrArr[0]:"")
                ]
                
                SVProgressHUD.showWithStatusWithBlack("请稍后...")
            
              var apiurl = SERVICE_ROOT_PATH + "item/create"
                
                
                let URL = NSURL(string: apiurl)!
                var _request = NSURLRequest(URL: URL)
                
               
       
                
                
                
                
                
//                 request_.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
//                request(request_).responseJSON() {
//                    (_, _, data, error) in
//
//
//                    if(error == nil)
//                    {
//                        NSLog("respone:%@",data!.description)
//
//                    }
//                    else
//                    {
//                        
//                    }
//                    
//                }

                
//                let custom: (URLRequestConvertible, [String: AnyObject]?) -> (NSURLRequest, NSError?) = {
//                    (URLRequest, parameters) in
//                    let mutableURLRequest = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
//                    mutableURLRequest.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
//                    mutableURLRequest.HTTPBody = body
//                    return (mutableURLRequest, nil)
//                }
//                
//                request(.POST, apiurl, parameters: nil, encoding: .Custom(custom)).responseJSON() {
//                    (_, _, data, error) in
//                    
//                    
//                    if(error == nil)
//                    {
//                        NSLog("respone:%@",data!.description)
//                  
//                    }
//                    else
//                    {
//                        
//                    }
//                    
//                }
                

                
//                self.httpObj.httpPostApi("item/create", parameters: para, tag: 11);
//
                var vc = T05PayVC(nibName: "T05PayVC", bundle: NSBundle.mainBundle());
                self.navigationController?.pushViewController(vc, animated: true);
            }
        }
        else
        {
            actionSheet.show(true)
        }

    }
    
    func checkInput()->String{
        
        var result = "";
        
        var category = txtCategory.text.trim();
        if(category.length == 0)
        {
            return "品牌不能为空"
        }
        var name = txtName.text.trim();
        if(name.length == 0)
        {
            return "品名不能为空"
        }
        var country = txtBuyArea.text.trim();
        if(country.length == 0)
        {
            return "购买地不能为空"
        }
        var price = txtPrice.text.trim();
        if(price.length == 0)
        {
            return "出价不能为空"
        }
        var spec = txtSize.text.trim();
        if(spec.length == 0)
        {
            return "规格不能为空"
        }
        
        var count = txtCount.text.trim();
        if(count.length == 0)
        {
            return "数量不能为空"
        }
        return result;
        
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
    
    //MARK:UItextFiledDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.dismissKeyboard();
        return true;
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            
            self.txtRemark.resignFirstResponder();
            
            return false;
        }
        
        return true;
    }

    //WebrequestDelegate
    func requestDataComplete(response: AnyObject, tag: Int) {
        if(tag == 11)//item创建成功,准备创建trade
        {
            var itemdic = response as! NSDictionary;
            var item = itemModel(dict: itemdic);
            print(item);
            if(item._id.length>0)
            {
                
                var para  = ["itemRef":item._id,
                    "quantity":self.txtCount.text];
                self.httpObj.httpPostApi("trade/create", parameters: para, tag: 12);
            }
        }
        else if(tag == 12)//trade创建成功,准备页面跳转
        {
            SVProgressHUD.dismiss();
            
        }
    }
    func requestDataFailed(error: String) {
        
        SVProgressHUD.dismiss();
        UIHEPLER.alertErrMsg(error);
        
    }
    
}
