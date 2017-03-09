//
//  ViewController.swift
//  UsingNSOperationQueues
//
//  Created by Kirill on 28.02.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
    
    let imageURLs = ["http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "https://pp.userapi.com/c636523/v636523157/1ef5f/CvaqFx76Ax4.jpg", "https://pp.userapi.com/c637319/v637319157/28f4/_ThprgsgbP4.jpg", "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg"]
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    var queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAction(_ sender: UIBarButtonItem) {
        queue = OperationQueue()
        
        /*queue.addOperation { () -> Void in
         
         let downloadURL = NSURL(string: self.imageURLs[0])!
         
         OperationQueue.main.addOperation({
         self.image1.af_setImage(withURL: downloadURL as URL)
         })
         }
         queue.addOperation { () -> Void in
         
         let downloadURL = NSURL(string: self.imageURLs[1])!
         
         OperationQueue.main.addOperation({
         self.image2.af_setImage(withURL: downloadURL as URL)
         })
         }
         queue.addOperation { () -> Void in
         
         let downloadURL = NSURL(string: self.imageURLs[2])!
         
         OperationQueue.main.addOperation({
         self.image3.af_setImage(withURL: downloadURL as URL)
         })
         }
         queue.addOperation { () -> Void in
         
         let downloadURL = NSURL(string: self.imageURLs[3])!
         
         OperationQueue.main.addOperation({
         self.image4.af_setImage(withURL: downloadURL as URL)
         })
         }
         */
        
        let operation1 = BlockOperation(block: {
            let downloadURL = NSURL(string: self.imageURLs[0])
            OperationQueue.main.addOperation({
                self.image1.af_setImage(withURL: downloadURL as! URL)
            })
        })
        
        operation1.completionBlock = {
            print("Operation 1 completed, cancelled:\(operation1.isCancelled)")
        }
        queue.addOperation(operation1)
        
        let operation2 = BlockOperation(block: {
            let downloadURL = NSURL(string: self.imageURLs[1])
            OperationQueue.main.addOperation({
                self.image2.af_setImage(withURL: downloadURL as! URL)
            })
        })
        
        operation2.completionBlock = {
            print("Operation 2 completed, cancelled:\(operation2.isCancelled)")
        }
        operation2.addDependency(operation1)
        queue.addOperation(operation2)
        
        
        let operation3 = BlockOperation(block: {
            let downloadURL = NSURL(string: self.imageURLs[2])
            OperationQueue.main.addOperation({
                self.image3.af_setImage(withURL: downloadURL as! URL)
            })
        })
        
        operation3.completionBlock = {
            print("Operation 3 completed, cancelled:\(operation3.isCancelled)")
        }
        operation3.addDependency(operation2)
        queue.addOperation(operation3)
        
        let operation4 = BlockOperation(block: {
            let downloadURL = NSURL(string: self.imageURLs[3])
            OperationQueue.main.addOperation({
                self.image4.af_setImage(withURL: downloadURL as! URL)
            })
        })
        
        operation4.completionBlock = {
            print("Operation 4 completed, cancelled:\(operation4.isCancelled)")
        }
        queue.addOperation(operation4)
    }
    
    @IBAction func stopAction(_ sender: UIBarButtonItem) {
        self.queue.cancelAllOperations()
    }
}

