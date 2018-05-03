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
    case finish(previous: String)
}

enum Command {
    case sync(route: RoutingCommand)
    case async(route: RoutingCommand, load: LoadingCommand)
}

class Flow {
    private let router: Router
    private let loader: Loader
    private var state: State

    init(router: Router, loader: Loader) {
        self.router = router
        self.loader = loader
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
            processAsyncStep(input: previous, state: state, step: GreenStep())
        case let .finish(previous):
            processStep(input: previous, state: state, step: DoneStep())
        }
    }

    private func processStep<T>(input: String, state: State, step _: T) where T: Step {
        let result = T.process(input: input as! T.Input, state: state as! T.CurrentState, callback: { [weak self] in self?.route(instruction: $0) })
        self.state = result.state as! State
        if case let .sync(route) = result.command {
            router.route(command: route)
        }
    }

    private func processAsyncStep<T>(input: String, state: State, step _: T) where T: AsyncStep {
        let result = T.processAsync(input: input as! T.Input, state: state as! T.CurrentState) { [weak self] in
            self?.state = $0.state as! State
            self?.route(instruction: $0.command)
        }
        switch result {
        case let .async(route, load):
            router.route(command: route)
            loader.load(command: load)
        case let .sync(route):
            router.route(command: route)
        }
    }
}
