import UIKit
// дает возможность дожидаться каждый поток, что бы он не завершался пока все потоки не отработают
import PlaygroundSupport

// GCD

class MyViewController: UIViewController {
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC_1"
        view.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(pressAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initButton()
    }
    
    @objc func pressAction() {
        print("1111")
        let vc = TwoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("press", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        view.addSubview(button)
    }
}

// второй контроллер для реализации примера блокировки
class TwoViewController: UIViewController {
    
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC_2"
        view.backgroundColor = UIColor.yellow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initImage()
        
        let imageURL: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/VanGogh_1887_Selbstbildnis.jpg/475px-VanGogh_1887_Selbstbildnis.jpg")!
        
        // так как загрузка производится в главном потоке то UI залочится пока не загрузится картинка из инета - это ужасно
//        if let data = try? Data(contentsOf: imageURL) {
//            image.image = UIImage(data: data)
//        }
        
        // решение использовать второй поток для загрузки картинки
        loadPhoto()
    }
    
    func loadPhoto() {
        let imageURL: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/VanGogh_1887_Selbstbildnis.jpg/475px-VanGogh_1887_Selbstbildnis.jpg")!
        // создаем ссылку на уже предустановленную очередь для работы с ней и устанавливаем приоритет
        let queue = DispatchQueue.global(qos: .userInteractive)
        // ставим что асинхронно
        queue.async {
            if let data = try? Data(contentsOf: imageURL) {
                // UI всегда ставим в основной очереди, UI всегда в мейн потоке
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
        }
    }
    
    func initImage() {
        image.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        image.center = view.center
        image.contentMode = .scaleAspectFill
        view.addSubview(image)
    }

}

let vc = MyViewController()
let navbar = UINavigationController(rootViewController: vc)

// отображаем VC в плейграунде
PlaygroundPage.current.liveView = navbar

