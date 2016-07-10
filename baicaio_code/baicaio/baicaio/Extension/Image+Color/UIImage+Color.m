//
//  UIImage+Color.m
//  B2C_iPhone_V4
//
//  Created by JimBo on 15/6/30.
//  Copyright (c) 2015年 edu24ol. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+(UIImage *)imageWithColor:(UIColor *)aColor{
    return [UIImage imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
