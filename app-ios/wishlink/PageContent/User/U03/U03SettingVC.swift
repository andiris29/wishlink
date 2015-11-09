//
//  U03SettingVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/19/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

enum SettingVCUploadImageType {
    case None, Portrait, Background
}

let LogoutNotification: String = "LogoutNotification"

class U03SettingVC: RootVC, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate, WebRequestDelegate{
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    var uploadImageRequest: Request!
    var uploadImageType: SettingVCUploadImageType = .None
    var isUploadHeadImage: Bool!
    var userModel = UserModel.shared
    
    weak var userVC: U02UserVC!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.httpObj.mydelegate = self
        self.fillDataForUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController!.navigationBar.hidden = false
        
        self.loadComNaviLeftBtn()
        self.loadComNavTitle("个人设置")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headImageView.layer.cornerRadius = CGRectGetWidth(self.headImageView.frame) * 0.5
        self.headImageView.layer.masksToBounds = true
        self.bgImageView.layer.cornerRadius = CGRectGetWidth(self.bgImageView.frame) * 0.5
        self.bgImageView.layer.masksToBounds = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - delegate
    
    func requestDataFailed(error: String,tag:Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            UIHelper().alertErrMsg(error)
        })
    }
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            self.view.userInteractionEnabled = true
        })
        if tag == 10 {
            
            
            
            // 注销
            UserModel.shared.logout()
            AppConfig().userLogout()
            
      
            self.logOutAction();

            
            
        }else if tag == 20 {
            // update user
            if let userDic = response["user"] as? NSDictionary {
                self.userModel.userDic = userDic as! [String : AnyObject]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.showSuccessWithStatusWithBlack("个人信息修改成功")
                    self.fillDataForUI()
                })
            }
        }
    }
    
    
    //跳转到Tab 第一个选项卡，并popup登录页面  －－update by andy.chen 2015-10-18
    func logOutAction()
    {
        let tababarController =  UIHEPLER.GetAppDelegate().window!.rootViewController as! UITabBarController
        tababarController.selectedIndex = 0;
        let vc = UIHEPLER.GetAppDelegate().window?.rootViewController
        vc?.navigationController?.popToRootViewControllerAnimated(false)
        UIHEPLER.showLoginPage(vc!,isToHomePage: true);
    }
    
    // MARK: -- UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.updateUser()
        return true
    }
    
    //MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if self.uploadImageType == .Portrait {
            self.headImageView.image = gotImage
            self.updatePortrait()
        }
        else if self.uploadImageType == .Background{
            self.bgImageView.image = gotImage
            self.updateBackground()
        }
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
            
            //            UIHelper.saveEditImageToLocal(gotImage, strName: "UserHead.jpg")
