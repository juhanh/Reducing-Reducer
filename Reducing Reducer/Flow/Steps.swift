import Foundation

protocol Step {
    associatedtype State

    static func process(state: State?, callback: @escaping (Instruction) -> ()) -> (command: Command, state: State?)
}

class BlueStep: Step {
    typealias State = String

    static func process(state: String?, callback: @escaping (Instruction) -> ()) -> (command: Command, state: String?) {
        if let p = state, !p.isEmpty {
            let model = Model(text: "Oh, you shouldn't have \(p)")
            let bindings = Bindings(go: { callback(.red(previous: $0)) })
            return (command: .showRed(model: model, bindings: bindings), nil)
        } else {
            let model = Model(text: "Hello there")
            let bindings = Bindings(go: { callback(.blue(previous: $0)) })
            return (command: .showBlue(model: model, bindings: bindings), nil)
        }
    }
}

class RedStep: Step {
    typealias State = String

    static func process(state: String?, callback: @escaping (Instruction) -> ()) -> (command: Command, state: String?) {
        if let p = state, !p.isEmpty {
            let model = Model(text: "Really? \(p)")
            let bindings = Bindings {
                callback(.green(previous: $0))
            }
            return (command: .showGreen(model: model, bindings: bindings), nil)
        } else {
            return (command: .restart(model: Model(text: "Hello there")), nil)
        }
    }
}

class GreenStep: Step {
    typealias State = String

    static func process(state: String?, callback: @escaping (Instruction) -> ()) -> (command: Command, state: String?) {
        if let p = state, !p.isEmpty {
            let model = Model(text: "Way cool! \(p)")
            let bindings = Bindings { _ in
                callback(.done)
            }
            return (command: .showGreen(model: model, bindings: bindings), nil)
        } else {
            return (command: .restart(model: Model(text: "Hello there")), nil)
        }
    }
}
