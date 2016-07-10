//
//  BCOGoodsDealInfo.swift
//  baicaio
//
//  Created by JimBo on 15/12/26.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import Foundation
import RealmSwift

class BCOGoodsDealInfo: Object {

    dynamic var title = ""
    //白菜哦的详细页
    dynamic var infoUrl = ""
    dynamic var imageUrl = ""
    dynamic var date = ""
    dynamic var time = ""
    dynamic var source = ""
    dynamic var category = ""
    //直达链接
    dynamic var directLink = ""
    var contentElementList = List<BCOGoodsDealContentElement>()
    var imageElementList = List<BCOGoodsDealContentElement>()
    
    
    override static func primaryKey() -> String? {
        return "infoUrl"
    }

}
