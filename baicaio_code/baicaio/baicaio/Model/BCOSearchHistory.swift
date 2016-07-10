//
//  BCOSearchHistory.swift
//  baicaio
//
//  Created by JimBo on 15/12/31.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import Foundation
import RealmSwift

class BCOSearchHistory: Object {

    dynamic var search = ""
    dynamic var date = NSDate()
    override static func primaryKey() -> String? {
        return "search"
    }

}
