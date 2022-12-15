import UIKit
import PlaygroundSupport
import Foundation

// плейграунд не будет выкидывать ничего из памяти пока не дойдет до конца
PlaygroundPage.current.needsIndefiniteExecution = true

class DispatchWorkItem1 {
    // attributes: .concurrent паралельная очередь
    private let queue = DispatchQueue(label: "DispatchWorkItem1", attributes: .concurrent)
    
    func create() {
        // создали надстройку
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("start")
        }
        
        // нотификация что будет в главном потоке
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("finish")
        }
        
        // передаем надстройку в асинхронный поток
        queue.async(execute: workItem)
    }
}

let dispatchWorkItem1 = DispatchWorkItem1()
// сначала выполняется наша задача, а потом срабатывает нотификация после выполнения
// dispatchWorkItem1.create()

// отмена задачи

class DispatchWorkItem2 {
    // последовательная очередь
    private let queue = DispatchQueue(label: "DispatchWorkItem1")
    
    func create() {
        queue.async {
            sleep(1)
            print(Thread.current)
            print("task1")
        }
        
        queue.async {
            sleep(1)
            print(Thread.current)
            print("task2")
        }
        
        // создали рабочую область
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Start workItem")
        }
        
        // передаем область в поток
        queue.async(execute: workItem)
        
        // отмена выполнения workItem,
        // можно отменять задачи только тогда, когда она еще не начала выполнятся, после начала выполнения отменить нельзя
        workItem.cancel()
    }
}

let dispatchWorkItem2 = DispatchWorkItem2()
// так как последовательный поток то все выполнялись друг за другом
// dispatchWorkItem2.create()


// получим фотографию 3 разными способами

var view = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))

imageView.backgroundColor = .yellow
imageView.contentMode = .scaleAspectFit
view.addSubview(imageView)

// показываем вью в плейграунде
PlaygroundPage.current.liveView = view

let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/VanGogh_1887_Selbstbildnis.jpg/274px-VanGogh_1887_Selbstbildnis.jpg")!

// 1. classic
func fetchImage() {
    let queue = DispatchQueue.global(qos: .utility)
    queue.async {
        if let data = try? Data(contentsOf: imageURL) {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
}

// fetchImage()

// 2. dispatchWorkItem
func fetchImage2() {
    var data: Data?
    let queue = DispatchQueue.global(qos: .utility)
    // создаем ворк айтем
    let workItem = DispatchWorkItem(qos: .userInteractive) {
        data = try? Data(contentsOf: imageURL)
        print(Thread.current)
    }
    
    queue.async(execute: workItem)
    // создаем нотификацию где поместим картинку на UI
    workItem.notify(queue: DispatchQueue.main) {
        if let imageData = data {
            imageView.image = UIImage(data: imageData)
        }
    }
}

//fetchImage2()

// 3. URLSession - работает асинхронно
// аломафаер это базука, он не всегда нужен для малых задач

func fetchImage3() {
    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
        print(Thread.current)
        if let imageData = data {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: imageData)
            }
        }
    }
    task.resume()
}

fetchImage3()
