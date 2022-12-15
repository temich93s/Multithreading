//
//  ViewController.swift
//  9_lesson
//
//  Created by 2lup on 13.12.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        afterBlock(seconds: 2,queue: .main) {
            print("Hello1")
            self.showAlert()
            print(Thread.current)
        }
        
        afterBlock(seconds: 4) {
            print("Hello2")
            print(Thread.current)
        }
    }
    
    // = это значение по умолчанию
    func afterBlock(seconds: Int, queue: DispatchQueue = DispatchQueue.global(), completion: @escaping () -> ()) {
        queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            completion()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Hello", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

