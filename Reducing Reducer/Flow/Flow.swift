import Foundation

class Bindings {
    let go: (String) -> ()

    init(go: @escaping (String) -> ()) {
        self.go = go
    }
}

enum Instruction {
    case start
    case blue(previous: String)
    case red(previous: String)
    case green(previous: String)
}

class Flow {
    private let router: Router
    private var state: State

    init(router: Router) {
        self.router = router
        state = State()
    }

    func route(instruction: Instruction) {
        switch instruction {
        case .start:
            processStep(input: "", state: state, step: StartStep())
        case let .blue(previous):
            processStep(input: previous, state: state, step: BlueStep())
        case let .red(previous):
            processStep(input: previous, state: state, step: RedStep())
        case let .green(previous):
            processStep(input: previous, state: state, step: GreenStep())
        }
    }

    private func processStep<T>(input: String, state: State, step _: T) where T: Step {
        let result = T.process(input: input as! T.Input, state: state as! T.CurrentState, callback: { [weak self] in self?.route(instruction: $0) })
        self.state = result.state as! State
        router.process(command: result.command)
    }
}
