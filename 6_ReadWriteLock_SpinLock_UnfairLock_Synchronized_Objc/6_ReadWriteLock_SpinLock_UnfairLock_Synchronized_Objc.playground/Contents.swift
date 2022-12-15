import UIKit

class ReadWriteLock {
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    // наша критическая секция, что будем защищать
    private var globalProperty: Int = 0
    
    init() {
        pthread_rwlock_init(&lock, &attribute)
    }
    
    public var workProperty: Int {
        get {
            // блокируем чтение
            pthread_rwlock_wrlock(&lock)
            // работа будет с временной переменной которая заблокирована замком
            let temp = globalProperty
            // разблокировали
            pthread_rwlock_unlock(&lock)
            return temp
        }
        set {
            // блокируем запись
            pthread_rwlock_wrlock(&lock)
            // работа будет с временной переменной которая заблокирована замком
            globalProperty = newValue
            // разблокировали
            pthread_rwlock_unlock(&lock)
        }
    }
}

// deprecated in iOS 10.0
class SpinLock {
    private var lock = OS_SPINLOCK_INIT
    
    func some() {
        OSSpinLockLock(&lock)
        // делаем работу
        OSSpinLockUnlock(&lock)
    }
}

// c 10.0 на замену SpinLock
class UnfairLock {
    private var lock = os_unfair_lock_s()
    
    var array = [Int]()
    
    func some() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)
    }
}

// objective-c
class SynchronizedObjc {
    private let lock  = NSObject()
    
    var array = [Int]()
    
    func some() {
        objc_sync_enter(lock)
        array.append(1)
        objc_sync_exit(lock)
    }
}
