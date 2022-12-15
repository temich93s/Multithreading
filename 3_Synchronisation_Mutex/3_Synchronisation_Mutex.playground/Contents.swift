import UIKit
import Darwin

// синхронизация данных и защита данных

class SaveThread {
    // создали мьютекс
    private var mutex = pthread_mutex_t()
    
    // проинициализировали мьютекс
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    // метод где защита объекта и его разблокировка, объект передаем через замыкание
    func someMethod(completion: () -> ()) {
        // блокируем объект передав ссылку на этот объект в памяти, блокируя его от других потоков
        pthread_mutex_lock(&mutex)
        // производим изменения
        completion()
        // разблокируем объект после изменений
        pthread_mutex_unlock(&mutex)
        // объект не освободится в случаем ошибок, поэтому добавляем defer
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}

var array = [String]()
let saveThread = SaveThread()

//saveThread.someMethod {
//    print("test")
//    array.append("1 thread")
//}
//
//array.append("2 thread")

// objective-c

class SaveThreadC {
    // создали мьютекс
    private var lockMutex = NSLock()
    
    // метод где защита объекта и его разблокировка, объект передаем через замыкание
    func someMethod(completion: () -> ()) {
        // блокируем объект передав ссылку на этот объект в памяти, блокируя его от других потоков
        lockMutex.lock()
        // производим изменения
        completion()
        // разблокируем объект после изменений
        defer {
            lockMutex.unlock()
        }
    }
}

var array1 = [String]()
let saveThread1 = SaveThreadC()

saveThread1.someMethod {
    print(Thread.current)
    print("test")
    array1.append("1 thread")
}

print(Thread.current)
array1.append("2 thread")
