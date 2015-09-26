//
//  Hokusai.swift
//  Hokusai
//
//  Created by Yuta Akizuki on 2015/07/07.
//  Copyright (c) 2015年 ytakzk. All rights reserved.
//

import UIKit

private struct HOKConsts {
    let animationDuration:NSTimeInterval = 0.8
    let hokusaiTag = 9999
}

// Action Types
public enum HOKAcitonType {
    case None, Selector, Closure
}

// Color Types
public enum HOKColorScheme {
    case Hokusai, Asagi, Matcha, Tsubaki, Inari, Karasu, Enshu
    
    func getColors() -> HOKColors {
        switch self {
        case .Asagi:
            return HOKColors(
                backGroundColor: UIColorHex(0x0bada8),
                buttonColor: UIColorHex(0x08827e),
                cancelButtonColor: UIColorHex(0x6dcecb),
                fontColor: UIColorHex(0xffffff)
            )
        case .Matcha:
            return HOKColors(
                backGroundColor: UIColorHex(0x314631),
                buttonColor: UIColorHex(0x618c61),
                cancelButtonColor: UIColorHex(0x496949),
                fontColor: UIColorHex(0xffffff)
            )
        case .Tsubaki:
            return HOKColors(
                backGroundColor: UIColorHex(0xe5384c),
                buttonColor: UIColorHex(0xac2a39),
                cancelButtonColor: UIColorHex(0xc75764),
                fontColor: UIColorHex(0xffffff)
            )
        case .Inari:
            return HOKColors(
                backGroundColor: UIColorHex(0xdd4d05),
                buttonColor: UIColorHex(0xa63a04),
                cancelButtonColor: UIColorHex(0xb24312),
                fontColor: UIColorHex(0x231e1c)
            )
        case .Karasu:
            return HOKColors(
                backGroundColor: UIColorHex(0x180614),
                buttonColor: UIColorHex(0x3d303d),
                cancelButtonColor: UIColorHex(0x261d26),
                fontColor: UIColorHex(0x9b9981)
            )
        case .Enshu:
            return HOKColors(
                backGroundColor: UIColorHex(0xccccbe),
                buttonColor: UIColorHex(0xffffff),
                cancelButtonColor: UIColorHex(0xe5e5d8),
                fontColor: UIColorHex(0x9b9981)
            )
        default: // Hokusai
            return HOKColors(
                backGroundColor: UIColorHex(0x00AFF0),
                buttonColor: UIColorHex(0x197EAD),
                cancelButtonColor: UIColorHex(0x1D94CA),
                fontColor: UIColorHex(0xffffff)
            )
        }
    }
    
    private func UIColorHex(hex: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

final public class HOKColors: NSObject {
    var backgroundColor: UIColor
    var buttonColor: UIColor
    var cancelButtonColor: UIColor
    var fontColor: UIColor
    
    required public init(backGroundColor: UIColor, buttonColor: UIColor, cancelButtonColor: UIColor, fontColor: UIColor) {
        self.backgroundColor   = backGroundColor
        self.buttonColor       = buttonColor
        self.cancelButtonColor = cancelButtonColor
        self.fontColor         = fontColor
    }
}

final public class HOKButton: UIButton {
    var target:AnyObject!
    var selector:Selector!
    var action:(()->Void)!
    var actionType = HOKAcitonType.None
    var isCancelButton = false
    
    // Font
    let kDefaultFont      = "AvenirNext-DemiBold"
    let kFontSize:CGFloat = 16.0
    
    func setColor(colors: HOKColors) {
        self.setTitleColor(colors.fontColor, forState: .Normal)
        self.backgroundColor = (isCancelButton) ? colors.cancelButtonColor : colors.buttonColor
    }
    
    func setFontName(fontName: String?) {
        let name:String
        if let fontName = fontName where !fontName.isEmpty {
            name = fontName
        } else {
            name = kDefaultFont
        }
        self.titleLabel?.font = UIFont(name: name, size:kFontSize)
    }
}

final public class HOKMenuView: UIView {
    var colorScheme = HOKColorScheme.Hokusai
    
    public let kDamping: CGFloat               = 0.7
    public let kInitialSpringVelocity: CGFloat = 0.8
    
    private var displayLink: CADisplayLink?
    private let shapeLayer     = CAShapeLayer()
    private var bendableOffset = UIOffsetZero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame.origin  = frame.origin
        shapeLayer.bounds.origin = frame.origin
    }
    
    func setShapeLayer(colors: HOKColors) {
        self.backgroundColor = UIColor.clearColor()
        shapeLayer.fillColor = colors.backgroundColor.CGColor
        self.layer.insertSublayer(shapeLayer, atIndex: 0)
    }
    
    func positionAnimationWillStart() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: "tick:")
            displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
        
