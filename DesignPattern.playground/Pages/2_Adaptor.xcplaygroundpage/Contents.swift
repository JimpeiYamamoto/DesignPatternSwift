import Foundation

// すでに提供されているクラス(adaptee)
public class Banner {
    private let str: String

    public init(str: String) {
        self.str = str
    }

    public func showWithParen() {
        print("(\(self.str))")
    }

    public func showWithAster() {
        print("*\(self.str)*")
    }
}

// 必要とされているインターフェース(target)
public protocol Print {
    func printWeak()
    func printStrong()
}

// Adaptor
public class PrintBanner: Print {
    private let banner: Banner

    public init(str: String) {
        self.banner = Banner(str: str)
    }

    public func printWeak() {
        banner.showWithParen()
    }

    public func printStrong() {
        banner.showWithAster()
    }
}

// 使い方1
let printBanner = PrintBanner(str: "helloWorld!")
printBanner.printStrong()
printBanner.printWeak()

// 使い方2
public class Hoge {
    let print: Print

    init(print: Print) {
        self.print = print
    }

    func hoge() {
        print.printStrong()
    }
}

let h = Hoge(print: printBanner)
h.hoge()

/**
 使い道
 - 既に存在するクラスを利用することがある
 - そのクラスが十分にテストされていて、実績があるならそのクラスが使いたい
 - Adaptorパターンを使うことで、既存のクラスに一皮被せて必要とするクラスをつくる
 - もしバグがあっても既存のクラスにはバグが少ないため、Adaptorクラスを重点的に調べれば良くなる
 - 既存のクラスをいじると、新たなテストが必要になるが、Adaptorパターンを使うことで不要
 */
