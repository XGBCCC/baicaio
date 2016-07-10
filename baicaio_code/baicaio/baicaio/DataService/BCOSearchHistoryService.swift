//
//  BCOSearchHistoryService.swift
//  baicaio
//
//  Created by JimBo on 15/12/31.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import RealmSwift

class BCOSearchHistoryService: NSObject {

    static func saveSearchHistory(searchString:String!){
        let searchHistrory = BCOSearchHistory()
        searchHistrory.search = searchString
        searchHistrory.date = NSDate()
        let realm = try! Realm()
        try! realm.write { () -> Void in
            realm.add(searchHistrory, update: true)
        }
        
    }
    
    static func getSearchHistory() -> List<BCOSearchHistory>{
    
        let realm = try! Realm()
        let sortedItems = realm.objects(BCOSearchHistory.self).sorted("date", ascending: false)
        
        
        let list = List<BCOSearchHistory>()
        list.appendContentsOf(sortedItems)
        return list;
    }
    
}
