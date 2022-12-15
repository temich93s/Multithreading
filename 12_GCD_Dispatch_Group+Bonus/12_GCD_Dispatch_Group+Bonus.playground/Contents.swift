import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let imageURLs = [
    "https://upload.wikimedia.org/wikipedia/commons/c/cd/VanGogh-starry_night.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/VanGogh_1887_Selbstbildnis.jpg/274px-VanGogh_1887_Selbstbildnis.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/5/5f/Van_Gogh_-_Portrait_of_Pere_Tanguy_1887-8.JPG",
    "https://upload.wikimedia.org/wikipedia/commons/b/b4/Vincent_Willem_van_Gogh_128.jpg" ]


class DispatchGroupTest1 {
    // создаем задачи и объединаем их в одной последовательном потоке
    private let queueSerial = DispatchQueue(label: "qu1")
    private let groupRed = DispatchGroup()
    
    func loadInfo() {
        // создаем поток и помещаем его в группу
        queueSerial.async(group: groupRed) {
            sleep(1)
            print("1")
        }
        // создаем поток и помещаем его в группу
        queueSerial.async(group: groupRed) {
            sleep(1)
            print("2")
        }
        // у группы есть нотифай
        groupRed.notify(queue: .main) {
            print("3")
        }
    }
}

let dispatchGroupTest1 = DispatchGroupTest1()
//dispatchGroupTest1.loadInfo()

// второй вариант

class DispatchGroupTest2 {
    // создаем задачи и объединаем их в одной паралельном потоке
    private let queueConc = DispatchQueue(label: "qu1", attributes: .concurrent)
    private let groupBlack = DispatchGroup()
    
    // блоки запустятся паралельно (кроме нотифая естественно)
    func loadInfo() {
        // добавляем следующий блок в группу
        groupBlack.enter()
        queueConc.async {
            sleep(1)
            print("1")
            // говорим группе что нужно выйти из текущего блока тоесть блок кода выходит из группы
            self.groupBlack.leave()
        }
        
        // добавляем следующий блок в группу
        groupBlack.enter()
        queueConc.async {
            sleep(1)
            print("2")
            // говорим группе что нужно выйти из текущего блока
            self.groupBlack.leave()
        }
        
        // пока все не выполнится ждем
        groupBlack.wait()
        print("finish all")
        
        groupBlack.notify(queue: .main) {
            print("groupBlack Done")
        }
    }
}

let dispatchGroupTest2 = DispatchGroupTest2()
dispatchGroupTest2.loadInfo()
