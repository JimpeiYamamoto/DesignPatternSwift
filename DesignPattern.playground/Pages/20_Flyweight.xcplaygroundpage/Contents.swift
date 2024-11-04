import Foundation

/**
 - Flyweight: 同じものを共有して無駄をなくす
 - インスタンスをできるだけ共有して、無駄にnewしない
 - intrinsicな情報：共有する情報
 - extrinsicな情報：共有しない情報 (場所や状況に依存するので共有できない)
 */
class BigChar {
    let char: String
    let fontData: String

    init(char: String) {
        self.char = char
        self.fontData = "---------------------\(char)--------------------------"
    }

    func _print() {
        print(fontData)
    }
}

class BigCharFactory {
    var pool: [String: BigChar] = [:]
    static let shared = BigCharFactory()

    private init() {}

    func getBigChar(char: String) -> BigChar {
        guard let bigChar = pool[char] else {
            let newBigChar = BigChar(char: char)
            pool[char] = newBigChar
            return newBigChar
        }
        return bigChar
    }
}

class BigString {
    var bigChars: [BigChar] = []

    init(str: String) {
        str.forEach { elem in
            bigChars.append(BigCharFactory.shared.getBigChar(char: String(elem)))
        }
    }

    func _print() {
        bigChars.forEach { bigChar in
            bigChar._print()
        }
    }
}

// main
let bigString = BigString(str: "HelloWorld")
bigString._print()
