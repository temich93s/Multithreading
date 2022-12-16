import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//var array = [Int]()
//
//for i in 0...9 {
//    array.append(i)
//}
//
// // при последовательной записи все хорошо
//print(array)
//print(array.count)

//var array = [Int]()
//
//DispatchQueue.concurrentPerform(iterations: 10) { (index) in
//    array.append(index)
//}
// // здесь происходит ошибка состояние гонки
//print(array)
//print(array.count)

// класс что будет делать массив потокобезопасным с помощью барьера
class SafeArray<T> {
    // делаем массив приватным что бы к нему никто не мог обратиться из вне
    // доступ к нему будет толко через потокобезопасные методы
    private var array = [T]()
    
    private let queue = DispatchQueue(label: "my", attributes: .concurrent)
    
    // защищаем запись
    public func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }
    
    // защищаем чтение
    public var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }
}

var arraySafe = SafeArray<Int>()
DispatchQueue.concurrentPerform(iterations: 10) { index in
    arraySafe.append(index)
}

print(arraySafe.valueArray)
