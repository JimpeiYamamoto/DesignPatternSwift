import Foundation

// MARK: factory package

// 抽象的な部品
protocol Item {
    var caption: String { get }
    func makeHtml() -> String
}

// HTMLのハイパーリンクを抽象的に表現
protocol Link: Item {
    var url: String { get }
}

// 複数のリンクやTrayを集めてひとまとまりにしたものを表す
protocol Tray: Item {
    var tray: [Item] { get set }

    mutating func add(item: Item)
}

extension Tray {
    mutating func add(item: Item) {
        self.tray.append(item)
    }
}

// 抽象的な製品
protocol Page {
    var title: String { get }
    var author: String { get }
    var content: [Item] { get set }

    mutating func add(item: Item)
    func output(filename: String)
    func makeHTML() -> String
}

extension Page {
    mutating func add(item: Item) {
        self.content.append(item)
    }

    func output(filename: String) {
        print(makeHTML())
        print("ファイルを作りました")
    }
}

// 抽象的な工場
protocol Factory {
    func createLink(caption: String, url: String) -> Link
    func createTray(caption: String) -> Tray
    func createPage(title: String, author: String) -> Page
}

// MARK: listFactory package

final class ListLink: Link {
    let url: String
    let caption: String

    init(url: String, caption: String) {
        self.url = url
        self.caption = caption
    }

    func makeHtml() -> String {
        "<li><a href=\(url)>\(caption)</a></li>\n"
    }
}

final class ListTray: Tray {
    var tray: [Item] = []
    let caption: String

    init(caption: String) {
        self.caption = caption
    }

    func makeHtml() -> String {
        var builtString = "<li>\n"
        builtString += "\(self.caption)"
        tray.forEach { elem in
            builtString += elem.makeHtml()
        }
        builtString = "</li>\n"
        return builtString
    }
}

final class ListPage: Page {
    let title: String
    let author: String

    var content: [Item] = []

    init(title: String, author: String) {
        self.title = title
        self.author = author
    }

    func makeHTML() -> String {
        var builtString = ""
        builtString += "<html><head><title>\(title)</title></head>\n"
        content.forEach { elem in
            builtString += elem.makeHtml()
        }
        builtString += "<hr><address>\(author)</hr></address>"
        builtString += "</html>\n"
        return builtString
    }
}

final class ListFactory: Factory {

    static func getFactory(className: String) -> Factory {
        ListFactory()
    }

    func createLink(caption: String, url: String) -> Link {
        ListLink(url: caption, caption: url)
    }

    func createTray(caption: String) -> Tray {
        ListTray(caption: caption)
    }

    func createPage(title: String, author: String) -> Page {
        ListPage(title: title, author: author)
    }
}

// MARK: main package
var factory = ListFactory()

let blog1 = factory.createLink(caption: "Blog1", url: "https://example.com/blog1")
let blog2 = factory.createLink(caption: "Blog2", url: "https://example.com/blog2")
let blog3 = factory.createLink(caption: "Blog3", url: "https://example.com/blog3")

var tray = factory.createTray(caption: "Blog Site")
tray.add(item: blog1)
tray.add(item: blog2)
tray.add(item: blog3)

var page = factory.createPage(title: "Blog", author: "Suzuki")
page.add(item: tray)
page.output(filename: "output")

/**
 - うまく実装できず、あまり理解できなかった...(これが一番難しそうだから一旦置いとくか)
 */
