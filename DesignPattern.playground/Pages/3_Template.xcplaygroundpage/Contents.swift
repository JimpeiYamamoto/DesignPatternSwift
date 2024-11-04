import Foundation

// 抽象クラス
public protocol AbstractDisplay {
    func open()
    func print_()
    func close()

    func display()
}

extension AbstractDisplay {
    // 抽象クラスのメソッドを呼び出しているため、実際に何をするかはopen, print_, closeを実装しているサブクラスに任される
    public func display() {
        open()
        for _ in 0..<5 {
            print_()
        }
        close()
    }
}

// サブクラス１(具象クラス)
public class CharDisplay: AbstractDisplay {
    private let c: String

    public init(c: String) {
        self.c = c
    }

    public func open() {
        print("<<", terminator: "")
    }

    public func close() {
        print(">>")
    }

    public func print_() {
        print(c, terminator: "")
    }
}

let cd = CharDisplay(c: "H")
cd.display()

// サブクラス２(具象クラス)
public class StringDisplay: AbstractDisplay {
    private let str: String

    public init(str: String) {
        self.str = str
    }

    public func open() {
        printLine()
    }

    public func print_() {
        print("|\(str)|")
    }

    public func close() {
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

let sd = StringDisplay(str: "Hello world!")
sd.display()

/**
 メモ
 - テンプレートメソッドでアルゴリズムが記述されているため、サブクラスでアルゴリズムを実装しなくて良いため、ロジックが共通化できる
 - スーパークラスでサブクラスのメソッドがどんなタイミングで呼び出されているか理解しておくs必要がある
 - スーパークラスの型に任意のサブクラスが代入できるのは、LSP(リスコスの置換原則)と同じ
 */
