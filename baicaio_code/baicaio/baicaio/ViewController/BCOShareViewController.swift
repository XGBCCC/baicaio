//
//  BCOShareViewController.swift
//  baicaio
//
//  Created by JimBo on 15/12/31.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import MonkeyKing

class BCOShareViewController: UIViewController {

    var goodsDealInfo = BCOGoodsDealInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func qqShareButtonTouched(sender: AnyObject) {
        
        //分享
        let message = MonkeyKing.Message.QQ(.Friends(info: (
            title: self.goodsDealInfo.title,
            description: self.goodsDealInfo.title,
            thumbnail: UIImage(named: "icon"),
            media: .URL(NSURL(string: self.goodsDealInfo.infoUrl)!)
        )))
        
        MonkeyKing.shareMessage(message) { success in
            print("shareURLToQQSession success: \(success)")
        }
        
    }

    @IBAction func weChatSareButtonTouched(sender: AnyObject) {
        
        //分享
        let message = MonkeyKing.Message.WeChat(.Session(info: (
            title: self.goodsDealInfo.title,
            description: self.goodsDealInfo.title,
            thumbnail: UIImage(named: "icon"),
            media: .URL(NSURL(string: self.goodsDealInfo.infoUrl)!)
        )))
        
        MonkeyKing.shareMessage(message) { success in
            print("shareURLToWeChatSession success: \(success)")
        }
        
    }
}
