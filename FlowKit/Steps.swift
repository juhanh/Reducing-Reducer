import Foundation

protocol Step {
    associatedtype StepState
    
    static func process(_ inputState: StepState,
                        processingEndCallback: @escaping (StepState) -> ()) -> Action
}

class StartStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, processingEndCallback: @escaping (FlowState) -> ()) -> Action {
        var mutableState = inputState
        mutableState.start = "Hello!"
        let model = mutableState.startModel!
        let bindings = Bindings {
            if !$0.isEmpty {
                mutableState.blue = $0
                processingEndCallback(mutableState)
            }
        }
        return .sync(route: .showBlue(model: model, bindings: bindings))
    }
}

class BlueStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, processingEndCallback: @escaping (FlowState) -> ()) -> Action {
        let model = inputState.redModel!
        let bindings = Bindings {
            if !$0.isEmpty {
                var mutableState = inputState
                mutableState.red = $0
                processingEndCallback(mutableState)
            }
        }
        return .sync(route: .showRed(model: model, bindings: bindings))
    }
}

class RedStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, processingEndCallback: @escaping (FlowState) -> ()) -> Action {
        let model = inputState.greenModel!
        let bindings = Bindings {
            if !$0.isEmpty {
                var mutableState = inputState
                mutableState.green = $0
                processingEndCallback(mutableState)
            }
        }
        return .sync(route: .showGreen(model: model, bindings: bindings))
    }
}

class GreenStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, processingEndCallback: @escaping (FlowState) -> ()) -> Action {
        return .async(route: .showLoader, load: .load(model: inputState.greenModel!, callback: {
            if !$0.isEmpty {
                var mutableState = inputState
                mutableState.done = $0
                processingEndCallback(mutableState)
            }
        }))
    }
}

class DoneStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, processingEndCallback: @escaping (FlowState) -> ()) -> Action {
        return .sync(route: .done(model: inputState.doneModel!))
    }
}
