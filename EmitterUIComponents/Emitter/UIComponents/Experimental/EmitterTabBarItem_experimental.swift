//
//  EmitterTabBarItem_experimental.swift
//  EmitterUIComponents
//
//  MIT License
//
//  Copyright (c) 2019 Luca Iaconis. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// **WARNING**: This is relying on view hierarchy, and not on any public / documented API.
/// It's just an example, but may stop working in future version of the OS (eg. if the view beaviour changes)
///
/// Custom tab bar item class which animates using the UIKit particle emitter
class EmitterTabBar_experimental: UITabBar {
    
    //MARK: Properties
    
    /// Convenient getter to the emitter tab bar items contained into this tab bar
    var emitterItems:[EmitterTabBarItem_experimental]{
        return self.items?.compactMap({$0 as? EmitterTabBarItem_experimental}) ?? []
    }
    
    /// Convenient getter to the **HIDDEN** button views associated to each tab bar item
    private var tabBarButtons:[UIControl] { self.subviews.compactMap({$0 as? UIControl}) }
    
    //MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    //MARK: View lifecyclce
    
    override var selectedItem: UITabBarItem?{
        didSet{
            let items = self.items?.compactMap({$0 as? EmitterTabBarItem_experimental}) ?? []
            items.forEach({$0.animateParticles = false})
            (self.selectedItem as? EmitterTabBarItem_experimental)?.animateParticles = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tabBarButtons.forEach { (btnX) in
            let subLayers = self.emitters(for: btnX)
            subLayers.forEach({$0.frame = btnX.bounds})
        }
    }
    
    //MARK: Private
    
    /// Basic setup
    private func setup(){
        let tabBtns = self.tabBarButtons
        let items = self.emitterItems
        guard tabBtns.count == items.count else { return }
        for i in 0..<items.count {
            items[i].tabBarButton = tabBtns[i]
        }
    }
    
    /// Convenient function for getting the emitter layers within the designated tab bar item button
    /// - Parameter btn: the tab bar item button to inspect
    /// - Returns: The resulting emitter layers
    private func emitters(for btn:UIControl)->[EmitterLayer]{
        return btn.layer.sublayers?.compactMap({$0 as? EmitterLayer}) ?? []
    }
    
}

/// Custom tab bar item class which animates using the UIKit particle emitter
class EmitterTabBarItem_experimental: UITabBarItem {

    //MARK: Properties
    
    /// The associated button which is represented by this tab bar item
    weak var tabBarButton: UIView?{
        didSet{
            guard let btn = self.tabBarButton else {
                self.emitterLayer?.removeFromSuperlayer()
                return
            }
            self.plugEmitter(to: btn)
        }
    }
    
    /// weak reference to the emitter layer contained into the represented tab bar button
    private weak var emitterLayer:EmitterLayer?
    
    /// Plugs the emitter layer into the provided tab bar button
    /// - Parameter btn: the tab bar button to decorate with the emitter layer
    private func plugEmitter(to btn:UIView){
        self.emitterLayer?.removeFromSuperlayer()
        let emitter = EmitterLayer()
        emitter.frame = btn.bounds
        btn.layer.addSublayer(emitter)
        self.emitterLayer = emitter
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.cornerRadius = 5.0
    }
    
}

//MARK: EmitterUIProtocol
extension EmitterTabBarItem_experimental: EmitterUIProtocol {
    
    var animateParticles:Bool {
        get{
            return self.emitterLayer?.animateParticles ?? false
        }
        set{
            self.emitterLayer?.animateParticles = newValue
        }
    }
    
    var particlesAnimationDuration:TimeInterval {
        get{
            self.emitterLayer?.particlesAnimationDuration ?? 0.0
        }
        set{
            self.emitterLayer?.particlesAnimationDuration = newValue
        }
    }
    
    var particlesAnimationPathType: EmitterLayer.PathType {
        get{
            self.emitterLayer?.particlesAnimationPathType ?? .rect
        }
        set{
            self.emitterLayer?.particlesAnimationPathType = newValue
        }
    }
    
    var particlesColors:[UIColor] {
        get{
            self.emitterLayer?.particlesColors ?? []
        }
        set{
            self.emitterLayer?.particlesColors = newValue
        }
    }
    
    var particleRadius:CGFloat {
        get{
            return self.emitterLayer?.particleRadius ?? 0.0
        }
        set{
            self.emitterLayer?.particleRadius = newValue
        }
    }
    
    var particleVelocity: CGFloat{
        get{
            return self.emitterLayer?.particleVelocity ?? 0.0
        }
        set{
            self.emitterLayer?.particleVelocity = newValue
        }
    }
}
