//
//  BCOConfig.swift
//  baicaio
//
//  Created by JimBo on 15/12/25.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import Spring
import MonkeyKing
import Fabric
import Crashlytics
import RealmSwift


public struct BCOConfig{
    static let mainColor = "4AA345"
    static let screenWidth = UIScreen.mainScreen().bounds.width
    
    static func configUI(){
        UINavigationBar.appearance().setBackgroundImage(UIImage.imageWithColor(UIColor(hex: mainColor)), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        
    }
    
    static func registerThirdParty(){
        Fabric.with([Crashlytics.self])
        MonkeyKing.registerAccount(.WeChat(appID: "***********", appKey: ""))
        MonkeyKing.registerAccount(.QQ(appID: "********"))
    }
    
    static func realmConfig(){
    
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // enumerate(_:_:) 方法遍历了存储在 Realm 文件中的每一个“BCOGoodsDealInfo”对象
                    migration.enumerate(BCOGoodsDealInfo.className()) { oldObject, newObject in
                        // 将名字进行合并，存放在 fullName 域中
                        newObject!["category"] = "首页"
                    }
                }
        })
        
    }
    
}
