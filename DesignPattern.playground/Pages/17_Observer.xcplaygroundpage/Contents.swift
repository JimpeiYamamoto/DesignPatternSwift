import Foundation

protocol NumberGenerator: AnyObject {
    var observers: [Observer] { get set }
    func getNumber() -> Int
    func execute()
}

extension NumberGenerator {
    func addObserver(observer: Observer) {
        observers.append(observer)
    }

    func notifyObservers() {
        observers.forEach { observer in
            observer.update(generator: self)
        }
    }
}

protocol Observer {
    func update(generator: NumberGenerator)
}

class RandomNumberGenerator: NumberGenerator {
    var observers: [Observer] = []
    private var number: Int = 0

    func getNumber() -> Int {
        number
    }

    func execute() {
        for i in 0..<20 {
            number = Int.random(in: 0..<50)
            notifyObservers()
            sleep(1)
        }
    }
}

class DigitObserver: Observer {
    func update(generator: NumberGenerator) {
        print("DigitObserver:", generator.getNumber())
    }
}

class GraphObserver: Observer {
    func update(generator: NumberGenerator) {
        print("GraphObserver: ", terminator: "")
        for i in 0..<generator.getNumber() {
            print("*", terminator: "")
        }
        print("")
    }
}

// main
let generator = RandomNumberGenerator()
let digitObserver = DigitObserver()
let graphObserver = GraphObserver()
generator.addObserver(observer: digitObserver)
generator.addObserver(observer: graphObserver)

generator.execute()

/**
 - 再利用性について
 - RandomNumberGeneratorクラスは、DigitObserverなのかGraphObserverなのかXXXObserverなのかは知らない。
 - ただobserversプロパティの要素がObserverプロトコルに準拠していることだけ知っている
 - そのため、updateメソッドが定義されていることは知っている

 - DigitObserverから見ると、RandomGeneratorなのかXXXGeneratorなのか走らない
 - ただ、NumberGeneratorに準拠していて、getNumberメソッドを持っていることだけ知っている

- だから、GeneratorもObserverもそれぞれ別の具体クラスに入れ替えられる
 */
