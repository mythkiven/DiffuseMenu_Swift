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

import UIKit

class ViewController: UIViewController,SDiffuseMenuDelegate {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var nearRadius: UISlider!
    @IBOutlet weak var farRadius: UISlider!
    @IBOutlet weak var endRadius: UISlider!
    @IBOutlet weak var timeOffSet: UISlider!
    @IBOutlet weak var menuWholeAngle: UISlider!
    @IBOutlet weak var animationDration: UISlider!
    @IBOutlet weak var rotateAddButton: UISwitch!
    @IBOutlet weak var rotateAddButtonAngle: UISlider!
    @IBOutlet weak var menuType: UISwitch!
    
    @IBOutlet weak var nearRadiusValue: UITextField!
    @IBOutlet weak var farRadiusValue: UITextField!
    @IBOutlet weak var endRadiusValue: UITextField!
    @IBOutlet weak var timeOffSetValue: UITextField!
    @IBOutlet weak var menuWholeAngleValue: UITextField!
    @IBOutlet weak var animationDrationValue: UITextField!
    @IBOutlet weak var rotateAddButtonAngleValue: UITextField!
    
    var menu: SDiffuseMenu!
    
    // MARK: - 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyMenuItemImage          =  UIImage(named:"menuitem-normal.png")
        let storyMenuItemImagePressed   =  UIImage(named:"menuitem-highlighted.png")
        let starImage                   =  UIImage(named:"star.png")
        
            
        // Default Menu
        
        let starMenuItem1 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem2 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem3 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem4 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem5 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem6 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem7 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem8 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem9 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        let starMenuItem10 =  SDiffuseMenuItem(image:storyMenuItemImage!,
                                                 highlightedImage:storyMenuItemImagePressed!,
                                                 contentImage:starImage!,
                                                 highlightedContentImage:nil)
        
        let menus =  [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4,
                      starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8,
                      starMenuItem9,starMenuItem10]
        
        let starItemNormalImage         = UIImage(named:"addbutton-normal.png")
        let starItemLightedImage        = UIImage(named:"addbutton-highlighted.png")
        let starItemContentImage        = UIImage(named:"plus-normal.png")
        let starItemContentLightedImage = UIImage(named:"plus-highlighted.png")
        
        let startItem =  SDiffuseMenuItem(image:starItemNormalImage!,
                                             highlightedImage:starItemLightedImage!,
                                             contentImage:starItemContentImage!,
                                             highlightedContentImage:starItemContentLightedImage
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
    
    // MARK: - private
    
    @IBAction func resetAnimation(_ sender: Any){
        if sender is UIButton {
            
            if menu.expanding == true {
                menu.close()
            }else{
                menu.open()
            }
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
        // 自旋角度
        menu.rotateAngle        = CGFloat(0.0)
        // 菜单自旋角度
        menu.expandRotation     = CGFloat(M_PI_4)
        // 结束时自旋角度
        menu.closeRotation      = CGFloat(0.0 )
        // 是否旋转菜单按钮
        menu.rotateAddButton    = rotateAddButton.isOn
        // 是否单一展示
        
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
    
    func SDiffuseMenuDidSelectMenuItem(_ menu:SDiffuseMenu, didSelectIndex index:Int) {
        print("选中按钮at index:\(index) is: \(menu.menuItemAtIndex(index)) ")
    }
    
    func SDiffuseMenuDidClose(_ menu:SDiffuseMenu) {
        print("菜单关闭动画结束")
    }
    
    func SDiffuseMenuDidOpen(_ menu:SDiffuseMenu) {
        print("菜单展开动画结束")
    }
    
    func SDiffuseMenuWillOpen(_ menu:SDiffuseMenu) {
        print("菜单将要展开")
    }
    
    func SDiffuseMenuWillClose(_ menu:SDiffuseMenu) {
        print("菜单将要关闭")
    }
    
    // MARK: -
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.resignFirstResponder()
    }
}


