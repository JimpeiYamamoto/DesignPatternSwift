import Foundation

/**
 - composite：容器と中身を同一視して、再起的な構造を作る
 - 例）ディレクトリの中には、ディレクトリエントリ（ディレクトリ＋ファイル）が入っている
 - つまり、ディレクトリとファイルが同一視されている
 - 容器と中身を同一視し、再起的な構造を形作る
 */

protocol Entry {
    func getName() -> String
    func getSize() -> Int
    func printList(prefix: String)
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

    func printList(prefix: String) {
        print("\(prefix)/\(getName())(\(getSize()))")
    }
}

class Directory: Entry {
    private let name: String
    private var directory: [Entry] = []


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

    func printList(prefix: String) {
        print("\(prefix)/\(getName())(\(getSize()))")
        directory.forEach { entry in
            entry.printList(prefix: "\(prefix)/\(name)")
        }
    }

    func add(entry: Entry) {
        directory.append(entry)
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

rootDir.printList(prefix: "")
