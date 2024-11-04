import Foundation

/**
 - Command (event)：命令をクラスにする
 - 命令をメソッドを呼び出すという動的な処理として表現するのでなく、命令を表す1個のインスタンスという1個のものとして表現する
 */


protocol Command {
    func execute()
}

class MacroCommand: Command {
    private var commands: [Command] = []

    func execute() {
        commands.forEach { cmd in
            cmd.execute()
        }
    }

    func _append(cmd: Command) {
        commands.append(cmd)
    }

    func undo() {
        commands.remove(at: commands.count-1)
    }

    func clear() {
        commands.removeAll()
    }
}

class DrawCommand: Command {

    private let drawable: Drawable
    private var position: (x: Int, y: Int)

    init(drawable: Drawable, position: (x: Int, y: Int)) {
        self.drawable = drawable
        self.position = position
    }

    func execute() {
        drawable.draw(position: position)
    }
}

protocol Drawable {
    func draw(position: (x: Int, y: Int))
}

class DrawCanvas: Drawable {
    private var color = "red"
    private var history: MacroCommand

    init(history: MacroCommand) {
        self.history = history
    }

    func draw(position: (x: Int, y: Int)) {
        print("描いています->", position)
    }

    // 履歴全体を再描画
    func paint() {
        history.execute()
    }
}

// main
let history = MacroCommand()
let canvas = DrawCanvas(history: history)

let cmd1 = DrawCommand(drawable: canvas, position: (2, 2))
let cmd2 = DrawCommand(drawable: canvas, position: (1, 0))
cmd1.execute()
history._append(cmd: cmd1)
cmd2.execute()
history._append(cmd: cmd2)

print("\n履歴を再実行")
history.execute()
