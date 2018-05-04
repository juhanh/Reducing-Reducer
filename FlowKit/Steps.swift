import Foundation

protocol Step {
    associatedtype StepState
    associatedtype Input

    static func process(_ input: Input,
                        inputState: StepState,
                        nextStepCallback: @escaping (FlowStep) -> ()) -> (action: Action, outputState: StepState)
}

protocol AsyncStep {
    associatedtype StepState
    associatedtype Input

    static func processAsync(_ input: Input,
                             inputState: StepState,
                             processingEndCallback: @escaping ((step: FlowStep, outputState: StepState)) -> ()) -> Action
}

class DoneModel: RoutingModel {
    let text: String

    init(text: String) {
        self.text = text
    }
}

class StartStep: Step {
    typealias StepState = FlowState
    typealias Input = String

    static func process(_ input: String, inputState: FlowState, nextStepCallback: @escaping (FlowStep) -> ()) -> (action: Action, outputState: FlowState) {
        let model = inputState.startModel
        let bindings = Bindings(go: { nextStepCallback(.blue(previous: $0)) })
        return (action: .sync(route: .showBlue(model: model, bindings: bindings)), outputState: inputState)
    }
}

class BlueStep: Step {
    typealias StepState = FlowState
    typealias Input = String

    static func process(_ input: String, inputState: FlowState, nextStepCallback: @escaping (FlowStep) -> ()) -> (action: Action, outputState: FlowState) {
        var mutableState = inputState
        mutableState.blue = input
        if let model = mutableState.redModel {
            let bindings = Bindings(go: { nextStepCallback(.red(previous: $0)) })
            return (action: .sync(route: .showRed(model: model, bindings: bindings)), outputState: mutableState)
        } else {
            return (action: .sync(route: .noop), outputState: mutableState)
        }
    }
}

class RedStep: Step {
    typealias StepState = FlowState
    typealias Input = String

    static func process(_ input: String, inputState: FlowState, nextStepCallback: @escaping (FlowStep) -> ()) -> (action: Action, outputState: FlowState) {
        var mutableState = inputState
        mutableState.red = input
        if let model = mutableState.greenModel {
            let bindings = Bindings {
                nextStepCallback(.green(previous: $0))
            }
            return (action: .sync(route: .showGreen(model: model, bindings: bindings)), outputState: mutableState)
        } else {
            return (action: .sync(route: .noop), outputState: mutableState)
        }
    }
}

class GreenStep: AsyncStep {
    typealias StepState = FlowState
    typealias Input = String

    static func processAsync(_ input: String, inputState: FlowState, processingEndCallback: @escaping ((step: FlowStep, outputState: FlowState)) -> ()) -> Action {
        var mutableState = inputState
        mutableState.green = input
        if let model = mutableState.greenModel {
            return .async(route: .showLoader, load: .load(model: model, callback: {
                mutableState.green = mutableState.green! + " \($0)"
                processingEndCallback((step: .finish(previous: $0.text), outputState: mutableState))
            }))
        } else {
            return .sync(route: .noop)
        }
    }
}

class DoneStep: Step {
    typealias StepState = FlowState
    typealias Input = String

    static func process(_ input: String, inputState: FlowState, nextStepCallback: @escaping (FlowStep) -> ()) -> (action: Action, outputState: FlowState) {
        var mutableState = inputState
        mutableState.green = input
        if let model = mutableState.doneModel {
            return (action: .sync(route: .done(model: model)), outputState: mutableState)
        } else {
            return (action: .sync(route: .noop), outputState: mutableState)
        }
    }
}
