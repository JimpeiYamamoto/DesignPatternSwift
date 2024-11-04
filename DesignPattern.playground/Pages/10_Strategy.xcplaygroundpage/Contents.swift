import Foundation

enum HandType: Equatable {
    case rock
    case scissors
    case paper

    func isStrongerThan(hand: HandType) -> Bool {
        fight(hand: hand) == 1
    }

    func isWeakerThan(hand: HandType) -> Bool {
        fight(hand: hand) == -1
    }

    private func fight(hand: HandType) -> Int {
        if self == hand {
            return 0
        }
        if (HandInformation(hand: self).value + 1) % 3 == HandInformation(hand: hand).value {
            return 1
        }
        return -1
    }

    struct HandInformation: Equatable {
        let name: String
        let value: Int

        init(hand: HandType) {
            switch hand {
            case .rock:
                self.name = "✊"
                self.value = 0
            case .scissors:
                self.name = "✌️"
                self.value = 1
            case .paper:
                self.name = "✋"
                self.value = 2
            }
        }
    }

    init(value: Int) {
        switch value {
        case 0:
            self = .rock
        case 1:
            self = .scissors
        case 2:
            self = .paper
        default:
            self = .rock
        }
    }
}

protocol Strategy {
    func nextHand() -> HandType
    func study(isWon: Bool)
}

final class WinningStrategy: Strategy {
    func nextHand() -> HandType {
        .init(value: .random(in: 0..<3))
    }
    
    func study(isWon: Bool) {
    }
}

final class ProbStrategy: Strategy {
    func nextHand() -> HandType {
        .init(value: .random(in: 0..<3))
    }
    
    func study(isWon: Bool) {
    }
}

final class Player {
    private let name: String
    private let strategy: Strategy
    private var winCount: Int = 0
    private var loseCount: Int = 0
    private var gameCount: Int = 0

    init(name: String, strategy: Strategy) {
        self.name = name
        self.strategy = strategy
    }

    func nextHand() -> HandType {
        strategy.nextHand()
    }

    func win() {
        self.winCount += 1
        self.gameCount += 1
    }

    func lose() {
        self.loseCount += 1
        self.gameCount += 1
    }

    func even() {
        self.gameCount += 1
    }

    func toString() -> String {
        "name: \(name)\ngameCount:\(gameCount)\nwinCount:\(winCount)\nloseCount:\(loseCount)"
    }
}

// main

let player1 = Player(name: "Taro", strategy: WinningStrategy())
let player2 = Player(name: "Hana", strategy: ProbStrategy())

for _ in 0...100 {
    let hand1 = player1.nextHand()
    let hand2 = player2.nextHand()

    if hand1.isStrongerThan(hand: hand2) {
        player1.win()
        player2.lose()
    } else if hand1.isWeakerThan(hand: hand2) {
        player1.lose()
        player2.win()
    } else {
        player1.even()
        player2.even()
    }
}
print(player1.toString())
print(player2.toString())
