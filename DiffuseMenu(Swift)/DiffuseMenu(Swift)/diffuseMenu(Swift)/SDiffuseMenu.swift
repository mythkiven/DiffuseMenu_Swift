//
//  SDiffuseMenu.swift
//  SDiffuseMenu
//
//  Created by 蒋孝才 on 17/1/11.
//  github地址:https://github.com/mythkiven
//
//  Copyright © 2017年 mythkiven. All rights reserved.
//
//  本动画是Swift版本的AwesomeMenu，OC版请参考https://github.com/levey/AwesomeMenu；
//  为方便注释，下边将add菜单按钮简称：菜单按钮，其余菜单选项按钮简称：选项按钮
//  代码相关的注解参见wiki；
//  在使用中如果出现BUG，或者优化的地方，还请提Issues，感谢！



import UIKit
import QuartzCore

protocol SDiffuseMenuDelegate : NSObjectProtocol {
    
    func SDiffuseMenuWillOpen(_ menu: SDiffuseMenu) // 将要开始展开动画
    
    func SDiffuseMenuWillClose(_ menu: SDiffuseMenu) // 将要开始关闭动画
    
    func SDiffuseMenuDidSelectMenuItem(_ menu: SDiffuseMenu, didSelectIndex index: Int) // 选中选项按钮
    
    func SDiffuseMenuDidOpen(_ menu: SDiffuseMenu) // 展开动画展开结束
    
    func SDiffuseMenuDidClose(_ menu: SDiffuseMenu) // 关闭动画关闭结束
    
}

class SDiffuseMenu : UIView, SDiffuseMenuItemDelegate, CAAnimationDelegate {
    
    // MARK: - 属性
    
    var menusItems: NSArray!{// 菜单数据源
        willSet {
            if (menusItems == newValue) {
                return
            }
            for v in self.subviews {
                if (v.tag >= 1000) {
                    v.removeFromSuperview()
                }
            }
        }
    }
    var expanding:              Bool = false // 是否在展开状态
    var nearRadius:             CGFloat! // 动画中半径的变化:从0-->最大farRadius-->最小nearRadius-->结束endRadius
    var endRadius:              CGFloat! // 动画中半径的变化:从0-->最大farRadius-->最小nearRadius-->结束endRadius
    var farRadius:              CGFloat! // 动画中半径的变化:从0-->最大farRadius-->最小nearRadius-->结束endRadius
    var startPoint:             CGPoint! // 动画起始点
    var timeOffset:             TimeInterval = 0 // 单个动画开始执行时间间隔
    var rotateAngle:            CGFloat! // 单个动画自旋角度
    var menuWholeAngle:         CGFloat! // 所有选项的整体角度,360°:M_PI * 2, 右上角90°:M_PI_2, ...
    var expandRotation:         CGFloat! // 展开时选项自旋角度
    var closeRotation:          CGFloat! // 关闭时选项自旋角度
    var animationDuration:      CFTimeInterval!// 动画时长
    var rotateAddButton:        Bool! // 是否要旋转菜单按钮
    var rotateAddButtonAngle:   CGFloat! // 旋转菜单按钮旋转的角度
    var delegate:               SDiffuseMenuDelegate!
    
    private var _flag:          Int = 0
    private var _timer:         Timer!
    private var _startButton:   SDiffuseMenuItem!
    private var _isAnimating:   Bool = false
    
    let kDiffuseMenuDefaultNearRadius                   = CGFloat(110.0)
    let kDiffuseMenuDefaultEndRadius                    = CGFloat(120.0)
    let kDiffuseMenuDefaultFarRadius                    = CGFloat(140.0)
    let kDiffuseMenuDefaultStartPointX                  = CGFloat(160.0)
    let kDiffuseMenuDefaultStartPointY                  = CGFloat(240.0)
    let kDiffuseMenuDefaultTimeOffset                   = 0.036
    let kDiffuseMenuDefaultRotateAngle                  = CGFloat(0.0)
    let kDiffuseMenuRotateAddButtonAngle                = CGFloat(-M_PI_4)
    let kDiffuseMenuDefaultMenuWholeAngle               = CGFloat(M_PI * 2)
    let kDiffuseMenuDefaultExpandRotation               = CGFloat(M_PI)
    let kDiffuseMenuDefaultCloseRotation                = CGFloat(M_PI * 2)
    let kDiffuseMenuDefaultAnimationDuration            = 0.5
    let kDiffuseMenuStartMenuDefaultAnimationDuration   = 0.3
    
    
    // MARK: - 初始化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(frame: CGRect, startItem: SDiffuseMenuItem, menusArray: NSArray) {
        super.init(frame: frame)
        
