//
//  WebRequestHelper.swift
//  landi-app
//
//  Created by Andy Chen on 6/24/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//
import Foundation
@objc protocol WebRequestDelegate  {
    
    
    func requestDataComplete(response:AnyObject,tag:Int)
    func requestDataFailed(error:String)
    optional func complateImgDownload(tag:Int,downloadImg:UIImage)
}

import UIKit
let SERVICE_ROOT_PATH = "http://idphoto.edonesoft.com/clientapi/"
class WebRequestHelper:NSObject {
    
    var mydelegate:WebRequestDelegate?
    
    func generateRequest(relative:String)->NSMutableURLRequest
    {
        var oriUrl = SERVICE_ROOT_PATH + relative
        var strUrl = oriUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url:NSURL = NSURL(string: strUrl!)!
        var token = AppConfig.sharedAppConfig.getAuthorizationString()
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        //添加请求header
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        NSLog("Request URL: %@", url);
        NSLog("Request Authorization: %@", token);
        return request;
    }
    
    func httpPostApi(apiname:String,body:String,tag:Int)
    {
        
        var request:NSMutableURLRequest = self.generateRequest(apiname);
        request.HTTPMethod = "POST";
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        NSLog("Request Body: %@", body);
        
        //跳过证书认证
        var securityPolicy : AFSecurityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
        securityPolicy.allowInvalidCertificates = true;
        //创建请求操作
        var operation:AFHTTPRequestOperation = AFHTTPRequestOperation(request: request);
        //设置安全级别
        operation.securityPolicy = securityPolicy;
        
        operation.setCompletionBlockWithSuccess({
            (operation:AFHTTPRequestOperation! , responseObject:AnyObject!) in
            
            self.handleHttpResponse(responseObject, tag: tag)
            
            },
            failure: {
                (operation:AFHTTPRequestOperation! , error:NSError!) in
                self.mydelegate?.requestDataFailed("网络不给力哦");
                
        })
        operation.start()
    }
    
    func httpGetApi(apiname:String,tag:Int)
    {
        var request:NSMutableURLRequest = self.generateRequest(apiname);
        request.HTTPMethod = "GET";
        
        //跳过证书认证
        var securityPolicy : AFSecurityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
        securityPolicy.allowInvalidCertificates = true;
        //创建请求操作
        var operation:AFHTTPRequestOperation = AFHTTPRequestOperation(request: request);
        //设置安全级别
        operation.securityPolicy = securityPolicy;
        
        operation.setCompletionBlockWithSuccess({
            (operation:AFHTTPRequestOperation! , responseObject:AnyObject!) in
            
         
            self.handleHttpResponse(responseObject, tag: tag)
            
            },
            failure: {
                (operation:AFHTTPRequestOperation! , error:NSError!) in
                self.mydelegate?.requestDataFailed("网络不给力哦");
                
        })
        operation.start()
    }
    
