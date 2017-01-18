
## SDiffuseMenu,Swift版的AwesomeMenu


>本动画是Swift版的[AwesomeMenu](https://github.com/levey/AwesomeMenu),如需OC版还请移步[这里](https://github.com/levey/AwesomeMenu)。
>Swift Diffuse Menu 简写: SDiffuseMenu
>我是刚从OC转Swift不久，还请大神多多指教😁😁

![](https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/SDiffuseMenu.gif)

## 嵌入使用
1、添加协议
``` swift
class ViewController: UIViewController,SDiffuseMenuDelegate {
    var menu: SDiffuseMenu!
}
```
2、设置选项数据
``` swift
guard let storyMenuItemImage        =  UIImage(named:"menuitem-normal.png")         else { fatalError("图片加载失败") }
        guard let storyMenuItemImagePressed =  UIImage(named:"menuitem-highlighted.png")    else { fatalError("图片加载失败") }
        guard let starImage                 =  UIImage(named:"star.png")                    else { fatalError("图片加载失败") }
        guard let starItemNormalImage       =  UIImage(named:"addbutton-normal.png")        else { fatalError("图片加载失败") }
        guard let starItemLightedImage      =  UIImage(named:"addbutton-highlighted.png")   else { fatalError("图片加载失败") }
        guard let starItemContentImage      =  UIImage(named:"plus-normal.png")             else { fatalError("图片加载失败") }
        guard let starItemContentLightedImage =  UIImage(named:"plus-highlighted.png")  else { fatalError("图片加载失败") }
        
        // Default Menu
        
        var menus = [SDiffuseMenuItem]()
        for _ in 0 ..< 9 {
            let starMenuItem =  SDiffuseMenuItem(image:storyMenuItemImage,
                                                 highlightedImage:storyMenuItemImagePressed, contentImage:starImage,
                                                 highlightedContentImage:nil)
            menus.append(starMenuItem)
        }
```
3、设置菜单按钮
``` swift
let startItem =  SDiffuseMenuItem(image:starItemNormalImage,
                                             highlightedImage:starItemLightedImage,
                                             contentImage:starItemContentImage,
                                             highlightedContentImage:starItemContentLightedImage
        )
```
4、添加SDiffuseMenu
``` swift
let menuRect = CGRect.init(x: self.menuView.bounds.size.width/2,
                                   y: self.menuView.bounds.size.width/2,
                                   width: self.menuView.bounds.size.width,
                                   height: self.menuView.bounds.size.width)
        menu =  SDiffuseMenu(frame:menuRect, startItem:startItem,
                                 menusArray:menus as NSArray)
        menu.center = self.menuView.center
        menu.delegate = self
        self.menuView.addSubview(menu)
```
5、动画配置

注意：动画中半径的变化:0-->最大farRadius-->最小nearRadius-->结束endRadius
``` swift
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
menu.rotateAngle        = CGFloat(0.0)
// 展开时自旋角度
menu.expandRotation     = CGFloat(M_PI)
// 结束时自旋角度
menu.closeRotation      = CGFloat(M_PI * 2)
// 是否旋转菜单按钮
menu.rotateAddButton    = rotateAddButton.isOn
// 菜单按钮旋转角度
menu.rotateAddButtonAngle = CGFloat((rotateAddButtonAngleValue.text! as NSString).floatValue)
// ..
```
6、动画过程监听
``` swift
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
```

## Swift转写之旅

总的来说，动画的原理还是比较简单的，涉及到的内容主要是CABasicAnimation、CAKeyframeAnimation以及事件响应链相关知识，下边分两部分分别介绍之。

#### CAPropertyAnimation动画

![](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Animation_Types_Timing/Art/animations_info_2x.png)

在SDiffuseMenu中动画用的是CAPropertyAnimation的子类CABasicAnimation和CAKeyframeAnimation实现，这两个子类简述如下：

- CABasicAnimation其实可以看作一种特殊的关键帧动画,只有头尾两个关键帧,具有移动、旋转、缩放等基本动画;
- CAKeyframeAnimation则可以支持任意多个关键帧,关键帧有两种方式来指定,使用path或values;
- path可以是CGPathRef、CGMutablePathRef或者贝塞尔曲线,注意的是：设置了path之后values就无效了;
- values则相对灵活, 可以指定任意关键帧帧值;
- 其他像keyTimes可以为values中的关键帧设置一一对应对应的时间点,其取值范围为0到1.0,keyTimes没有设置的时候,各个关键帧的时间是平分的等等

>更多的动画知识请戳此处 [CoreAnimation_guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004514)
>>
>>相关的指南、示例代码可以通过点击页面右上角搜索按钮进行搜索，其实官方的东西挺适合入门的，因为官方文档大多点到为止，更深的还是需要实践中摸索总结的。

#### 动画分析

不论多么复杂的动画，都是由简单的动画组成的，大家先看看SDiffuseMenu中单选项动画：

![](https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/singleItemAnimation.gif)

仔细分析发现可以将整个动画可以拆分为三大部分：

- 1、菜单按钮的自旋转，通过transform属性即可实现；
- 2、选项按钮的整体展开动画，实际是在定时器中依次添加选项按钮的动画组，控制timeInterval来实现动画的先后顺序；
- 3、单个动画拆分为3部分：展开动画、结束动画和点击动画，都是动画组，下边以结束动画为例，简单介绍其实现过程：

**单个关闭动画分析**

点击关闭动画之后：选项首先会自旋转从endRadius到farRadius，到达farRadius之后，开始返回并同时自旋转，然后回到起始点。

**1、自旋**

自旋转过程主要是靠控制关键帧，大家仔细看会发现展开动画和结束动画的自旋转是有差异的，因为关键帧设置的不同。

展开动画中设置的关键帧如下，0.3对应expandRotation展开自选角度，0.4对应0°，所以在0.3 -> 0.4的时间会出现快速的自旋。
``` swift
rotateAnimation.values = [CGFloat(expandRotation),CGFloat(0.0)]
rotateAnimation.keyTimes = [NSNumber(value: 0.3 as Float),  NSNumber(value: 0.4 as Float)]
```

而关闭的动画中我设置如下，细化了关键帧，可以看出自旋的动画细节丰富一些，0 -> 0.4 慢速自旋，0.4 -> 0.5 快速自旋。
``` swift
rotateAnimation.values = [CGFloat(0.0),CGFloat(closeRotation),CGFloat(0.0)]
rotateAnimation.keyTimes = [NSNumber(value: 0.0 as Float),NSNumber(value: 0.4 as Float), NSNumber(value: 0.5 as Float)]
```

**2、移动**

移动的控制源于path是怎样设定的，代码中我写了两种方法，其中一种是注释掉的：

``` swift
let positionAnimation =  CAKeyframeAnimation(keyPath:"position")
positionAnimation.duration = animationDuration
```
使用贝塞尔曲线作为path,从代码中可以明显的看出移动的路径：endPoint -> farPoint -> startPoint
``` swift
let path = UIBezierPath.init()
path.move(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
path.addLine(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
positionAnimation.path = path.cgPath
```
或者使用CGPathRef或GCMutablePathRef设置路径
``` swift
let path =  CGMutablePath()
path.move(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
path.addLine(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
positionAnimation.path = path
```

自旋和平移都有了，接下来要加入到动画组中：
``` swift
let animationgroup =  CAAnimationGroup()
animationgroup.animations = [positionAnimation, rotateAnimation]
animationgroup.duration = animationDuration
// 动画结束后，layer保持最终的状态
animationgroup.fillMode = kCAFillModeForwards
// 速度控制我设置的如此，大家根据需要自行修改即可
animationgroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
// 代理是为了获取到动画结束的信号
animationgroup.delegate = self
```

然后添加进layer即可 'item.layer.add(animationgroup,forKey:"Close")'

其余的动画原理其实和上边的关闭动画是一样的，基于属性的动画，通过操作帧来实现我们想要的效果，小伙伴们直接看代码吧~

**这里插一句，不知道小伙伴们有没有注意到一点，就是layer为什么叫CALayer，而且和动画的关系还这么紧密？** **原因在下文**



#### 整体动画的控制

注意，整体动画的控制上边并未表述，在这个地方也需要注意下，为了让整体动画在一个合适的角度展示出来，就需要从整体上控制角度。其中属性menuWholeAngle控制整体动画的范围角度，rotateAngle属性用于控制整体的偏移角度。

![](https://ooo.0o0.ooo/2017/01/16/587c8c512c911.png)
![](https://ooo.0o0.ooo/2017/01/16/587c8c7530072.png)
![](https://ooo.0o0.ooo/2017/01/16/587c8c8635998.png)

实现整体的偏移，具体到代码就是每一个选项按钮都按照rotateAngle进行偏移：
``` swift
private func _rotateCGPointAroundCenter( _ point: CGPoint, center: CGPoint, angle: CGFloat) -> CGPoint {
    let translation     = CGAffineTransform(translationX: center.x, y: center.y)
    let rotation        = CGAffineTransform(rotationAngle: angle)
    let transformGroup  = translation.inverted().concatenating(rotation).concatenating(translation)
    return point.applying(transformGroup)
}
```

当从两个方面来控制整体的角度之后，单个选项的坐标也变得容易计算了：
``` swift
// 
// ti * menuWholeAngle / icount - CGFloat(1.0) 表示每个选项相对于正Y轴的偏移角度 

let sinValue  = CGFloat(sinf(Float(ti * menuWholeAngle / icount - CGFloat(1.0))))
let cosValue  = CGFloat(cosf(Float(ti * menuWholeAngle / icount - CGFloat(1.0) )))
// 结束点坐标
var x         = startPoint.x + CGFloat(endRadius) * sinValue
var y         = (CGFloat(startPoint.y) - endRadius * cosValue)
let endPoint  =  CGPoint(x: x,y: y)
item.endPoint = _rotateCGPointAroundCenter(endPoint, center: startPoint, angle: rotateAngle)
// 最近点坐标
x = startPoint.x + nearRadius * CGFloat(sinValue)
y = startPoint.y - nearRadius * CGFloat(cosValue)
let nearPoint  =  CGPoint(x: x, y: y)
item.nearPoint = _rotateCGPointAroundCenter(nearPoint, center: startPoint, angle: rotateAngle)
// 最远点坐标
let farPoint   =  CGPoint(x: startPoint.x + farRadius * sinValue, y: startPoint.y - farRadius * cosValue)
item.farPoint  = _rotateCGPointAroundCenter(farPoint, center: startPoint, angle: rotateAngle)
```



#### 事件响应链

当touch事件发生之后，传递给控件之后，控件会调用'hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {}'遍历子view，寻找合适的view来处理事件，其中'point(inside point: CGPoint, with event: UIEvent?) -> Bool'

说道事件响应小伙伴们想起的是不是hitTest，SDiffuseMenu这里其实暂时没有用hitTest，主要是用point来处理touch事件。



``` swift
override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    // 动画中禁止touch
    if (_isAnimating) {
        return false
    }
    // 展开时可以touch任意按钮
    else if (true == expanding) {
        return true
    } 
    // 除上述情况外，仅菜单按钮可点击
    else {
        return _startButton.frame.contains(point)
    }
}
```

## 优化与改进






