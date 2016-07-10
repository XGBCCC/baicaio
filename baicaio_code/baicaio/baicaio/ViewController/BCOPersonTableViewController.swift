//
//  BCOPersonTableViewController.swift
//  baicaio
//
//  Created by JimBo on 16/1/4.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import JDStatusBarNotification

class BCOPersonTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(BCOPersonTableViewController.Reusable.disclosureCellIdentifier, forIndexPath: indexPath) as! BCOPersonDetailCell
        if indexPath.row == 0 {
            cell.titleLabel.text = "清除缓存"
            cell.detailLabel.text = String(format: "%.1fMB", Double(BCOUtil.cacheSize())/1024.0/1024.0)
        }else{
            cell.titleLabel.text = "意见反馈"
            cell.detailLabel.text = ""
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.showAlertControllerForClean()
        }else {
            self.performSegue(BCOPersonTableViewController.Segue.showFeedbackViewController)
        }
        
    }
    
    
    //MARK - alert
    func showAlertControllerForClean(){
        let alertController = UIAlertController(title: "提示", message: "将清除所有图片缓存，确认删除？", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (_) -> Void in
            
        }
        
        let OKAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default) { (_) -> Void in
            BCOUtil.clearCache()
            self.tableView.reloadData()
            JDStatusBarNotification.showWithStatus("操作成功", dismissAfter: 1.0, styleName: JDStatusBarStyleSuccess)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

class BCOPersonDetailCell:UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    
}
