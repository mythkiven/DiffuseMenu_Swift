//
//
//
//  Created by mythkiven on 17/1/11.
//  github地址:https://github.com/mythkiven
//
//  说明如下:
//  1、本动画是 Swift 版本的 AwesomeMenu,OC 版请参考 https://github.com/levey/AwesomeMenu
//  2、代码解析见 https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/README.md
//  3、修订记录见 https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/Revision History.md


import UIKit

class ViewController: UIViewController, SDiffuseMenuDelegate {
    
    @IBOutlet weak var menuView:                UIView!
    @IBOutlet weak var nearRadius:              UISlider!
    @IBOutlet weak var farRadius:               UISlider!
    @IBOutlet weak var endRadius:               UISlider!
    @IBOutlet weak var timeOffSet:              UISlider!
    @IBOutlet weak var menuWholeAngle:          UISlider!
    @IBOutlet weak var animationDration:        UISlider!
    @IBOutlet weak var rotateAngle:             UISlider!
    @IBOutlet weak var isRotateAddButton:       UISwitch!
    @IBOutlet weak var rotateAddButtonAngle:    UISlider!
    @IBOutlet weak var isLineGrapyType:         UISwitch! 
    
    @IBOutlet weak var nearRadiusValue:             UITextField!
    @IBOutlet weak var farRadiusValue:              UITextField!
    @IBOutlet weak var endRadiusValue:              UITextField!
    @IBOutlet weak var timeOffSetValue:             UITextField!
    @IBOutlet weak var menuWholeAngleValue:         UITextField!
    @IBOutlet weak var animationDrationValue:       UITextField!
    @IBOutlet weak var rotateAddButtonAngleValue:   UITextField!
    @IBOutlet weak var rotateAngleValue:            UITextField!
    
    var menu: SDiffuseMenu!
    
    
    // MARK: - 
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let menuRect = CGRect.init(x: self.menuView.bounds.size.width/2,
                                   y: self.menuView.bounds.size.width/2,
                                   width: self.menuView.bounds.size.width,
                                   height: self.menuView.bounds.size.width)
        // 创建菜单
        
        menu         =  SDiffuseMenu(frame: menuRect,
                                 startItem: startItem,
                                 menusArray: menus as NSArray,
                                 grapyType: SDiffuseMenu.SDiffuseMenuGrapyType.arc)
        
        menu.center   = self.menuView.center
        menu.delegate = self
        
        self.menuView.addSubview(menu)
        
        // 配置动画
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
        
//        print("菜单状态%@",menu.expanding == true ? "展开":"关闭")
        
        // 获取控件初始数据
        nearRadiusDidChangeValue(nearRadius)
        farRadiusDidChangeValue(farRadius)
        endRadiusDidChangeValue(endRadius)
        timeOffSetDidChangeValue(timeOffSet)
        menuWholeAngleDidChangeValue(menuWholeAngle)
        animationDrationDidChangeValue(animationDration)
        rotateAddButtonAngleDidChangeValue(rotateAddButtonAngle)
        rotateAngleDidChangeValue(rotateAngle)
        
        // 动画配置:
        
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
        // 整体偏移角度
        menu.rotateAngle        = CGFloat((rotateAngleValue.text! as NSString).floatValue)
        // 展开时自旋角度
        menu.expandRotation     = CGFloat(M_PI)
        // 结束时自旋角度
        menu.closeRotation      = CGFloat(M_PI * 2)
        // 是否旋转菜单按钮
        menu.rotateAddButton    = isRotateAddButton.isOn
        // 菜单按钮旋转角度
        menu.rotateAddButtonAngle = CGFloat((rotateAddButtonAngleValue.text! as NSString).floatValue)
        // 菜单展示的形状:直线 or 弧形
        menu.sDiffuseMenuGrapyType = isLineGrapyType.isOn == true ? .line : .arc
       
        
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
    
    
    @IBAction func nearRadiusDidChangeValue(_ sender: UISlider) {
        nearRadiusValue.text =  String(format: "%.1f", sender.value)
    }
    @IBAction func farRadiusDidChangeValue(_ sender: UISlider) {
        farRadiusValue.text =  String(format: "%.1f", sender.value)
    }
    @IBAction func endRadiusDidChangeValue(_ sender: UISlider) {
        endRadiusValue.text =  String(format: "%.1f", sender.value)
    }
    @IBAction func animationDrationDidChangeValue(_ sender: UISlider) {
        animationDrationValue.text =  String(format: "%.1f", sender.value)
    }
    @IBAction func menuWholeAngleDidChangeValue(_ sender: UISlider) {
        menuWholeAngleValue.text =  String(format: "%.2f", sender.value)
    }
    @IBAction func rotateAddButtonAngleDidChangeValue(_ sender: UISlider) {
        rotateAddButtonAngleValue.text = String(format: "%.2f", sender.value)
    }
    @IBAction func rotateAngleDidChangeValue(_ sender: UISlider) {
        rotateAngleValue.text = String(format: "%.2f", sender.value)
    }
    @IBAction func timeOffSetDidChangeValue(_ sender: UISlider) {
        timeOffSetValue.text =  String(format: "%.4f", sender.value)
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


