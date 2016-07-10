//
//  AppDelegate.swift
//  baicaio
//
//  Created by JimBo on 15/12/24.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import MonkeyKing


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        BCOConfig.configUI()
        BCOConfig.registerThirdParty()
        BCOConfig.realmConfig()
        
        //注册推送
        APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.union(.Alert).union(.Badge).rawValue, categories: nil)
        APService.setupWithOption(launchOptions)
        
     
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        
        return false
    }


    func applicationDidBecomeActive(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(application: UIApplication) {
        BCOGetGoodsDealsService.removeData()
    }
}


//MARK - 推送
extension AppDelegate {

    //注册成功
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        APService.registerDeviceToken(deviceToken)
    }
    
    //接收到推送
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        APService.handleRemoteNotification(userInfo)
        
        //获取content
        let content = ((userInfo["aps"] as? NSDictionary) ?? ["alert":""]).objectForKey("alert")
        
        //如果error为1999，则表示网站改版了，需要重新编码
        if let error = (userInfo["error"] as? String) {
            
            if let rootVC = application.keyWindow?.rootViewController {
                rootVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
                let controller = Storyboards.Main.instantiateTipViewController()
                if let errorCode = Int(error) {
                    controller.setup(content as? String, actionType: TipViewActionType(rawValue: errorCode)!)
                    rootVC.presentViewController(controller, animated: true, completion: nil)
                }
            }
            
        }
        
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
}



