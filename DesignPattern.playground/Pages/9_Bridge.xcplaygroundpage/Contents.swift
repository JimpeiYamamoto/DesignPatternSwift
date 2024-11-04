import Foundation

/**
 - Bridgeパターン：機能のクラス階層と実装のクラス階層の橋渡しをする
 - 実装のクラス階層：superClassが抽象クラスで、subClassが実装クラスになっている状態
 - 機能のクラス階層：superClassが基本的な機能を持っていて、subClassで新しい機能を追加する
 */


// 実装のクラス階層
protocol DisplayType {
    func rawUpen()
    func rawPrint()
    func rawClose()
}

// 実装のクラス階層
class StringDisplay: DisplayType {
    private let str: String

    init(str: String) {
        self.str = str
    }
    func rawUpen() {
        printLine()
    }
    
    func rawPrint() {
        print("|\(str)|")
    }
    
    func rawClose() {
        printLine()
    }

    private func printLine() {
        print("+", terminator: "")
        str.forEach { _ in
            print("-", terminator: "")
        }
        print("+")
    }
}

// 機能のクラス階層
class Display {
    // 委譲にすることで緩い結びつきにしている（準拠は強い結びつき）
    private let impl: DisplayType

    init(impl: DisplayType) {
        self.impl = impl
    }

    func open() {
        impl.rawUpen()
    }

    func _print() {
        impl.rawPrint()
    }

    func close() {
        impl.rawClose()
    }

    func display() {
        open()
        _print()
        close()
    }
}

// 機能のクラス階層
class CountDisplay: Display {

    override init(impl: DisplayType) {
        super.init(impl: impl)
    }

    func multiDisplay(times: Int) {
        open()
        for _ in 0 ... times {
            _print()
        }
        close()
    }
}

// main
let d1 = Display(impl: StringDisplay(str: "Hello, Japan!"))
let d2 = Display(impl: StringDisplay(str: "Hello, World!"))
let d3 = CountDisplay(impl: StringDisplay(str: "Hello, Universe!"))

d1.display()
d2.display()
d3.multiDisplay(times: 5)
