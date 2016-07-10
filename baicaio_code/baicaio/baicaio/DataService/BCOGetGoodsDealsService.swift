//
//  BCOGetGoodsDealsService.swift
//  baicaio
//
//  Created by JimBo on 15/12/26.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift


typealias loadGoodsDealsCompletionHandler = (List<BCOGoodsDealInfo>?,NSError?) -> Void
typealias loadGoodsDealInfoCompletionHandler = (BCOGoodsDealInfo?,NSError?) ->Void

class BCOGetGoodsDealsService: NSObject {
    
    
    //获取商品优惠列表
    static func getGoodsDetalList(urlString:String, pageOfCagegoty page:Int, category:String, completionHandler:loadGoodsDealsCompletionHandler){
        var url:String = urlString
        if page>1 {
            if url.hasPrefix("http://www.baicaio.com/?s="){
                let searchString:String = url.stringByReplacingOccurrencesOfString("http://www.baicaio.com/?s=", withString: "")
                url = "http://www.baicaio.com/page/" + String(stringInterpolationSegment: page) + "?s=" + searchString

                
            }else{
                url = url + "page/" + String(stringInterpolationSegment: page)
            }
        }
        
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.GET, url)
            .responseData { response in
                if response.result.isSuccess {
                    
                    let goodsDealArray = self.goodsDealArrayWithHtmlData(response.data!,category: category)
                    
                    if goodsDealArray.count>0 {
                        let realm = try! Realm()
                        
                        try! realm.write{
                            //添加新的数据
                            realm.add(goodsDealArray, update: true)
                        }
                        
                    }
                    
                    completionHandler(goodsDealArray,nil)
                    
                }else{
                    let error = NSError(domain: "加载失败", code: 40004, userInfo: nil)
                    let list = List<BCOGoodsDealInfo>()
                    if page == 1 {
                        let realm = try! Realm()
                        let result = realm.objects(BCOGoodsDealInfo.self).filter("category = '\(category)'")
                        
                        for item in result {
                            list.append(item)
                        }
                    }
                    completionHandler(list,error)
                }
        }
    }
    
    //获取商品详情
    static func getGoodsDealInfo(urlStr : String , completionHandler : loadGoodsDealInfoCompletionHandler){
        
        //判断本地是否已缓存，如果已缓存，则直接取本地
        if let goodsDealInfo = self.getGoodsDealInfoFormDBWithUrl(urlStr) {
        
            completionHandler(goodsDealInfo,nil)
        
        }else {
            
            Alamofire.request(.GET, urlStr)
                .responseData { response in
                    if response.result.isSuccess {
                        
                        let goodsDealInfo = self.goodsDealInfoWithHtmlData(response.data!, introUrl: urlStr)
                        completionHandler(goodsDealInfo,nil)
                        
                    }else{
                        let error = NSError(domain: "加载失败", code: 40004, userInfo: nil)
                        completionHandler(nil,error)
                    }
            }
        
        }
        
    }
    
    //根据分类获取所有商品详情【已收藏的除外】
    static func getGoodsDealExceptCollectedWithCategory(category:String) -> [BCOGoodsDealInfo]{
    
        let realm = try! Realm()
        let collectedResult = realm.objects(BCOGoodsDealCollected.self)
        
            
        if collectedResult.count>0 {
            
            let willDeleteArray = realm.objects(BCOGoodsDealInfo).filter("category = '\(category)'").filter({ (goodsDealInfo) -> Bool in
                if let _ = collectedResult.filter("infoUrl = '\(goodsDealInfo.infoUrl)'").first{
                    return false
                }
                return true
            })
            
            return willDeleteArray
        }else{
            return realm.objects(BCOGoodsDealInfo.self).reverse()
        }
        
        
    }
    
    //获取所有没收藏的数据【已收藏的除外】
    static func getGoodsDealExceptCollected() -> [BCOGoodsDealInfo]{
        
        let realm = try! Realm()
        let collectedResult = realm.objects(BCOGoodsDealCollected.self)
        
        
        if collectedResult.count>0 {
            
            let willDeleteArray = realm.objects(BCOGoodsDealInfo).filter({ (goodsDealInfo) -> Bool in
                if let _ = collectedResult.filter("infoUrl = '\(goodsDealInfo.infoUrl)'").first{
                    return false
                }
                return true
            })
            
            return willDeleteArray
        }else{
            return realm.objects(BCOGoodsDealInfo.self).reverse()
        }
        
        
    }
    
    
    //根据data，解析出商品优惠的列表
    private static func goodsDealArrayWithHtmlData(data:NSData,category:String) -> List<BCOGoodsDealInfo>{
    
        let goodsDealArray = List<BCOGoodsDealInfo>()
        
        let html = TFHpple(HTMLData: data)
        let ulElements = html.searchWithXPathQuery("//ul[@class='post-list']")
        for ulElement in ulElements {
            let liElements = ulElement.childrenWithTagName("li")
            // 这里是同一个对象
            for liElement in liElements {
                
                let goodsDetail = BCOGoodsDealInfo()
                
                //日期
                let divDateElements = liElement.searchWithXPathQuery("//div[@class='date']")
                if let divDateElement = divDateElements.first as? TFHppleElement {
                    goodsDetail.date = divDateElement.content
                }
                
                //时间
                let divTimeElements = liElement.searchWithXPathQuery("//div[@class='time']")
                if let divTimeElement = divTimeElements.first as? TFHppleElement {
                    goodsDetail.time = divTimeElement.content
                }
                
                let divThumbElements = liElement.searchWithXPathQuery("//div[@class='thumb']")
                if let divThumbElement = divThumbElements.first as? TFHppleElement {
                    //图片地址
                    let imgElements = divThumbElement.searchWithXPathQuery("//img")
                    if let imgElement = imgElements.first as? TFHppleElement {
                        goodsDetail.imageUrl = imgElement.objectForKey("src")
                    }
                    //商城
                    let spanElements = divThumbElement.searchWithXPathQuery("//span")
                    if let spanElement = spanElements.first as? TFHppleElement {
                        goodsDetail.source = spanElement.content
                    }
                }
                
                
                let h2Elements = liElement.searchWithXPathQuery("//h2[@class='title']")
                let h2Element = h2Elements.first
                
                if let aElements = h2Element?.searchWithXPathQuery("//a") {
                    if let aElement = aElements.first {
                        goodsDetail.title = aElement.text.description
                        goodsDetail.infoUrl = aElement.objectForKey("href")
                    }
                }
                
                //设置分类
                goodsDetail.category = category
                
                goodsDealArray.append(goodsDetail)
            }
        }
    
        return goodsDealArray
    }
    
    
    //根据data 解析商品优惠详细信息
    private static func goodsDealInfoWithHtmlData(data:NSData,introUrl:String) -> BCOGoodsDealInfo {
    
        let realm = try! Realm()
        let goodsDealInfo = realm.objectForPrimaryKey(BCOGoodsDealInfo.self, key: introUrl)
        let html = TFHpple(HTMLData: data)
        let ulElements = html.searchWithXPathQuery("//ul[@class='post-list post-content']")
        //内容所在的ul
        let ulElement = ulElements.first as! TFHppleElement

        let divContentElements = ulElement.searchWithXPathQuery("//div[@class='content']")
        //内容所在的div
        let divContentElement = divContentElements.first as! TFHppleElement
        //获取内容
        let pContentElements = divContentElement.searchWithXPathQuery("//p")
        
        //所有content
        let elementArray = List<BCOGoodsDealContentElement>()
        //单独存储Image的
        let imageElementArray = List<BCOGoodsDealContentElement>()
        let imgElements = divContentElement.searchWithXPathQuery("//img")
        
        let srcDict = NSMutableDictionary()
        for imageElement in imgElements {
            let imageHppleElement = imageElement as! TFHppleElement
            let contentElement = BCOGoodsDealContentElement()
            //只拿没有添加过的图片地址
            let src = imageHppleElement.objectForKey("src")
            if let _ = srcDict.objectForKey(src) {
                print("已包含该图片")
            }else{
                contentElement.elementType = BCOGoodsDealContentElementType.Image.rawValue
                contentElement.imgUrl = (imageHppleElement.objectForKey("src"))!
                imageElementArray.append(contentElement)
                srcDict.setValue("", forKey: src)
            }
            
            
        }
        
        //获取直达链接
        var linkUrl = ""
        let buyLinkDivElements = divContentElement.searchWithXPathQuery("//a[@rel='nofollow external']")
        if buyLinkDivElements.count>0{
            if let buyLinkElement = buyLinkDivElements.first as? TFHppleElement {
                linkUrl = buyLinkElement.objectForKey("href")
            }
        }
    
        
        //获取内容
        for pContentElement in pContentElements! {
            //分解每个内容
            if(pContentElement.hasChildren()){
                
                if let pContentHppleElement = pContentElement as? TFHppleElement {
                    
                    let elements = pContentHppleElement.children
                 
                    for newElement in elements {
                        let contentElement = BCOGoodsDealContentElement()
                        
                        if(newElement.tagName == "a"){
                            
                            contentElement.elementType = BCOGoodsDealContentElementType.Link.rawValue
                            contentElement.text = newElement.content
                            contentElement.linkUrl = (newElement.objectForKey("href"))
                            
                        }else if(newElement.tagName == "img"){
                            contentElement.elementType = BCOGoodsDealContentElementType.Image.rawValue
                            contentElement.imgUrl = (newElement.objectForKey("src"))
                            
                        }else if(newElement.tagName == "strong"){
                            if let hppleElement = newElement as? TFHppleElement {
                                
                                if hppleElement.hasChildren(){
                                    let subElement = hppleElement.firstChild
                                    if(subElement.tagName == "a"){
                                        contentElement.elementType = BCOGoodsDealContentElementType.Link.rawValue
                                        contentElement.text = subElement.content
                                        contentElement.linkUrl = (subElement.objectForKey("href"))
                                    }else{
                                        contentElement.elementType = BCOGoodsDealContentElementType.Text.rawValue
                                        contentElement.text = subElement.content
                                    }
                                }else{
                                    if let hppleElement = newElement as? TFHppleElement {
                                        contentElement.elementType = BCOGoodsDealContentElementType.Text.rawValue
                                        contentElement.text = hppleElement.content
                                    }
                                }
                            
                            }
                            
                        }else{
                            if let hppleElement = newElement as? TFHppleElement {
                                contentElement.elementType = BCOGoodsDealContentElementType.Text.rawValue
                                contentElement.text = hppleElement.content
                            }
                        }
                        
                        elementArray.append(contentElement)
                    }
                }
                
                
            }else{
            
                let contentElement = BCOGoodsDealContentElement()
                contentElement.elementType = BCOGoodsDealContentElementType.Text.rawValue
                contentElement.text = pContentElement.text.description
                elementArray.append(contentElement)
                
            }
            
            //每个p标签最后，都需要添加换行
            let contentElement = BCOGoodsDealContentElement()
            contentElement.elementType = BCOGoodsDealContentElementType.Text.rawValue
            contentElement.text = "\n\n"
            elementArray.append(contentElement)
            
        }
     
        try! realm.write { () -> Void in
            goodsDealInfo?.imageElementList.removeAll()
            goodsDealInfo?.contentElementList.removeAll()
            goodsDealInfo?.imageElementList.appendContentsOf(imageElementArray)
            goodsDealInfo?.contentElementList.appendContentsOf(elementArray)
            goodsDealInfo?.directLink = linkUrl
        }
        
        return goodsDealInfo!
    }
    
    
    //从本地数据库获取详情
    private static func getGoodsDealInfoFormDBWithUrl(infoUrl:String) -> BCOGoodsDealInfo? {
    
        let realm = try! Realm()
        
        let goodsDealInfoList = realm.objects(BCOGoodsDealInfo.self).filter("infoUrl = %@", infoUrl).filter { (goodsDealInfo:BCOGoodsDealInfo) -> Bool in
            
            if goodsDealInfo.contentElementList.count>0 {
                return true
            }
            return false
            
        }
        
        return goodsDealInfoList.first;
        
    }
    
    //清除数据
    static func removeData(){
    
        let realm = try! Realm()
        try! realm.write { () -> Void in
            let willDeleteArray = self.getGoodsDealExceptCollected()
            realm.delete(willDeleteArray)
        }
        
    }
    
}