    func uploadImage(imageData:NSData,tag:Int)
    {
        var request:NSMutableURLRequest = self.generateRequest("system/upload/image?ext=png");
        request.HTTPMethod = "POST";
        request.HTTPBody = imageData;
        //跳过证书认证
        var securityPolicy : AFSecurityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
        securityPolicy.allowInvalidCertificates = true;
        //创建请求操作
        var operation:AFHTTPRequestOperation = AFHTTPRequestOperation(request: request);
        //设置安全级别
        operation.securityPolicy = securityPolicy;
        
        operation.setCompletionBlockWithSuccess({
            (operation:AFHTTPRequestOperation! , responseObject:AnyObject!) in
            
            self.handleHttpResponse(responseObject, tag: tag)
            
            },
            failure: {
                (operation:AFHTTPRequestOperation! , error:NSError!) in
                self.mydelegate?.requestDataFailed("网络不给力哦");
                
        })
        operation.start()
    }
    
    
    func handleHttpResponse(body:AnyObject,tag:Int)
    {
        
        
        var varData = body as! NSData;
        var datastring = NSString(data:varData, encoding:NSUTF8StringEncoding) as! String
        println("response:\r\n"+datastring);
        let dataDir:NSDictionary = datastring.objectFromJSONString() as! NSDictionary
        
        
        if(dataDir.count == 0 || dataDir.objectForKey("Code") == nil)
        {
            self.mydelegate?.requestDataFailed("网络异常,无效的响应.");
            return ;
        }
        var strCode = dataDir.objectForKey("Code") as! Int
        if(strCode == 10000)//code为1000正常的响应
        {
            var strDetail:AnyObject = dataDir.objectForKey("Detail")!
            
            self.mydelegate?.requestDataComplete(strDetail, tag: tag)
        }
        else if(strCode == 20000)//Code为20000,token令牌失效
        {
            if(AppConfig.sharedAppConfig.isUserLogin())
            {
                AppConfig.sharedAppConfig.userLogout()
            }
            return
        }
        else
        {
            var strErr = dataDir.objectForKey("Message") as! String
            println("Response Error:"+strErr);
            self.mydelegate?.requestDataFailed(strErr)
            
        }
        
    }
    func downloadImg(url:String,tag:Int)
    {
        var  encodeName = url.stringByReplacingOccurrencesOfString("/", withString: "_", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        //判断文件路径是否存在，不存在则创建
        var imagepath:String = UIHelper.getCachedFilePath("cachedimages");
        
        var fm:NSFileManager = NSFileManager.defaultManager();
        if(!fm.fileExistsAtPath(imagepath))
        {
            fm.createDirectoryAtPath(imagepath, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        //检测本读是否有该图片缓存
        imagepath = imagepath+"/"+encodeName
        var image = UIImage(contentsOfFile: imagepath);
        if (image != nil) {
            
            self.mydelegate?.complateImgDownload!(tag, downloadImg: image!)
            //iv.image = image;
            return;
        }
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!);
        request.HTTPMethod = "GET";
        
        //跳过证书认证
        var securityPolicy : AFSecurityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
        securityPolicy.allowInvalidCertificates = true;
        //创建请求操作
        var operation:AFHTTPRequestOperation = AFHTTPRequestOperation(request: request);
        //设置安全级别
        operation.securityPolicy = securityPolicy;
        
        operation.setCompletionBlockWithSuccess({
            
            
            (operation:AFHTTPRequestOperation! , responseObject:AnyObject!) in
            
            (responseObject as! NSData).writeToFile(imagepath, atomically: true)
            
            var image = UIImage(data: responseObject as! NSData)
            NSLog("Write to file:%@", imagepath);
            //显示图片
            if (image != nil) {
                self.mydelegate?.complateImgDownload!(tag, downloadImg: image!)
                
            } else {
                self.mydelegate?.requestDataFailed("下载的图片格式有问题！")
            }
            },
            failure: {
                
                (operation:AFHTTPRequestOperation! , error:NSError!) in
                self.mydelegate?.requestDataFailed(error.description)
                NSLog("Download image failed: %@", error.description);
                
        })
        operation.start()
        
        
        
    }
    
    /*
    下载网络图片并加载ImageView中，仅第一次下载，第二次开始读区缓存
    
    */
    func renderImageView(iv:UIImageView,url:String,defaultName:String)
    {
        var  encodeName = url.stringByReplacingOccurrencesOfString("/", withString: "_", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        //判断文件路径是否存在，不存在则创建
        var imagepath:String = UIHelper.getCachedFilePath("cachedimages");
        
        var fm:NSFileManager = NSFileManager.defaultManager();
        if(!fm.fileExistsAtPath(imagepath))
        {
            fm.createDirectoryAtPath(imagepath, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        //检测本读是否有该图片缓存
        imagepath = imagepath+"/"+encodeName
        var image = UIImage(contentsOfFile: imagepath);
        if (image != nil) {
            iv.image = image;
            return;
        }
        
        
        
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!);
        request.HTTPMethod = "GET";
        
        //跳过证书认证
        var securityPolicy : AFSecurityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
        securityPolicy.allowInvalidCertificates = true;
        //创建请求操作
        var operation:AFHTTPRequestOperation = AFHTTPRequestOperation(request: request);
        //设置安全级别
        operation.securityPolicy = securityPolicy;
        
        operation.setCompletionBlockWithSuccess({
            
            
            (operation:AFHTTPRequestOperation! , responseObject:AnyObject!) in
            
            (responseObject as! NSData).writeToFile(imagepath, atomically: true)
            
            var image = UIImage(data: responseObject as! NSData)
            NSLog("Write to file:%@", imagepath);
            //显示图片
            if (image != nil) {
                iv.image = image;
            } else {
                iv.image = UIHelper.getBundledImage(defaultName)
            }
            },
            failure: {
                
                (operation:AFHTTPRequestOperation! , error:NSError!) in
                
                iv.image = UIImage(named: defaultName) //UIHelper.getBundledImage(defaultName)
                NSLog("Download image failed: %@", error.description);
                
        })
        operation.start()
        
    }
    
    
    
}
