import Foundation
/**
 - 状態を保存する
 - カプセル化の破壊：不用意にアクセスを許すと、クラスの内部構造に依存したコードがプログラムに散らばって、クラスの修正がしにくくなる
 - Mementoパターン：インスタンスの状態を表す役割を導入して、カプセル化の破壊に陥ることなく保存と復元を行う
 - undo：やり直し
 - redo
 - history：作業履歴の作成
 - snapshot：現在状態の保存
 */

class Memento {
    var money: Int
    var fruits: [String]

    init(money: Int, fruits: [String]) {
        self.money = money
        self.fruits = fruits
    }

    func addFruits(fruit: String) {
        self.fruits.append(fruit)
    }

    func getFruits() -> [String] {
        self.fruits
    }

    func getMoney() -> Int {
        self.money
    }
}

class Gamer {
    private var money: Int
    private var fruits: [String] = []

    private static let fruitsName = [
        "りんご", "ぶどう", "ばなな", "みかん"
    ]

    init(money: Int) {
        self.money = money
    }

    func getMoney() -> Int {
        self.money
    }

    func bet() {
        let dice = Int.random(in: 1...6)
        switch dice {
        case 1:
            money += 100
            print("increase money")

        case 2:
            money /= 2
            print("half money")

        case 6:
            let fruit = getFruit()
            fruits.append(fruit)
            print("get fruit of \(fruit)")

        default:
            break
        }
    }

    public func createMemento() -> Memento {
        Memento(
            money: money,
            fruits: fruits.filter { $0.contains("おいしい") }
        )
    }

    public func restoreMemento(memento: Memento) {
        self.fruits = memento.fruits
        self.money = memento.money
    }

    private func getFruit() -> String {
        let fruit = Self.fruitsName[Int.random(in: 0...3)]
        return Bool.random()
            ? fruit
            : "おいしい" + fruit
    }

    func toString() -> String {
        "[money=\(money), fruits=\(fruits)]"
    }
}

// main
let gamer = Gamer(money: 100)
var memento = gamer.createMemento()

for i in 0..<100 {
    print("===\(i)")
    print("現状:\(gamer.toString())")
    gamer.bet()
    print("所持金は\(gamer.getMoney())円になりました")

    if gamer.getMoney() > memento.getMoney() {
        print("*増えたので保存しとく")
        memento = gamer.createMemento()
    } else if gamer.getMoney() <= memento.getMoney() / 2 {
        print("減ったので以前の状態で復元する")
        gamer.restoreMemento(memento: memento)
    }

    sleep(1)
}
