import Foundation

protocol Builder {
    func makeTitle(title: String)
    func makeString(str: String)
    func makeItems(items: [String])
    func close()
}

class Director {
    let builder: Builder

    init(builder: Builder) {
        self.builder = builder
    }

    func construct() {
        builder.makeTitle(title: "Greeting")
        builder.makeString(str: "一般的な挨拶")
        builder.makeItems(items: [
            "How are you ?",
            "Hello",
            "Hi.",
        ])
        builder.makeString(str: "時間帯に応じた挨拶")
        builder.makeItems(items: [
            "Good morning",
            "Good afternoon",
            "Good night",
        ])
        builder.close()
    }
}

final class TextBuilder: Builder {
    private var builtString: String = ""

    func makeTitle(title: String) {
        builtString += "\n=====================\n"
        builtString += "「\(title)」\n\n"

    }

    func makeString(str: String) {
        builtString += "・\(str)\n\n"
    }

    func makeItems(items: [String]) {
        items.forEach { item in
            builtString += "  ・\(item)\n"
        }
        builtString += "\n"
    }

    func close() {
        builtString += "=====================\n"
    }

    func getTextResult() -> String {
        builtString
    }
}

final class HtmlBuilder: Builder {
    private var filename = "untitled.html"
    private var builtString: String = ""

    func makeTitle(title: String) {
        filename = title + ".html"
        builtString += "<html>\n"
        builtString += "<head>\(title)</head>"
    }

    func makeString(str: String) {
        builtString += "<p>\(str)</p>\n"
    }

    func makeItems(items: [String]) {
        items.forEach { item in
            builtString += "<li>\(item)</li>\n"
        }
    }

    func close() {
        builtString += "</html>"
    }

    func getHtmlResult() -> (String, String) {
        return (filename, builtString)
    }
}

let textBuilder = TextBuilder()
let director1 = Director(builder: textBuilder)

director1.construct()

let textResult = textBuilder.getTextResult()
print(textResult)

let htmlBuilder = HtmlBuilder()
let director2 = Director(builder: htmlBuilder)
director2.construct()
let (filename, builtHtml) = htmlBuilder.getHtmlResult()
print(filename)
print(builtHtml)

/**
 - オブジェクト指向では、誰が何を知っているかが重要
 - mainはBuilderインターフェースのメソッドを知らない
 - DirectorクラスもBuilderのインターフェースのみ知っていて、具体的なBuilderクラスを知らない
 - Builderクラスは文書の構築に必要十分なメソッドを宣言している必要があるが、今後全てで対応可能とか限らないため、適宜修正が必要になる
 - Buiderパターン：構造を持ったインスタンスを組み上げていく、組み上げの過程はDirectorによって隠蔽される
 */
