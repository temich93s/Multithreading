import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// работаем со системным таймером, который может работать в других потоках, не только в главном
// указываем очередь в которой будем работать
let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
// установим обработчик событий, сработает при срабатывании таймера
timer.setEventHandler {
    print("1")
}

// настраиваем таймер (его найтройки)
// время когда начать и через сколько секунд повторить
timer.schedule(wallDeadline: .now(), repeating: 1)

// по умолчанию таймер не активирован, активируем его
timer.activate()
