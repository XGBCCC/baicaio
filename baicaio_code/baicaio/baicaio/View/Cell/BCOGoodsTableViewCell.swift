//
//  BCOGoodsTableViewCell
//  baicaio
//
//  Created by JimBo on 15/12/26.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit
import Kingfisher

class BCOGoodsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var soureLabel: UILabel!
    
    var goodsDealInfo = BCOGoodsDealInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 4
        self.containerView.layer.masksToBounds = true
        
        self.selectedBackgroundView = UIView(frame: self.containerView.frame)
        
    }
    
    
    
    func setupCellWithGoodsDealInfo(goodsDealInfo:BCOGoodsDealInfo){
        self.goodsImageView.kf_cancelDownloadTask()
        self.goodsDealInfo = goodsDealInfo
        if goodsDealInfo.imageUrl.hasPrefix("http://") {
            self.goodsImageView.kf_setImageWithURL(NSURL(string: goodsDealInfo.imageUrl)!, placeholderImage: nil)
        }else {
            self.goodsImageView.image = nil
        }
        titleLabel.text = goodsDealInfo.title
        soureLabel.text = goodsDealInfo.source + " | " + goodsDealInfo.date + " " + goodsDealInfo.time
    }

}
