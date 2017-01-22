//
//  ViewController.swift
//  SDiffuseMenuDemo
//
//  Created by gyjrong on 17/1/22.
//  Copyright © 2017年 mythkiven. All rights reserved.
//

import UIKit

import SDiffuseMenu


class ViewController: UIViewController, SDiffuseMenuDelegate {

    var menu: SDiffuseMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 本demo 用于测试 pod ,更丰富的 demo 请运行~/Source 目录下的 demo
        
        guard let storyMenuItemImage            =  UIImage(named:"menuitem-normal.png")         else { fatalError("图片加载失败") }
        guard let storyMenuItemImagePressed     =  UIImage(named:"menuitem-highlighted.png")    else { fatalError("图片加载失败") }
        guard let starImage                     =  UIImage(named:"star.png")                    else { fatalError("图片加载失败") }
        guard let starItemNormalImage           =  UIImage(named:"addbutton-normal.png")        else { fatalError("图片加载失败") }
        guard let starItemLightedImage          =  UIImage(named:"addbutton-highlighted.png")   else { fatalError("图片加载失败") }
        guard let starItemContentImage          =  UIImage(named:"plus-normal.png")             else { fatalError("图片加载失败") }
        guard let starItemContentLightedImage   =  UIImage(named:"plus-highlighted.png")        else { fatalError("图片加载失败") }
        
        // 选项数组
        var menus = [SDiffuseMenuItem]()
        for _ in 0 ..< 6 {
            let starMenuItem =  SDiffuseMenuItem(image: storyMenuItemImage,
                                                 highlightedImage: storyMenuItemImagePressed, contentImage: starImage,
                                                 highlightedContentImage: nil)
            menus.append(starMenuItem)
        }
        
        // 菜单按钮
        let startItem =  SDiffuseMenuItem(image: starItemNormalImage,
                                          highlightedImage: starItemLightedImage,
                                          contentImage: starItemContentImage,
                                          highlightedContentImage: starItemContentLightedImage
        )
        
        let menuRect = CGRect.init(x: self.view.bounds.size.width/2,
                                   y: self.view.bounds.size.width/2,
                                   width: self.view.bounds.size.width,
                                   height: self.view.bounds.size.width)
        // 创建菜单
        menu         =  SDiffuseMenu(frame: menuRect,
                                     startItem: startItem,
                                     menusArray: menus as NSArray,
                                     grapyType: SDiffuseMenu.SDiffuseMenuGrapyType.arc)
        
        menu.center   = self.view.center
        menu.delegate = self
        
        self.view.addSubview(menu)

        resetAnimation()
        
    }

    func resetAnimation(){
        
        
        // 动画时长
        menu.animationDuration  = CFTimeInterval(5.0)
        // 最小半径
        menu.nearRadius         = CGFloat(50)
        // 结束半径
        menu.endRadius          = CGFloat(100)
        // 最大半径
        menu.farRadius          = CGFloat(150)
        // 单个动画间隔时间
        menu.timeOffset         = CFTimeInterval(0.001)
        // 整体角度
        menu.menuWholeAngle     = CGFloat(M_PI*2)
        // 整体偏移角度
        menu.rotateAngle        = CGFloat(0)
        // 展开时自旋角度
        menu.expandRotation     = CGFloat(M_PI)
        // 结束时自旋角度
        menu.closeRotation      = CGFloat(M_PI * 2)
        // 是否旋转菜单按钮
        menu.rotateAddButton    = true
        // 菜单按钮旋转角度
        menu.rotateAddButtonAngle = CGFloat(M_PI_4)
        // 菜单展示的形状:直线 or 弧形
        menu.sDiffuseMenuGrapyType = .arc
        
        
        // 为方便使用,已枚举常见方位,可直接使用.无需再次设置 rotateAngle && menuWholeAngle
        // 若对于 rotateAngle\menuWholeAngle 不熟悉,建议查看 source 目录下的配置图片
        //        menu.sDiffuseMenuDirection = .above // 上方180°
        //        menu.sDiffuseMenuDirection = .left // 左方180°
        //        menu.sDiffuseMenuDirection = .below // 下方180°
        //        menu.sDiffuseMenuDirection = .right // 右方180°
        //        menu.sDiffuseMenuDirection = .upperRight // 右上方90°
        //        menu.sDiffuseMenuDirection = .lowerRight // 右下方90°
        //        menu.sDiffuseMenuDirection = .upperLeft // 左上方90°
        //        menu.sDiffuseMenuDirection = .lowerLeft // 左下方90°
        //        menu.sDiffuseMenuDirection = .other
        
    }


    // MARK: - 动画代理方法

    func SDiffuseMenuDidSelectMenuItem(_ menu: SDiffuseMenu, didSelectIndex index: Int) {
        print("选中按钮at index:\(index) is: \(menu.menuItemAtIndex(index)) ")
    }
    
    func SDiffuseMenuDidClose(_ menu: SDiffuseMenu) {
        print("关闭动画关闭结束")
    }
    
    func SDiffuseMenuDidOpen(_ menu: SDiffuseMenu) {
        print("展开动画展开结束")
    }
    
    func SDiffuseMenuWillOpen(_ menu: SDiffuseMenu) {
        print("菜单将要展开")
    }
    
    func SDiffuseMenuWillClose(_ menu: SDiffuseMenu) {
        print("菜单将要关闭")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

