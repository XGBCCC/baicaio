//
//  BCOGoodsDealContentElement.swift
//  baicaio
//
//  Created by JimBo on 15/12/27.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import Foundation
import RealmSwift

enum BCOGoodsDealContentElementType:Int{
    case Text = 0,Link,Image
}

class BCOGoodsDealContentElement: Object {
    
    dynamic var elementType = 0
    dynamic var text = ""
    dynamic var linkUrl = ""
    dynamic var imgUrl = ""
    dynamic var width = 0
    dynamic var height = 0


}
