//
//  BCOGoodsInfoContentCell.swift
//  baicaio
//
//  Created by JimBo on 15/12/26.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import YYText
import Kingfisher

let KGoodsDealImageLoadedNotificationName = "BCOGoodsDealImageLoadedNotificationName"
let KGoodsDealLinkedTouchedNotificationName = "BCOGoodsDealLinkedTouchedNotificationName"
let KGoodsDealImageTouchedNotificationName = "BCOGoodsDealImageTouchedNotificationName"
let KGoodsInfoContentImageBaseTag = 400

class BCOGoodsInfoContentCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: YYLabel!
    
    var goodsDealInfo = BCOGoodsDealInfo()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.setupContentTextView()
    }
    
    func setupContentTextView(){
        self.contentTextView.numberOfLines = 0
        self.contentTextView.userInteractionEnabled = true
    }
    
    func setupGoodsDealInfo(goodsDealInfo:BCOGoodsDealInfo,attributedString:NSMutableAttributedString){
        self.goodsDealInfo = goodsDealInfo
        self.dateLabel.text = goodsDealInfo.source + " | " + goodsDealInfo.date + " " + goodsDealInfo.time
        self.titleLabel.text = goodsDealInfo.title
        self.contentTextView.attributedText = attributedString
        
    }

    
    static func heightAndContentAttStringWithGoodsDealInfo(goodsDealInfo:BCOGoodsDealInfo) -> (height:CGFloat,attributeString:NSMutableAttributedString){
    
        var imageIndex = 0
        
        let text = NSMutableAttributedString()
        
        let elementList = goodsDealInfo.contentElementList
        //遍历Element
        for element in elementList {
            
            let defaultTextFontAttributes = [NSForegroundColorAttributeName:UIColor(hex: "777777"),NSFontAttributeName:UIFont.systemFontOfSize(14)]
            let defaultLinkFontAttributes = [NSForegroundColorAttributeName:UIColor(hex: "156BC5"),NSFontAttributeName:UIFont.systemFontOfSize(14)]
            
            if element.elementType == BCOGoodsDealContentElementType.Text.rawValue {
                let textAttributedString = NSMutableAttributedString(string: element.text, attributes: defaultTextFontAttributes)
                text.appendAttributedString(textAttributedString)
            }else if element.elementType == BCOGoodsDealContentElementType.Link.rawValue {
                let textAttributedString = NSMutableAttributedString(string: element.text, attributes: defaultLinkFontAttributes)
                let textHightlight = YYTextHighlight()
                textHightlight.setColor(UIColor(hex: "9AC2E8"))
                textHightlight.tapAction = { (_,_,_,_) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(KGoodsDealLinkedTouchedNotificationName, object: element.linkUrl)
                    
                }
                
                textAttributedString.yy_setTextHighlight(textHightlight, range: textAttributedString.yy_rangeOfAll())
                
                text.appendAttributedString(textAttributedString)
            }else if element.elementType == BCOGoodsDealContentElementType.Image.rawValue {
                
                var imageWidth = BCOConfig.screenWidth-20
                var imageHeight = (BCOConfig.screenWidth-20)/1.6
                
                let imageView = UIImageView()
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                //判断是否已缓存该图片
                if let image = KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(element.imgUrl){
                    if  image.size.width > imageWidth {
                        //对image进行缩放
                        let scale = image.size.width/imageWidth
                        imageHeight = image.size.height/scale
                    }else{
                        imageWidth = image.size.width
                        imageHeight = image.size.height
                    }
                    
                    imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight)
                    imageView.image = image
                    
                    //处理图片点击事件
                    imageView.userInteractionEnabled = true
                    imageView.tag = KGoodsInfoContentImageBaseTag+imageIndex;
                    let tapGesture = UITapGestureRecognizer(target: self, action: "goodsInfoContentImageTaped:")
                    imageView.addGestureRecognizer(tapGesture);
                    imageIndex++;
                }else{
                
                    //下载图片
                    KingfisherManager.sharedManager.downloader.downloadImageWithURL(NSURL(string: element.imgUrl)!, progressBlock: nil, completionHandler: { (image, error, imageURL, originalData) -> () in
                        if let image = image {
                            KingfisherManager.sharedManager.cache.storeImage(image, forKey: element.imgUrl)
                            NSNotificationCenter.defaultCenter().postNotificationName(KGoodsDealImageLoadedNotificationName, object: nil)
                        }
                    })
                
                }
                let imageAttributedString = NSMutableAttributedString.yy_attachmentStringWithContent(imageView, contentMode: UIViewContentMode.ScaleAspectFit, attachmentSize: CGSizeMake(imageWidth, imageHeight), alignToFont: UIFont.systemFontOfSize(14), alignment: YYTextVerticalAlignment.Center)
                
                text.appendAttributedString(imageAttributedString)
                
            }
            
        }
        
        text.yy_setLineSpacing(2, range: NSMakeRange(0, text.length))
        let contentTextLayout = YYTextLayout(containerSize: CGSizeMake(BCOConfig.screenWidth-20, CGFloat.max), text: text)
        
        
        let titleTextFontAttributes = [NSFontAttributeName:UIFont.boldSystemFontOfSize(16)]
        let titleText = NSMutableAttributedString(string: goodsDealInfo.title, attributes: titleTextFontAttributes)
        let titleTextLayout = YYTextLayout(containerSize: CGSizeMake(BCOConfig.screenWidth-20, CGFloat.max), text: titleText)
    
        let height = 10+16+13+titleTextLayout!.textBoundingSize.height+15+contentTextLayout!.textBoundingSize.height+1
        
        return (height,text)
    }
    
    static func goodsInfoContentImageTaped(tapGestureRecognizer:UITapGestureRecognizer){
        let view = tapGestureRecognizer.view
        let index = view!.tag-KGoodsInfoContentImageBaseTag
        NSNotificationCenter.defaultCenter().postNotificationName(KGoodsDealImageTouchedNotificationName, object: index)
    
    }

}


