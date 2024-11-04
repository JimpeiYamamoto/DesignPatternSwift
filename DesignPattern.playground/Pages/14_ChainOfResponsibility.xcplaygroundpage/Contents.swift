import Foundation

/**
 - たらい回し
 - 複数のオブジェクトを鎖のように繋いでおき、そのオブジェクトの鎖を順次渡り歩いて、目的のオブジェクトを決定する
 - これにより、要求する側と、処理する側の結びつきを弱められる
 - このパターンを使わないと、「この要求はこの人が処理するべき」という知識を誰かが中央集権的に持っている必要があるが、
 - その知識を、要求する側が持つのは賢明ではない（要求を出す人が処理者の役割分担の詳細を知ることになり、部品としての独立性が失われるため）
 */


class Trouble {
    private let number: Int

    public init(number: Int) {
        self.number = number
    }

    public func getNumber() -> Int {
        number
    }

    public func toString() -> String {
        "[Trouble \(number)]"
    }
}

// AnyObjectをつけることで「クラス専用プロトコル」になる
// 本来enumやstructは値型なのでmutatingが必要になるが、enumやstructだとchainの書き方ができないため、classにする必要がある
// ただクラスにすると、mutatingキーワードが不要なのでだめになる
protocol Support: AnyObject {
    var next: Support? { get set }
    var name: String { get }
    func resolve(trouble: Trouble) -> Bool
    func support(trouble: Trouble)
}

extension Support {

    func setNext(next: Support) -> Support {
        self.next = next
        return next
    }

    func support(trouble: Trouble) {
        if resolve(trouble: trouble) {
            done(trouble: trouble)
        } else if next != nil {
            next?.support(trouble: trouble)
        } else {
            fail(trouble: trouble)
        }
    }

    func toString() -> String {
        "[\(self.name)]"
    }

    func done(trouble: Trouble) {
        print("\(trouble.toString()) is resolve by \(toString())")
    }

    func fail(trouble: Trouble) {
        print("\(trouble.toString()) cannot be resolved")
    }
}

class NoSupport: Support {
    let name: String
    var next: Support? = nil

    public init(name: String) {
        self.name = name
    }

    func resolve(trouble: Trouble) -> Bool {
        false
    }
}

class LimitSupport: Support {
    var next: Support? = nil
    let name: String
    var limit: Int

    public init(name: String, limit: Int) {
        self.name = name
        self.limit = limit
    }

    func resolve(trouble: Trouble) -> Bool {
        if trouble.getNumber() < limit {
            return true
        }
        return false
    }
}

class OddSupport: Support {
    var next: Support? = nil
    let name: String

    public init(name: String) {
        self.name = name
    }

    func resolve(trouble: Trouble) -> Bool {
        trouble.getNumber() % 2 == 1
    }
}

class SpecialSupport: Support {
    var next: Support? = nil
    let name: String
    private let number: Int

    public init(name: String, number: Int) {
        self.name = name
        self.number = number
    }

    func resolve(trouble: Trouble) -> Bool {
        trouble.getNumber() == self.number
    }
}

// main
var alice = NoSupport(name: "Alice")
var bob = LimitSupport(name: "Bob", limit: 100)
var charlie = SpecialSupport(name: "Charlie", number: 429)
var diana = LimitSupport(name: "Diana", limit: 200)
var elmo = OddSupport(name: "Elmo")
var fled = LimitSupport(name: "Fred", limit: 300)

alice.setNext(next: bob).setNext(next: charlie).setNext(next: diana).setNext(next: elmo).setNext(next: fled)

for i in 0 ..< 500 {
    alice.support(trouble: Trouble(number: i))
}
