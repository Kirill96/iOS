//
//  ViewControllerTwo.swift
//  UsingFrameworks
//
//  Created by Kirill on 25.02.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit
import CoreImage

class ViewControllerTwo: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addParallaxToView(view: view)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        guard let image = imageView?.image, let cgimg = image.cgImage else {
            print("imageView does not have an omage!")
            return
        }
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let sepiaFilter = CIFilter(name: "CISepiaTone")
        sepiaFilter?.setValue(coreImage, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(0.5, forKey: kCIInputIntensityKey)
        
        if let sepiaOutput = sepiaFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let exposureFilter = CIFilter(name: "CIGammaAdjust")
            exposureFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
            
            if let exposureOutput = exposureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let output = context.createCGImage(exposureOutput, from: exposureOutput.extent)
                let result = UIImage(cgImage: output!)
                imageView?.image = result
            }
        }
    }

    func addParallaxToView(view: UIView) {
        let amount = 50
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
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
