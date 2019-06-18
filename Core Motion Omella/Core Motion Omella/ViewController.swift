//
//  ViewController.swift
//  Core Motion Omella
//
//  Created by Pedro Henrique Guedes Silveira on 17/06/19.
//  Copyright © 2019 Pedro Henrique Guedes Silveira. All rights reserved.
//

import UIKit
import CoreMotion




class ViewController: UIViewController,UICollisionBehaviorDelegate {

    
    @IBOutlet var barries: [UIView]!
    @IBOutlet weak var ball: UIImageView!
    let motion = CMMotionManager()
    var referenceAttitude:CMAttitude?
    var collision: UICollisionBehavior?
    var animator: UIDynamicAnimator? = nil
    var gravity: UIGravityBehavior? = nil
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceMotion()
        animator = UIDynamicAnimator(referenceView: self.view)
        barries.append(ball)
        collision = UICollisionBehavior(items: barries)
        collision?.collisionDelegate = self
        animator?.addBehavior(collision!)
    }
    
    
    func deviceMotion() {
        
        if motion.isDeviceMotionAvailable {
            
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            
            var timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                              block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    var relativeAttitude = data.attitude
                                    if let ref = self.referenceAttitude{
                                        //Esta função faz a orientação do dispositivo ser calculado com relação à orientação de referência passada
                                        relativeAttitude.multiply(byInverseOf: ref)
                                    }
                                    
                                    let x = relativeAttitude.pitch
                                    let y = relativeAttitude.roll
                                    let z = relativeAttitude.yaw
                                    
                                    let pushBehavior: UIPushBehavior = UIPushBehavior(items: [self.ball], mode: .instantaneous)
                                    pushBehavior.pushDirection = CGVector(dx: y, dy: x)
                                    
                                    self.animator?.addBehavior(pushBehavior)
                                }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
    }
 }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        let colliderItem:UIView = item1 as! UIView
        let collidedItem:UIView = item2 as! UIView
        
    }
}
