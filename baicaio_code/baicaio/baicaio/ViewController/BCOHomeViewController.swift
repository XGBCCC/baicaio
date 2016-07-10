//
//  BCOHomeViewController.swift
//  baicaio
//
//  Created by JimBo on 15/12/25.
//  Copyright © 2015年 JimBo. All rights reserved.
//

import UIKit

class BCOHomeViewController: YZDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpAllViewController()
        self.setUpTitleView()
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.dd(self.view)
    }
    
    func setUpTitleView(){
        self.titleFont = UIFont.systemFontOfSize(15)
        
        self.setUpTitleGradient { (isShowTitleGradient:UnsafeMutablePointer<ObjCBool>,titleColorGradientStyle:UnsafeMutablePointer<YZTitleColorGradientStyle>,startR:UnsafeMutablePointer<CGFloat>,startG:UnsafeMutablePointer<CGFloat>,startB:UnsafeMutablePointer<CGFloat>,endR:UnsafeMutablePointer<CGFloat>,endG:UnsafeMutablePointer<CGFloat>,endB:UnsafeMutablePointer<CGFloat>) -> Void in
            
            titleColorGradientStyle.initialize(YZTitleColorGradientStyleRGB)
            
            isShowTitleGradient.initialize(true)
            
            startR.initialize(0.76)
            startG.initialize(0.76)
            startB.initialize(0.76)
            
            
            endR.initialize(0.29)
            endG.initialize(0.63)
            endB.initialize(0.27)
            
        }
        
        self.setUpTitleScale { (isShowTitleScale:UnsafeMutablePointer<ObjCBool>,titleScale:UnsafeMutablePointer<CGFloat>) -> Void in
            
            isShowTitleScale.initialize(true)
            titleScale.initialize(1.13)
            
        }
    }
    
    func setUpAllViewController(){
    
        let homeViewController = Storyboards.Main.instantiateGoodsTableViewController()
        homeViewController.title = "首页"
        homeViewController.requestURLString = "http://www.baicaio.com/"
        homeViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(homeViewController)
        

        let ghhzViewController = Storyboards.Main.instantiateGoodsTableViewController()
        ghhzViewController.title = "个护化妆"
        ghhzViewController.requestURLString = "http://www.baicaio.com/topics/ghhz/"
        ghhzViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(ghhzViewController)
        
        let bjysViewController = Storyboards.Main.instantiateGoodsTableViewController()
        bjysViewController.title = "保健养生"
        bjysViewController.requestURLString = "http://www.baicaio.com/topics/bjys/"
        bjysViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(bjysViewController)
        
        let smjdViewController = Storyboards.Main.instantiateGoodsTableViewController()
        smjdViewController.title = "数码家电"
        smjdViewController.requestURLString = "http://www.baicaio.com/topics/smjd/"
        smjdViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(smjdViewController)
        
        let fzxhViewController = Storyboards.Main.instantiateGoodsTableViewController()
        fzxhViewController.title = "服装鞋帽"
        fzxhViewController.requestURLString = "http://www.baicaio.com/topics/fzxm/"
        fzxhViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(fzxhViewController)
        
        let xbsdViewController = Storyboards.Main.instantiateGoodsTableViewController()
        xbsdViewController.title = "箱包手袋"
        xbsdViewController.requestURLString = "http://www.baicaio.com/topics/xbsd/"
        xbsdViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(xbsdViewController)
        
        let zbssViewController = Storyboards.Main.instantiateGoodsTableViewController()
        zbssViewController.title = "钟表首饰"
        zbssViewController.requestURLString = "http://www.baicaio.com/topics/zbss/"
        zbssViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(zbssViewController)
        
        let mywjViewController = Storyboards.Main.instantiateGoodsTableViewController()
        mywjViewController.title = "母婴玩具"
        mywjViewController.requestURLString = "http://www.baicaio.com/topics/mywj/"
        mywjViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(mywjViewController)
        
        let rybhViewController = Storyboards.Main.instantiateGoodsTableViewController()
        rybhViewController.title = "日用百货"
        rybhViewController.requestURLString = "http://www.baicaio.com/topics/rybh/"
        rybhViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(rybhViewController)
        
        let spjyViewController = Storyboards.Main.instantiateGoodsTableViewController()
        spjyViewController.title = "食品酒饮"
        spjyViewController.requestURLString = "http://www.baicaio.com/topics/spjy/"
        spjyViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(spjyViewController)
        
        let tsyxViewController = Storyboards.Main.instantiateGoodsTableViewController()
        tsyxViewController.title = "图书音像"
        tsyxViewController.requestURLString = "http://www.baicaio.com/topics/tsyx/"
        tsyxViewController.viewType = BCOGoodsTableViewControllerShowType.GoodsDealInfoList
        self.addChildViewController(tsyxViewController)
    }
    

    func dd(view:UIView){
        for subView in view.subviews {
            self.dd(subView)
            if subView.isKindOfClass(UIScrollView) && (subView as! UIScrollView).scrollsToTop{
                print(subView)
            }
        }
    }

}

