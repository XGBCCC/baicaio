//
//  BCOGoodsInfoViewController.swift
//  baicaio
//
//  Created by JimBo on 15/12/26.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import SafariServices
import MJRefresh
import JBImageBrowserViewController
import JDStatusBarNotification

class BCOGoodsInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var goodsDealIntroUrl = ""
    var goodsDealInfo = BCOGoodsDealInfo()
    var goodsPhotoArray = [JBImage]()
    var goodsDealCollected = false
    var goodsLayoutInfo = (height:CGFloat.min,attributeString:NSMutableAttributedString())
    
    
    @IBOutlet weak var bannerView: CyclePictureView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectingButton: UIButton!
    @IBOutlet weak var actionButtonsContainerView: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.setupBannerView()
        self.setupTableView()
        
        
        self.title = "优惠详情"
        let backItem = UIBarButtonItem(image: UIImage(named: "nav_back_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "navigationBack")
        self.navigationItem.leftBarButtonItem = backItem
        
        self.actionButtonsContainerView.userInteractionEnabled = false
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.setNeedsStatusBarAppearanceUpdate()
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 0.0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentImageLoaded", name: KGoodsDealImageLoadedNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentLinkTouched:", name: KGoodsDealLinkedTouchedNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentImageTouched:", name: KGoodsDealImageTouchedNotificationName, object: nil)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let goodsContentCell = tableView.dequeueReusableCell(BCOGoodsInfoViewController.Reusable.GoodsContentInfoCellIdentifier, forIndexPath: indexPath) as! BCOGoodsInfoContentCell
        
        goodsContentCell.setupGoodsDealInfo(self.goodsDealInfo, attributedString: self.goodsLayoutInfo.attributeString)
        return goodsContentCell
    }
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.goodsLayoutInfo = BCOGoodsInfoContentCell.heightAndContentAttStringWithGoodsDealInfo(self.goodsDealInfo)
        return goodsLayoutInfo.height
    }
    
    
    
    // MARK - load Data
    func refreshData(){
        BCOGetGoodsDealsService.getGoodsDealInfo(self.goodsDealIntroUrl) { (goodsDealInfo:BCOGoodsDealInfo?, error:NSError?) -> Void in
            
            if error == nil{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.goodsDealInfo = goodsDealInfo!
                    self.tableView.reloadData()
                    self.resetBannerView()
                    self.tableView.mj_header.removeFromSuperview()
                    
                    //收藏
                    self.goodsDealCollected = BCOGoodsDealCollectionService.isCollected(self.goodsDealInfo.infoUrl)
                    
                    if self.goodsDealCollected {
                        self.collectingButton.setImage(UIImage(named: "info_shoucang_selected_icon"), forState: UIControlState.Normal)
                        self.collectingButton.setTitle("取消收藏", forState: UIControlState.Normal)
                    }else{
                        self.collectingButton.setImage(UIImage(named: "info_shoucang_icon"), forState: UIControlState.Normal)
                        self.collectingButton.setTitle("收藏", forState: UIControlState.Normal)
                    }
                    
                    self.actionButtonsContainerView.userInteractionEnabled = true
                    
                })
                
            }else{
            
            
            }
            self.tableView.mj_header.endRefreshing()
        }
    
    }
    
    
    // reset banner
    func resetBannerView(){
        var imageURLArray: [String] = []
        for element in self.goodsDealInfo.imageElementList {
            imageURLArray.append(element.imgUrl)
        }
        if imageURLArray.count>0 {
            bannerView.imageURLArray = imageURLArray
        }
    }
    
    //MARK  - action
    func contentImageLoaded(){
        self.tableView.reloadData()
    }
    
    func contentImageTouched(notification: NSNotification){
        let index = notification.object as! UInt
        self.pushPhotoBrowserViewController(index)
    }
    
    func contentLinkTouched(notification: NSNotification){
        let link = notification.object as! String
        let safariViewCoroller = SFSafariViewController(URL: NSURL(string: link)!, entersReaderIfAvailable: true)
        safariViewCoroller.delegate = self
        self.navigationController?.presentViewController(safariViewCoroller, animated: true, completion: { () -> Void in
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            self.setNeedsStatusBarAppearanceUpdate()
        })
        
    }

    
    @IBAction func collectingButtonDidTouch(sender: UIButton) {
        //收藏
        self.goodsDealCollected = !BCOGoodsDealCollectionService.isCollected(self.goodsDealInfo.infoUrl)
        
        if self.goodsDealCollected {
            BCOGoodsDealCollectionService.doCollection(self.goodsDealInfo.infoUrl)
            self.collectingButton.setImage(UIImage(named: "info_shoucang_selected_icon"), forState: UIControlState.Normal)
            self.collectingButton.setTitle("取消收藏", forState: UIControlState.Normal)
            
        }else{
            BCOGoodsDealCollectionService.removeCollection(self.goodsDealInfo.infoUrl)
            self.collectingButton.setImage(UIImage(named: "info_shoucang_icon"), forState: UIControlState.Normal)
            self.collectingButton.setTitle("收藏", forState: UIControlState.Normal)
        }
        
        JDStatusBarNotification.showWithStatus("操作成功", dismissAfter: 1.0, styleName: JDStatusBarStyleSuccess)
    }
    
    @IBAction func linkButtonDidTouch(sender: UIButton) {
        //点击直达链接
        let link = self.goodsDealInfo.directLink
        if link.length>0 {
            let safariViewCoroller = SFSafariViewController(URL: NSURL(string: link)!, entersReaderIfAvailable: true)
            safariViewCoroller.delegate = self
            self.navigationController?.presentViewController(safariViewCoroller, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
                self.setNeedsStatusBarAppearanceUpdate()
            })
        }
    }
    
    
    
    
    //MARK - notification
    func navigationBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK - setup
    func setupBannerView(){
        bannerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)/1.66)
        self.tableView.tableHeaderView = bannerView
        bannerView.backgroundColor = UIColor.clearColor()
        bannerView.autoScroll = false
        bannerView.pictureContentMode = .ScaleAspectFit
        bannerView.currentDotColor = UIColor(hex: BCOConfig.mainColor)
        bannerView.delegate = self
        
    }
    
    func setupTableView(){
        self.tableView.separatorStyle = .None
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")
        self.tableView.mj_header.beginRefreshing()
    }
    
    //MARK - sugue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == BCOGoodsInfoViewController.Segue.shareSegue {
            let viewController = segue.destinationViewController as! BCOShareViewController
            viewController.goodsDealInfo = self.goodsDealInfo
        }
    }
    

}


extension BCOGoodsInfoViewController:SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        controller.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
}

extension BCOGoodsInfoViewController: CyclePictureViewDelegate {
    
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        self.pushPhotoBrowserViewController(UInt(indexPath.row))
    }
    
}


extension BCOGoodsInfoViewController {
    
    func pushPhotoBrowserViewController(currentIndex:UInt){
        
        if self.goodsPhotoArray.count == 0 {
            
            for element in self.goodsDealInfo.imageElementList {
                
                let photo = JBImage(url:NSURL(string: element.imgUrl))
                self.goodsPhotoArray.append(photo)
                
            }
        }
        
        let photoBrowser = JBImageBrowserViewController(imageArray: self.goodsPhotoArray, failedPlaceholderImage: nil)
        self.presentViewController(photoBrowser, animated: true, completion: nil)
        
    }

    
}



