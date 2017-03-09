//
//  ViewController.swift
//  UsingGCD
//
//  Created by Kirill on 27.02.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var inactiveQueue: DispatchQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //makeSyncQueues()
        //makeAsyncQueues()
        //queuesWithQoS()
//        concurrentQueues()
//        
//        if let queue = inactiveQueue {
//            queue.activate()
//        }
        //queueWithDelay()
//        workItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeSyncQueues() {
        let queue = DispatchQueue(label: "ru.kirill")
        
        queue.sync {
            for i in 1..<10 {
                print("🐝", i)
            }
        }
        
        for i in 100..<110 {
            print("❄️", i)
        }
    }
    
    func makeAsyncQueues() {
        let queue = DispatchQueue(label: "ru.kirill")
        
        queue.async {
            for i in 1..<10 {
                print("🐝", i)
            }
        }
        
        for i in 100..<110 {
            print("❄️", i)
        }
    }

    func queuesWithQoS() {
        let queue1 = DispatchQueue(label: "ru.kirill", qos: DispatchQoS.userInitiated)
        //let queue1 = DispatchQueue(label: "ru.kirill", qos: DispatchQoS.background)
        //let queue2 = DispatchQueue(label: "ru.kirill1", qos: DispatchQoS.userInitiated)
        let queue2 = DispatchQueue(label: "ru.kirill1", qos: DispatchQoS.utility)
        
        queue1.async {
            for i in 1..<10 {
                print("🐝", i)
            }
        }
        
        queue2.async {
            for i in 100..<110 {
                print("❄️", i)
            }
        }
        
        for i in 1000..<1010 {
            print("😀", i)
        }
    }
    
    func concurrentQueues() {
        //let anotherQueue = DispatchQueue(label: "ru.kirill.another", qos: .utility)
//        let anotherQueue = DispatchQueue(label: "ru.kirill.another", qos: .utility, attributes: .concurrent)
//        let anotherQueue = DispatchQueue(label: "ru.kirill.another", qos: .utility, attributes: .initiallyInactive)
        let anotherQueue = DispatchQueue(label: "ru.kirill.another", qos: .utility, attributes: [.concurrent, .initiallyInactive])
        inactiveQueue = anotherQueue
        let globalQueue = DispatchQueue.global()
        
        anotherQueue.async {
            for i in 1..<10 {
                print("🐝", i)
            }
        }
        
        anotherQueue.async {
            for i in 100..<110 {
                print("❄️", i)
            }
        }
        
        anotherQueue.async {
            for i in 1000..<1010 {
                print("😀", i)
            }
        }
        
        globalQueue.async {
            for i in 15..<20 {
                print("!!!", i)
            }
        }
    }
    
    func queueWithDelay() {
        let delayQueue = DispatchQueue(label: "ru.kirill", qos: .userInitiated)
        
        print(Date())
        let additionalTime: DispatchTimeInterval = .seconds(2)
        
        delayQueue.asyncAfter(deadline: .now() + additionalTime) {
            print(Date())
        }
    }
    
    func workItem() {
        var value = 10
        
        let workItem = DispatchWorkItem {
            value += 10
        }
        
        let queue = DispatchQueue(label: "ru.kirill", qos: .utility)
        queue.async {
            workItem.perform()
        }
        
        workItem.notify(queue: DispatchQueue.main) {
            print("value = ", value)
        }
    }

}

