Emitter UI Components
============

Emitter UI Components is an iOS project written in Swift which provides a small set of common UI components customised with the UIKit provided particle emitter layer by using the custom emitter layer `EmitterLayer`. Such custom layer is a subclass of `CAEmitterLayer` and is used in the following custom UI components:

* `EmitterView`: a sublcass of `UIView` which layerClass is `EmitterLayer` and implements the protocol `EmitterUIProtocol`
* `EmitterTextField`: a sublcass of `UITextField` which layerClass is `EmitterLayer` and implements the protocol `EmitterUIProtocol`
* `EmitterButton`: a sublcass of `UIButton` which layerClass is `EmitterLayer` and implements the protocol `EmitterUIProtocol`
* `EmitterTabBar_experimental`: (**Eperimental**) is a revisited sublcass of `UITabBar`
* `EmitterTabBarItem_experimental`: (**Eperimental**) is a revisited sublcass of `UITabBarItem` and implements the protocol `EmitterUIProtocol`
* `EmitterSlider_experimental`: (**Eperimental**) is a revisited sublcass of `UITabBar` and implements the protocol `EmitterUIProtocol`

The `EmitterLayer` layer can be applied to any UIView-based component.

The project provides a convenient protocol to be used for UI components called `EmitterUIProtocol`, exposing following properties:

* `animateParticles`: Whether the particle emitter should start or not
* `particlesAnimationDuration`: Updates the particles animation duration with which the emitter position moves along the path
* `particlesAnimationPathType`: Updates the particles animation path type with which the emitter position moves
* `particlesColors`: The particles colors to be used in the particle emitters
* `particleRadius`: The radius to be used as base size for each particle in the system
* `particleVelocity`: The initial velocity to be used for each particle in the system
 
## Sample usage:

 ```swift
@IBOutlet weak var myTextfield: EmitterTextField!
    
func setupTextField(){
    //self.myTextfield.animateWithFirstResponder = false // specific for EmitterTextField component
    
    // Set the emitter position animation duration to 5 seconds
    self.myTextfield.particlesAnimationDuration = 5.0
    // Set the path type to be ovalIn related to the UI component rect
    self.myTextfield.particlesAnimationPathType = .ovalIn
    // Set the particle radius of each emitter cell
    self.myTextfield.particleRadius = 10.0
    // Set the colors which will be used to randomly generate emitter cell
    self.myTextfield.particlesColors = [.green, .white, .red]
    // Set the emitter cells initial velocity at the creation time
    self.myTextfield.particleVelocity = 20.0
    // Start animating the particles on the UI component
    self.myTextfield.animateParticles = true
}
```