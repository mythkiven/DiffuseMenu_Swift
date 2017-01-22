//
//
//  V1.1.0
// 
//  Created by mythkiven on 17/1/11.
//  github地址:https://github.com/mythkiven
//
//  说明如下:
//  1、本动画是 Swift 版本的 AwesomeMenu,OC 版请参考 https://github.com/levey/AwesomeMenu
//  2、代码解析见 https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/README.md
//  3、修订记录见 https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/Revision History.md

import UIKit

protocol SDiffuseMenuItemDelegate : NSObjectProtocol {
    
    func SDiffuseMenuItemTouchesBegan(_ item: SDiffuseMenuItem)
    
    func SDiffuseMenuItemTouchesEnd(_ item: SDiffuseMenuItem)
}

class SDiffuseMenuItem : UIImageView {
    var contentImageView:   UIImageView!
    var startPoint:         CGPoint!
    var endPoint:           CGPoint!
    var nearPoint:          CGPoint!
    var farPoint:           CGPoint!
    
    var delegate: SDiffuseMenuItemDelegate!
    
    let kDiffuseMenuItemDefaultTouchRange = CGFloat(2.0)
    
    required init?(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
    }
    
    init(image:UIImage,
         highlightedImage hImg: UIImage,
         contentImage cImg:UIImage,
         highlightedContentImage hCImg:UIImage!) {
        super.init(image: image)
        
        contentImageView                    = UIImageView(image:cImg)
        contentImageView.highlightedImage   = hCImg
        self.image                          = image
        self.highlightedImage               = hImg
        self.isUserInteractionEnabled       = true
        
        self.addSubview(contentImageView)
        
    }
    
    override var isHighlighted: Bool {
        set(vaN) {
            super.isHighlighted             = vaN
            contentImageView.isHighlighted  = vaN
        }
        get{
            return super.isHighlighted
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bounds = CGRect(x: 0,
                             y: 0,
                             width: self.image!.size.width,
                             height: self.image!.size.height)
        let width   = contentImageView.image!.size.width
        let height  = contentImageView.image!.size.height
        
        contentImageView.frame = CGRect(x: self.bounds.size.width/2 - width/2,
                                        y: self.bounds.size.height/2 - height/2,
                                        width: width,
                                        height: height)
    }
    
    class func ScaleRect( _ rect:CGRect, n:CGFloat) -> CGRect {
        let x       = (rect.size.width - rect.size.width * n) / 2
        let y       = (rect.size.height - rect.size.height * n) / 2
        let width   = rect.size.width * n
        let height  = rect.size.height * n
        
        return CGRect(x: x , y: y ,width: width ,height: height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHighlighted = true
        delegate?.SDiffuseMenuItemTouchesBegan(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location =  ((touches as NSSet).anyObject()! as AnyObject).location(in: self) // 点击范围
        
        if (!SDiffuseMenuItem.ScaleRect(self.bounds, n: kDiffuseMenuItemDefaultTouchRange).contains(location)) {
            self.isHighlighted = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHighlighted = false
        
        let location =   ((touches as NSSet).anyObject()! as AnyObject).location(in: self) // 点击范围
        if (SDiffuseMenuItem.ScaleRect(self.bounds, n: kDiffuseMenuItemDefaultTouchRange).contains(location)) {
            delegate?.SDiffuseMenuItemTouchesEnd(self)
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHighlighted = false
    }
    
}