        shapeLayer.bounds = CGRect(origin: CGPointZero, size: self.bounds.size)
    }
    
    func updatePath() {
        let width  = CGRectGetWidth(shapeLayer.bounds)
        let height = CGRectGetHeight(shapeLayer.bounds)
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addQuadCurveToPoint(CGPoint(x: width, y: 0),
            controlPoint:CGPoint(x: width * 0.5, y: 0 + bendableOffset.vertical))
        path.addQuadCurveToPoint(CGPoint(x: width, y: height + 100.0),
            controlPoint:CGPoint(x: width + bendableOffset.horizontal, y: height * 0.5))
        path.addQuadCurveToPoint(CGPoint(x: 0, y: height + 100.0),
            controlPoint: CGPoint(x: width * 0.5, y: height + 100.0))
        path.addQuadCurveToPoint(CGPoint(x: 0, y: 0),
            controlPoint: CGPoint(x: bendableOffset.horizontal, y: height * 0.5))
        path.closePath()
        
        shapeLayer.path = path.CGPath
    }
    
    func tick(displayLink: CADisplayLink) {
        if let presentationLayer = layer.presentationLayer() as? CALayer {
            var verticalOffset = self.layer.frame.origin.y - presentationLayer.frame.origin.y
            
            // On dismissing, the offset should not be offend on the buttons.
            if verticalOffset > 0 {
                verticalOffset *= 0.2
            }
            
            bendableOffset = UIOffset(
                horizontal: 0.0,
                vertical: verticalOffset
            )
            updatePath()
            
            if verticalOffset == 0 {
                self.displayLink!.invalidate()
                self.displayLink = nil
            }
        }
    }
}

final public class Hokusai: UIViewController, UIGestureRecognizerDelegate {
    // Views
    private var menuView = HOKMenuView()
    private var buttons  = [HOKButton]()
    
    private var instance:Hokusai!       = nil
    private var kButtonWidth:CGFloat    = 250
    private let kButtonHeight:CGFloat   = 48.0
    private let kButtonInterval:CGFloat = 16.0
    private var bgColor                 = UIColor(white: 1.0, alpha: 0.7)
    
    // Variables users can change
    public var colorScheme        = HOKColorScheme.Hokusai
    public var fontName           = ""
    public var colors:HOKColors!  = nil
    public var cancelButtonTitle  = "Cancel"
    public var cancelButtonAction : (()->Void)?
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    required public init() {
        super.init(nibName:nil, bundle:nil)
        view.frame            = UIScreen.mainScreen().bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        view.backgroundColor  = UIColor.clearColor()
        
        menuView.frame = view.frame
        view.addSubview(menuView)
    
        kButtonWidth = view.frame.width * 0.8
        
        // Gesture Recognizer for tapping outside the menu
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("dismiss"))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func onOrientationChange(notification: NSNotification){

        kButtonWidth = view.frame.width * 0.8

        let menuHeight = CGFloat(buttons.count + 2) * kButtonInterval + CGFloat(buttons.count) * kButtonHeight
        menuView.frame = CGRect(
            x: 0,
            y: view.frame.height - menuHeight,
            width: view.frame.width,
            height: menuHeight
        )
        
        menuView.shapeLayer.frame         = menuView.frame
        menuView.shapeLayer.bounds.origin = menuView.frame.origin
        menuView.shapeLayer.layoutIfNeeded()
        menuView.layoutIfNeeded()

        for var i = 0; i < buttons.count; i++ {
            let btn = buttons[i]
            btn.frame  = CGRect(x: 0.0, y: 0.0, width: kButtonWidth, height: kButtonHeight)
            btn.center = CGPoint(x: view.center.x, y: -kButtonHeight * 0.25 + (kButtonHeight + kButtonInterval) * CGFloat(i + 1))
        }
        self.view.layoutIfNeeded()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view != gestureRecognizer.view {
            return false
        }
        return true
    }
    
    // Add a button with a closure
    public func addButton(title:String, action:()->Void) -> HOKButton {
        let btn        = addButton(title)
        btn.action     = action
        btn.actionType = HOKAcitonType.Closure
        btn.addTarget(self, action:Selector("buttonTapped:"), forControlEvents:.TouchUpInside)
        return btn
    }
    
