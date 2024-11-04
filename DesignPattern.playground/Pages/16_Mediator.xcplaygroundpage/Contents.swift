import Foundation
/**
 - Mediator(仲介者)：相手は相談役一人だけ
 - メンバーはみんな相談役だけに報告し、メンバーへの指示は相談役だけからくる
 - 具体のColleagueは再利用性が高いが、具体Mediatorは再利用しにくい
 - Colleagueには利用対象へ依存したロジックが含まれていないため
 - Mediatorに依存が閉じ込められている
 */

protocol Mediator {
    func createColleagues()
    func colleagueChanged()
}

class LoginFrame: Mediator {

    private var checkGuest: ColleagueCheckBox
    private var checkLogin: ColleagueCheckBox
    private var textUser: ColleagueTextField
    private var textPass: ColleagueTextField
    private var buttonOk: ColleagueButton
    private var buttonCancel: ColleagueButton

    init(
        checkGuest: ColleagueCheckBox,
        checkLogin: ColleagueCheckBox,
        textUser: ColleagueTextField,
        textPass: ColleagueTextField,
        buttonOk: ColleagueButton,
        buttonCancel: ColleagueButton
    ) {
        self.checkGuest = checkGuest
        self.checkLogin = checkLogin
        self.textUser = textUser
        self.textPass = textPass
        self.buttonOk = buttonOk
        self.buttonCancel = buttonCancel

        // 生成
        createColleagues()
        // addSubView
        // 有効無効の初期指定
        colleagueChanged()
    }

    func createColleagues() {
        self.checkGuest.setMediator(mediator: self)
        self.checkLogin.setMediator(mediator: self)
        self.textUser.setMediator(mediator: self)
        self.textPass.setMediator(mediator: self)
        self.buttonOk.setMediator(mediator: self)
        self.buttonCancel.setMediator(mediator: self)
    }

    // ロジックがバグっていたとしても、有効・無効のロジックはここ以外にないため、ここをデバッグすれば良い
    // つまり、各Colleagueに有効・無効ロジックが含まれていたら、デバッグが大変だが、Mediatorで集約することで、実現できている
    func colleagueChanged() {
        if checkGuest.isEnabled == true {
            textUser.setColleagueEnabled(enabled: false)
            textPass.setColleagueEnabled(enabled: false)
            buttonOk.setColleagueEnabled(enabled: true)

        } else {

            textUser.setColleagueEnabled(enabled: true)
            guard textUser.text.count > 0
            else {
                textPass.setColleagueEnabled(enabled: false)
                buttonOk.setColleagueEnabled(enabled: false)
                return
            }

            textPass.setColleagueEnabled(enabled: true)
            buttonOk.setColleagueEnabled(enabled: textPass.text.count > 0)
        }
    }

    func printState() {
        print("================================")
        print("checkGuest:", self.checkGuest.isEnabled)
        print("checkLogin:", self.checkLogin.isEnabled)
        print("textUser:", self.textUser.isEnabled)
        print("textPass:", self.textPass.isEnabled)
        print("buttonOk:", self.buttonOk.isEnabled)
        print("buttonCancel:", self.buttonCancel.isEnabled)
    }
}

protocol Colleague {
    func setMediator(mediator: Mediator)
    func setColleagueEnabled(enabled: Bool)
}

class ColleagueButton: Colleague {
    public var isEnabled: Bool = true
    private var mediator: Mediator? = nil

    func setMediator(mediator: Mediator) {
        self.mediator = mediator
    }

    func setColleagueEnabled(enabled: Bool) {
        self.isEnabled = enabled
    }
}

class ColleagueTextField: Colleague {
    private var mediator: Mediator? = nil

    public var isEnabled: Bool = true
    public var backGroundColorStr = "white"
    public var text: String = "" {
        didSet {
            textValueChanged()
        }
    }

    func setMediator(mediator: Mediator) {
        self.mediator = mediator
    }

    func setColleagueEnabled(enabled: Bool) {
        self.isEnabled = enabled
        self.backGroundColorStr = enabled ? "white" : "lightGray"
    }

    func textValueChanged() {
        mediator?.colleagueChanged()
    }
}

class ColleagueCheckBox: Colleague {
    private var mediator: Mediator? = nil

    public var isEnabled: Bool = true {
        didSet {
            itemStateChanged()
        }
    }

    func setMediator(mediator: Mediator) {
        self.mediator = mediator
    }

    func setColleagueEnabled(enabled: Bool) {
        self.isEnabled = enabled
    }

    func itemStateChanged() {
        mediator?.colleagueChanged()
    }
}

let checkGuest = ColleagueCheckBox()
let checkLogin = ColleagueCheckBox()
let textUser = ColleagueTextField()
let textPass = ColleagueTextField()
let buttonOk = ColleagueButton()
let buttonCancel = ColleagueButton()

let loginFrame = LoginFrame(
    checkGuest: checkGuest,
    checkLogin: checkLogin,
    textUser: textUser,
    textPass: textPass,
    buttonOk: buttonOk,
    buttonCancel: buttonCancel
)
checkLogin.setColleagueEnabled(enabled: true)
checkGuest.setColleagueEnabled(enabled: false)
print("初期状態")
loginFrame.printState()

print("\ntyped TextUser")
textUser.text = "user"
loginFrame.printState()

print("\ntyped TextPass")
textPass.text = "pass"
loginFrame.printState()

