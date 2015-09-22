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

let SERVICE_ROOT_PATH = "http://121.41.162.102:80/services/"

class WebRequestHelper:NSObject {
    
    var mydelegate:WebRequestDelegate?
    
    let headers = [
        "Content-Type": "application/json;charset=utf-8"
    ];
    
    /*
    执行一个Post方式的Http请求
    */
    func httpPostApi(apiName:String,parameters: [String: AnyObject]? = nil,tag:Int) {
        
        var apiurl = SERVICE_ROOT_PATH + apiName
        
        request(.POST, apiurl, parameters: parameters, encoding: .JSON, headers: self.headers).responseJSON() {
            (_, _, data, error) in
            
            
            if(error == nil)
            {
                NSLog("respone:%@",data!.description)
                self.handleHttpResponse(data!, tag: tag)
            }
            else
            {
                self.mydelegate?.requestDataFailed("网络不给力哦");
            }
            
        }
    }
    
    func httpGetApi(apiName:String,parameters: [String: AnyObject]? = nil,tag:Int) {
        
        var apiurl = SERVICE_ROOT_PATH + apiName
        NSLog("request url: %@", apiurl)
        
        request(.GET, apiurl, parameters: parameters, encoding: .URL, headers: self.headers)
            .responseJSON() {
            (_, _, data, error) in
            
            if(error == nil)
            {
                self.handleHttpResponse(data!, tag: tag)
            }
            else
            {
                self.mydelegate?.requestDataFailed("网络不给力哦");
            }
            
        }
    }
    
    /*
    请求成功后，解析结果JSON公共部分
    
    */
    func handleHttpResponse(body:AnyObject,tag:Int) {

        let dataDir:NSDictionary = body as! NSDictionary
        
        if( dataDir.objectForKey("data") != nil)
        {
            self.mydelegate?.requestDataComplete(dataDir.objectForKey("data")!, tag: tag);
            
        }
        else
        {
            //解析metadata
            var errorMsg = "返回数据无效";
            var metaDic = dataDir.objectForKey("metadata")  as! NSDictionary
            if(metaDic.count>0)
            {
//                var errCode = metaDic.objectForKey("error");
                var errDic = metaDic.objectForKey("devInfo") as! NSDictionary;
                if(errDic.count>0)
                {
                    var errCode =  errDic.objectForKey("errorCode") as! Int;
                    var errDesc =  errDic.objectForKey("description") as! String;
                    errorMsg = "ErrorCode:\(errCode) \(errDesc)";
                    
                    
                }
            }
            
            self.mydelegate?.requestDataFailed(errorMsg)
        }
    }
    
    /*
    下载网络图片并加载ImageView中，
    仅第一次下载，第二次开始读区缓存
    
    参数：
    iv:显示下载后图片的UIimageView
    url:图片的url
    defaultName：如果下载失败，则所加载的默认图片名称
    
    */
    func renderImageView(iv:UIImageView,url:String,defaultName:String) {
        var  encodeName = url.stringByReplacingOccurrencesOfString("/", withString: "_", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        //判断文件路径是否存在，不存在则创建
        var imagepath:String = UIHEPLER.getCachedFilePath("cachedimages");
        
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
        
        request(.GET, url, parameters: nil, encoding: .URL, headers: self.headers).responseJSON() {
            (_, _, data, error) in
            
            if(error == nil)
            {
                var image = UIImage(data: data as! NSData)
                NSLog("Write to file:%@", imagepath);
                //显示图片
                if (image != nil) {
                    iv.image = image;
                } else {
                    iv.image = UIHEPLER.getBundledImage(defaultName)
                }
            }
            else
            {
                iv.image = UIImage(named: defaultName) //UIHelper.getBundledImage(defaultName)
                NSLog("Download image failed: %@", error!.description);
            }
        }
    }
}