    // Add a button with a selector
    public func addButton(title:String, target:AnyObject, selector:Selector) -> HOKButton {
        let btn        = addButton(title)
        btn.target     = target
        btn.selector   = selector
        btn.actionType = HOKAcitonType.Selector
        btn.addTarget(self, action:Selector("buttonTapped:"), forControlEvents:.TouchUpInside)
        return btn
    }
    
    // Add a cancel button
    public func addCancelButton(title:String) -> HOKButton {
        if let cancelButtonAction = cancelButtonAction {
            return addButton(title, action: cancelButtonAction)
        } else {
            let btn        = addButton(title)
            btn.addTarget(self, action:Selector("buttonTapped:"), forControlEvents:.TouchUpInside)
            btn.isCancelButton = true
            return btn
        }
    }
    
    // Add a button just with the title
    private func addButton(title:String) -> HOKButton {
        let btn = HOKButton()
        btn.layer.masksToBounds = true
        btn.setTitle(title, forState: .Normal)
        menuView.addSubview(btn)
        buttons.append(btn)
        return btn
    }
    
    // Show the menu
    public func show() {
        if let rv = UIApplication.sharedApplication().keyWindow {
            if rv.viewWithTag(HOKConsts().hokusaiTag) == nil {
                view.tag = HOKConsts().hokusaiTag.hashValue
                rv.addSubview(view)
            }
        } else {
            print("Hokusai::  You have to call show() after the controller has appeared.")
            return
        }
        
        // This is needed to retain this instance.
        instance = self
        
        let colors = (self.colors == nil) ? colorScheme.getColors() : self.colors
        
        // Set a background color of Menuview
        menuView.setShapeLayer(colors)
        
        // Add a cancel button
        self.addCancelButton("Done")
        
        // Decide the menu size
        let menuHeight = CGFloat(buttons.count + 2) * kButtonInterval + CGFloat(buttons.count) * kButtonHeight
        menuView.frame = CGRect(
            x: 0,
            y: view.frame.height - menuHeight,
            width: view.frame.width,
            height: menuHeight
        )
        
        // Locate buttons
        for var i = 0; i < buttons.count; i++ {
            let btn = buttons[i]
            btn.frame  = CGRect(x: 0.0, y: 0.0, width: kButtonWidth, height: kButtonHeight)
            btn.center = CGPoint(x: view.center.x, y: -kButtonHeight * 0.25 + (kButtonHeight + kButtonInterval) * CGFloat(i + 1))
            btn.layer.cornerRadius = kButtonHeight * 0.5
            btn.setFontName(fontName)
            btn.setColor(colors)
        }
        
        // Animations
        animationWillStart()
        
        // Debug
        if (buttons.count == 0) {
            print("Hokusai::  The menu has no item yet.")
        } else if (buttons.count > 6) {
            print("Hokusai::  The menu has lots of items.")
        }
    }
    
    // Add an animation on showing the menu
    private func animationWillStart() {
        // Background
        self.view.backgroundColor = UIColor.clearColor()
        UIView.animateWithDuration(HOKConsts().animationDuration * 0.4,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.view.backgroundColor = self.bgColor
            },
            completion: nil
        )
        
        // Menuview
        menuView.frame = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height), size: menuView.frame.size)
        UIView.animateWithDuration(HOKConsts().animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.6,
            options: [.BeginFromCurrentState, .AllowUserInteraction, .OverrideInheritedOptions],
            animations: {
                self.menuView.frame = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height-self.menuView.frame.height), size: self.menuView.frame.size)
                self.menuView.layoutIfNeeded()
            },
            completion: {(finished) in
        })
        
        menuView.positionAnimationWillStart()
    }
    
    // Dismiss the menuview
    public func dismiss() {
        // Background and Menuview
        UIView.animateWithDuration(HOKConsts().animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 100.0,
            initialSpringVelocity: 0.6,
            options: [.BeginFromCurrentState, .AllowUserInteraction, .OverrideInheritedOptions, .CurveEaseOut],
            animations: {
                self.view.backgroundColor = UIColor.clearColor()
                self.menuView.frame       = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height), size: self.menuView.frame.size)
            },
            completion: {(finished) in
                self.view.removeFromSuperview()
        })
        menuView.positionAnimationWillStart()
    }
    
    // When the buttons are tapped, this method is called.
    func buttonTapped(btn:HOKButton) {
        if btn.actionType == HOKAcitonType.Closure {
            btn.action()
        } else if btn.actionType == HOKAcitonType.Selector {
            let control = UIControl()
            control.sendAction(btn.selector, to:btn.target, forEvent:nil)
        } else {
            if !btn.isCancelButton {
                print("Unknow action type for button")
            }
        }
        dismiss()
    }

}
