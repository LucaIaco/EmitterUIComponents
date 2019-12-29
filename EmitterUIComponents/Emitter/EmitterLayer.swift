//
//  EmitterLayer.swift
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

/// The custom emitter layer class applicable to a generic UI component
class EmitterLayer: CAEmitterLayer {
    
    //MARK: Public
    
    /// Whether the particle emitter should start or not
    var animateParticles:Bool = false {
        didSet{
            if self.animateParticles {
                self.startParticles()
            }else{
                self.stopParticles()
            }
        }
    }
    
    /// Updates the particles animation duration with which the emitter position moves along the path
    var particlesAnimationDuration:TimeInterval = 6.0{
        didSet{
            guard self.animateParticles else { return }
            self.updateParticlesAnimation(resumeTime: true)
        }
    }
    
    /// Updates the particles animation path type with which the emitter position moves
    var particlesAnimationPathType: EmitterLayer.PathType = .rect {
        didSet{
            guard self.animateParticles else { return }
            self.updateParticlesAnimation(resumeTime: true)
        }
    }
    
    /// The particles colors to be used in the particle emitters
    var particlesColors:[UIColor] = [.red,.yellow]{
        didSet{
            guard self.animateParticles else { return }
            self.updateParticleCells()
        }
    }
    
    /// The radius to be used as base size for each particle in the system
    var particleRadius:CGFloat = 10 {
        didSet{
            guard self.animateParticles else { return }
            self.updateParticleCells()
        }
    }
    
    /// The initial velocity to be used for each particle in the system
    var particleVelocity:CGFloat = 10 {
        didSet{
            guard self.animateParticles else { return }
            self.updateParticleCells()
        }
    }
    
    //MARK: Init & Layer lifecycle
    
    override init() {
        super.init()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    override var bounds: CGRect{
        willSet{
            // if bound size changes, update the animation (path) if needed
            guard self.animateParticles, self.bounds.size != newValue.size else { return }
            self.updateParticlesAnimation(pathRect: newValue, resumeTime: true)
        }
    }
    
    //MARK: Private
    
    private let animKey = "animEmitterKey"
    
    /// Initial layer setup
    private func setup(){
        self.emitterPosition = .zero
        self.emitterShape = .point
        self.renderMode = .oldestLast
    }
    
    /// Stops the emitter point animation and stops the particle generation rate
    private func stopParticles(preservePosition:Bool = true){
        self.removeAnimation(forKey: self.animKey)
        // (equivalent to turning OFF)
        self.birthRate = 0
    }
    
    /// Removes any existing particles and creates & run a new emitter
    /// - Parameter pathRect: if provided, is the rect to be used for the animation path in place of the default one
    private func startParticles(pathRect:CGRect? = nil) {
        
        // acts as multiplier for each contained emitter cell (equivalent to turning ON)
        self.birthRate = 1.0
        
        self.updateParticleCells()
        
        // animate the emitter layer position
        self.updateParticlesAnimation(pathRect: pathRect)
    }
    
    /// Updates the emitter layer cells based on the current configuration in terms of
    /// color and radius
    private func updateParticleCells() {
        let cells = self.particlesColors.map({ makeEmitterCell(color: $0,
                                                               radius: self.particleRadius,
                                                               velocity: self.particleVelocity)})
        self.emitterCells = cells
    }
    
    /// If animateParticles is enabled, it interrupt the running particles animation,
    /// and creates a new one
    /// - Parameter pathRect: if provided, is the rect to be used for the animation path in place of the default one
    /// - Parameter resumeTime: If true, it recovers from the existing animation elapsed time, otherwise starts from the beginning
    private func updateParticlesAnimation(pathRect:CGRect? = nil, resumeTime:Bool = false){
        
        var elapsedTime:TimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
        if resumeTime, let currentAnim = self.animation(forKey: self.animKey){
            elapsedTime = currentAnim.beginTime
        }
        self.removeAnimation(forKey: self.animKey)
        
        let animation = CAKeyframeAnimation(keyPath: "emitterPosition")
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.duration = self.particlesAnimationDuration
        animation.isRemovedOnCompletion = false
        animation.calculationMode = .paced
        animation.path = self.particleAnimationPath(for: pathRect ?? self.bounds)
        animation.beginTime = elapsedTime
        
        self.add(animation, forKey: self.animKey)
    }
    
    /// The default particle animationPath based on the current emitter layer configuration
    /// - Parameter rect: the rect to be used for creating the path
    /// - Returns: The resulting cgpath
    private func particleAnimationPath(for rect:CGRect) -> CGPath {
        switch self.particlesAnimationPathType {
        case .rect:
            return UIBezierPath(rect: rect).cgPath
        case .roundedRect(let cornerRadius):
            return UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        case .ovalIn:
            return UIBezierPath(ovalIn: rect).cgPath
        case .arcCenter(let radius, let startAngle, let endAngle, let clockWise):
            return UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockWise).cgPath
        case .custom(let path):
            return path
        }
        
    }
}

//MARK: Emitter Cell methods
extension EmitterLayer {
    
    /// THe birth rate used by the emitter cell to generate particles
    private var cellBirthRate:Float { 60.0 }
    
    /// The lifetyme duraiton of each generated particle
    private var cellLifetime:Float { 10.0 }
    
    /// creates a new emitter cell
    /// - Parameter color: the tint color of the emitter cell content
    /// - Parameter radius: the radius to be used for the resulting cell size
    /// - Parameter velocity: The emitter cell initial velocity
    private func makeEmitterCell(color: UIColor, radius:CGFloat, velocity:CGFloat) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = self.cellBirthRate
        cell.lifetime = self.cellLifetime
        cell.alphaSpeed = -0.5
        cell.velocity = velocity
        cell.emissionRange = 2 * CGFloat.pi
        cell.scaleSpeed = -0.5
        let size = CGSize(width: radius, height: radius)
        cell.contents = EmitterLayer.makeParticleContent(color: color, size: size).cgImage
        return cell
    }
    
    /// creates a particle content as UIImage (as radial gradient)
    /// - Parameter color: the tint colorcolor
    /// - Parameter size: the image size
    /// - Returns: The resulting image
    private class func makeParticleContent(color:UIColor, size:CGSize = CGSize(width: 3, height: 3)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                            colors: [color.cgColor,
                                                     color.withAlphaComponent(0).cgColor] as CFArray,
                                      locations: [0,1]) else{ return }
            context.cgContext.drawRadialGradient(gradient,
                                                 startCenter: CGPoint(x: size.width/2, y: size.height/2),
                                                 startRadius: 0,
                                                 endCenter: CGPoint(x: size.width/2, y: size.height/2),
                                                 endRadius: size.width/2,
                                                 options: .drawsBeforeStartLocation)
        }
        return image
    }
    
    
}

//MARK: Emitter Cell path types
extension EmitterLayer {
    
    /// The set of bezier path types
    /// - rect: the path will use a simple rect
    /// - roundedRect: the path will use a rounded corner rect option with custom corner radius
    /// - ovalIn: the path will use the ovalIn option
    /// - arcCenter: the path will use the arcCenter option with custom parameters
    /// - custom: an external custom path
    ///
    enum PathType {
        case rect
        case roundedRect(cornerRadius:CGFloat)
        case ovalIn
        case arcCenter(radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat, clockWise:Bool)
        case custom(path:CGPath)
    }
    
}
