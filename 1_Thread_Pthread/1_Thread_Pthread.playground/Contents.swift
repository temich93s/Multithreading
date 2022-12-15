import UIKit

// Thread
// Operation
// GCD

// паралельная
// 1 поток ----
// 2 поток ----

// последовательная
// 1 поток   - --
// 2 поток -- -  -

// асинхронная
// main(UI)    -------
// асин. поток    -    (- это загрузка фото из сети)

// unix - posix
// создаем поток
var thread = pthread_t(bitPattern: 0)
// создаем аттрибут
var attribut = pthread_attr_t()
// инициализируем аттрибут
pthread_attr_init(&attribut)
// кладем код в потом
pthread_create(&thread, &attribut, { (pointer) in
    print("test1")
    return nil
}, nil)

// objective-c (оболочка над unix)
// создание потока
var nsthread = Thread {
    print("test2")
}
// запуск потока
nsthread.start()
nsthread.isMainThread
// словарь для хранения данных
nsthread.setValue("111", forKey: "key")
nsthread.cancel()
