import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

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
// dispatchGroupTest2.loadInfo()

class EightImage: UIView {
    public var ivs = [UIImageView]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // 1 вариант
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        
        // 2 вариант
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 300, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 300, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 400, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100)))
        
        for i in 0...7 {
            ivs[i].contentMode = .scaleAspectFit
            self.addSubview(ivs[i])
        }
    }
    
    // Обязательный инициализатор на случай если все упадет что бы вернуть nil
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var view = EightImage(frame: CGRect(x: 0, y: 0, width: 700, height: 900))
view.backgroundColor = UIColor.red

let imageURLs = [
    "https://upload.wikimedia.org/wikipedia/commons/c/cd/VanGogh-starry_night.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/VanGogh_1887_Selbstbildnis.jpg/274px-VanGogh_1887_Selbstbildnis.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/5/5f/Van_Gogh_-_Portrait_of_Pere_Tanguy_1887-8.JPG",
    "https://upload.wikimedia.org/wikipedia/commons/b/b4/Vincent_Willem_van_Gogh_128.jpg" ]

var images = [UIImage]()

PlaygroundPage.current.liveView = view

// асинхронная обертка загрузки изображений
func asyncLoadImage(imageURL: URL, runQueue: DispatchQueue, completionQueue: DispatchQueue, compeletion: @escaping (UIImage?, Error?) -> ()) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async {
                compeletion(UIImage(data: data), nil)
            }
        } catch let error {
            completionQueue.async {
                compeletion(nil, error)
            }
        }
    }
}

// метод формирующий группу асинхронных операций
func asyncGroup() {
    let aGroup = DispatchGroup()
    
    for i in 0...3 {
        // добавление операций в группу
        aGroup.enter()
        asyncLoadImage(imageURL: URL(string: imageURLs[i])!, runQueue: .global(), completionQueue: .main) { result, error in
            guard let image1 = result else { return }
            images.append(image1)
            // выходим из группы в конце выполненной задачи
            aGroup.leave()
        }
    }
    
    aGroup.notify(queue: .main) {
        for i in 0...3 {
            view.ivs[i].image = images[i]
        }
    }
}
// загружаются на UI одновременно
 asyncGroup()

// через urlsession, он асинхронно работает в интернете, но без групп
func asyncUrlSession() {
    for i in 4...7 {
        let url = URL(string: imageURLs[i - 4])
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                view.ivs[i].image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

// загружаются по очереди
asyncUrlSession()
