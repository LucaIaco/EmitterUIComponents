//
//  ViewController.swift
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

class ViewController: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var sampleView: EmitterView!
    
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var radiusSlider: EmitterSlider_experimental!
    @IBOutlet weak var velocitySlider: UISlider!
    
    @IBOutlet weak var color1Segment: UISegmentedControl!
    @IBOutlet weak var color2Segment: UISegmentedControl!
    @IBOutlet weak var animPathTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var tabBarView: EmitterTabBar_experimental!
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Private
    
    /// Updates the animation path duration for all the UI emitter components
    private func updateDuration(){
        self.emitterComponents.forEach({$0.particlesAnimationDuration = TimeInterval(durationSlider.value)})
    }
    
    /// Updates the particle cells radius for all the UI emitter components
    private func updateRadius(){
        self.emitterComponents.forEach({ $0.particleRadius = CGFloat(radiusSlider.value) })
    }
    
    /// Updates the particle cells initial velocity for all the UI emitter components
    private func updateVelocity(){
        self.emitterComponents.forEach({ $0.particleVelocity = CGFloat(velocitySlider.value) })
    }
    
    /// Updates the particle cells color options for all the UI emitter components
    private func updateColors(){
        let col1 = self.color(for: self.color1Segment)
        let col2 = self.color(for: self.color2Segment)
        self.emitterComponents.forEach({$0.particlesColors = [col1,col2]})
    }
    
    /// Updates the animation path type for all the UI emitter components
    private func updatePathType(){
        let pathType = self.pathType(for: self.animPathTypeSegment)
        self.emitterComponents.forEach({ $0.particlesAnimationPathType = pathType })
    }
    
    /// Return the color associated to the given segmented control
    /// - Parameter segment: the segment control to evaluate
    /// - Returns: The resulting color for the given segment and his selected index
    private func color(for segment:UISegmentedControl)-> UIColor {
        switch segment.selectedSegmentIndex {
        case 0:
            return .green
        case 1:
            return .yellow
        case 2:
            return .red
        case 3:
            return .blue
        case 4:
            return .white
        default:
            return .green
        }
    }
    
    /// Return the path type associated to the given segmented control
    /// - Parameter segment: the segment control to evaluate
    /// - Returns: The resulting emitter animation path type for the given segment and his selected index
    private func pathType(for segment:UISegmentedControl)-> EmitterLayer.PathType {
        switch segment.selectedSegmentIndex {
        case 0:
            return .rect
        case 1:
            return .roundedRect(cornerRadius: 20)
        case 2:
            return .ovalIn
        case 3:
            return .arcCenter(radius: 30, startAngle: 0, endAngle: 2*CGFloat.pi, clockWise: false)
        case 4:
            // sample triangle as custom path
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 20, y: 40))
            path.addLine(to: CGPoint(x: 40, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            return .custom(path: path)
        default:
            return .rect
        }
    }
    
    /// Array of emitter components to be updated in this sample project
    private lazy var emitterComponents:[EmitterUIProtocol] = {
        let block1:[EmitterUIProtocol] = self.stackView.arrangedSubviews.compactMap({$0 as? EmitterUIProtocol })
        let block2:[EmitterUIProtocol] = self.tabBarView.emitterItems
        let block3:[EmitterUIProtocol] = [self.radiusSlider]
        return block1 + block2 + block3
    }()
}

//MARK: Event handlers
extension ViewController {
    
    @IBAction func onSwitchViewChanged(_ sender: UISwitch) {
        self.sampleView.animateParticles = sender.isOn
    }
    @IBAction func onSlideAnimDurationChanges(_ sender: UISlider) {
        self.updateDuration()
    }
    
    @IBAction func onSlideAnimRadiusChanges(_ sender: UISlider) {
        self.updateRadius()
    }
    
    @IBAction func onSlideCellVelocityChanges(_ sender: UISlider) {
        self.updateVelocity()
    }
    
    @IBAction func onSegmentColorChanged(_ sender: UISegmentedControl) {
        self.updateColors()
    }
    
    @IBAction func onSegmentAnimPathTypeChanged(_ sender: UISegmentedControl) {
        self.updatePathType()
    }
}
