//
//  HomeVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/15/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

class HomeVC: RootVC,WebRequestDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.httpObj.mydelegate = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil!);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //下载网路图片，仅第一次下载，第二次开始读区本地缓存
        self.httpObj.renderImageView(self.imageView, url: "https://www.baidu.com/img/baidu_jgylogo3.gif?v=39549282.gif", defaultName: "ErrorImg");
    }
 

    @IBAction func btnAction(sender: AnyObject) {
        self.httpObj.httpGetApi("system/config/mobile", tag: 10)
    }

    
    //MARK: WebRequestDelegate
    //请求成功的回调
    func requestDataComplete(response:AnyObject,tag:Int)
    {
        
        if(tag == 10)
        {
            println("处理后的数据："+response.description);
        }
    }
    
    /*
    请求失败的回调
    */
    func requestDataFailed(error:String)
    {
        println(error);
    }


}
