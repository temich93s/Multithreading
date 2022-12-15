import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// создаем очередь
let queue = DispatchQueue(label: "qu1", attributes: .concurrent)

// создаем семафор, указывая сколько потоков могут проходить через него (одновременно работать)
let semaphore = DispatchSemaphore(value: 2)

queue.async {
    // декремент. тоесть у DispatchSemaphore(value: 2) отнимается 1
    semaphore.wait() // -1
    sleep(3)
    print("method 1")
    semaphore.signal() // +1
}

queue.async {
    // декремент. тоесть у DispatchSemaphore(value: 2) отнимается 1
    semaphore.wait()
    sleep(3)
    print("method 2")
    semaphore.signal()
}

queue.async {
    // декремент. тоесть у DispatchSemaphore(value: 2) отнимается 1
    semaphore.wait()
    sleep(3)
    print("method 3")
    semaphore.signal()
}

// создали семафор
let sem = DispatchSemaphore(value: 2)

// создали счетчик который выполняет 10 задач параллельна
DispatchQueue.concurrentPerform(iterations: 10) { (id: Int) in
    // отнимаем
    sem.wait(timeout: DispatchTime.distantFuture)
    sleep(2)
    print("block", String(id))
    // добавляем
    sem.signal()
}

class SemaphorTest {
    private let semaphore = DispatchSemaphore(value: 2)
    private var array = [Int]()
    
    private func methodWork(_ id: Int) {
        semaphore.wait()
        array.append(id)
        print("test array ", array.count)
        Thread.sleep(forTimeInterval: 1)
        semaphore.signal()
    }
    
    func startAllThread() {
        DispatchQueue.global().async {
            self.methodWork(111)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(222)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(333)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(444)
            print(Thread.current)
        }
    }
}

let semaphoreTest = SemaphorTest()
semaphoreTest.startAllThread()
