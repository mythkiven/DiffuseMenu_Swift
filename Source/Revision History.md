

## Document Revision History

**SDiffuseMenu 使用及解析[请戳一下](https://github.com/mythkiven/DiffuseMenu_Swift)**

#### 2017-01-22  V1.2.0

- 支持 cocoaPods 
- 修改 storyboard :删除Stack View


#### 2017-01-20  V1.1.0

- 新增任意方位的直线形状动画:

1) 新增动画类型枚举:直线型 or 弧线形

``` swift
public enum SDiffuseMenuGrapyType : String {
    case line
    case arc
}
```

2) 初始化方法,需传入动画类型

``` swift
init(frame: CGRect, startItem: SDiffuseMenuItem, menusArray: NSArray, grapyType: SDiffuseMenuGrapyType) {}
```

3) 在初始化之后,仍可通过 `sDiffuseMenuGrapyType` 属性修改动画类型

- 新增8个常见方位的枚举,无需自行设置方向,拿来即可使用:

此枚举对 line 和 arc 两种动画形式皆有效

``` swift
    public enum SDiffuseMenuDirection : String {
        case above      // 上方180°
        
        case left       // 左方180°
        
        case right      // 右方180°
        
        case below      // 下方180°
        
        case upperLeft  // 左上方90°
        
        case upperRight // 右上方90°
        
        case lowerLeft  // 左下方90°
        
        case lowerRight // 右下方90°
        
        case other      // 其他方向
    }
```

- 修复BUG: 传入仅含一个元素的数组时,计算报错的问题
- 更新内容及部分配图..

#### 2017-01-18  V1.0.0

V1.0.0版,实现任意方位的弧线型动画



