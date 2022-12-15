import UIKit

class QueueTest1 {
    // создаем последовательную очередь со своим названием
    private let serialQueue = DispatchQueue(label: "serialTest")
    // создание параллельной очереди
    private let concurrentQueue = DispatchQueue(label: "concurrentTest", attributes: .concurrent)
}

class QueueTest2 {
    // глобальная очередь
    private let globalQueue = DispatchQueue.global()
    // оснавная очередь
    private let mainQueue = DispatchQueue.main
}
