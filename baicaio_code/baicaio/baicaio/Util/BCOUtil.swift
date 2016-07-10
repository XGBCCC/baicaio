//
//  BCOUtil.swift
//  baicaio
//
//  Created by JimBo on 16/1/4.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class BCOUtil: NSObject {
    
    static func cacheSize() -> Int {

        var imageCacheSize = 0
        do {
            let attr : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(KingfisherManager.sharedManager.cache.diskCachePath)
            
            if let _attr = attr {
                imageCacheSize = Int(_attr.fileSize())
            }
        } catch {
            
        }
        
        let realm = try! Realm()
        let fileManager = NSFileManager.defaultManager()
        let fileAttributes = try! fileManager.attributesOfItemAtPath(realm.path)
        let realmSize = fileAttributes["NSFileSize"] as! Int
        
        return imageCacheSize+realmSize
    }
    
    
    static func clearCache(){
        KingfisherManager.sharedManager.cache.clearDiskCache()
//        let realm = try! Realm()
//        try! realm.write { () -> Void in
//            realm.delete(realm.objects(BCOSearchHistory.self))
//        }
        
    }
    
}