        self.nearRadius     = kDiffuseMenuDefaultNearRadius
        self.endRadius      = kDiffuseMenuDefaultEndRadius
        self.farRadius      = kDiffuseMenuDefaultFarRadius
        self.timeOffset     = Double(kDiffuseMenuDefaultTimeOffset)
        self.rotateAngle    = kDiffuseMenuDefaultRotateAngle
        self.menuWholeAngle = kDiffuseMenuDefaultMenuWholeAngle
        self.startPoint     = CGPoint(x: kDiffuseMenuDefaultStartPointX, y: kDiffuseMenuDefaultStartPointY)
        self.expandRotation = kDiffuseMenuDefaultExpandRotation
        self.closeRotation  = kDiffuseMenuDefaultCloseRotation
        self.animationDuration      = Double(kDiffuseMenuDefaultAnimationDuration)
        self.rotateAddButton        = true
        self.rotateAddButtonAngle   = kDiffuseMenuRotateAddButtonAngle
        self.backgroundColor        = UIColor.white
        self.menusItems             = menusArray
        _startButton                = startItem
        _startButton.delegate       = self
        _startButton.center         = self.startPoint
        
        self.addSubview(_startButton)
    }
    
    // MARK: - image
    func setStartPoint(_ aPoint: CGPoint) {
        startPoint          = aPoint
        _startButton.center = aPoint
    }
    func setImage(_ image: UIImage) {
        _startButton.image = image
    }
    func image() -> UIImage {
        return _startButton.image!
    }
    func setHighlightedImage(_ highlightedImage: UIImage) {
        _startButton.highlightedImage = highlightedImage
    }
    func getHighlightedImage() -> UIImage {
        return _startButton.highlightedImage!
    }
    func setContentImage(_ contentImage: UIImage) {
        _startButton.contentImageView.image = contentImage
    }
    func getContentImage() -> UIImage {
        return _startButton.contentImageView.image!
    }
    func setHighlightedContentImage(_ highlightedContentImage: UIImage) {
        _startButton.contentImageView.highlightedImage = highlightedContentImage
    }
    func getHighlightedContentImage() -> UIImage {
        return _startButton.contentImageView.highlightedImage!
    }
    
    // MARK: - public
    
    public func open() {
        if _isAnimating == true || self.expanding == true {
            return
        }
        _expandingMenu(true)
    }
    
    public func close() {
        if _isAnimating == true || self.expanding == false {
            return
        }
        _expandingMenu(false)
    }
    
    public func menuItemAtIndex(_ index: Int) -> SDiffuseMenuItem? {
        if index >= menusItems.count {
             return nil
        }
        return menusItems.object(at: index) as? SDiffuseMenuItem
    }
    
    // MARK: - SDiffuseMenuItemDelegate
    
    func SDiffuseMenuItemTouchesBegan(_ item: SDiffuseMenuItem) {
        if (item == _startButton) {
            self.expanding = !self.expanding
            _expandingMenu(self.expanding)
        }
    }
    
    func SDiffuseMenuItemTouchesEnd(_ item: SDiffuseMenuItem) {
        if (item == _startButton) {
            return
        }
        
        let blowup = self._blowupAnimationAtPoint(item.center)
        item.layer.add(blowup, forKey: "blowup")
        item.center = item.startPoint
        
        for index in 0 ..< menusItems.count {
            let otherItem = menusItems.object(at: index) as! SDiffuseMenuItem
            let shrink    = self._shrinkAnimationAtPoint(otherItem.center)
            if (otherItem.tag == item.tag) {
                continue
            }
            otherItem.layer.add(shrink, forKey: "shrink")
            otherItem.center = otherItem.startPoint
        }
        expanding = false
        
        let angle =  self.expanding ? -M_PI_4 : 0.0
        UIView.animate(withDuration: animationDuration, animations: {
            ()-> Void in
            self._startButton.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        })
        
        self.delegate.SDiffuseMenuDidSelectMenuItem(self, didSelectIndex: (item.tag - 1000))
    }
    
    // MARK: - 事件链
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (_isAnimating) {
            return false
        }
        if (true == expanding) {
            return true
        } else {
            return _startButton.frame.contains(point)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.expanding = !self.expanding
        _expandingMenu(self.expanding)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(anim.value(forKey: "id") as? NSString == "lastAnimation") {
            self.delegate?.SDiffuseMenuDidClose(self)
        }
        if(anim.value(forKey: "id") as? NSString == "firstAnimation") {
            self.delegate?.SDiffuseMenuDidOpen(self)
        }
    }
    
    // MARK: - private
    
    private func _expandingMenu(_ expanding: Bool) {
        if (expanding) {
            self._setMenu()
            self.delegate?.SDiffuseMenuWillOpen(self)
        }else {
            self.delegate?.SDiffuseMenuWillClose(self)
        }
        
        self.expanding = expanding
        
        if ((rotateAddButton) == true) {
            let angle = self.expanding ? rotateAddButtonAngle : 0.0
            
            UIView.animate(withDuration: Double(kDiffuseMenuStartMenuDefaultAnimationDuration), animations: {
                ()-> Void in
                self._startButton.transform = CGAffineTransform(rotationAngle: CGFloat(angle!))
            })
        }
        
        if (_timer == nil) {
            _flag = self.expanding ? 0 : (menusItems.count - 1)
            let selector =  self.expanding ? #selector(_expandAnimation) : #selector(_closeAnimation)
            _timer = Timer(timeInterval: timeOffset,
                           target: self,
                           selector: selector,
                           userInfo: nil,
                           repeats: true)
            
            RunLoop.current.add(_timer, forMode: RunLoopMode.commonModes)
            _isAnimating = true
        }
    }
    
    @objc private func _expandAnimation() {
        if (_flag == menusItems.count) {
            _isAnimating = false
            _timer.invalidate()
            _timer = nil
            return
        }
        let tag =  1000 + _flag
        
        if self.viewWithTag(tag) == nil {
            return
        }
        
        let item = self.viewWithTag(tag) as! SDiffuseMenuItem
        
        let rotateAnimation =  CAKeyframeAnimation(keyPath:"transform.rotation.z")
        rotateAnimation.values = [CGFloat(expandRotation),CGFloat(0.0)]
        rotateAnimation.duration = animationDuration
        rotateAnimation.keyTimes = [NSNumber(value: 0.3 as Float),  NSNumber(value: 0.4 as Float)]
        
        let positionAnimation =  CAKeyframeAnimation(keyPath:"position")
        positionAnimation.duration = animationDuration
        
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
        path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
        path.addLine(to: CGPoint(x: item.nearPoint.x, y: item.nearPoint.y))
        path.addLine(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
        positionAnimation.path = path.cgPath
        
        /*  写法2:
         
         let path =  CGMutablePath()
         path.move(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
         path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
         path.addLine(to: CGPoint(x: item.nearPoint.x, y: item.nearPoint.y))
         path.addLine(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
         positionAnimation.path = path
         
         */
        
        let animationgroup =  CAAnimationGroup()
        animationgroup.animations = [positionAnimation, rotateAnimation ]
        animationgroup.duration = animationDuration
        animationgroup.fillMode = kCAFillModeForwards
        animationgroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        animationgroup.delegate = self
        
        if(_flag == menusItems.count - 1) {
            animationgroup.setValue("firstAnimation",forKey:"id")
        }
        
        item.layer.add(animationgroup,forKey:"Expand")
        item.center = item.endPoint
        
        _flag += 1
    }
    
    @objc private func _closeAnimation() {
        if (_flag == -1) {
            _isAnimating = false
            _timer.invalidate()
            _timer = nil
            return
        }
        
        let tag =  1000 + _flag
        let item =  self.viewWithTag(tag) as! SDiffuseMenuItem
        
        let rotateAnimation =  CAKeyframeAnimation(keyPath:"transform.rotation.z")
        rotateAnimation.values = [CGFloat(0.0),CGFloat(closeRotation),CGFloat(0.0)]
        rotateAnimation.duration = animationDuration
        rotateAnimation.keyTimes = [NSNumber(value: 0.0 as Float),    NSNumber(value: 0.4 as Float),                                NSNumber(value: 0.5 as Float)]
        
        let positionAnimation =  CAKeyframeAnimation(keyPath:"position")
        positionAnimation.duration = animationDuration
        
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
        path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
        path.addLine(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
        positionAnimation.path = path.cgPath
        
        /*  写法2:
         
         let path =  CGMutablePath()
         path.move(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
         path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
         path.addLine(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
         positionAnimation.path = path
         
         */
        
        let animationgroup =  CAAnimationGroup()
        animationgroup.animations = [positionAnimation, rotateAnimation]
        animationgroup.duration = animationDuration
        animationgroup.fillMode = kCAFillModeForwards
        animationgroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        animationgroup.delegate = self
        
        if(_flag == 0){
            animationgroup.setValue("lastAnimation",forKey:"id")
        }
        
        item.layer.add(animationgroup,forKey:"Close")
        item.center = item.startPoint
        
        _flag -= 1
    }
    
    private func _blowupAnimationAtPoint(_ p:CGPoint) -> CAAnimationGroup {
        
        let positionAnimation =  CAKeyframeAnimation(keyPath:"position")
        positionAnimation.values = [NSValue(cgPoint: p)]
        positionAnimation.keyTimes = [NSNumber(value: 0.3 as Float)]
        
        let scaleAnimation =  CABasicAnimation(keyPath:"transform")
        scaleAnimation.toValue = NSValue(caTransform3D:CATransform3DMakeScale(3.0, 3.0, 1.0))
        
        let opacityAnimation =  CABasicAnimation(keyPath:"opacity")
        opacityAnimation.toValue  = NSNumber(value: 0.0 as Float)
        
        let animationgroup =  CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = animationDuration
        animationgroup.fillMode = kCAFillModeForwards
        
        return animationgroup
    }
    
    private func _shrinkAnimationAtPoint(_ p:CGPoint) -> CAAnimationGroup {
        
        let positionAnimation =  CAKeyframeAnimation(keyPath:"position")
        positionAnimation.values = [ NSValue(cgPoint: p) ]
        positionAnimation.keyTimes = [ NSNumber(value: 0.3 as Float) ]
        
        let scaleAnimation =  CABasicAnimation(keyPath:"transform")
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1))
        
        let opacityAnimation =  CABasicAnimation(keyPath:"opacity")
        opacityAnimation.toValue  = NSNumber(value: 0.0 as Float)
        
        let animationgroup =  CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = animationDuration
        animationgroup.fillMode = kCAFillModeForwards
        
        return animationgroup
    }
    
    private func _rotateCGPointAroundCenter( _ point: CGPoint, center: CGPoint, angle: CGFloat) -> CGPoint {
        let translation     = CGAffineTransform(translationX: center.x, y: center.y)
        let rotation        = CGAffineTransform(rotationAngle: angle)
        let transformGroup  = translation.inverted().concatenating(rotation).concatenating(translation)
        
        return point.applying(transformGroup)
        
    }
    
    private func _setMenu() {
        for index in 0 ..< menusItems.count {
            
            let tcount  = CGFloat(menusItems.count)
            let item    = menusItems.object(at: index) as! SDiffuseMenuItem
            let ti      = CGFloat(index)
            
            item.tag = 1000 + index
            item.startPoint = self.startPoint
            
            if (menuWholeAngle >= CGFloat(M_PI * 2)) {
                menuWholeAngle = menuWholeAngle - menuWholeAngle / (tcount)
            }
            let p1 = ti * menuWholeAngle
            let p2 = tcount - CGFloat(1.0)
            let sin = sinf(Float(p1 / p2))
            
            var x = startPoint.x + CGFloat(endRadius) * CGFloat(sin)
            var y = (CGFloat(startPoint.y) - endRadius * CGFloat(cosf(Float(ti * menuWholeAngle / CGFloat(tcount - CGFloat(1))))))
            
            let endPoint =  CGPoint(x: x,y: y)
            item.endPoint = _rotateCGPointAroundCenter(endPoint, center: startPoint, angle: rotateAngle)
            x = startPoint.x + nearRadius * CGFloat(sinf(Float(ti * menuWholeAngle / (tcount - CGFloat(1)))))
            y = startPoint.y - nearRadius * CGFloat(cosf(Float(ti * menuWholeAngle / (tcount - CGFloat(1)))))
            let nearPoint =  CGPoint(x: x, y: y)
            item.nearPoint = _rotateCGPointAroundCenter(nearPoint, center: startPoint, angle: rotateAngle)
            
            let farPoint =  CGPoint(x: startPoint.x + farRadius * CGFloat(sinf(Float(ti * menuWholeAngle / (tcount - CGFloat(1))))), y: startPoint.y - farRadius * CGFloat(cosf(Float(ti * menuWholeAngle / (tcount - CGFloat(1))))))
            item.farPoint = _rotateCGPointAroundCenter(farPoint, center: startPoint, angle: rotateAngle)
            item.center = item.startPoint
            item.delegate = self
            self.insertSubview(item, belowSubview:_startButton)
            
        }
    }

    
}















