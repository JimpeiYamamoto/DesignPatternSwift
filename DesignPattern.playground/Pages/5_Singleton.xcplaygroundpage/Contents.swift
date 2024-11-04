import Foundation

public final class Singleton {
    private init() {
        print("init called")
    }

    private static let shared = Singleton()

    public static func getInstance() -> Singleton {
        return Self.shared
    }
}

print("Start")
 let s = Singleton.getInstance()

/**
 - インスタンスが一つしかないという前提条件の元でプログラミングできる
 - getInstanceメソッドが呼ばれた時にインスタンスが作られる(Startの方が先にprintされることからわかる)
 */
