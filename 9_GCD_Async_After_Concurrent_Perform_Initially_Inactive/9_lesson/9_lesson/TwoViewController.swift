//
//  TwoViewController.swift
//  9_lesson
//
//  Created by 2lup on 13.12.2022.
//

import UIKit

class TwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // долго выполняется, блокируется кнопка
//        for i in 0...200000 {
//            print(i)
//        }
        
        // выполнение итераций паралельно в нескольких потоках в том числе и в главной
//        DispatchQueue.concurrentPerform(iterations: 200000) { number in
//            print(number)
//            print(Thread.current)
//        }
        
        // тот же конкарент но без главной очереди
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async {
//            DispatchQueue.concurrentPerform(iterations: 200000) { number in
//                print(number)
//                print(Thread.current)
//            }
//        }
        
        myInactiveQueue()
        
        // управляемая +- очередь
        func myInactiveQueue() {
            let inactiveQueue = DispatchQueue(label: "Inac", attributes: [.concurrent, .initiallyInactive])
            
            inactiveQueue.async {
                print("done")
            }
            print("not start")
            inactiveQueue.activate()
            print("active")
            inactiveQueue.suspend()
            print("sleep")
            inactiveQueue.resume()
             
        }
    }
}
