import Foundation

/**
 - 状態をクラスで表現する

 - 具体的な状態を別々のクラスとして表現して、問題を分割した
 - Stateパターンで、状態に依存した処理を表現するには
  - 抽象メソッドとして宣言し、インターフェースとする
  - 具象メソッドとして実装し、個々のクラスにする
 */

protocol State {
    func doClock(context: Context, hour: Int)
    func doUse(context: Context)
    func doAlarm(context: Context)
    func doPhone(context: Context)
}

protocol Context {
    func setClock(hour: Int)
    func changeState(state: State)
    func callSecurityCenter(msg: String)
    func recordLog(msg: String)
}

class DayState: State {
    static let shared = DayState()

    private init() {}

    func doClock(context: Context, hour: Int) {
        if hour < 9 || hour > 17 {
            context.changeState(state: NightState.shared)
        }
    }
    func doUse(context: Context) {
        context.recordLog(msg: "金庫使用(昼間)")
    }
    func doAlarm(context: Context) {
        context.callSecurityCenter(msg: "非常ベル(昼間)")
    }
    func doPhone(context: Context) {
        context.callSecurityCenter(msg: "通常の通話(昼間)")
    }
}

class NightState: State {
    static let shared = NightState()

    private init() {}

    func doClock(context: Context, hour: Int) {
        if hour > 9 && hour < 17 {
            context.changeState(state: DayState.shared)
        }
    }
    func doUse(context: Context) {
        context.recordLog(msg: "非常：夜間の金庫使用")
    }
    func doAlarm(context: Context) {
        context.callSecurityCenter(msg: "非常ベル(夜間)")
    }
    func doPhone(context: Context) {
        context.recordLog(msg: "夜間の通話録音")
    }
}

class SafeFrame: Context {
    var state: State

    init(state: State) {
        self.state = state
    }

    func setClock(hour: Int) {
        state.doClock(context: self, hour: hour)
    }

    func changeState(state: State) {
        print("state: \(self.state) -> \(state)")
        self.state = state
    }
    func callSecurityCenter(msg: String) {
        print("call! \(msg)")
    }

    func recordLog(msg: String) {
        print("record... \(msg)")
    }
}

// main
let frame = SafeFrame(state: DayState.shared)
for hour in 0..<24 {
    print("=================")
    print("hour:\(hour)")
    frame.setClock(hour: hour)
    frame.state.doUse(context: frame)
    frame.state.doPhone(context: frame)
}
