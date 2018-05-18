import Foundation

protocol Step {
    associatedtype StepState
    
    static func process(_ inputState: StepState,
                        completion: @escaping (StepState) -> ()) -> Action
}

class StartStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, completion: @escaping (FlowState) -> ()) -> Action {
        var mutableState = inputState
        mutableState.start = "Hello!"
        let model = mutableState.startModel!
        let bindings = Bindings {
            if !$0.isEmpty {
                mutableState.blue = $0
                completion(mutableState)
            }
        }
        return .route(command: .showBlue(model: model, bindings: bindings))
    }
}

class BlueStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, completion: @escaping (FlowState) -> ()) -> Action {
        let model = inputState.redModel!
        let bindings = Bindings {
            if !$0.isEmpty {
                var mutableState = inputState
                mutableState.red = $0
                completion(mutableState)
            }
        }
        return .route(command: .showRed(model: model, bindings: bindings))
    }
}

class RedStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, completion: @escaping (FlowState) -> ()) -> Action {
        let model = inputState.greenModel!
        let bindings = Bindings {
            if !$0.isEmpty {
                var mutableState = inputState
                mutableState.green = $0
                completion(mutableState)
            }
        }
        return .route(command: .showGreen(model: model, bindings: bindings))
    }
}

class GreenStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, completion: @escaping (FlowState) -> ()) -> Action {
        return .loadAsync(route: .showLoader, command: .load(model: inputState.greenModel!, callback: {
            if !$0.isEmpty {
                var mutableState = inputState
                mutableState.done = $0
                completion(mutableState)
            }
        }))
    }
}

class DoneStep: Step {
    typealias StepState = FlowState
    
    static func process(_ inputState: FlowState, completion: @escaping (FlowState) -> ()) -> Action {
        return .route(command: .done(model: inputState.doneModel!))
    }
}
