//
//  BCOGoodsDealCollectedGoodsDeal.swift
//  baicaio
//
//  Created by JimBo on 15/12/29.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import Foundation
import RealmSwift

class BCOGoodsDealCollected: Object {

    dynamic var infoUrl = ""
    dynamic var collectedDate:NSDate = NSDate()

    override static func primaryKey() -> String? {
        return "infoUrl"
    }
    
}
