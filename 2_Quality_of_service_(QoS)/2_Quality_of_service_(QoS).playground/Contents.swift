import UIKit

// quality of service качество обслуживания
// более приоритетные задачи выполняются быстрее остальных

// создаем поток
var pthread = pthread_t(bitPattern: 0)
// создаем аттрибут
var attribute = pthread_attr_t()
pthread_attr_init(&attribute)
// передаем аттрибут и вызываем qos
// QOS_CLASS_USER_INITIATED - это приоритет
pthread_attr_set_qos_class_np(&attribute, QOS_CLASS_USER_INITIATED, 0)
// создаем поток c кодом
pthread_create(&pthread, &attribute, { (pointer) in
    print("test")
    // меняем приоритет в ходе выполнения
    pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0)
    return nil
}, nil)

// ojective-c
let nsThread = Thread {
    print("test2")
    print(qos_class_self())
}
// устанавливаем приоритет
nsThread.qualityOfService = .userInteractive
nsThread.start()
print(qos_class_main())
