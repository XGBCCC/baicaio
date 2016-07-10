//
//  BCOSearchViewController.swift
//  baicaio
//
//  Created by JimBo on 15/12/30.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import RealmSwift

class BCOSearchViewController: UIViewController,UISearchBarDelegate{

    var searchBar:UISearchBar = UISearchBar()
    var searchHistoryList = List<BCOSearchHistory>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        self.searchBar = UISearchBar(frame: CGRectMake(0,0,BCOConfig.screenWidth-30,20))
        searchBar.placeholder = "请输入"
        searchBar.setValue("取消", forKeyPath: "_cancelButtonText")
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.tintColor = UIColor.blackColor()
        self.searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchBar

        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.searchHistoryList = BCOSearchHistoryService.getSearchHistory()
        self.tableView.reloadData()
        
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //查询
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.search(searchBar.text!)
    }
    
    func search(searchString:String!){
        self.searchBar.setValue(searchString, forKeyPath: "text")
        BCOSearchHistoryService.saveSearchHistory(searchString)
        let homeViewController = Storyboards.Main.instantiateGoodsTableViewController()
        homeViewController.title = searchString
        homeViewController.requestURLString = "http://www.baicaio.com/?s=\(searchString)"
        homeViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoListForSearch
        self.navigationController?.pushViewController(homeViewController, animated: true)
        
    }

}

extension BCOSearchViewController:UITableViewDelegate,UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchHistoryList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCellIdentifier", forIndexPath: indexPath)
        let searchHistory = self.searchHistoryList[indexPath.row]
        cell.textLabel?.text = searchHistory.search
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let searchHistory = self.searchHistoryList[indexPath.row]
        self.search(searchHistory.search)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "搜索历史"
    }
    
}
