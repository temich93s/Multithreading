import UIKit

// NSRecursiveLock

// глобальный экземпляр класса (
let recursiveLock = NSRecursiveLock()

// класс 1 потока отдельного от мейна
class RecursiveMutexTest {
    // мьютекс
    private var mutex = pthread_mutex_t()
    // атрибут
    private var attribute = pthread_mutexattr_t()
    
    init() {
        //инициализируем аттрибуты и задаем настройку рекурсива
        pthread_mutexattr_init(&attribute)
        // второй параметр указывает что это рекурсив
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attribute)
    }
    
    // первый метод лочит поток, а потом вызывает вторую функцию которая опять лочит залоченый поток
    func firstTask() {
        pthread_mutex_lock(&mutex)
        twoTask()
        pthread_mutex_unlock(&mutex)
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
    
    private func twoTask() {
        pthread_mutex_lock(&mutex)
        print("finish")
        pthread_mutex_unlock(&mutex)
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}

let recursive = RecursiveMutexTest()
recursive.firstTask()

// objective-c

// наследуемся от потока что бы можно было вызвать сразу поток
class RecursiveThread: Thread {
    // решили просто переопределить функцию мейн
    override func main() {
        recursiveLock.lock()
        print("protect1")
        callMe()
        defer {
            recursiveLock.unlock()
        }
        print("exit1")
    }
    
    func callMe() {
        recursiveLock.lock()
        print("protect2")
        defer {
            recursiveLock.unlock()
        }
        print("exit2")
    }
}

let thread = RecursiveThread()
// запускаем поток, вызовится мейн
thread.start()
