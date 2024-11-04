import Foundation
// FactoryパターンはTemplateをインスタンス化に適用したもの

// Productはuseできるものと定義
public protocol Product {
    func use()
    func toString() -> String
}

// FactoryはProductをcreateしてregisterするもの
// 実際に生成されるConcreateProductについて何もしらない
protocol Factory {
    func createProduct(owner: String) -> Product
    func registerProduct(product: Product)

    func create(owner: String) -> Product
}

extension Factory {
    func create(owner: String) -> Product {
        let product = createProduct(owner: owner)
        registerProduct(product: product)
        return product
    }
}

// ↑ Frameworkパッケージ
// =============================================
// ↓ idcardパッケージ

public final class IDCard: Product {
    private let owner: String

    public init(owner: String) {
        print("\(owner)のカードを作ります")
        self.owner = owner
    }

    public func use() {
        print("\(toString()) を使います")
    }

    public func toString() -> String {
        "IDCard \(owner)"
    }

}

public final class IDCardFactory: Factory {
    func createProduct(owner: String) -> Product {
        return IDCard(owner: owner)
    }
   
    // 本来であればデータベースへの追加など
    func registerProduct(product: Product) {
        print("\(product.toString()) を登録しました")
    }
}

// 使い方
let idCardFactory = IDCardFactory()
let idCard1 = idCardFactory.create(owner: "Yamada")
let idCard2 = idCardFactory.create(owner: "Tamura")
let idCard3 = idCardFactory.create(owner: "Suzuki")
idCard1.use()
idCard2.use()
idCard3.use()

/**
 使い道
 - Package内のコードを一切いじらずに、IDCard以外の別のProductとFactoryが作れる（frameworkパッケージはidcardパッケージに依存してない）
 */
