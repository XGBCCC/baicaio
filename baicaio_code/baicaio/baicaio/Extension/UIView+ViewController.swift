//
//  UIView+ViewController.swift
//  baicaio
//
//  Created by JimBo on 15/12/29.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import Foundation
public extension UIView{

    func findViewController() -> UIViewController? {
    
        for(var next = self.superview;(next != nil);next=next?.superview){
            
            let nextResponder = next?.nextResponder()
            
            if nextResponder!.isKindOfClass(UIViewController.self) {
                return nextResponder as? UIViewController
            }
        
        }
        return nil
        
    }

}