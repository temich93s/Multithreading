import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

print(Thread.current)

// создаем просто замыкание (это не операция так как операция это класс)
let operation1 = {
    print("start")
    print(Thread.current)
    print("finish")
}

// создаем очередь операций
let queue = OperationQueue()
// передаем замыкание в очередь операций
// эта операция выполнится в асинхронном потоке, так как OperationQueue выплняет все в асинхронном потоке
// queue.addOperation(operation1)

// создаем потокобезопасность и теперь будем оперировать операциями, а не блокамиБ как в предыддущем примере

print("-----")

print(Thread.current)

// создаем результат
var result: String?

// создаем конкатоператион, вызвав класс блок оператион
// блок оператион наследуется от Operation у которого есть инициализатор принимающий блок кода
// блокоперейшн включает в себя все что умеет оперейшн
let concatOperation = BlockOperation {
    result = "result"
    print(Thread.current)
    print(result!)
}

// запускаем блокоперратион
// все выполнится в мейне, сам себя он никуда не переводит, для перевода используем operationQueue
// concatOperation.start()
// print(result!)

// добавляем оперейшн в оперейшнуью
// queue.addOperation(concatOperation)

// --
// можно напрямую писать блок кода в operationQueue
let queue1 = OperationQueue()
//queue1.addOperation {
//    print(Thread.current)
//    print("result")
//}

// --
// можно создать оболочку на потоком
// тут не основной поток поток
class MyThread: Thread {
    // в мейн пишем сам код
    override func main() {
        print(Thread.current)
        print("MyThread")
    }
}

let myThread = MyThread()
myThread.start()

// тут не основной поток поток
class OperationA: Operation {
    // в мейн пишем сам код
    override func main() {
        print(Thread.current)
        print("OperationA")
    }
}

let operationA = OperationA()
// operationA.start()

// добавляем их
let queue2 = OperationQueue()
queue2.addOperation(operationA)
