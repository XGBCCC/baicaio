//
//  TipViewController.swift
//  baicaio
//
//  Created by JimBo on 16/1/11.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import MessageUI

enum TipViewActionType:Int {
    case None = 0
    case Error = 1999
}

class TipViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    var content:String? = ""
    var actionType:TipViewActionType = .None
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentLabel.text = self.content;
        guard self.actionType == .Error else{
            self.actionButton.titleLabel?.text = "申请使用测试版"
            self.actionButton.hidden = true
            return
        }
        self.actionButton.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func setup(content:String?,actionType:TipViewActionType){
        self.content = content;
        self.actionType = actionType
    }
    
    @IBAction func actionButtonTouched(sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["eric_jingbo@126.com"])
            mailComposeVC.setSubject("[白菜哦] 反馈")
            self.presentViewController(mailComposeVC, animated:true, completion: nil)
        }
    }
    
    @IBAction func closeButtonTouched(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    //MARK - 邮件代理
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        return
        
    }
    

}
