//
//  UIImage+Color.swift
//  baicaio
//
//  Created by JimBo on 15/12/25.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import Foundation
public extension UIImage{

    public static func imageWithColor(color:UIColor,withFrame frame:CGRect)->UIImage{
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, frame)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    public static func imageWithColor(color:UIColor)->UIImage{
        return UIImage.imageWithColor(color, withFrame: CGRectMake(0, 0, 1, 1))
    }

}