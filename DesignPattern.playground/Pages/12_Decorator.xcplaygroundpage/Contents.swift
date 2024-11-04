import Foundation
/**
 - 中心となるオブジェクトがある
 - 飾りつけとなる機能を一皮一皮被せていって、より目的にあったオブジェクトに仕上げていく
 - Compositeパターンも再帰的な構造を扱うが、Decoratorパターンは外枠を重ねることで機能を追加していく点に主眼がある
 - Decoratorパターンでは委譲が使われている
 - 包まれる方を変更することなく、機能の追加ができる
 */

protocol Display {
    // 列数(≒文字数)
    func getColumns() -> Int
    // 行数
    func getRows() -> Int
    func getRowText(row: Int) -> String
}

extension Display {
    func show() {
        for row in 0 ..< getRows() {
            print(getRowText(row: row))
        }
    }
}

class StringDisplay: Display {
    let str: String

    init(str: String) {
        self.str = str
    }

    func getColumns() -> Int {
        str.count
    }

    func getRows() -> Int {
        1
    }

    func getRowText(row: Int) -> String {
        str
    }
}

protocol Border: Display {}

class SideBorder: Border {

    let display: Display
    let borderChar: String

    init(display: Display, borderChar: String) {
        self.display = display
        self.borderChar = borderChar
    }

    func getColumns() -> Int {
        1 + display.getColumns() + 1
    }

    func getRows() -> Int {
        display.getRows()
    }

    func getRowText(row: Int) -> String {
        "\(borderChar)\(display.getRowText(row: row))\(borderChar)"
    }
}

class FullBorder: Border {

    let display: Display

    init(display: Display) {
        self.display = display
    }

    func getColumns() -> Int {
        1 + display.getColumns() + 1
    }

    func getRows() -> Int {
        1 + display.getRows() + 1
    }

    func getRowText(row: Int) -> String {
        switch row {
        case 0, display.getRows() + 1:
            "+\(makeLine(ch: "-", count: display.getColumns()))+"
        default:
            "|\(display.getRowText(row: row-1))|"
        }
    }

    private func makeLine(ch: String, count: Int) -> String {
        var str = ""
        for _ in 0 ..< count {
            str += ch
        }
        return str
    }
}

let b1 = StringDisplay(str: "Hello world")
let b2 = SideBorder(display: b1, borderChar: "#")
let b3 = FullBorder(display: b2)
b1.show()
b2.show()
b3.show()
print("")
let b4 = FullBorder(
    display: SideBorder(
        display: FullBorder(
            display: SideBorder(
                display: StringDisplay(
                    str: "Hello Japan"
                ),
                borderChar: "*"
            )
        ),
        borderChar: "/"
    )
)
b4.show()

print("")
let b5 = FullBorder(display: b4)
b5.show()

print("")
let b6 = SideBorder(display: b5, borderChar: "$")
b6.show()
