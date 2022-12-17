import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let operationQueue = OperationQueue()

class OperationCancelTest: Operation {
    override func main() {
        // в мейне проверяем отменилась ли операция, перед ее запуском
        if isCancelled {
            print(isCancelled)
            return
        }
        print("test 1")
        sleep(1)
        
        if isCancelled {
            print(isCancelled)
            return
        }
        print("test 2")
        
    }
}

// создаем метод отмены
func cancelOperationMethod() {
    let cancelOperation = OperationCancelTest()
    // операция запускается сразу при ее добавлении
    operationQueue.addOperation(cancelOperation)
    // отменяем операцию
    cancelOperation.cancel()
}
// cancelOperationMethod()

// аналог барьера
class WaitOperationTest {
    private let operationQueue = OperationQueue()
    
    func test() {
        // добавляем операции в очередь операций с разной скоростью выполнения
        print("-1-")
        operationQueue.addOperation {
            sleep(1)
            print("test 1")
        }
        print("-2-")
        operationQueue.addOperation {
            sleep(2)
            print("test 2")
        }
        print("-3-")
        operationQueue.addOperation {
            print("test 3")
        }
        print("-4-")
        operationQueue.addOperation {
            print("test 4")
        }
    }
}

let waitOperationTest = WaitOperationTest()
// выполнятся в порядке кто быстрее (3412)
// waitOperationTest.test()

class WaitOperationTest1 {
    private let operationQueue = OperationQueue()
    
    func test() {
        // добавляем операции в очередь операций с разной скоростью выполнения
        print("-1-")
        operationQueue.addOperation {
            sleep(1)
            print("test 1")
        }
        print("-2-")
        operationQueue.addOperation {
            sleep(2)
            print("test 2")
        }
        // наш барьер - дальше код никакой не выполняются (даже print("-3-")) пока не закончат все выполение все предыдущие
        operationQueue.waitUntilAllOperationsAreFinished()
        print("-3-")
        operationQueue.addOperation {
            sleep(1)
            print("test 3")
        }
        print("-4-")
        operationQueue.addOperation {
            print("test 4")
        }
    }
}

let waitOperationTest1 = WaitOperationTest1()
// выполнятся (1243)
// waitOperationTest1.test()

// -----
//
class WaitOperationTest2 {
    private let operationQueue = OperationQueue()
    
    func test() {
        print("-1-")
        let operation1 = BlockOperation {
            sleep(1)
            print("test1")
        }
        print("-2-")
        let operation2 = BlockOperation {
            sleep(2)
            print("test2")
        }
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: true)
        print("-3-")
        operationQueue.addOperation {
            sleep(1)
            print("test3")
        }
        print("-4-")
        operationQueue.addOperation {
            print("test4")
        }
    }
}
let waitOperationTest2 = WaitOperationTest2()
// waitOperationTest2.test()

// ---
// комплишн блок
// у операций есть комплишн блок

class CompletionBlockTest {
    private let operationQueue = OperationQueue()
    
    func test() {
        let operation1 = BlockOperation {
            print("test 1")
        }
        // вот сам комплишн блок
        // operationQueue.addOperation(operation1)
        sleep(1)
        operation1.completionBlock = {
            print("CompletionBlockTest")
        }
        operationQueue.addOperation(operation1)
    }
}

let completionBlockTest = CompletionBlockTest()
completionBlockTest.test()
