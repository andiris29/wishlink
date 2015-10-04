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

class U03SettingVC: RootVC, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate, WebRequestDelegate{
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    var uploadImageRequest: Request!
    var uploadImageType: SettingVCUploadImageType = .None
    var isUploadHeadImage: Bool!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = false
        
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
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - delegate
    
    func requestDataFailed(error: String) {
        SVProgressHUD.dismiss()
        UIHelper().alertErrMsg(error)
    }
    
    func requestDataComplete(response: AnyObject, tag: Int) {
        if tag == 10 {
            SVProgressHUD.dismiss()
            UserModel.shared.isLogin = false
            AppConfig().userLogout()
        }
    }
    
    // MARK: -- UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if self.uploadImageType == .Portrait {
            self.headImageView.image = gotImage
        }
        else if self.uploadImageType == .Background{
            self.bgImageView.image = gotImage
        }
        self.uploadImage()
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
            
            //            UIHelper.saveEditImageToLocal(gotImage, strName: "UserHead.jpg")
            var imgData = UIImageJPEGRepresentation(gotImage, 1.0)
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - response event
    
    @IBAction func btnAction(sender: UIButton) {
        var tag = sender.tag ;
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
            var vc = U03AddressManagerVC(nibName: "U03AddressManagerVC", bundle: NSBundle.mainBundle())
            
            self.navigationController?.pushViewController(vc, animated: true);
        case 103:
            println("常见问题")
        case 104:
            // 退出登录
            self.logout();
        default:
            println("1111")
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // MARK: - prive method
    
    func logout() {
        SVProgressHUD.showInfoWithStatus("请稍等...")
        if let registrationId = APService.registrationID() {
            self.httpObj.httpPostApi("user/logout", parameters: ["registrationId": registrationId], tag: 10)
        }else {
            UserModel.shared.isLogin = false
            AppConfig().userLogout()
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: 上传图片
    func uploadImage () {
        var urlString = "http://121.41.162.102:80/services/"
        var imageData: NSData
        switch self.uploadImageType {
        case .Portrait:
            urlString = urlString + "user/updatePortrait"
            imageData = UIImageJPEGRepresentation(self.headImageView.image!, 1.0)
        case .Background:
            urlString = urlString + "user/updateBackground"
            imageData = UIImageJPEGRepresentation(self.bgImageView.image!, 1.0)
        default:
            return
        }
    }
    
    //MARK:弹出图片上传选择框
    func imgHeadChange()
    {
        var alertController = UIAlertController(title: "上传图片", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:  {
            (action: UIAlertAction!) -> Void in
            
        })
        var deleteAction = UIAlertAction(title: "拍照上传", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) -> Void in
            
            var imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.delegate = self;
                self.presentViewController(imagePicker, animated: true, completion: nil);
            }
        })
        var archiveAction = UIAlertAction(title: "从相册中选择", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) -> Void in
            
            var imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self;
            self.presentViewController(imagePicker, animated: true, completion: nil);
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
