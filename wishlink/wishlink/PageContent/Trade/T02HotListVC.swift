//
//  T02HotListVC.swift
//  wishlink
//
//  Created by Andy Chen on 8/21/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import UIKit

//class T02HotListVC: RootVC {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    
//
//}

//
//  U02UserVC.swift
//  wishlink
//
//  Created by Yue Huang on 8/17/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

//import UIKit
//
//enum CollectionViewCellType: Int {
//    case CollectionViewCellTypeTrade = 0, CollectionViewCellTypeItem = 1
//}

class T02HotListVC: RootVC, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let itemCellIde = "U02ItemCell"

    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preparePage()

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!APPCONFIG.isUserLogin())
        {
            var loginVC = U01LoginVC(nibName: "U01LoginVC", bundle: MainBundle);
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
        
    

    }
    override func viewDidAppear(animated: Bool) {
            UIHelper.loadLeftItem(self.navigationController! , imgNormal: "u02-back", imgHightLight: "u02-back-w", btnAction: "leftBtnClicked:")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width: CGFloat = (UIScreen.mainScreen().bounds.size.width - 20 - 10) / 2.0;
        var height: CGFloat = 250.0
        
 
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier(itemCellIde, forIndexPath: indexPath) as! U02ItemCell
        return cell!
    }
    

    

    // MARK: - prive method
    
    func preparePage() {
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 7.5, right: 10)
       
        self.collectionView.registerNib(UINib(nibName: "U02ItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: itemCellIde)
        
        self.collectionView.scrollEnabled = true;
    
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor();
//        self.navigationController?.navigationItem.set = UIColor.clearColor();
        
        let leftBtn : UIButton = UIButton(frame: CGRectMake(0, 0, 32, 32));
        leftBtn.setImage(UIImage(named: "u02-back"), forState: UIControlState.Normal)
        leftBtn.setImage(UIImage(named: "u02-back-w"), forState: UIControlState.Highlighted)
        leftBtn.backgroundColor = UIColor.clearColor();
        leftBtn.addTarget(self, action: "leftBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem : UIBarButtonItem = UIBarButtonItem(customView: leftBtn)
    
       self.navigationItem.leftBarButtonItem = leftItem;

        
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 40, 30))
        titleLabel.text = "热门"
        titleLabel.textColor = UIHelper.mainColor;
        titleLabel.font = UIFont.boldSystemFontOfSize(15)
        titleLabel.textAlignment = NSTextAlignment.Center
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBarHidden = false;

    }
    
    func leftBtnClicked(button: UIButton){
        
        var loginVC = U01LoginVC(nibName: "U01LoginVC", bundle: MainBundle);
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
    
 

    
}










