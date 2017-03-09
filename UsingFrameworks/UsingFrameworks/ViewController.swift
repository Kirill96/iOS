//
//  ViewController.swift
//  UsingFrameworks
//
//  Created by Kirill on 25.02.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var firstContact = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let square = UIView(frame: CGRect(x:100, y:20, width:100, height:100))
        square.backgroundColor = UIColor.gray
        view.addSubview(square)
        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [square])
        collision.collisionDelegate = self
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
        
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("Boundary contact occurred - \(identifier)")
        let collidingView = item as! UIView
        collidingView.backgroundColor = UIColor.yellow
        UIView.animate(withDuration: 0.3) {
            collidingView.backgroundColor = UIColor.gray
        }
        if (!firstContact) {
            firstContact = true
            
            let square = UIView(frame: CGRect(x: 30, y: 0, width: 150, height: 100))
            square.backgroundColor = UIColor.gray
            view.addSubview(square)
            let itemBehaviour = UIDynamicItemBehavior(items: [square])
            itemBehaviour.elasticity = 0.6
            animator.addBehavior(itemBehaviour)
            collision.addItem(square)
            gravity.addItem(square)
            
            for item in 0 ..< 20 {
                let sq = UIView(frame: CGRect(x: 30 + 20*item, y: 0, width: 15, height: 15))
                view.addSubview(sq)
                collision.addItem(sq)
                gravity.addItem(sq)
            }
            
            let barrier_two = UIView(frame: CGRect(x: 25, y: 500, width: 50, height: 20))
            barrier_two.backgroundColor = UIColor.green
            view.addSubview(barrier_two)
            collision.addBoundary(withIdentifier: "barrier_two" as NSCopying, for: UIBezierPath(rect: barrier_two.frame))
            
            animator.addBehavior(collision)
            
            let attach = UIAttachmentBehavior(item: collidingView, attachedTo:square)
            animator.addBehavior(attach)
        }
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "Home")
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                view.window!.layer.add(transition, forKey: kCATransition)
                
                self.present(resultViewController, animated:false, completion:nil)
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

