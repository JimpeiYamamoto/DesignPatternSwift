import Foundation

/**
 - ファサードパターン
 - シンプルにする
 - 規模が大きいとクラスが多くなって、関係しあってるクラスに対して適切な制御が必要になる
 - その処理を行う窓口を用意する
 - 個別に制御しなくても、窓口に対して、要求を出すだけで良くなるため
 - 複雑に絡み合ってごちゃごちゃした詳細をまとめ、高レベルのインターフェースを提供する
 - Facade役は、システムの外にはシンプルなインターフェースを見せる
 - Facade役は、システムの内にある各クラスの役割や依存関係を考えて正しい順番でクラスを利用する
 - Facadeがやっていることは、複雑なもの（裏側で動いているクラスの関係や使い方）を単純に見せている
 - 単純に見せるポイントは、インターフェースを少なくすること（外部との結合が疎である）
 */

struct Property {
    let filename: String

    init(filename: String) {
        self.filename = filename
    }
}

class Database {
    init() {}

    static func getProperties(databaseName: String) -> Property {
        .init(filename: "\(databaseName).txt")
    }
}

struct Writer {
    init() {}

    func write(_ str: String) {
        print(str)
    }
}

class HtmlWriter {
    let writer: Writer

    public init(writer: Writer) {
        self.writer = writer
    }

    public func title(title: String) {
        writer.write(title)
    }

    public func paragraph(msg: String) {
        writer.write(msg)
    }

    public func close() {
        writer.write("end... \n")
    }
}

// 外部に対して1つのmakeWelcomePageメソッドだけを見せているFacade
// Facadeに対しては、HtmlWriterもPropertyも依存しない（Facadeを呼び出すことがない）
public class PageMaker {

    public static func makeWelcomePage(address: String, fileName: String) {
        let property = Property(filename: fileName)
        let htmlWriter = HtmlWriter(writer: Writer())
        htmlWriter.title(title: "title")
        htmlWriter.paragraph(msg: "welcome to my page")
        htmlWriter.close()
    }
}

// mainでは、シンプルな１行だけになる(高レベルなインターフェースをのみを外部に提供しているため)
PageMaker.makeWelcomePage(address: "hoge.com", fileName: "filenameeee")
