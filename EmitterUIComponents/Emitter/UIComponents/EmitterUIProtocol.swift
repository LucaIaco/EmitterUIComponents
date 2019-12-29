//
//  EmitterUIProtocol.swift
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

/// Convenient Protocol at which Emitter UI components should be conformed to
protocol EmitterUIProtocol: class {

    /// Whether the particle emitter should start or not
    var animateParticles:Bool { get set }
    
    /// Updates the particles animation duration with which the emitter position moves along the path
    var particlesAnimationDuration:TimeInterval { get set }
    
    /// Updates the particles animation path type with which the emitter position moves
    var particlesAnimationPathType: EmitterLayer.PathType { get set }
    
    /// The particles colors to be used in the particle emitters
    var particlesColors:[UIColor] { get set }
    
    /// The radius to be used as base size for each particle in the system
    var particleRadius:CGFloat { get set }
    
    /// The initial velocity to be used for each particle in the system
    var particleVelocity:CGFloat { get set }
}
