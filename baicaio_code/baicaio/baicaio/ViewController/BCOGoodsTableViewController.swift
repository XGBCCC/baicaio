//
//  BCOGoodsTableViewController.swift
//  baicaio
//
//  Created by JimBo on 15/12/25.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import RealmSwift
import MJRefresh
import JDStatusBarNotification

enum BCOGoodsTableViewControllerShowType:Int{
    case GoodsDealInfoCollectedList = 0, GoodsDealInfoList,GoodsDealInfoListForSearch
}

class BCOGoodsTableViewController: UITableViewController {

    var goodsDealArray = List<BCOGoodsDealInfo>()
    var requestURLString = "http://www.baicaio.com/"
    var willLoadPage = 1
    var viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoCollectedList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        if  self.viewType == .GoodsDealInfoListForSearch {
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.scrollsToTop = true
        if self.viewType == BCOGoodsTableViewControllerShowType.GoodsDealInfoCollectedList {
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.scrollsToTop = false
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goodsDealArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let goodsCell = tableView.dequeueReusableCell(BCOGoodsTableViewController.Reusable.GoodsTableViewCellIdentifier, forIndexPath: indexPath) as! BCOGoodsTableViewCell
        
        goodsCell.setupCellWithGoodsDealInfo(self.goodsDealArray[indexPath.row])
        
        return goodsCell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //如果是收藏界面，则允许删除
        if self.viewType == .GoodsDealInfoCollectedList {
            return true
        }else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            //移除收藏，删除这一行
            let goodsDealInfo = self.goodsDealArray[indexPath.row]
            BCOGoodsDealCollectionService.removeCollection(goodsDealInfo.infoUrl)
            self.goodsDealArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    
    //segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == BCOGoodsTableViewController.Segue.ShowGoodsDealInfoSegue {
            let viewController = segue.destinationViewController as! BCOGoodsInfoViewController
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            let goodsDealInfo = self.goodsDealArray[indexPath!.row]
            viewController.goodsDealIntroUrl = goodsDealInfo.infoUrl
        }
    }
    
    
    //MARK - load data
    func loadData(){
        
        //默认，从网络获取
        if (self.viewType == BCOGoodsTableViewControllerShowType.GoodsDealInfoList||self.viewType == BCOGoodsTableViewControllerShowType.GoodsDealInfoListForSearch){
        
            var category = self.title!
            if self.viewType == BCOGoodsTableViewControllerShowType.GoodsDealInfoListForSearch {
                category = "搜索"
            
            }
            BCOGetGoodsDealsService.getGoodsDetalList(self.requestURLString, pageOfCagegoty: self.willLoadPage,category: category) { (goodsDealArray:List<BCOGoodsDealInfo>?, error:NSError?) -> Void in
                if let newGoodsDealArray = goodsDealArray {
                    if self.willLoadPage == 1 {
                        self.goodsDealArray.removeAll()
                    }
                    self.willLoadPage++
                    self.goodsDealArray.appendContentsOf(newGoodsDealArray)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.mj_footer.endRefreshing()
                        if (error != nil) {
                            self.tableView.mj_footer.removeFromSuperview();

                            JDStatusBarNotification.showWithStatus(error?.domain, dismissAfter: 1.0, styleName: JDStatusBarStyleSuccess)
                        }else{
                            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadData")
                        }
                    })
                    
                    
                    
                    
                }
            }
        }else{
        
            //查看收藏夹
            self.goodsDealArray = BCOGoodsDealCollectionService.getCollectedGoodDealList()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_footer.removeFromSuperview()
            })
            
            
            
        }
    }
    
    // MARK - scroll view delegate
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.tableView.showsVerticalScrollIndicator = true
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    
    //MARK - setup tableView
    func setupTableView(){
        self.tableView.separatorStyle = .None
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadData")
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadData")
        
        self.tableView.mj_header.beginRefreshing()
        
    }
    

}
