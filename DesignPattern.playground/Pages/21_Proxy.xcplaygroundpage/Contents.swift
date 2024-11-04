import Foundation
/**
 - Proxy：必要になってから作る
 - PrinterProxyを作って、表示したいインスタンスを作っていく
 - いざprintする段階で初めて、PrinterProxyクラスがPrinterクラスのインスタンスを生成する
 - 前提として、Printerクラスのインスタンス生成に多くの時間がかかるものとする
 - HTTPプロキシもHTTPサーバーとHTTPクライアントの間に入って、Webページのキャッシングを行うソフトウェア
 - Proxyの種類
   - Virtual Proxy：今回の例。インスタンスが必要になったタイミングで、生成・初期化を行う
   - Remote Proxy：RealSubjectがネットワークの向こう側にいるにもかかわらず、あたかも自分の側にいるかのように、透過的にメソッドを呼び出せる
   - Access Proxy：RealSubject役の機能に対して、アクセス制限を設ける。定められたユーザーならメソッドの呼び出しを許可する

 */


protocol Printable {
    func setPrinterName(name: String)
    func getPrinterName() -> String
    func _print(str: String)
}

// PrinterクラスはPrinterProxyの存在を知らない
class Printer: Printable {
    private var name: String

    init(name: String) {
        print("generating Printer ...")
        for i in 0..<5 {
            print(".")
            sleep(1)
        }
        print("done generating !")
        self.name = name
    }

    func setPrinterName(name: String) {
        self.name = name
    }
    func getPrinterName() -> String {
        self.name
    }
    func _print(str: String) {
        print("=== \(name) ====")
        print(str)
    }
}

class PrinterProxy: Printable {
    private var name: String = "No Name"
    private var real: Printer? = nil

    init() {}

    func setPrinterName(name: String) {
        self.name = name
        self.real?.setPrinterName(name: name)
    }

    func getPrinterName() -> String {
        self.name
    }

    func _print(str: String) {
        realize()
        real?._print(str: str)
    }

    // Printerを現実化する
    private func realize() {
        if real == nil {
            real = Printer(name: self.name)
        }
    }
}

// main
var printerProxy = PrinterProxy()
printerProxy.setPrinterName(name: "Alice")
print("my name is \(printerProxy.getPrinterName()) now.")
printerProxy.setPrinterName(name: "Bob")
print("my name is \(printerProxy.getPrinterName()) now.")
printerProxy._print(str: "Hello World!")
