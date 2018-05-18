import Foundation

protocol Step {
    static func shouldExecuteStep(_ state: FlowState) -> Bool
    static func process(_ inputState: FlowState,
                        completion: @escaping (FlowState) -> ()) -> Action
}

private extension FlowState {
    var isStartFilled: Bool {
        return !start.isNullOrEmpty
    }
}

class StartStep: Step {
    static func shouldExecuteStep(_ state: FlowState) -> Bool {
        return !state.isStartFilled
    }
    
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

private extension FlowState {
    var isBlueFilled: Bool {
        return !blue.isNullOrEmpty
    }
}

class BlueStep: Step {
    static func shouldExecuteStep(_ state: FlowState) -> Bool {
        return !state.isBlueFilled
    }
    
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

private extension FlowState {
    var isRedFilled: Bool {
        return !red.isNullOrEmpty
    }
}

class RedStep: Step {
    static func shouldExecuteStep(_ state: FlowState) -> Bool {
        return !state.isRedFilled
    }
    
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

private extension FlowState {
    var isGreenFilled: Bool {
        return !green.isNullOrEmpty
    }
}

class GreenStep: Step {
    static func shouldExecuteStep(_ state: FlowState) -> Bool {
        return !state.isGreenFilled
    }
    
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

private extension FlowState {
    var isDoneFilled: Bool {
        return !done.isNullOrEmpty
    }
}

class DoneStep: Step {
    static func shouldExecuteStep(_ state: FlowState) -> Bool {
        return !state.isDoneFilled
    }
    
    static func process(_ inputState: FlowState, completion: @escaping (FlowState) -> ()) -> Action {
        return .route(command: .done(model: inputState.doneModel!))
    }
}

extension Optional where Wrapped == String {
    var isNullOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
