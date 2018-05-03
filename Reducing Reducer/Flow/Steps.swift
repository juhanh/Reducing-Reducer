import Foundation

protocol Step {
    associatedtype CurrentState
    associatedtype Input

    static func process(input: Input,
                        state: CurrentState,
                        callback: @escaping (Instruction) -> ()) -> (command: Command, state: CurrentState)
}

protocol AsyncStep {
    associatedtype CurrentState
    associatedtype Input

    static func processAsync(input: Input,
                             state: CurrentState,
                             processingEndCallback: @escaping ((command: Instruction, state: CurrentState)) -> ()) -> Command
}


protocol Model {
    var text: String { get }
}

class DoneModel: Model {
    let text: String

    init(text: String) {
        self.text = text
    }
}

class StartStep: Step {
    typealias CurrentState = State
    typealias Input = String

    static func process(input: String, state: State, callback: @escaping (Instruction) -> ()) -> (command: Command, state: State) {
        let model = state.startModel
        let bindings = Bindings(go: { callback(.blue(previous: $0)) })
        return (command: .sync(route: .showBlue(model: model, bindings: bindings)), state)
    }
}

class BlueStep: Step {
    typealias CurrentState = State
    typealias Input = String

    static func process(input: String, state: State, callback: @escaping (Instruction) -> ()) -> (command: Command, state: State) {
        var mutableState = state
        mutableState.blue = input
        if let model = mutableState.redModel {
            let bindings = Bindings(go: { callback(.red(previous: $0)) })
            return (command: .sync(route: .showRed(model: model, bindings: bindings)), state: mutableState)
        } else {
            return (command: .sync(route: .noop), state: mutableState)
        }
    }
}

class RedStep: Step {
    typealias CurrentState = State
    typealias Input = String

    static func process(input: String, state: State, callback: @escaping (Instruction) -> ()) -> (command: Command, state: State) {
        var mutableState = state
        mutableState.red = input
        if let model = mutableState.greenModel {
            let bindings = Bindings {
                callback(.green(previous: $0))
            }
            return (command: .sync(route: .showGreen(model: model, bindings: bindings)), state: mutableState)
        } else {
            return (command: .sync(route: .noop), state: mutableState)
        }
    }
}

class GreenStep: AsyncStep {
    typealias CurrentState = State
    typealias Input = String

    static func processAsync(input: String, state: State, processingEndCallback: @escaping ((command: Instruction, state: State)) -> ()) -> Command {
        var mutableState = state
        mutableState.green = input
        if let model = mutableState.greenModel {
            return .async(route: .showLoader, load: .load(model: model, callback: {
                mutableState.green = mutableState.green! + " \($0)"
                processingEndCallback((command: .finish(previous: $0.text), state: mutableState))
            }))
        } else {
            return .sync(route: .noop)
        }
    }
}

class DoneStep: Step {
    typealias CurrentState = State
    typealias Input = String

    static func process(input: String, state: State, callback: @escaping (Instruction) -> ()) -> (command: Command, state: State) {
        var mutableState = state
        mutableState.green = input
        if let model = mutableState.doneModel {
            return (command: .sync(route: .done(model: model)), state: mutableState)
        } else {
            return (command: .sync(route: .noop), state: mutableState)
        }
    }
}
