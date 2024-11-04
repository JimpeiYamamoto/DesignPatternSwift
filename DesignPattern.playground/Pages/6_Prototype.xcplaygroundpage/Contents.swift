import Foundation
// Prototypeパターン：クラスからインスタンスを生成するのではなく、インスタンスから別のインスタンスを作り出す

// 複製を可能にするためのもの
protocol Product {
    func use(s: String)
    func createCopy() -> Product
}

// Productインターフェースを利用してインスタンスの複製を行うクラス
final class Manager {
    var showcase: [String: Product] = [:]

    func register(name: String, prototype: Product) {
        showcase[name] = prototype
    }

    func create(prototypeName: String) -> Product? {
        guard let p = showcase[prototypeName] else { return nil }
        return p.createCopy()
    }
}

final class MessageBox: Product {

    let decoChar: String

    init(decoChar: String) {
        self.decoChar = decoChar
    }

    func use(s: String) {
        print(decoChar, terminator: "")
        s.forEach { _ in
            print(decoChar, terminator: "")
        }
        print(decoChar, terminator: "")
        print("")
        print("\(decoChar)\(s)\(decoChar)")
        print(decoChar, terminator: "")
        s.forEach { _ in
            print(decoChar, terminator: "")
        }
        print(decoChar, terminator: "")
        print("")
    }

    func createCopy() -> Product {
        MessageBox(decoChar: self.decoChar)
    }
}

final class UnderLinePen: Product {
    let ulChar: String

    init(ulChar: String) {
        self.ulChar = ulChar
    }

    func use(s: String) {
        print(s)
        s.forEach { _ in
            print(ulChar, terminator: "")
        }
    }

    func createCopy() -> Product {
        UnderLinePen(ulChar: self.ulChar)
    }
}

let manager = Manager()
let mbox1 = MessageBox(decoChar: "*")
let mbox2 = MessageBox(decoChar: "/")
let ulpen = UnderLinePen(ulChar: "-")

manager.register(name: "strong1", prototype: mbox1)
manager.register(name: "strong2", prototype: mbox2)
manager.register(name: "line", prototype: ulpen)

let p1 = manager.create(prototypeName: "strong1")
let p2 = manager.create(prototypeName: "strong2")
let p3 = manager.create(prototypeName: "line")

p1?.use(s: "helloWorld")
print("")
p2?.use(s: "helloWorld")
print("")
p3?.use(s: "helloWorld")

/**
 - 複数のひな形のクラスのインスタンスを作成したいとき、それぞれ別のクラスで作ると管理が大変
 - クラスから特定のインスタンス生成が煩雑なときに、コピーできる
 - フレームワークと生成するインスタンスを分離できる(クラス名がソース内に書かれていると、そのクラスと切り離して再利用することができない)
 */
