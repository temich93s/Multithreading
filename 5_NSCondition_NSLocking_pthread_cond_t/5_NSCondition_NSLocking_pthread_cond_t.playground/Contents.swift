import UIKit
import Foundation
import Darwin

// NSCondition
// 2 потока, нет гарантии какой из них прийдет раньше какой позже
// 1 записывает, 2 читает - проблема
// решение это выстраивание этих потоков в очередь по условию

let condition111 = NSCondition()

// создаем условие
var available = false
// сишный кондишн
var condition = pthread_cond_t()
// сишный мьютекс
var mutex = pthread_mutex_t()

class ContionMutexPrinter: Thread {
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        printer()
    }
    
    private func printer() {
        pthread_mutex_lock(&mutex)
        print("printer in")
        while (!available) {
            // устанавливаем ожидание
            pthread_cond_wait(&condition, &mutex)
        }
        available = false
        defer {
             pthread_mutex_unlock(&mutex)
        }
        print("printer out")
    }
}

class ContionMutexWriter: Thread {
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        writer()
    }
    
    private func writer() {
        pthread_mutex_lock(&mutex)
        print("writer in")
        // посылаем сигнал что мы закончили, что бы ридер проснулся
        pthread_cond_signal(&condition)
        available = true
        defer {
             pthread_mutex_unlock(&mutex)
        }
        print("writer out")
    }
}

let conditonMutexWriter = ContionMutexWriter()
let conditonMutexPrinter = ContionMutexPrinter()

conditonMutexPrinter.start()
conditonMutexWriter.start()

// objective-c

let condi = NSCondition()
var availble = false

class Writer: Thread {
    override func main() {
        // блокируем поток
        condi.lock()
        print("Writer in")
        availble = true
        // посылаем сигнал
        condi.signal()
        defer {
            condi.unlock()
        }
        print("Writer out")
    }
}

class Printer: Thread {
    override func main() {
        // блокируем поток
        condi.lock()
        print("Printer in")
        while (!availble) {
            // ставим поток на ожидание
            print("1")
            condi.wait()
            print("2")
        }
        availble = false
        defer {
            condi.unlock()
        }
        print("Printer out")
    }
}

let wr = Writer()
let pr = Printer()
pr.start()
wr.start()
