//
//  CompareViewController.swift
//  Weather
//
//  Created by Daniel Martinsson on 2018-04-08.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController {
    
    var blueBox: UIView?
    var redBox: UIView?
    var animator: UIDynamicAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frameRect = CGRect(x: 10, y: 20, width: 80, height: 80)
        blueBox = UIView(frame: frameRect)
        blueBox?.backgroundColor = UIColor.blue
        
        frameRect = CGRect(x: 150, y: 20, width: 60, height: 60)
        redBox = UIView(frame: frameRect)
        redBox?.backgroundColor = UIColor.red
        
        self.view.addSubview(blueBox!)
        self.view.addSubview(redBox!)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravity = UIGravityBehavior(items: [blueBox!,
                                                redBox!])
        let vector = CGVector(dx: 0.0, dy: 1.0)
        gravity.gravityDirection = vector
        
        let collision = UICollisionBehavior(items: [blueBox!,
                                                    redBox!])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        let behaviorBlue = UIDynamicItemBehavior(items: [blueBox!])
        behaviorBlue.elasticity = 0.5
        
        let behaviorRed = UIDynamicItemBehavior(items:[redBox!])
        behaviorRed.elasticity = 0.9
    
        animator?.addBehavior(behaviorBlue)
        animator?.addBehavior(behaviorRed)
        animator?.addBehavior(collision)
        animator?.addBehavior(gravity)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