//            var imgData = UIImageJPEGRepresentation(gotImage, 1.0)
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - response event
    
    @IBAction func btnAction(sender: UIButton) {
        let tag = sender.tag ;
        switch tag {
        case 100:
            // 上传头像
            self.uploadImageType = .Portrait
            self.imgHeadChange()
        case 101:
            // 上传背景图片
            self.uploadImageType = .Background
            self.imgHeadChange()
        case 102:
            // 地址管理
            let vc = U03AddressManagerVC(nibName: "U03AddressManagerVC", bundle: NSBundle.mainBundle())
            
            userVC.navigationController?.pushViewController(vc, animated: true);
        case 103:
            print("常见问题")
        case 104:
            // 退出登录
            self.logout();
        case 105:
            let numString = "telprompt://021-64269893"
            APPLICATION.openURL(NSURL(string: numString)!)
        default:
            print("1111")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - prive method
    
    func validateNickname() -> Bool{
        if self.nicknameTextField.text != nil {
            if self.nicknameTextField.text == self.userModel.nickname {
                return false
            }
            
            // TODO 验证nickname合法性
            return true
        }
        else {
            return false
        }
    }
    
    func updateUser() {
        if self.validateNickname() == false {
            return
        }
        let dic = [
            "nickname": self.nicknameTextField.text!,
            "alipay.id": "test@gmail.com"
        ]
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        self.httpObj.httpPostApi("user/update", parameters: dic, tag: 20)
    }
    
    // MARK:
    func updatePortrait() {
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        self.view.userInteractionEnabled = false
        let apiurl = APPCONFIG.SERVICE_ROOT_PATH + "user/updatePortrait"
        upload(.POST, apiurl, headers: nil, multipartFormData: {
            (multipartFormData) -> Void in
            let imageName = "portrait"
            let imageData = UIHEPLER.compressionImageToDate(self.headImageView.image!)
            let imageStream = NSInputStream(data: imageData)
            let len = UInt64(imageData.length)
            multipartFormData.appendBodyPart(stream:imageStream, length:len, name: imageName, fileName: imageName, mimeType: "image/jpeg")
            
            }) {
                encodingResult in
                switch encodingResult {
                case .Success(let _upload, _, _ ):
                    _upload.responseJSON(completionHandler: { (requst, response, result) -> Void in
                        switch result {
                        case .Success(let json):
                            if let dic = json["data"] as? NSDictionary {
                                self.userModel.userDic = dic["user"] as! [String : AnyObject]
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    SVProgressHUD.showSuccessWithStatusWithBlack("头像上传成功")
                                    self.view.userInteractionEnabled = true
                                    self.fillDataForUI()
                                })
                            }
                        case .Failure(let error):
                            SVProgressHUD.showErrorWithStatusWithBlack("头像上传失败")
                            print(error)
                        }
                        
                    })
                case .Failure(let encodingError):
                    SVProgressHUD.showErrorWithStatusWithBlack("头像上传失败")
                    print(encodingError)
                }
        }
    }
    
    func updateBackground() {
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        self.view.userInteractionEnabled = false
        let apiurl = APPCONFIG.SERVICE_ROOT_PATH + "user/updateBackground"
        upload(.POST, apiurl, headers: nil, multipartFormData: {
            (multipartFormData) -> Void in
            let imageName = "background"
            let imageData = UIHEPLER.compressionImageToDate(self.bgImageView.image!)
            let imageStream = NSInputStream(data: imageData)
            let len = UInt64(imageData.length)
            multipartFormData.appendBodyPart(stream:imageStream, length:len, name: imageName, fileName: imageName, mimeType: "image/jpeg")
            
            }) {
                encodingResult in
                switch encodingResult {
                case .Success(let _upload, _, _ ):
                    _upload.responseJSON(completionHandler: { (requst, response, result) -> Void in
                        switch result {
                        case .Success(let json):
                            if let dic = json["data"] as? NSDictionary {
                                self.userModel.userDic = dic["user"] as! [String : AnyObject]
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    SVProgressHUD.showSuccessWithStatusWithBlack("背景图片上传成功")
                                    self.view.userInteractionEnabled = true
                                    self.fillDataForUI()
                                })
                            }
                        case .Failure(let error):
                            SVProgressHUD.showErrorWithStatusWithBlack("背景图片上传失败")
                            print(error)
                        }
                        
                    })
                case .Failure(let encodingError):
                    SVProgressHUD.showErrorWithStatusWithBlack("背景图片上传失败")
                    print(encodingError)
                }
        }
    }
    
    func logout() {
        SVProgressHUD.showWithStatusWithBlack("请稍等...")
        if let registrationId = APService.registrationID() {
            self.httpObj.httpPostApi("user/logout", parameters: ["registrationId": registrationId], tag: 10)
        }else {
            UserModel.shared.logout()
            AppConfig().userLogout()
            SVProgressHUD.dismiss()
            NSNotificationCenter.defaultCenter().postNotificationName(LogoutNotification, object: nil)
            
            self.logOutAction();
            

            
        }
    }
    
    //MARK:弹出图片上传选择框
    func imgHeadChange()
    {
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: "上传图片", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:  {
                (action: UIAlertAction) -> Void in
                
            })
            let deleteAction = UIAlertAction(title: "拍照上传", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction) -> Void in
                
                let imagePicker = UIImagePickerController()
                if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                    imagePicker.delegate = self;
                    self.userVC.presentViewController(imagePicker, animated: true, completion: nil);
                }
            })
            let archiveAction = UIAlertAction(title: "从相册中选择", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction) -> Void in
                
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.delegate = self;
                self.userVC.presentViewController(imagePicker, animated: true, completion: nil);
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            alertController.addAction(archiveAction)
            
            self.userVC.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func fillDataForUI() {
        self.nicknameTextField.text = self.userModel.nickname
        self.httpObj.renderImageView(self.headImageView, url: self.userModel.portrait, defaultName: "")
        self.httpObj.renderImageView(self.bgImageView, url: self.userModel.background, defaultName: "")
    }
    
    // MARK: - setter and getter
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}







