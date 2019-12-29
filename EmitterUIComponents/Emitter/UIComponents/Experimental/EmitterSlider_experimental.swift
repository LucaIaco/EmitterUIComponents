//
//  EmitterSlider_experimental.swift
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
/// Custom slider class which animates using the UIKit particle emitter
class EmitterSlider_experimental: UISlider {

    //MARK: Properties
    
    /// Weak reference to the hypothetical thumb image view
    private weak var thumbImageView:UIImageView?
    
    /// Weak reference to the referred emitter layer if any
    private weak var emitterLayer:EmitterLayer?
    
    private var didSetup = false
    
    //MARK: View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let thmbImgView = self.thumbImageView {
            self.emitterLayer?.frame = thmbImgView.bounds
        }
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        self.setup()
    }
    
    //MARK: Private
    
    /// Basic setup
    private func setup(){
        guard self.didSetup == false else { return }
        if let thmbImgView = self.subviews.compactMap({$0 as? UIImageView}).first {
            self.thumbImageView = thmbImgView
            self.plugEmitter(to: thmbImgView)
            
            // add handlers
            self.addTarget(self, action: #selector(onTouchDownOrDragEnter(sender:)), for: [.touchDown,.touchDragEnter])
            self.addTarget(self, action: #selector(onTouchCancel(sender:)), for: [.touchCancel])
            self.addTarget(self, action: #selector(onTouchUp(sender:)), for: [.touchUpInside,.touchUpOutside])
            
            self.didSetup = true
        }
    }
    
    /// Plugs the emitter layer into the provided view
    /// - Parameter btn: the tab bar button to decorate with the emitter layer
    private func plugEmitter(to view:UIView){
        self.emitterLayer?.removeFromSuperlayer()
        let emitter = EmitterLayer()
        emitter.frame = view.bounds
        view.layer.addSublayer(emitter)
        self.emitterLayer = emitter
    }
    
}

//MARK: - Event handlers
extension EmitterSlider_experimental {
    
    @objc private func onTouchDownOrDragEnter(sender:Any){
        self.animateParticles = true
    }
    
    @objc private func onTouchCancel(sender:Any){
        self.animateParticles = false
    }
    
    @objc private func onTouchUp(sender:Any){
        self.animateParticles = false
    }
}

//MARK: EmitterUIProtocol
extension EmitterSlider_experimental: EmitterUIProtocol {
    
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
