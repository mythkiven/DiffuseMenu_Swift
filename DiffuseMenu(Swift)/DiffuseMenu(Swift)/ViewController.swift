//
//  ViewController.swift
//  DiffuseMenu(Swift)
//
//  Created by 蒋孝才 on 17/1/11.
//  github地址:https://github.com/mythkiven
//  如有任何问题，还请提issues
//
//  Copyright © 2017年 mythkiven. All rights reserved.
//
//  本动画是Swift版本的AwesomeMenu，OC版请参考https://github.com/levey/AwesomeMenu；
//  为方便注释，下边将add菜单按钮简称：菜单按钮，其余菜单选项按钮简称：选项按钮
//  代码相关的注解参见 https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/README.md；
//  在使用中如果出现BUG，或者优化的地方，还请提Issues，感谢！

import UIKit

class ViewController: UIViewController, SDiffuseMenuDelegate {
    
    @IBOutlet weak var menuView:                UIView!
    @IBOutlet weak var nearRadius:              UISlider!
    @IBOutlet weak var farRadius:               UISlider!
    @IBOutlet weak var endRadius:               UISlider!
    @IBOutlet weak var timeOffSet:              UISlider!
    @IBOutlet weak var menuWholeAngle:          UISlider!
    @IBOutlet weak var animationDration:        UISlider!
    @IBOutlet weak var rotateAddButton:         UISwitch!
    @IBOutlet weak var rotateAddButtonAngle:    UISlider!
//    @IBOutlet weak var menuType: UISwitch! // 开发中
    
    @IBOutlet weak var nearRadiusValue:             UITextField!
    @IBOutlet weak var farRadiusValue:              UITextField!
    @IBOutlet weak var endRadiusValue:              UITextField!
    @IBOutlet weak var timeOffSetValue:             UITextField!
    @IBOutlet weak var menuWholeAngleValue:         UITextField!
    @IBOutlet weak var animationDrationValue:       UITextField!
    @IBOutlet weak var rotateAddButtonAngleValue:   UITextField!
    
    var menu: SDiffuseMenu!
    
    // MARK: - 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let storyMenuItemImage        =  UIImage(named:"menuitem-normal.png")         else { fatalError("图片加载失败") }
        guard let storyMenuItemImagePressed =  UIImage(named:"menuitem-highlighted.png")    else { fatalError("图片加载失败") }
        guard let starImage                 =  UIImage(named:"star.png")                    else { fatalError("图片加载失败") }
        guard let starItemNormalImage       =  UIImage(named:"addbutton-normal.png")        else { fatalError("图片加载失败") }
        guard let starItemLightedImage      =  UIImage(named:"addbutton-highlighted.png")   else { fatalError("图片加载失败") }
        guard let starItemContentImage      =  UIImage(named:"plus-normal.png")             else { fatalError("图片加载失败") }
        guard let starItemContentLightedImage =  UIImage(named:"plus-highlighted.png")  else { fatalError("图片加载失败") }
        
        
        var menus = [SDiffuseMenuItem]()
        
        for _ in 0 ..< 9 {
            let starMenuItem =  SDiffuseMenuItem(image: storyMenuItemImage,
                                                 highlightedImage: storyMenuItemImagePressed, contentImage: starImage,
                                                 highlightedContentImage: nil)
            menus.append(starMenuItem)
        }
        
        let startItem =  SDiffuseMenuItem(image: starItemNormalImage,
                                             highlightedImage: starItemLightedImage,
                                             contentImage: starItemContentImage,
                                             highlightedContentImage: starItemContentLightedImage
        )
        let menuRect = CGRect.init(x: self.menuView.bounds.size.width/2,
                                   y: self.menuView.bounds.size.width/2,
                                   width: self.menuView.bounds.size.width,
                                   height: self.menuView.bounds.size.width)
        menu =  SDiffuseMenu(frame:menuRect, startItem:startItem,
                                 menusArray:menus as NSArray)
        menu.center = self.menuView.center
        menu.delegate = self
        self.menuView.addSubview(menu)
        resetAnimation("")
    }
    
    // MARK: -
    
    @IBAction func resetAnimation(_ sender: Any){
        if sender is UIButton {
            // 调试代码控制动画
//            if menu.expanding == true {
//                menu.close()
//            }else{
//                menu.open()
//            }
        }
        
        print("菜单状态%@",menu.expanding == true ? "展开":"关闭")
        
        nearRadiusDidChangeValue(nearRadius)
        farRadiusDidChangeValue(farRadius)
        endRadiusDidChangeValue(endRadius)
        timeOffSetDidChangeValue(timeOffSet)
        menuWholeAngleDidChangeValue(menuWholeAngle)
        animationDrationDidChangeValue(animationDration)
        rotateAddButtonAngleDidChangeValue(rotateAddButtonAngle)
        
        // 动画时长
        menu.animationDuration  = CFTimeInterval(animationDrationValue.text!)
        // 最小半径
        menu.nearRadius         = CGFloat((nearRadiusValue.text! as NSString).floatValue)
        // 结束半径
        menu.endRadius          = CGFloat((endRadiusValue.text! as NSString).floatValue)
        // 最大半径
        menu.farRadius          = CGFloat((farRadiusValue.text! as NSString).floatValue)
        // 单个动画间隔时间
        menu.timeOffset         = CFTimeInterval(timeOffSetValue.text!)!
        // 整体角度
        menu.menuWholeAngle     = CGFloat((menuWholeAngleValue.text! as NSString).floatValue)
        // 整体偏移角度，注意与menuWholeAngle差异，详情参见https://github.com/mythkiven/DiffuseMenu_Swift
        menu.rotateAngle        = CGFloat(0)
        // 展开时自旋角度
        menu.expandRotation     = CGFloat(M_PI)
        // 结束时自旋角度
        menu.closeRotation      = CGFloat(M_PI * 2)
        // 是否旋转菜单按钮
        menu.rotateAddButton    = rotateAddButton.isOn
        // 菜单按钮旋转角度
        menu.rotateAddButtonAngle = CGFloat((rotateAddButtonAngleValue.text! as NSString).floatValue)
    }
    
    
    @IBAction func nearRadiusDidChangeValue(_ sender: UISlider) {
        nearRadiusValue.text =  String(format: "%.1f", sender.value)
    }
    @IBAction func farRadiusDidChangeValue(_ sender: UISlider) {
        farRadiusValue.text =  String(format: "%.1f", sender.value)
    }
    @IBAction func endRadiusDidChangeValue(_ sender: UISlider) {
        endRadiusValue.text =  String(format: "%.1f", sender.value)
    }
    @IBAction func timeOffSetDidChangeValue(_ sender: UISlider) {
        timeOffSetValue.text =  String(format: "%.4f", sender.value)
    }
    @IBAction func menuWholeAngleDidChangeValue(_ sender: UISlider) {
        menuWholeAngleValue.text =  String(format: "%.2f", sender.value)
    }
    @IBAction func animationDrationDidChangeValue(_ sender: UISlider) {
        animationDrationValue.text =  String(format: "%.1f", sender.value)
    }
    @IBAction func rotateAddButtonAngleDidChangeValue(_ sender: UISlider) {
        rotateAddButtonAngleValue.text = String(format: "%.2f", sender.value)
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
    
    // MARK: -
  
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.resignFirstResponder()
//    }
}


