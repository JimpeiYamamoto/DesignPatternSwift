import Foundation

/**
 Visitorパターン
 - データ構造と処理を分離する
 - データ構造の各要素に処理をしていく
 - このとき、処理を行う訪問者のクラスを用意して
 - データ構造は訪問者を受け入れるようにする

 - Visitorはvisitメソッドを持ち、データ構造側から呼ばれる
 - VIsitorはデータ構造に対して、依存する

 - 目的は処理をデータ構造から分離すること
 - これにより、File、Directoryクラスは部品としての独立性が高まった
 - Entryに準拠したクラスにメソッドを直接生やすと、新しい処理を追加するたびにFileやDirectoryを修正する必要が出てくる
 - これは、オープンクローズドの法則（
   - クラスが拡張に開かれていて（設計するときは将来の拡張を許すようにして、理由なく拡張を禁止してはいけない→拡張するたびに既存のクラスの修正が必要なのは困る）
   - クラスが修正に閉じられている（拡張を行っても、既存のクラスは修正する必要がない）
 - 今回は、ConcreteVisitorの追加は簡単だが、ConcreteElementの追加は困難になっている
   - 例えばDevice:Elementを追加した場合、全てのVisitorにvisitメソッドを追加する必要があるが、
   - ConcreteVisitorを追加してもConcreteElementの変更が不要になっている
 */

// データ構造はCompositeパターンで作成したFileとDirectoryを利用する
protocol Entry: Element {
    func getName() -> String
    func getSize() -> Int
}

extension Entry {
    func toString() -> String {
        "\(getName())(\(getSize()))"
    }
}

class File: Entry {
    private let name: String
    private let size: Int

    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }

    func getName() -> String {
        name
    }

    func getSize() -> Int {
        size
    }

    func accept(visitor: Visitor) {
        visitor.visit(file: self)
    }
}

class Directory: Entry {
    private let name: String
    var directory: [Entry] = []


    init(name: String) {
        self.name = name
    }

    func getName() -> String {
        name
    }

    func getSize() -> Int {
        return directory.reduce(0) { result, entry in
            result + entry.getSize()
        }
    }

    func add(entry: Entry) {
        directory.append(entry)
    }

    func accept(visitor: Visitor) {
        visitor.visit(directory: self)
    }
}

protocol Visitor {
    func visit(file: File)
    func visit(directory: Directory)
}

// Visitorを受け入れるインターフェース
protocol Element {
    func accept(visitor: Visitor)
}


class ListVisitor: Visitor {
    private var currentDir = ""

    func visit(file: File) {
        print("\(currentDir)/\(file.toString())")
    }

    func visit(directory: Directory) {
        print("\(self.currentDir)/\(directory.toString())")
        let saveDir = self.currentDir
        self.currentDir = "\(self.currentDir)/\(directory.getName())"
        directory.directory.forEach { entry in
            entry.accept(visitor: self)
        }
        currentDir = saveDir
    }
}

// main
let rootDir = Directory(name: "root")
let binDir = Directory(name: "bin")
let tmpDir = Directory(name: "tmp")
let usrDir = Directory(name: "usr")
let yuki = Directory(name: "yuki")
let hanako = Directory(name: "hanako")
let tomura = Directory(name: "tomura")

rootDir.add(entry: binDir)
rootDir.add(entry: tmpDir)
rootDir.add(entry: usrDir)
binDir.add(entry: File(name: "vi", size: 10000))
binDir.add(entry: File(name: "latex", size: 30000))
usrDir.add(entry: yuki)
yuki.add(entry: File(name: "diary.html", size: 100))
yuki.add(entry: File(name: "compose.java", size: 200))
hanako.add(entry: File(name: "memo.tex", size: 300))
usrDir.add(entry: hanako)
usrDir.add(entry: tomura)

rootDir.accept(visitor: ListVisitor())
