//
//  EmitterButton.swift
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

/// Custom button class which animates using the UIKit particle emitter
class EmitterButton: UIButton {
    
    //MARK: Properties
    
    private let scaleFactor:CGFloat = 0.95
    private let animDuration:TimeInterval = 0.3
    
    /// referemnce to the currently used emitter layer
    private var emitterLayer:EmitterLayer? {
        return self.layer as? EmitterLayer
    }
    
    //MARK: View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override class var layerClass: AnyClass{
        return EmitterLayer.self
    }

    //MARK: Private
    
    /// Basic setup
    private func setup(){
        self.emitterLayer?.backgroundColor = UIColor.white.cgColor
        self.emitterLayer?.cornerRadius = 5.0
        self.emitterLayer?.masksToBounds = false
        self.emitterLayer?.borderColor = UIColor.lightGray.cgColor
        self.emitterLayer?.borderWidth = 1.0
        self.emitterLayer?.shadowColor = UIColor.gray.cgColor
        self.emitterLayer?.shadowOpacity = 0.8
        self.emitterLayer?.shadowRadius = 5
        self.emitterLayer?.shadowOffset = CGSize(width: 3, height: 3)
        
        self.addTarget(self, action: #selector(onTouchDownOrDragEnter(sender:)), for: [.touchDown,.touchDragEnter])
        self.addTarget(self, action: #selector(onTouchCancelOrDragExit(sender:)), for: [.touchCancel,.touchDragExit])
        self.addTarget(self, action: #selector(onTouchUpInside(sender:)), for: .touchUpInside)
    }
    
    /// animates the component as pressed/released button
    /// - Parameter press: the press state
    /// - Parameter completion: block called when press/release transition finishes
    private func pressed(_ press:Bool, completion:((Bool)->())? = nil ){
        self.animate({
            if press{
                self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
            }else{
                self.transform = .identity
            }
        }, completion: completion)
    }
    
    /// Animates with the default component animation configuration
    /// - Parameter animation: the animaiton block to be used
    /// - Parameter completion: the completion block called on animaiton finished
    private func animate(_ animation:@escaping (()->()), completion:((Bool)->())? = nil){
        UIView.animate(withDuration: self.animDuration,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 5,
            options: [.allowUserInteraction],
            animations: animation, completion: completion)
    }
    
}

//MARK: - Event handlers
extension EmitterButton {
    
    @objc private func onTouchDownOrDragEnter(sender:Any){
        self.animateParticles = true
        self.pressed(true)
    }
    
    @objc private func onTouchCancelOrDragExit(sender:Any){
        self.animateParticles = false
        self.pressed(false)
    }
    
    @objc private func onTouchUpInside(sender:Any){
        self.animateParticles = false
        self.pressed(false)
    }
}

//MARK: EmitterUIProtocol
extension EmitterButton: EmitterUIProtocol {
    
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
