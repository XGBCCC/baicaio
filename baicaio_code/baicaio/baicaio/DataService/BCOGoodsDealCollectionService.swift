//
//  BCOGoodsDealCollectionService.swift
//  baicaio
//
//  Created by JimBo on 15/12/29.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import RealmSwift

class BCOGoodsDealCollectionService: NSObject {

    static func isCollected(infoUrl:String) -> Bool {
    
        let realm = try! Realm()
        if let _ = realm.objectForPrimaryKey(BCOGoodsDealCollected.self, key: infoUrl) {
            return true
        }
        
        return false
    }
    
    static func doCollection(infoUrl:String){
        let item = BCOGoodsDealCollected()
        item.infoUrl = infoUrl
        item.collectedDate = NSDate()

        let realm = try! Realm()
        try! realm.write { () -> Void in
            realm.add(item, update: true)
        }
    }
    
    static func removeCollection(infoUrl:String){
        let item = BCOGoodsDealCollected()
        item.infoUrl = infoUrl
        
        let realm = try! Realm()
        
        if let item = realm.objectForPrimaryKey(BCOGoodsDealCollected.self, key: infoUrl) {
            try! realm.write { () -> Void in
                realm.delete(item)
            }
        }
        
    }
    
    static func getCollectedGoodDealList() -> List<BCOGoodsDealInfo> {
    
        let realm = try! Realm()
        let collectedGoodsDealList = realm.objects(BCOGoodsDealCollected).sorted("collectedDate",ascending:false)
        
        let sqlStr = NSMutableString()
        sqlStr.appendString("infoUrl in {")
        for item in collectedGoodsDealList {
            sqlStr.appendString("'\(item.infoUrl)'")
            if collectedGoodsDealList.last != item {
                sqlStr.appendString(",")
            }
        }
        sqlStr.appendString("}")
        
        let result = realm.objects(BCOGoodsDealInfo.self).filter(sqlStr as String)
        //倒叙
        let resultArray = result.reverse()
        
        let list = List<BCOGoodsDealInfo>()
        list.appendContentsOf(resultArray)
        return list;
        
    }
    
}
