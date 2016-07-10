//
//  BCOFeedbackViewController.swift
//  baicaio
//
//  Created by JimBo on 16/1/11.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import MessageUI

class BCOFeedbackViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func feedbackButtonTouched(sender: UIButton) {
        
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["eric_jingbo@126.com"])
            mailComposeVC.setSubject("[白菜哦] 反馈")
            self.presentViewController(mailComposeVC, animated:true, completion: nil)
        }
        
    }
    
    //MARK - 邮件代理
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        return
        
    }
    
}
