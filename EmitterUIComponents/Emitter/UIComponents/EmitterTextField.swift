//
//  EmitterTextField.swift
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

/// Custom textfield class which animates using the UIKit particle emitter
class EmitterTextField: UITextField {
    
    //MARK: Properties
    
    /// If true, it automatically enables and disables the animation on became/resign the first responder
    var animateWithFirstResponder:Bool = true
    
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
    
    override func becomeFirstResponder() -> Bool {
        if self.animateWithFirstResponder, !self.isFirstResponder {
            self.animateParticles = true
        }
        self.emitterLayer?.borderWidth = 3.0
        self.emitterLayer?.borderColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        if self.animateWithFirstResponder, self.isFirstResponder {
            self.animateParticles = false
        }
        self.emitterLayer?.borderWidth = 1.0
        self.emitterLayer?.borderColor = UIColor.lightGray.cgColor
        return super.resignFirstResponder()
    }
    
    override class var layerClass: AnyClass{
        return EmitterLayer.self
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: super.intrinsicContentSize.width, height: 34.0)
    }
    
    //MARK: Private
    
    /// Basic setup
    private func setup(){
        self.borderStyle = .none
        self.emitterLayer?.cornerRadius = 5.0
        self.emitterLayer?.borderWidth = 1.0
        self.emitterLayer?.borderColor = UIColor.lightGray.cgColor
    }
    
}

//MARK: EmitterUIProtocol
extension EmitterTextField: EmitterUIProtocol {
    
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
